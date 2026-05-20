import 'dart:ffi';

import 'package:flutter/material.dart';
import '../../../../shared/app_text_field.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
    required this.onClear,
    required this.onDismiss,
    required this.onChange
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;
  final VoidCallback onDismiss;
  final Function(String) onChange;

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
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AppTextField(
      onChanged : widget.onChange,
      controller: widget.controller,
      focusNode: widget.focusNode,
      hint: 'Search…',
      textInputAction: TextInputAction.search,
      autofocus: false,
      onFieldSubmitted: widget.onSubmitted,
      prefixIcon: IconButton(
        icon: Icon(
          Icons.arrow_back_rounded,
          color: colors.onSurface.withOpacity(0.6),
        ),
        splashRadius: 20,
        onPressed: widget.onDismiss,
      ),
      suffixIcon: _hasText
          ? IconButton(
        icon: Icon(
          Icons.close_rounded,
          color: colors.onSurface.withOpacity(0.5),
        ),
        splashRadius: 18,
        onPressed: widget.onClear,
      )
          : null,
    );
  }
}
