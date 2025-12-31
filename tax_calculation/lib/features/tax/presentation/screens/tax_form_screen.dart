import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/tax_history.dart';
import '../../domain/services/tax_calculator.dart';
import '../providers/tax_provider.dart';
import 'tax_result_screen.dart';
import 'tax_history_screen.dart';

class TaxFormScreen extends ConsumerStatefulWidget {
  const TaxFormScreen({super.key});

  @override
  ConsumerState<TaxFormScreen> createState() => _TaxFormScreenState();
}

class _TaxFormScreenState extends ConsumerState<TaxFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _annualIncomeController = TextEditingController(text: '0');
  final _providentFundController = TextEditingController(text: '0');
  final _socialSecurityController = TextEditingController(text: '0');

  bool _isSaving = false;

  @override
  void dispose() {
    _annualIncomeController.dispose();
    _providentFundController.dispose();
    _socialSecurityController.dispose();
    super.dispose();
  }

  Future<void> _calculate() async {
    if (!_formKey.currentState!.validate()) return;

    final annualIncome = double.tryParse(_annualIncomeController.text) ?? 0;
    final personalExpense = min(annualIncome * 0.5, 100000).toDouble();
    const personalDeduction = 60000;
    final providentFund = double.tryParse(_providentFundController.text) ?? 0;
    final socialSecurity = double.tryParse(_socialSecurityController.text) ?? 0;

    setState(() => _isSaving = true);

    final tax = TaxCalculator.calculate(
      annualIncome: annualIncome,
      personalExpense: personalExpense,
      personalDeduction: personalDeduction.toDouble(),
      providentFund: providentFund,
      socialSecurity: socialSecurity,
    );

    final history = TaxHistory(
      annualIncome: annualIncome,
      personalExpense: personalExpense,
      personalDeduction: personalDeduction.toDouble(),
      providentFund: providentFund,
      socialSecurity: socialSecurity,
      tax: tax,
    );

    // Save to DB
    await ref.read(taxRepositoryProvider).save(history);

    if (!mounted) return;
    setState(() => _isSaving = false);

    // Navigate to Result Screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaxResultScreen(history: history),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('คำนวณภาษีเงินได้'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'ดูประวัติ',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TaxHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            children: [
              _buildNumberField(
                controller: _annualIncomeController,
                label: 'รายได้ต่อปี (บาท)',
                validator: (value) => numberValidator(value, required: true),
              ),
              const SizedBox(height: 12),
              _buildNumberField(
                controller: _providentFundController,
                label: 'กองทุนสำรองเลี้ยงชีพ (บาท)',
                validator: (value) => numberValidator(value),
              ),
              const SizedBox(height: 12),
              _buildNumberField(
                controller: _socialSecurityController,
                label: 'ค่าประกันสังคม (บาท)',
                validator: (value) => numberValidator(value),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _calculate,
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('คำนวณภาษี'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller..text = '0',
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) {
        // Replace empty string with '0'
        if (value.isEmpty) {
          controller.text = '0';
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length),
          );
          // Force only 1 period and max 2 decimal places
        } else if ('.'.allMatches(value).isNotEmpty) {
          int firstDotIndex = value.indexOf('.');
          if (firstDotIndex >= 0) {
            String beforeDot = value.substring(0, firstDotIndex + 1);
            if (beforeDot.startsWith('0') &&
                beforeDot != '0' &&
                !beforeDot.startsWith('0.')) {
              beforeDot = beforeDot.substring(1, beforeDot.length);
            }
            String afterDot = value
                .substring(firstDotIndex + 1)
                .replaceAll('.', ''); // Remove all extra dots
            if (afterDot.length > 2) {
              afterDot = afterDot.substring(0, 2);
            }
            final newValue = beforeDot + afterDot;
            controller.text = newValue;
            controller.selection = TextSelection.fromPosition(
              TextPosition(offset: newValue.length),
            );
          }
        } else if (value.startsWith('0') &&
            value != '0' &&
            !value.startsWith('0.')) {
          final newValue = value.substring(1, value.length);
          controller.text = newValue;
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: newValue.length),
          );
        }
      },
      validator: validator,
    );
  }
}

String? numberValidator(String? value, {bool required = false}) {
  if (required && (value == null || value.isEmpty)) {
    return "กรุณากรอกข้อมูล";
  }
  if (value != null && value.isNotEmpty) {
    if (double.tryParse(value) == null) {
      return "กรุณากรอกเป็นตัวเลข";
    } else if (required && (double.tryParse(value) ?? 0) <= 0) {
      return "กรุณากรอกเป็นตัวเลขมากกว่า 0";
    }
  }
  return null;
}

String? emailValidator(String? value) {
  // Regex for email
  final emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );
  if (value == null || value.isEmpty) {
    return 'กรุณากรอกอีเมล';
  } else if (!emailRegex.hasMatch(value)) {
    return 'รูปแบบอีเมลไม่ถูกต้อง';
  }
  return null;
}
