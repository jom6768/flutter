import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:tax_calculation/features/tax/domain/models/tax_history.dart';
import 'package:tax_calculation/features/tax/domain/services/tax_calculator.dart';
import 'package:tax_calculation/features/tax/presentation/providers/tax_history_provider.dart';
import 'package:tax_calculation/features/tax/presentation/screens/tax_result_screen.dart';

class TaxHistoryScreen extends ConsumerWidget {
  const TaxHistoryScreen({super.key});

  static final NumberFormat _formatter = NumberFormat('#,##0.00');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(taxHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ประวัติการคำนวณภาษี'),
      ),
      body: historyAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Center(
          child: Text(
            'เกิดข้อผิดพลาด: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
        data: (histories) {
          if (histories.isEmpty) {
            return const Center(
              child: Text(
                'ยังไม่มีประวัติการคำนวณภาษี',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: histories.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final TaxHistory history = histories[index];

              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  // 🔥 คำนวณ breakdown ใหม่จาก history
                  final result = TaxCalculator.calculateWithBreakdown(
                    annualIncome: history.annualIncome,
                    personalExpense: history.personalExpense,
                    personalDeduction: history.personalDeduction,
                    providentFund: history.providentFund,
                    socialSecurity: history.socialSecurity,
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TaxResultScreen(
                        history: history,
                        result: result,
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// LEFT: content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _row(
                                'เงินได้ทั้งปี',
                                history.annualIncome,
                              ),
                              _row(
                                'ค่าใช้จ่าย และค่าลดหย่อน',
                                history.personalExpense +
                                    history.personalDeduction +
                                    history.providentFund +
                                    history.socialSecurity,
                              ),
                              const Divider(height: 24),
                              _row(
                                'ภาษีที่ต้องจ่าย',
                                history.tax,
                                isHighlight: true,
                              ),
                            ],
                          ),
                        ),

                        /// RIGHT: arrow
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _row(
    String label,
    double value, {
    bool isHighlight = false,
  }) {
    final TextStyle textStyle = TextStyle(
      fontSize: isHighlight ? 16 : 14,
      fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
      color: isHighlight ? Colors.redAccent : Colors.black87,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textStyle),
          Text(
            '${_formatter.format(value)} บาท',
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
