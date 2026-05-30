import 'package:flutter/material.dart';
import '../../../../shared/app_text_field.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
    required this.onClear,
    required this.onDismiss,
    required this.onChange,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;
  final VoidCallback onDismiss;
  final ValueChanged<String> onChange;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => widget.focusNode.requestFocus(),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AppTextField(
      onChanged: widget.onChange,
      controller: widget.controller,
      focusNode: widget.focusNode,
      hint: 'Search…',
      textInputAction: TextInputAction.search,
      autofocus: false,
      onFieldSubmitted: widget.onSubmitted,
      // We wrap inside a constrained, padded container to neutralize standard IconButton bloating
      prefixIcon: Container(
        margin: const EdgeInsets.all(4),
        child: IconButton(
          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          padding: EdgeInsets.zero,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: colors.onSurface.withOpacity(0.6),
            size: 20,
          ),
          splashRadius: 10,
          onPressed: widget.onDismiss,
        ),
      ),
      // We always render a widget structure here, using Visibility to hide it.
      // This guarantees that the space requirements never fluctuate when typing.
      suffixIcon: Visibility(
        visible: _hasText,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: Container(
          margin: const EdgeInsets.all(4),
          child: IconButton(
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.close_rounded,
              color: colors.onSurface.withOpacity(0.5),
              size: 20,
            ),
            splashRadius: 10,
            onPressed: widget.onClear,
          ),
        ),
      ),
    );
  }
}