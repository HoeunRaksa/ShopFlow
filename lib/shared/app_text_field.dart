import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.controller,
    this.focusNode,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.isEnabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.initialValue,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.iosStyle = false,
  });

  final String? label;
  final String? hint;
  final String? helperText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isPassword;
  final bool isEnabled;
  final bool readOnly;
  final int maxLines;
  final int? maxLength;
  final String? initialValue;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final bool iosStyle;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscure = true;
  bool _isFocused = false;
  late FocusNode _focusNode;
  static const _errorClr = Color(0xFFA32D2D);
  static const _radius = BorderRadius.all(Radius.circular(8));
  static const _iosRadius = BorderRadius.all(Radius.circular(16));

  InputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: _radius,
    borderSide: BorderSide(color: color, width: 1.5),
  );

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      if (widget.iosStyle) setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final errorClr = colorScheme.error;

    if (widget.iosStyle) return _buildIos(theme, colorScheme, errorClr);
    return _buildDefault(theme, colorScheme, errorClr);
  }

  Widget _buildDefault(ThemeData theme, ColorScheme colorScheme, Color errorClr) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      initialValue: widget.initialValue,
      obscureText: widget.isPassword && _obscure,
      keyboardType:
      widget.isPassword ? TextInputType.visiblePassword : widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      maxLength: widget.maxLength,
      enabled: widget.isEnabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      textCapitalization: widget.textCapitalization,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        helperText: widget.helperText,
        helperMaxLines: 3,
        errorMaxLines: 3,
        counterText: '',
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
            size: 18,
            color: theme.hintColor,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        )
            : widget.suffixIcon,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        filled: !widget.isEnabled,
        fillColor: theme.disabledColor.withOpacity(0.1),
        enabledBorder: _border(theme.dividerColor),
        focusedBorder: _border(colorScheme.primary),
        errorBorder: _border(errorClr),
        focusedErrorBorder: _border(errorClr),
        disabledBorder: _border(theme.disabledColor.withOpacity(0.2)),
        labelStyle: TextStyle(fontSize: 14, color: colorScheme.onSurface.withOpacity(0.7)),
        hintStyle: TextStyle(fontSize: 14, color: theme.hintColor),
        errorStyle: TextStyle(fontSize: 11, color: errorClr),
      ),
    );
  }

  Widget _buildIos(ThemeData theme, ColorScheme colorScheme, Color errorClr) {
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              widget.label!,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withOpacity(0.7),
                letterSpacing: 0.1,
              ),
            ),
          ),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: _iosRadius,
            color: isDark
                ? Colors.white.withOpacity(_isFocused ? 0.12 : 0.07)
                : Colors.black.withOpacity(_isFocused ? 0.04 : 0.02),
            border: Border.all(
              color: _isFocused
                  ? colorScheme.primary
                  : theme.dividerColor,
              width: _isFocused ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                blurRadius: 20,
                spreadRadius: -2,
                offset: const Offset(0, 4),
              ),
              if (_isFocused)
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.1),
                  blurRadius: 16,
                  spreadRadius: -2,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: _iosRadius,
            child: TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              initialValue: widget.initialValue,
              obscureText: widget.isPassword && _obscure,
              keyboardType: widget.isPassword
                  ? TextInputType.visiblePassword
                  : widget.keyboardType,
              textInputAction: widget.textInputAction,
              inputFormatters: widget.inputFormatters,
              maxLines: widget.isPassword ? 1 : widget.maxLines,
              maxLength: widget.maxLength,
              enabled: widget.isEnabled,
              readOnly: widget.readOnly,
              autofocus: widget.autofocus,
              textCapitalization: widget.textCapitalization,
              validator: widget.validator,
              onChanged: widget.onChanged,
              onFieldSubmitted: widget.onFieldSubmitted,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: colorScheme.onSurface,
                letterSpacing: -0.2,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                helperText: widget.helperText,
                helperMaxLines: 3,
                errorMaxLines: 3,
                counterText: '',
                prefixIcon: widget.prefixIcon != null
                    ? IconTheme(
                  data: IconThemeData(
                    color: theme.hintColor,
                    size: 18,
                  ),
                  child: widget.prefixIcon!,
                )
                    : null,
                suffixIcon: widget.isPassword
                    ? IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                    size: 18,
                    color: theme.hintColor,
                  ),
                  onPressed: () =>
                      setState(() => _obscure = !_obscure),
                )
                    : widget.suffixIcon,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 13,
                ),
                filled: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: OutlineInputBorder(
                  borderRadius: _iosRadius,
                  borderSide: BorderSide(
                    color: errorClr.withOpacity(0.7),
                    width: 1.5,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: _iosRadius,
                  borderSide: BorderSide(color: errorClr, width: 1.5),
                ),
                disabledBorder: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: theme.hintColor,
                  fontWeight: FontWeight.w400,
                ),
                errorStyle: TextStyle(fontSize: 11, color: errorClr),
              ),
            ),
          ),
        ),
        if (widget.helperText == null) const SizedBox(height: 0),
      ],
    );
  }
}