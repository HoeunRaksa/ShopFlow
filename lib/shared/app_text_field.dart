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

  static const _radius = BorderRadius.all(Radius.circular(12));
  static const _iosRadius = BorderRadius.all(Radius.circular(14));

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
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
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 7),
            child: Text(
              widget.label!,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withOpacity(0.6),
                letterSpacing: 0.1,
              ),
            ),
          ),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: _radius,
            color: isDark
                ? Colors.white.withOpacity(_isFocused ? 0.09 : 0.05)
                : (_isFocused
                ? colorScheme.primary.withOpacity(0.03)
                : Colors.black.withOpacity(0.035)),
            boxShadow: _isFocused
                ? [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.12),
                blurRadius: 0,
                spreadRadius: 1.5,
              ),
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.06),
                blurRadius: 8,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ]
                : [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                blurRadius: 4,
                spreadRadius: 0,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: _radius,
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
                fontSize: 14.5,
                fontWeight: FontWeight.w400,
                color: colorScheme.onSurface,
                letterSpacing: -0.1,
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
                    color: _isFocused
                        ? colorScheme.primary.withOpacity(0.8)
                        : theme.hintColor,
                    size: 18,
                  ),
                  child: widget.prefixIcon!,
                )
                    : null,
                suffixIcon: widget.isPassword
                    ? IconButton(
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 18,
                    color: theme.hintColor,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                )
                    : widget.suffixIcon,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                filled: true,
                fillColor: Colors.transparent,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: OutlineInputBorder(
                  borderRadius: _radius,
                  borderSide: BorderSide(
                    color: colorScheme.error.withOpacity(0.5),
                    width: 0.8,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: _radius,
                  borderSide: BorderSide(
                    color: colorScheme.error,
                    width: 0.8,
                  ),
                ),
                disabledBorder: InputBorder.none,
                labelStyle: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface.withOpacity(0.5),
                ),
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: theme.hintColor,
                  fontWeight: FontWeight.w400,
                ),
                errorStyle: TextStyle(
                  fontSize: 11,
                  color: colorScheme.error,
                ),
              ),
            ),
          ),
        ),
      ],
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
            padding: const EdgeInsets.only(left: 4, bottom: 7),
            child: Text(
              widget.label!,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withOpacity(0.6),
                letterSpacing: 0.1,
              ),
            ),
          ),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: _iosRadius,
            color: isDark
                ? Colors.white.withOpacity(_isFocused ? 0.10 : 0.06)
                : (_isFocused
                ? colorScheme.primary.withOpacity(0.03)
                : Colors.black.withOpacity(0.030)),
            boxShadow: _isFocused
                ? [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.13),
                blurRadius: 0,
                spreadRadius: 1.5,
              ),
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.07),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 3),
              ),
            ]
                : [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.22 : 0.06),
                blurRadius: 6,
                spreadRadius: 0,
                offset: const Offset(0, 1),
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
                    color: _isFocused
                        ? colorScheme.primary.withOpacity(0.8)
                        : theme.hintColor,
                    size: 18,
                  ),
                  child: widget.prefixIcon!,
                )
                    : null,
                suffixIcon: widget.isPassword
                    ? IconButton(
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 18,
                    color: theme.hintColor,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                )
                    : widget.suffixIcon,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                filled: true,
                fillColor: Colors.transparent,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: OutlineInputBorder(
                  borderRadius: _iosRadius,
                  borderSide: BorderSide(
                    color: errorClr.withOpacity(0.5),
                    width: 0.8,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: _iosRadius,
                  borderSide: BorderSide(color: errorClr, width: 0.8),
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
      ],
    );
  }
}