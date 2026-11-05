import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/date_time/mony_date_formatter.dart';
import '../../../core/widgets/mony_feedback.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/money/money_formatter.dart';
import '../../categories/domain/category.dart';
import '../../categories/presentation/category_picker.dart';
import '../../payment_methods/domain/payment_method.dart';
import '../../payment_methods/presentation/payment_method_picker.dart';
import '../../payment_methods/presentation/payment_methods_providers.dart';
import '../../transactions/domain/transaction.dart';
import '../../transactions/domain/transaction_repository.dart';
import '../../transactions/domain/transaction_validator.dart';
import '../../transactions/presentation/transactions_providers.dart';
import '../data/on_device_receipt_ocr.dart';
import '../domain/receipt_draft.dart';

class ReceiptScannerPage extends ConsumerStatefulWidget {
  const ReceiptScannerPage({super.key});

  @override
  ConsumerState<ReceiptScannerPage> createState() => _ReceiptScannerPageState();
}

class _ReceiptScannerPageState extends ConsumerState<ReceiptScannerPage> {
  bool _duplicateCheckFailed = false;
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  final _merchant = TextEditingController();
  final _amount = TextEditingController();
  final _items = TextEditingController();
  final _rawText = TextEditingController();
  Uint8List? _imageBytes;
  DateTime _date = DateTime.now();
  int? _categoryId;
  int? _paymentMethodId;
  bool _recognizing = false;
  bool _saving = false;
  String? _notice;

  bool get _supportsOnDeviceOcr =>
      !kIsWeb &&
      const {
        TargetPlatform.android,
        TargetPlatform.iOS,
      }.contains(defaultTargetPlatform);

  @override
  void dispose() {
    _merchant.dispose();
    _amount.dispose();
    _items.dispose();
    _rawText.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await _picker.pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.rear,
        maxWidth: 2200,
        imageQuality: 90,
        requestFullMetadata: false,
      );
      if (image == null) return;
      final bytes = await image.readAsBytes();
      if (!mounted) return;
      setState(() {
        _imageBytes = bytes;
        _notice = _supportsOnDeviceOcr
            ? 'Imagen lista para revisar.'
            : 'La imagen se puede revisar, pero el OCR local está disponible en Android e iOS.';
      });
      if (_supportsOnDeviceOcr) await _recognize(image.path);
    } catch (_) {
      if (!mounted) return;
      setState(
        () => _notice =
            'No se pudo abrir la imagen. Revisa el permiso de cámara o galería y vuelve a intentar.',
      );
    }
  }

  Future<void> _recognize(String imagePath) async {
    setState(() {
      _recognizing = true;
      _notice = null;
    });
    try {
      final text = await OnDeviceReceiptOcr().recognize(imagePath);
      if (!mounted) return;
      _applyText(text);
      setState(() {
        _notice = text.trim().isEmpty
            ? 'No pudimos leer texto. Puedes escribir los datos manualmente.'
            : 'Texto extraído en este dispositivo. Revisa los campos antes de guardar.';
      });
    } catch (_) {
      if (!mounted) return;
      setState(
        () => _notice =
            'No pudimos leer este ticket. Ajusta la imagen o completa los campos manualmente.',
      );
    } finally {
      if (mounted) setState(() => _recognizing = false);
    }
  }

  void _applyText(String text) {
    final draft = ReceiptParser.parse(text);
    setState(() {
      _rawText.text = text;
      if (draft.merchant.isNotEmpty) _merchant.text = draft.merchant;
      if (draft.totalInCents != null) {
        _amount.text = MoneyFormatter.toDopInput(draft.totalInCents!);
      }
      if (draft.date != null) _date = draft.date!;
      _items.text = draft.itemSummary;
    });
  }

  Future<void> _chooseDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(_date.year, _date.month, _date.day),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      setState(() => _date = DateTime(picked.year, picked.month, picked.day));
    }
  }

  Future<void> _save(PaymentMethod? defaultMethod) async {
    if (_saving || !(_formKey.currentState?.validate() ?? false)) return;
    final amount = MoneyFormatter.parseDopMinorUnits(_amount.text);
    if (amount == null) return;
    final paymentMethodId = _paymentMethodId ?? defaultMethod?.id;
    final selectionError = TransactionValidator.validateSelection(
      categoryId: _categoryId,
      paymentMethodId: paymentMethodId,
    );
    if (selectionError != null) {
      _showMessage(selectionError);
      return;
    }
    final date = DateTime(_date.year, _date.month, _date.day);
    setState(() {
      _saving = true;
      _duplicateCheckFailed = false;
    });
    try {
      List<FinanceTransaction> duplicateCandidates = const [];
      try {
        final candidates = await ref
            .read(transactionRepositoryProvider)
            .findDuplicateCandidates(amountInCents: amount, date: date);
        duplicateCandidates = ReceiptParser.potentialDuplicates(
          amountInCents: amount,
          date: date,
          merchant: _merchant.text,
          transactions: candidates,
        );
      } catch (_) {
        if (mounted) setState(() => _duplicateCheckFailed = true);
      }
      if (!mounted) return;
      if (duplicateCandidates.isNotEmpty) {
        final confirmed = await _confirmPossibleDuplicate(duplicateCandidates);
        if (confirmed != true || !mounted) return;
      }

      final itemSummary = _items.text
          .split(RegExp(r'[\n,;]+'))
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .join(', ');
      final description = [
        _merchant.text.trim(),
        if (itemSummary.isNotEmpty) 'Artículos: $itemSummary',
      ].where((part) => part.isNotEmpty).join(' · ');
      try {
        await ref
            .read(transactionRepositoryProvider)
            .create(
              FinanceTransaction(
                amountInCents: amount,
                type: TransactionType.expense,
                categoryId: _categoryId!,
                paymentMethodId: paymentMethodId!,
                description: description,
                date: date,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            );
        if (!mounted) return;
        MonyFeedback.success(context, 'Gasto del ticket guardado.');
        context.goNamed('transactions');
      } on InvalidTransactionException catch (error) {
        _showMessage(error.message);
      } catch (_) {
        _showMessage(
          'No se pudo guardar el gasto. Revisa tus selecciones e inténtalo de nuevo.',
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<bool?> _confirmPossibleDuplicate(
    List<FinanceTransaction> matches,
  ) => showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      icon: const Icon(Icons.content_paste_search_outlined),
      title: const Text('Posible ticket duplicado'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ya existe un gasto con el mismo importe y fecha:'),
            const SizedBox(height: 10),
            for (final match in matches.take(3))
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.receipt_long_outlined),
                title: Text(
                  match.description?.isNotEmpty == true
                      ? match.description!
                      : 'Gasto sin descripción',
                ),
                subtitle: Text(
                  '${MoneyFormatter.toDopInput(match.amountInCents)} DOP · ${_dateLabel(match.date)}',
                ),
              ),
            const SizedBox(height: 8),
            const Text('Comprueba que no hayas registrado ya este ticket.'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Volver a revisar'),
        ),
        FilledButton.tonal(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Guardar de todos modos'),
        ),
      ],
    ),
  );

  void _showMessage(String message) {
    if (!mounted) return;
    MonyFeedback.info(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final defaultMethod = ref.watch(defaultPaymentMethodProvider).value;
    final maxWidth = MediaQuery.sizeOf(context).width > 760
        ? 760.0
        : MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear ticket')),
      body: Center(
        child: SizedBox(
          width: maxWidth,
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Importa una foto o registra los datos manualmente. Revisa cada campo antes de guardar.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    if (_supportsOnDeviceOcr)
                      FilledButton.tonalIcon(
                        onPressed: _recognizing
                            ? null
                            : () => _pickImage(ImageSource.camera),
                        icon: const Icon(Icons.photo_camera_outlined),
                        label: const Text('Tomar foto'),
                      ),
                    OutlinedButton.icon(
                      onPressed: _recognizing
                          ? null
                          : () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Importar imagen'),
                    ),
                  ],
                ),
                if (_imageBytes != null) ...[
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.memory(
                      _imageBytes!,
                      height: 220,
                      cacheHeight:
                          (220 * MediaQuery.devicePixelRatioOf(context))
                              .round(),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stack) => const SizedBox(
                        height: 90,
                        child: Center(
                          child: Text('No se puede mostrar la imagen.'),
                        ),
                      ),
                    ),
                  ),
                ],
                if (_recognizing) ...[
                  const SizedBox(height: 12),
                  const LinearProgressIndicator(),
                  const SizedBox(height: 6),
                  const Text('Leyendo ticket en el dispositivo…'),
                ],
                if (_notice != null) ...[
                  const SizedBox(height: 10),
                  Text(_notice!, style: Theme.of(context).textTheme.bodySmall),
                ],
                const SizedBox(height: 18),
                TextFormField(
                  controller: _rawText,
                  onChanged: (_) => setState(() {}),
                  minLines: 2,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: 'Texto leído o pegado (opcional)',
                    hintText:
                        'Puedes corregir el texto y volver a extraer los datos.',
                    border: OutlineInputBorder(),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: _rawText.text.trim().isEmpty
                        ? null
                        : () => _applyText(_rawText.text),
                    icon: const Icon(Icons.auto_fix_high),
                    label: const Text('Extraer datos del texto'),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _merchant,
                  maxLength: 100,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Comercio',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amount,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Total del ticket',
                    prefixText: 'RD\$ ',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => TransactionValidator.validateAmount(
                    MoneyFormatter.parseDopMinorUnits(value ?? ''),
                  ),
                ),
                const SizedBox(height: 16),
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Fecha de compra',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(_dateLabel(_date))),
                      IconButton(
                        tooltip: 'Cambiar fecha',
                        onPressed: _chooseDate,
                        icon: const Icon(Icons.calendar_month_outlined),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _items,
                  minLines: 2,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Artículos (opcional)',
                    hintText: 'Se guardan como nota del gasto.',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                CategoryPicker(
                  type: CategoryType.expense,
                  value: _categoryId,
                  onChanged: (category) =>
                      setState(() => _categoryId = category?.id),
                ),
                const SizedBox(height: 10),
                PaymentMethodPicker(
                  value: _paymentMethodId,
                  onChanged: (method) =>
                      setState(() => _paymentMethodId = method?.id),
                ),
                if (_duplicateCheckFailed)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      'No pudimos revisar si ya existe un movimiento igual. Aun así puedes guardar tras verificar tu historial.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: _saving || _recognizing
                      ? null
                      : () => _save(defaultMethod),
                  icon: _saving
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  label: const Text('Revisé y guardar gasto'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _dateLabel(DateTime date) => MonyDateFormatter.formatDate(date);
