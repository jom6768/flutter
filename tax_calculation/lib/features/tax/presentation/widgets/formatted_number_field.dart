import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:tax_calculation/features/tax/presentation/formatters/decimal_input_formatter.dart';
import 'package:tax_calculation/features/tax/presentation/utils/number_format_utils.dart';

/// TextFormField for number
/// - tap: delete comma + select all (iOS/Android)
/// - blur: add comma + fixed 2 decimals
/// - used value is double (no comma)
class FormattedNumberField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int decimalRange;
  final bool enabled;
  final TextInputAction textInputAction;
  final FocusNode? nextFocusNode;

  const FormattedNumberField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.decimalRange = 2,
    this.enabled = true,
    this.textInputAction = TextInputAction.next,
    this.nextFocusNode,
  });

  @override
  State<FormattedNumberField> createState() => _FormattedNumberFieldState();
}

class _FormattedNumberFieldState extends State<FormattedNumberField> {
  late final FocusNode _focusNode;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      // 👉 Focus in (Tab / Next / programmatic)
      if (_focusNode.hasFocus && !_editing) {
        _enterEditMode();
      }

      // 👉 Focus out (blur)
      if (!_focusNode.hasFocus && _editing) {
        _exitEditMode();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
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

  void _handleSubmitted() {
    _exitEditMode();

    if (widget.nextFocusNode != null) {
      widget.nextFocusNode!.requestFocus();
    } else {
      _focusNode.unfocus();
    }
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
      ),
      validator: widget.validator,
      textInputAction: widget.textInputAction,

      // 👉 soft keyboard "Next / Done"
      onFieldSubmitted: (_) => _handleSubmitted(),

      // 👉 for touch (iOS)
      onTap: () {
        if (!_editing) {
          _enterEditMode();
        }
      },
    );
  }
}
