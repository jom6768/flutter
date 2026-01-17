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

class _TaxFormScreenState extends ConsumerState<TaxFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final TabController _tabController;

  // Controllers
  late final TextEditingController _annualIncomeController;
  late final TextEditingController _providentFundController;
  late final TextEditingController _socialSecurityController;
  late final TextEditingController _lifeInsuranceController;
  late final TextEditingController _healthInsuranceController;
  late final TextEditingController _doubleDonationController;
  late final TextEditingController _normalDonationController;

  // FocusNodes
  final _annualIncomeFocus = FocusNode();
  final _providentFundFocus = FocusNode();
  final _socialSecurityFocus = FocusNode();
  final _lifeInsuranceFocus = FocusNode();
  final _healthInsuranceFocus = FocusNode();
  final _doubleDonationFocus = FocusNode();
  final _normalDonationFocus = FocusNode();

  bool _incomeError = false;
  bool _deductionError = false;
  bool _donationError = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

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
    _tabController.dispose();
    _annualIncomeController.dispose();
    _providentFundController.dispose();
    _socialSecurityController.dispose();
    _lifeInsuranceController.dispose();
    _healthInsuranceController.dispose();
    _doubleDonationController.dispose();
    _normalDonationController.dispose();
    _annualIncomeFocus.dispose();
    _providentFundFocus.dispose();
    _socialSecurityFocus.dispose();
    _lifeInsuranceFocus.dispose();
    _healthInsuranceFocus.dispose();
    _doubleDonationFocus.dispose();
    _normalDonationFocus.dispose();
    super.dispose();
  }

  bool get _hasIncome => parseNumber(_annualIncomeController.text) > 0;

  void _animateToTab(int index, FocusNode focus) {
    _tabController.animateTo(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );

    Future.microtask(() {
      if (!mounted) return;
      focus.requestFocus();
    });
  }

  void _updateErrorState() {
    setState(() {
      _incomeError =
          numberValidator(_annualIncomeController.text, required: true) != null;

      _deductionError = [
        _providentFundController,
        _socialSecurityController,
        _lifeInsuranceController,
        _healthInsuranceController,
      ].any((c) => numberValidator(c.text) != null);

      _donationError = [
        _doubleDonationController,
        _normalDonationController,
      ].any((c) => numberValidator(c.text) != null);
    });
  }

  void _jumpToFirstErrorTab() {
    if (_incomeError) {
      _tabController.animateTo(0);
    } else if (_deductionError) {
      _tabController.animateTo(1);
    } else if (_donationError) {
      _tabController.animateTo(2);
    }
  }

  Future<void> _calculate() async {
    _updateErrorState();

    if (!_formKey.currentState!.validate()) {
      _jumpToFirstErrorTab();
      return;
    }

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

    if (widget.initialHistory != null) {
      Navigator.pop(context, history);
      return;
    }

    final id = await ref.read(taxRepositoryProvider).insert(history);
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => TaxResultScreen(
          history: history.copyWith(id: id),
          result: result,
        ),
      ),
    );
  }

  Tab _tab(
    String label,
    IconData icon,
    bool error, {
    bool disabled = false,
  }) {
    final color = disabled ? Colors.grey : null;

    return Tab(
      child: Opacity(
        opacity: disabled ? 0.5 : 1,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: color)),
            if (disabled)
              const Padding(
                padding: EdgeInsets.only(left: 4),
              ),
            if (error)
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(Icons.error, color: Colors.red, size: 16),
              ),
          ],
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(_hasIncome ? 48 : 78),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TabBar(
                controller: _tabController,
                onTap: (i) {
                  if (i > 0 && !_hasIncome) {
                    _tabController.animateTo(0);
                  }
                },
                tabs: [
                  _tab('เงินได้', Icons.payments, _incomeError),
                  _tab(
                    'ค่าลดหย่อน',
                    Icons.remove_circle,
                    _deductionError,
                    disabled: !_hasIncome,
                  ),
                  _tab(
                    'บริจาค',
                    Icons.volunteer_activism,
                    _donationError,
                    disabled: !_hasIncome,
                  ),
                ],
              ),
              if (!_hasIncome)
                Container(
                  width: double.infinity,
                  color: Colors.amber.shade100,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: const Text(
                    'กรุณากรอกเงินได้รวมทั้งปี เพื่อปลดล็อกแท็บค่าลดหย่อนและบริจาค',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'ดูประวัติ',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const TaxHistoryScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: TabBarView(
          controller: _tabController,
          physics: _hasIncome
              ? const AlwaysScrollableScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          children: [
            _incomeTab(),
            _deductionTab(),
            _donationTab(isLoading),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: (!_hasIncome || isLoading) ? null : _calculate,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('บันทึก และคำนวณภาษี'),
          ),
        ),
      ),
    );
  }

  Widget _incomeTab() => _wrap([
        FormattedNumberField(
          label: 'เงินได้รวมทั้งปี (บาท)',
          controller: _annualIncomeController,
          focusNode: _annualIncomeFocus,
          // validator: (v) => numberValidator(v, required: true),
          validator: numberValidator,
          textInputAction: TextInputAction.next,
          infoTooltip: 'เงินได้รวมทั้งปี ก่อนหักค่าใช้จ่ายและค่าลดหย่อน',
          onChanged: (_) => setState(() {}),
          onFieldSubmitted: (_) {
            if (_hasIncome) {
              _animateToTab(1, _providentFundFocus);
            }
          },
        ),
      ]);

  Widget _deductionTab() => _wrap([
        FormattedNumberField(
          label: 'กองทุนสำรองเลี้ยงชีพ (บาท)',
          controller: _providentFundController,
          focusNode: _providentFundFocus,
          validator: numberValidator,
          textInputAction: TextInputAction.next,
          nextFocusNode: _socialSecurityFocus,
          infoTooltip: 'ลดหย่อนได้สูงสุด 15% ของเงินได้ แต่ไม่เกิน 500,000 บาท',
        ),
        _gap,
        FormattedNumberField(
          label: 'ค่าประกันสังคม (บาท)',
          controller: _socialSecurityController,
          focusNode: _socialSecurityFocus,
          validator: numberValidator,
          textInputAction: TextInputAction.next,
          nextFocusNode: _lifeInsuranceFocus,
          infoTooltip: 'ลดหย่อนได้ไม่เกิน 9,000 บาท',
        ),
        _gap,
        FormattedNumberField(
          label: 'เบี้ยประกันชีวิต (บาท)',
          controller: _lifeInsuranceController,
          focusNode: _lifeInsuranceFocus,
          validator: numberValidator,
          textInputAction: TextInputAction.next,
          nextFocusNode: _healthInsuranceFocus,
          infoTooltip: 'ลดหย่อนได้ไม่เกิน 100,000 บาท',
        ),
        _gap,
        FormattedNumberField(
          label: 'เบี้ยประกันสุขภาพ (บาท)',
          controller: _healthInsuranceController,
          focusNode: _healthInsuranceFocus,
          validator: numberValidator,
          textInputAction: TextInputAction.next,
          infoTooltip:
              'ลดหย่อนได้ไม่เกิน 25,000 บาท และเมื่อรวมกับเบี้ยประกันชีวิตแล้วจะต้องไม่เกิน 100,000 บาท',
          onFieldSubmitted: (_) {
            _animateToTab(2, _doubleDonationFocus);
          },
        ),
      ]);

  Widget _donationTab(bool isLoading) => _wrap([
        FormattedNumberField(
          label: 'บริจาคเพื่อการศึกษา/กีฬา/โรงพยาบาลรัฐ (บาท)',
          controller: _doubleDonationController,
          focusNode: _doubleDonationFocus,
          validator: numberValidator,
          textInputAction: TextInputAction.next,
          nextFocusNode: _normalDonationFocus,
          infoTooltip: 'ลดหย่อนได้ 2 เท่า แต่ไม่เกิน 10% ของเงินได้สุทธิ',
        ),
        _gap,
        FormattedNumberField(
          label: 'บริจาคอื่นๆ (บาท)',
          controller: _normalDonationController,
          focusNode: _normalDonationFocus,
          validator: numberValidator,
          textInputAction: TextInputAction.done,
          infoTooltip: 'ลดหย่อนได้ไม่เกิน 10% ของเงินได้สุทธิ',
        ),
      ]);

  Widget _wrap(List<Widget> children) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: children),
      );

  static const _gap = SizedBox(height: 12);
}
