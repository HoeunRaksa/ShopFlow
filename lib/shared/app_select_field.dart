import 'package:flutter/material.dart';
class AppSelectField<T> extends StatefulWidget {
  const AppSelectField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.isEnabled = true,
  });

  final String? label;
  final String? hint;
  final String? helperText;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final Widget? prefixIcon;
  final bool isEnabled;

  @override
  State<AppSelectField<T>> createState() => _AppSelectFieldState<T>();
}
class _AppSelectFieldState<T> extends State<AppSelectField<T>> {
  static const _primary = Color(0xFF185FA5);
  static const _errorClr = Color(0xFFA32D2D);
  static const _radius = BorderRadius.all(Radius.circular(8));

  final _formFieldKey = GlobalKey<FormFieldState<T>>();
  T? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.value;
  }

  @override
  void didUpdateWidget(AppSelectField<T> old) {
    super.didUpdateWidget(old);
    if (widget.value != old.value) {
      setState(() => _selected = widget.value);
    }
  }

  InputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: _radius,
    borderSide: BorderSide(color: color, width: 1.5),
  );

  Widget? _selectedLabel() {
    if (_selected == null) return null;
    try {
      final match = widget.items.firstWhere((i) => i.value == _selected);
      return match.child;
    } catch (_) {
      return null;
    }
  }

  Future<void> _openSheet() async {
    if (!widget.isEnabled) return;

    // Unfocus any active field first
    FocusScope.of(context).unfocus();

    final result = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SelectSheet<T>(
        items: widget.items,
        selected: _selected,
        primary: _primary,
      ),
    );

    // result == null means dismissed without picking — don't clear selection
    if (!mounted) return;
    if (result != null || (result == null && _selected != null)) {
      // Only update if user tapped an item (result != null)
      if (result != null) {
        setState(() => _selected = result);
        _formFieldKey.currentState?.didChange(result);
        widget.onChanged?.call(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      key: _formFieldKey,
      initialValue: _selected,
      validator: widget.validator,
      builder: (state) {
        final hasError = state.hasError;
        final borderColor = hasError
            ? _errorClr
            : !widget.isEnabled
            ? Colors.grey.shade200
            : Colors.grey.shade400;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Tap target ──────────────────────────────────────────────
            GestureDetector(
              onTap: widget.isEnabled ? _openSheet : null,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: widget.label,
                  hintText: widget.hint,
                  prefixIcon: widget.prefixIcon,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  filled: !widget.isEnabled,
                  fillColor: Colors.grey.shade100,
                  enabledBorder: _border(borderColor),
                  focusedBorder: _border(_primary),
                  errorBorder: _border(_errorClr),
                  focusedErrorBorder: _border(_errorClr),
                  disabledBorder: _border(Colors.grey.shade200),
                  labelStyle: const TextStyle(fontSize: 14),
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade400,
                  ),
                  // Suppress the built-in error — we render it below
                  errorStyle: const TextStyle(height: 0, fontSize: 0),
                  border: _border(borderColor),
                ),
                isEmpty: _selected == null,
                child: Row(
                  children: [
                    Expanded(
                      child: _selectedLabel() != null
                          ? DefaultTextStyle(
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        child: _selectedLabel()!,
                      )
                          : Text(
                        widget.hint ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: widget.isEnabled
                          ? Colors.grey.shade600
                          : Colors.grey.shade300,
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),

            // ── Helper / error text ──────────────────────────────────────
            if (hasError || widget.helperText != null)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 14, right: 14),
                child: Text(
                  hasError ? state.errorText! : widget.helperText!,
                  style: TextStyle(
                    fontSize: 11,
                    color: hasError ? _errorClr : Colors.grey.shade600,
                  ),
                  maxLines: 3,
                ),
              ),
          ],
        );
      },
    );
  }
}
// ─────────────────────────────────────────────────────────────────────────────
// Bottom-sheet content
// ─────────────────────────────────────────────────────────────────────────────
class _SelectSheet<T> extends StatefulWidget {
  const _SelectSheet({
    required this.items,
    required this.selected,
    required this.primary,
  });

  final List<DropdownMenuItem<T>> items;
  final T? selected;
  final Color primary;

  @override
  State<_SelectSheet<T>> createState() => _SelectSheetState<T>();
}
class _SelectSheetState<T> extends State<_SelectSheet<T>> {
  final _searchController = TextEditingController();
  late List<DropdownMenuItem<T>> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = widget.items;
    _searchController.addListener(_onSearch);
  }

  void _onSearch() {
    final q = _searchController.text.trim().toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? widget.items
          : widget.items.where((item) {
        // Best-effort: stringify the child widget if it's a Text
        final child = item.child;
        if (child is Text) {
          return (child.data ?? '').toLowerCase().contains(q);
        }
        return true; // keep items we can't inspect
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    // Cap the sheet at 60 % of the screen; let it shrink for small lists
    final maxHeight = mq.size.height * 0.60;

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Handle ──────────────────────────────────────────────────
            const SizedBox(height: 10),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),

            // ── Search ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                autofocus: widget.items.length > 8,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search…',
                  hintStyle:
                  TextStyle(fontSize: 14, color: Colors.grey.shade400),
                  prefixIcon: const Icon(Icons.search, size: 20),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // ── Divider ─────────────────────────────────────────────────
            Divider(height: 1, color: Colors.grey.shade200),

            // ── List ─────────────────────────────────────────────────────
            Flexible(
              child: _filtered.isEmpty
                  ? Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'No results found',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              )
                  : ListView.builder(
                padding: EdgeInsets.only(
                  top: 4,
                  bottom: mq.viewInsets.bottom + 8,
                ),
                itemCount: _filtered.length,
                itemBuilder: (_, i) {
                  final item = _filtered[i];
                  final isSelected = item.value == widget.selected;

                  return InkWell(
                    onTap: () => Navigator.of(context).pop(item.value),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      color: isSelected
                          ? widget.primary.withValues(alpha: 0.06)
                          : null,
                      child: Row(
                        children: [
                          Expanded(
                            child: DefaultTextStyle(
                              style: TextStyle(
                                fontSize: 14,
                                color: isSelected
                                    ? widget.primary
                                    : Colors.black87,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                              child: item.child,
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check_rounded,
                                size: 18, color: widget.primary),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}