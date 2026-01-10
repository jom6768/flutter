import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tax_calculation/features/tax/domain/models/tax_history.dart';
import 'package:tax_calculation/features/tax/presentation/providers/tax_calculate_provider.dart';
import 'package:tax_calculation/features/tax/presentation/screens/tax_result_screen.dart';
import 'package:tax_calculation/features/tax/presentation/screens/tax_history_screen.dart';
import 'package:tax_calculation/features/tax/presentation/validators/form_validators.dart';
import 'package:tax_calculation/features/tax/presentation/widgets/formatted_number_field.dart';
import 'package:tax_calculation/features/tax/presentation/utils/number_format_utils.dart';

class TaxFormScreen extends ConsumerStatefulWidget {
  const TaxFormScreen({super.key});

  @override
  ConsumerState<TaxFormScreen> createState() => _TaxFormScreenState();
}

class _TaxFormScreenState extends ConsumerState<TaxFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _annualIncomeController =
      TextEditingController(text: formatForDisplay(0));
  final _providentFundController =
      TextEditingController(text: formatForDisplay(0));
  final _socialSecurityController =
      TextEditingController(text: formatForDisplay(0));

  // FocusNodes สำหรับ Next
  final _annualFocus = FocusNode();
  final _providentFocus = FocusNode();
  final _socialFocus = FocusNode();

  @override
  void dispose() {
    _annualIncomeController.dispose();
    _providentFundController.dispose();
    _socialSecurityController.dispose();

    _annualFocus.dispose();
    _providentFocus.dispose();
    _socialFocus.dispose();

    super.dispose();
  }

  Future<void> _calculate() async {
    if (!_formKey.currentState!.validate()) return;

    final input = TaxInput(
      annualIncome: parseNumber(_annualIncomeController.text),
      providentFund: parseNumber(_providentFundController.text),
      socialSecurity: parseNumber(_socialSecurityController.text),
    );

    final result = await ref.read(taxCalculateProvider(input).future);

    final history = TaxHistory(
      annualIncome: input.annualIncome,
      personalExpense: (input.annualIncome * 0.5).clamp(0, 100000),
      personalDeduction: 60000,
      providentFund: input.providentFund,
      socialSecurity: input.socialSecurity,
      tax: result.tax,
    );

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaxResultScreen(
          history: history,
          result: result,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(
          taxCalculateProvider(
            const TaxInput(
              annualIncome: 0,
              providentFund: 0,
              socialSecurity: 0,
            ),
          ),
        )
        .isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('คำนวณภาษีเงินได้'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
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
              FormattedNumberField(
                label: 'เงินได้ทั้งปี (บาท)',
                controller: _annualIncomeController,
                validator: (v) => numberValidator(v, required: true),
                textInputAction: TextInputAction.next,
                nextFocusNode: _providentFocus,
              ),
              const SizedBox(height: 12),
              FormattedNumberField(
                label: 'กองทุนสำรองเลี้ยงชีพ (บาท)',
                controller: _providentFundController,
                validator: numberValidator,
                textInputAction: TextInputAction.next,
                nextFocusNode: _socialFocus,
              ),
              const SizedBox(height: 12),
              FormattedNumberField(
                label: 'ค่าประกันสังคม (บาท)',
                controller: _socialSecurityController,
                validator: numberValidator,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _calculate,
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
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
}
