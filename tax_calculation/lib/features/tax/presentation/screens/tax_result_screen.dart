import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:tax_calculation/features/tax/domain/models/tax_breakdown.dart';
import 'package:tax_calculation/features/tax/domain/models/tax_history.dart';
import 'package:tax_calculation/features/tax/domain/services/tax_calculator.dart';
import 'package:tax_calculation/features/tax/presentation/screens/tax_form_screen.dart';
import 'package:tax_calculation/features/tax/presentation/screens/tax_history_screen.dart';

class TaxResultScreen extends StatelessWidget {
  final TaxHistory history;
  final TaxCalculationResult result;

  TaxResultScreen({
    super.key,
    required this.history,
    required this.result,
  });

  final NumberFormat _formatter = NumberFormat('#,##0.00');
  final NumberFormat _intFormatter = NumberFormat('#,##0');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ผลการคำนวณภาษี'),
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
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _showTaxBreakdownDialog(context),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
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
                '${_formatter.format(result.tax)} บาท',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'แตะเพื่อดูรายละเอียด',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= TAX BREAKDOWN DIALOG =================

  void _showTaxBreakdownDialog(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    const double headerHeight = 28;
    const double rowHeight = 26;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'รายละเอียดการคำนวณภาษี',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: isSmallScreen ? 16 : 20,
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'เงินได้สุทธิ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${_formatter.format(result.netIncome)} บาท',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const Divider(),
                  const SizedBox(height: 16),

                  // ================= TABLE =================

                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 600,
                      ),
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowHeight: headerHeight,
                              dataRowMinHeight: rowHeight,
                              dataRowMaxHeight: rowHeight,
                              horizontalMargin: 12,
                              columnSpacing: 12,
                              showCheckboxColumn: false,
                              headingTextStyle: TextStyle(
                                fontSize: isSmallScreen ? 10 : 12,
                                fontWeight: FontWeight.bold,
                              ),
                              dataTextStyle: TextStyle(
                                fontSize: isSmallScreen ? 10 : 12,
                              ),
                              columns: const [
                                DataColumn(
                                    label: Center(child: Text('เงินได้สุทธิ'))),
                                DataColumn(
                                    label: Center(child: Text('อัตราภาษี'))),
                                DataColumn(
                                    label: Center(child: Text('ฐานคำนวณ'))),
                                DataColumn(label: Center(child: Text('ภาษี'))),
                              ],
                              rows: _buildTaxTableRows(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Divider(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ผลรวม',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${_formatter.format(result.tax)} บาท',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),

                  const Divider(),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('ปิด'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<DataRow> _buildTaxTableRows(BuildContext context) {
    return result.breakdown.map((TaxBreakdownRow row) {
      return DataRow(
        cells: [
          _cell(
            Text(
              row.max == null
                  ? '${_intFormatter.format(row.min)} ขึ้นไป'
                  : '${_intFormatter.format(row.min)} - ${_intFormatter.format(row.max)}',
            ),
            align: Alignment.center,
          ),
          _cell(
            Text('${(row.rate * 100).toInt()}%'),
            align: Alignment.centerRight,
          ),
          _cell(
            Text(row.taxable == 0 ? '-' : _intFormatter.format(row.taxable)),
            align: Alignment.centerRight,
          ),
          _cell(
            Text(row.tax == 0 ? '-' : _intFormatter.format(row.tax)),
            align: Alignment.centerRight,
          ),
        ],
      );
    }).toList();
  }

  // ================= SECTIONS =================

  Widget _incomeSection() {
    return _section(
      title: 'เงินได้',
      children: [
        _row('เงินได้ทั้งปี', history.annualIncome),
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
    return _section(
      title: 'คำนวณภาษี',
      children: [
        _row('เงินได้สุทธิ', result.netIncome),
        const Divider(),
        _row('ภาษีที่ต้องชำระ', result.tax, isHighlight: true),
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

  Widget _row(String label, double value, {bool isHighlight = false}) {
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

  DataCell _cell(
    Widget child, {
    Alignment align = Alignment.centerLeft,
  }) {
    return DataCell(
      Align(
        alignment: align,
        child: child,
      ),
    );
  }

  // ================= ACTIONS =================

  Widget _actionButtons(BuildContext context) {
    return SizedBox(
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
    );
  }
}
