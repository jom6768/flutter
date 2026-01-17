import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:tax_calculation/features/tax/utils/decimal_input_formatter.dart';
import 'package:tax_calculation/features/tax/utils/number_format_utils.dart';

/// TextFormField for number
/// - tap: delete comma + select all (iOS/Android)
/// - blur: add comma + fixed 2 decimals
/// - used value is double (no comma)
class FormattedNumberField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? infoTooltip;
  final int decimalRange;
  final bool enabled;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;

  const FormattedNumberField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.decimalRange = 2,
    this.enabled = true,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.nextFocusNode,
    this.infoTooltip,
    this.onChanged,
    this.onFieldSubmitted,
  });

  @override
  State<FormattedNumberField> createState() => _FormattedNumberFieldState();
}

class _FormattedNumberFieldState extends State<FormattedNumberField> {
  FocusNode? _internalFocusNode;
  bool _editing = false;
  bool _hoveringInfo = false;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  bool get _ownsFocusNode => widget.focusNode == null;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      // Focus in (Tab / Next / programmatic)
      if (_focusNode.hasFocus && !_editing) {
        _enterEditMode();
      }

      // Focus out (blur)
      if (!_focusNode.hasFocus && _editing) {
        _exitEditMode();
      }
    });
  }

  @override
  void dispose() {
    if (_ownsFocusNode) {
      _internalFocusNode?.dispose();
    }
    super.dispose();
  }

  void _enterEditMode() {
    _editing = true;

    final controller = widget.controller;
    final value = parseNumber(controller.text);
    final text = formatForEdit(value);

    controller.text = text;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: controller.text.length,
      );
    });
  }

  void _exitEditMode() {
    _editing = false;

    final controller = widget.controller;
    final value = parseNumber(controller.text);

    controller.text = formatForDisplay(value);
  }

  void _handleSubmitted(String _) {
    _exitEditMode();

    if (widget.nextFocusNode != null) {
      widget.nextFocusNode!.requestFocus();
    } else {
      _focusNode.unfocus();
    }
  }

  Widget? _buildInfoIcon(BuildContext context) {
    if (widget.infoTooltip == null) return null;

    final theme = Theme.of(context);

    return Tooltip(
      message: widget.infoTooltip!,
      waitDuration: const Duration(milliseconds: 300),
      showDuration: const Duration(seconds: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      preferBelow: false,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 13,
        height: 1.4,
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.help,
        onEnter: (_) => setState(() => _hoveringInfo = true),
        onExit: (_) => setState(() => _hoveringInfo = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: _hoveringInfo
                ? theme.colorScheme.primary.withOpacity(0.08)
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.info_outline,
            size: 18,
            color: _hoveringInfo ? theme.colorScheme.primary : Colors.grey,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      textAlign: TextAlign.right,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
        DecimalInputFormatter(decimalRange: widget.decimalRange),
      ],
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        prefixIcon: _buildInfoIcon(context),
      ),
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,

      // soft keyboard "Next / Done"
      onFieldSubmitted: (value) {
        _exitEditMode();

        if (widget.onFieldSubmitted != null) {
          // ให้ parent จัดการเอง (เช่น animate tab + focus)
          widget.onFieldSubmitted!.call(value);
          return;
        }

        // default behavior
        if (widget.nextFocusNode != null) {
          widget.nextFocusNode!.requestFocus();
        } else {
          _focusNode.unfocus();
        }
      },

      // for touch (iOS)
      onTap: () {
        if (!_editing) {
          _enterEditMode();
        }
      },
    );
  }
}
