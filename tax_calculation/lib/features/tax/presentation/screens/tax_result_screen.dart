import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/models/tax_history.dart';
import 'tax_form_screen.dart';
import 'tax_history_screen.dart';

class TaxResultScreen extends StatelessWidget {
  final TaxHistory history;

  final NumberFormat _formatter = NumberFormat('#,##0.00');

  TaxResultScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ผลการคำนวณภาษี'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _summaryCard(context),
            const SizedBox(height: 24),
            _incomeSection(),
            const SizedBox(height: 16),
            _deductionSection(),
            const SizedBox(height: 16),
            _calculationSection(),
            const SizedBox(height: 32),
            _actionButtons(context),
          ],
        ),
      ),
    );
  }

  // ================= SUMMARY =================

  Widget _summaryCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'ภาษีที่ต้องชำระ',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(
              '${_formatter.format(history.tax)} บาท',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= SECTIONS =================

  Widget _incomeSection() {
    return _section(
      title: 'รายได้',
      children: [
        _row('รายได้ต่อปี', history.annualIncome),
      ],
    );
  }

  Widget _deductionSection() {
    return _section(
      title: 'ค่าใช้จ่าย และค่าลดหย่อน',
      children: [
        _row('ค่าใช้จ่ายส่วนตัว', history.personalExpense),
        _row('ค่าลดหย่อนส่วนตัว', history.personalDeduction),
        _row('กองทุนสำรองเลี้ยงชีพ', history.providentFund),
        _row('ค่าประกันสังคม', history.socialSecurity),
      ],
    );
  }

  Widget _calculationSection() {
    final deduct = history.personalDeduction +
        history.providentFund +
        history.socialSecurity;
    final taxableIncome =
        history.annualIncome - history.personalExpense - deduct;

    return _section(
      title: 'คำนวณภาษี',
      children: [
        _row('รายได้สุทธิ', taxableIncome),
        const Divider(),
        _row(
          'ภาษีที่ต้องชำระ',
          history.tax,
          isHighlight: true,
        ),
      ],
    );
  }

  // ================= REUSABLE =================

  Widget _section({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _row(
    String label,
    double value, {
    bool isHighlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            '${_formatter.format(value)} บาท',
            style: TextStyle(
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              color: isHighlight ? Colors.red : null,
            ),
          ),
        ],
      ),
    );
  }

  // ================= ACTIONS =================

  Widget _actionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const TaxFormScreen(),
                ),
                (route) => false,
              );
            },
            child: const Text('กรอกแบบฟอร์มใหม่'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TaxHistoryScreen(),
                ),
              );
            },
            child: const Text('ดูประวัติย้อนหลัง'),
          ),
        ),
      ],
    );
  }
}
