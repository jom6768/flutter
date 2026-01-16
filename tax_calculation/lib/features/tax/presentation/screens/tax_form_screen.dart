import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tax_calculation/features/tax/application/tax_provider.dart';
import 'package:tax_calculation/features/tax/domain/tax_models.dart';
import 'package:tax_calculation/features/tax/presentation/screens/tax_result_screen.dart';
import 'package:tax_calculation/features/tax/presentation/screens/tax_history_screen.dart';
import 'package:tax_calculation/features/tax/presentation/widgets/formatted_number_field.dart';
import 'package:tax_calculation/features/tax/utils/form_validators.dart';
import 'package:tax_calculation/features/tax/utils/number_format_utils.dart';

class TaxFormScreen extends ConsumerStatefulWidget {
  final TaxHistory? initialHistory;

  const TaxFormScreen({
    super.key,
    this.initialHistory,
  });

  @override
  ConsumerState<TaxFormScreen> createState() => _TaxFormScreenState();
}

class _TaxFormScreenState extends ConsumerState<TaxFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late final TextEditingController _annualIncomeController;
  late final TextEditingController _providentFundController;
  late final TextEditingController _socialSecurityController;
  late final TextEditingController _lifeInsuranceController;
  late final TextEditingController _healthInsuranceController;
  late final TextEditingController _doubleDonationController;
  late final TextEditingController _normalDonationController;

  // FocusNodes
  final _annualFocus = FocusNode();
  final _providentFocus = FocusNode();
  final _socialSecurityFocus = FocusNode();
  final _lifeInsuranceFocus = FocusNode();
  final _healthInsuranceFocus = FocusNode();
  final _doubleDonationFocus = FocusNode();
  final _normalDonationFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    final h = widget.initialHistory;

    _annualIncomeController =
        TextEditingController(text: formatForDisplay(h?.annualIncome ?? 0));
    _providentFundController =
        TextEditingController(text: formatForDisplay(h?.providentFund ?? 0));
    _socialSecurityController =
        TextEditingController(text: formatForDisplay(h?.socialSecurity ?? 0));
    _lifeInsuranceController =
        TextEditingController(text: formatForDisplay(h?.lifeInsurance ?? 0));
    _healthInsuranceController =
        TextEditingController(text: formatForDisplay(h?.healthInsurance ?? 0));
    _doubleDonationController =
        TextEditingController(text: formatForDisplay(h?.doubleDonation ?? 0));
    _normalDonationController =
        TextEditingController(text: formatForDisplay(h?.normalDonation ?? 0));
  }

  @override
  void dispose() {
    _annualIncomeController.dispose();
    _providentFundController.dispose();
    _socialSecurityController.dispose();
    _lifeInsuranceController.dispose();
    _healthInsuranceController.dispose();
    _doubleDonationController.dispose();
    _normalDonationController.dispose();

    _annualFocus.dispose();
    _providentFocus.dispose();
    _socialSecurityFocus.dispose();
    _lifeInsuranceFocus.dispose();
    _healthInsuranceFocus.dispose();
    _doubleDonationFocus.dispose();
    _normalDonationFocus.dispose();

    super.dispose();
  }

  Future<void> _calculate() async {
    if (!_formKey.currentState!.validate()) return;

    ref.read(taxLoadingProvider.notifier).state = true;

    final input = TaxInput(
      annualIncome: parseNumber(_annualIncomeController.text),
      providentFund: parseNumber(_providentFundController.text),
      socialSecurity: parseNumber(_socialSecurityController.text),
      lifeInsurance: parseNumber(_lifeInsuranceController.text),
      healthInsurance: parseNumber(_healthInsuranceController.text),
      doubleDonation: parseNumber(_doubleDonationController.text),
      normalDonation: parseNumber(_normalDonationController.text),
    );

    final result = await ref.read(taxCalculateProvider(input).future);

    final history = TaxHistory(
      id: widget.initialHistory?.id,
      annualIncome: input.annualIncome,
      personalExpense: (input.annualIncome * 0.5).clamp(0, 100000),
      personalDeduction: 60000,
      providentFund: input.providentFund,
      socialSecurity: input.socialSecurity,
      lifeInsurance: input.lifeInsurance,
      healthInsurance: input.healthInsurance,
      doubleDonation: input.doubleDonation,
      normalDonation: input.normalDonation,
      tax: result.tax,
    );

    ref.read(taxLoadingProvider.notifier).state = false;

    if (!mounted) return;

    // ===== EDIT MODE =====
    if (widget.initialHistory != null) {
      Navigator.pop(context, history);
      return;
    }

    // ===== CREATE MODE =====
    final id = await ref.read(taxRepositoryProvider).insert(history);

    if (!mounted) return;

    final savedHistory = history.copyWith(id: id);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => TaxResultScreen(
          history: savedHistory,
          result: result,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(taxLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('คำนวณภาษีเงินได้'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'ดูประวัติ',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const TaxHistoryScreen(),
                ),
                (route) => false,
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
                nextFocusNode: _socialSecurityFocus,
              ),
              const SizedBox(height: 12),
              FormattedNumberField(
                label: 'ค่าประกันสังคม (บาท)',
                controller: _socialSecurityController,
                validator: numberValidator,
                textInputAction: TextInputAction.next,
                nextFocusNode: _lifeInsuranceFocus,
              ),
              const SizedBox(height: 12),
              FormattedNumberField(
                label: 'เบี้ยประกันชีวิต (บาท)',
                controller: _lifeInsuranceController,
                validator: numberValidator,
                textInputAction: TextInputAction.next,
                nextFocusNode: _healthInsuranceFocus,
              ),
              const SizedBox(height: 12),
              FormattedNumberField(
                label: 'เบี้ยประกันสุขภาพ (บาท)',
                controller: _healthInsuranceController,
                validator: numberValidator,
                textInputAction: TextInputAction.next,
                nextFocusNode: _doubleDonationFocus,
              ),
              const SizedBox(height: 12),
              FormattedNumberField(
                label: 'บริจาคเพื่อการศึกษา/กีฬา/โรงพยาบาลรัฐ (บาท)',
                controller: _doubleDonationController,
                validator: numberValidator,
                textInputAction: TextInputAction.next,
                nextFocusNode: _normalDonationFocus,
              ),
              const SizedBox(height: 12),
              FormattedNumberField(
                label: 'บริจาคอื่นๆ (บาท)',
                controller: _normalDonationController,
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
                      : const Text('บันทึก และคำนวณภาษี'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
