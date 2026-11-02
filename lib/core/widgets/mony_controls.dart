import 'package:flutter/material.dart';

import '../theme/mony_tokens.dart';

enum MonyButtonStyle { primary, secondary, text, danger }

class MonyButton extends StatelessWidget {
  const MonyButton({
    required this.label,
    required this.onPressed,
    this.style = MonyButtonStyle.primary,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final MonyButtonStyle style;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final child = icon == null
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon),
              const SizedBox(width: MonySpace.x2),
              Flexible(child: Text(label, textAlign: TextAlign.center)),
            ],
          );
    return switch (style) {
      MonyButtonStyle.primary => FilledButton(
        onPressed: onPressed,
        child: child,
      ),
      MonyButtonStyle.secondary => OutlinedButton(
        onPressed: onPressed,
        child: child,
      ),
      MonyButtonStyle.text => TextButton(onPressed: onPressed, child: child),
      MonyButtonStyle.danger => FilledButton.tonal(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.error,
        ),
        child: child,
      ),
    };
  }
}

class MonyIconButton extends StatelessWidget {
  const MonyIconButton({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.selected = false,
    super.key,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: semanticLabel,
    isSelected: selected,
    onPressed: onPressed,
    icon: Icon(icon),
    selectedIcon: Icon(icon),
  );
}

class SearchField extends StatelessWidget {
  const SearchField({
    required this.controller,
    required this.onChanged,
    this.hintText = 'Buscar',
    this.onClear,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    onChanged: onChanged,
    textInputAction: TextInputAction.search,
    decoration: InputDecoration(
      hintText: hintText,
      prefixIcon: const Icon(Icons.search),
      suffixIcon: controller.text.isEmpty
          ? null
          : IconButton(
              tooltip: 'Limpiar búsqueda',
              onPressed: onClear ?? controller.clear,
              icon: const Icon(Icons.close),
            ),
    ),
  );
}

class MonyFilterChip extends StatelessWidget {
  const MonyFilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    this.avatar,
    super.key,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final Widget? avatar;

  @override
  Widget build(BuildContext context) => FilterChip(
    label: Text(label),
    avatar: avatar,
    selected: selected,
    onSelected: onSelected,
  );
}

class AppIcon extends StatelessWidget {
  const AppIcon({
    required this.icon,
    this.semanticLabel,
    this.size = 24,
    this.color,
    super.key,
  });

  final IconData icon;
  final String? semanticLabel;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final widget = Icon(icon, size: size, color: color);
    return semanticLabel == null
        ? ExcludeSemantics(child: widget)
        : Semantics(label: semanticLabel, image: true, child: widget);
  }
}
