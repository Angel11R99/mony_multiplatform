import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/mony_feedback.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../shopping_lists/domain/shopping_list.dart';
import '../../shopping_lists/presentation/shopping_lists_providers.dart';
import '../domain/barcode_product.dart';
import '../presentation/barcode_providers.dart';

class BarcodeScannerPage extends ConsumerStatefulWidget {
  const BarcodeScannerPage({this.shoppingListId, super.key});
  final int? shoppingListId;

  @override
  ConsumerState<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends ConsumerState<BarcodeScannerPage> {
  final _barcodeController = TextEditingController();
  final _nameController = TextEditingController();
  final _camera = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const [
      BarcodeFormat.ean8,
      BarcodeFormat.ean13,
      BarcodeFormat.upcA,
      BarcodeFormat.upcE,
      BarcodeFormat.itf14,
      BarcodeFormat.code128,
    ],
  );
  BarcodeLookupResult? _result;
  String? _message;
  bool _allowNetwork = false;
  bool _lookingUp = false;
  bool _adding = false;
  int _quantity = 1;

  bool get _cameraSupported =>
      kIsWeb ||
      const {
        TargetPlatform.android,
        TargetPlatform.iOS,
        TargetPlatform.macOS,
      }.contains(defaultTargetPlatform);

  @override
  void dispose() {
    _barcodeController.dispose();
    _nameController.dispose();
    _camera.dispose();
    super.dispose();
  }

  Future<void> _lookup([String? detectedCode]) async {
    final code = (detectedCode ?? _barcodeController.text).trim();
    if (!isValidProductBarcode(code)) {
      setState(() {
        _result = null;
        _message =
            'Ingresa un código EAN o UPC válido (8, 12, 13 o 14 dígitos).';
      });
      return;
    }
    setState(() {
      _barcodeController.text = code;
      _result = null;
      _message = null;
      _lookingUp = true;
    });
    try {
      final repository = await ref.read(
        barcodeProductRepositoryProvider.future,
      );
      final result = await repository.lookup(code, allowNetwork: _allowNetwork);
      if (!mounted) return;
      setState(() {
        _result = result;
        _nameController.text = result?.product.displayName ?? '';
        _message = result == null
            ? 'No encontramos el producto. Puedes escribir su nombre y agregarlo manualmente.'
            : result.fromCache
            ? 'Resultado guardado en este dispositivo.'
            : 'Producto encontrado en Open Food Facts.';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _message =
            'No hay conexión con el catálogo. Puedes volver a intentar o continuar sin conexión.';
      });
    } finally {
      if (mounted) setState(() => _lookingUp = false);
    }
  }

  Future<void> _addToList() async {
    final listId = widget.shoppingListId;
    final name = _nameController.text.trim();
    final barcode = _barcodeController.text.trim();
    if (listId == null || name.isEmpty || !isValidProductBarcode(barcode)) {
      return;
    }
    setState(() => _adding = true);
    try {
      await ref
          .read(shoppingListRepositoryProvider)
          .saveItem(
            ShoppingListItem(
              shoppingListId: listId,
              name: name,
              barcode: barcode,
              quantity: _quantity,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
      if (!mounted) return;
      MonyFeedback.success(context, '$name agregado a la lista.');
      context.pop();
    } catch (_) {
      if (!mounted) return;
      MonyFeedback.error(context, 'No se pudo agregar el producto a la lista.');
    } finally {
      if (mounted) setState(() => _adding = false);
    }
  }

  void _onDetect(BarcodeCapture capture) {
    if (_lookingUp || _adding || capture.barcodes.isEmpty) return;
    final code = capture.barcodes.first.rawValue;
    if (code != null) _lookup(code);
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(barcodeProductRepositoryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear código')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (widget.shoppingListId != null)
                const Text('Escanea un producto para agregarlo a esta lista.'),
              if (_cameraSupported)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      height: 260,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          MobileScanner(
                            controller: _camera,
                            onDetect: _onDetect,
                            errorBuilder: (context, error) => ColoredBox(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.no_photography_outlined,
                                        size: 36,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        error.errorCode ==
                                                MobileScannerErrorCode
                                                    .permissionDenied
                                            ? 'Permite el acceso a la cámara para escanear. También puedes ingresar el código manualmente.'
                                            : 'La cámara no está disponible. Ingresa el código manualmente.',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IgnorePointer(
                            child: Center(
                              child: Container(
                                width: 270,
                                height: 115,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: ValueListenableBuilder(
                              valueListenable: _camera,
                              builder: (context, state, _) =>
                                  IconButton.filledTonal(
                                    tooltip: state.torchState == TorchState.on
                                        ? 'Apagar linterna'
                                        : 'Encender linterna',
                                    onPressed: _camera.toggleTorch,
                                    icon: Icon(
                                      state.torchState == TorchState.on
                                          ? Icons.flash_on
                                          : Icons.flash_off,
                                    ),
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                const Card.outlined(
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: Text(
                      'La cámara no está disponible en esta plataforma. Usa la entrada manual.',
                    ),
                  ),
                ),
              const SizedBox(height: 18),
              TextField(
                controller: _barcodeController,
                keyboardType: TextInputType.number,
                maxLength: 14,
                decoration: InputDecoration(
                  labelText: 'Código de barras',
                  hintText: 'EAN / UPC',
                  prefixIcon: const Icon(Icons.qr_code_2),
                  suffixIcon: IconButton(
                    tooltip: 'Consultar código',
                    onPressed: _lookingUp || repository.isLoading
                        ? null
                        : () => _lookup(),
                    icon: const Icon(Icons.search),
                  ),
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (_) => _lookup(),
                onChanged: (_) => setState(() {
                  _result = null;
                  _message = null;
                }),
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Consultar catálogo en internet'),
                subtitle: const Text(
                  'Desactivado inicialmente: solo se usan productos guardados en este dispositivo. Actívalo para consultar Open Food Facts.',
                ),
                value: _allowNetwork,
                onChanged: (value) => setState(() => _allowNetwork = value),
              ),
              if (repository.isLoading) const LinearProgressIndicator(),
              if (_lookingUp)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(child: CircularProgressIndicator()),
                ),
              if (_message != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    _message!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              if (_result?.product case final product?)
                _ProductCard(product: product),
              if (widget.shoppingListId != null &&
                  isValidProductBarcode(_barcodeController.text)) ...[
                TextField(
                  controller: _nameController,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del producto',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                Row(
                  children: [
                    const Text('Cantidad'),
                    const Spacer(),
                    IconButton(
                      onPressed: _quantity > 1
                          ? () => setState(() => _quantity--)
                          : null,
                      icon: const Icon(Icons.remove),
                    ),
                    Text('$_quantity'),
                    IconButton(
                      onPressed: () => setState(() => _quantity++),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                FilledButton.icon(
                  onPressed: _adding || _nameController.text.trim().isEmpty
                      ? null
                      : _addToList,
                  icon: _adding
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add_shopping_cart),
                  label: const Text('Agregar a la lista'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});
  final BarcodeProduct product;

  @override
  Widget build(BuildContext context) => Card.outlined(
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          if (product.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.imageUrl!,
                width: 76,
                height: 76,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) =>
                    const SizedBox.shrink(),
              ),
            ),
          if (product.imageUrl != null) const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.displayName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (product.brand != null) Text(product.brand!),
                if (product.quantity != null) Text(product.quantity!),
                Text(
                  product.barcode,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
