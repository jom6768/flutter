import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/models/tax_history.dart';
import '../providers/tax_history_provider.dart';

class TaxHistoryScreen extends ConsumerWidget {
  const TaxHistoryScreen({super.key});

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
        error: (error, stackTrace) => Center(
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

              return Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _row('รายได้ต่อปี', history.annualIncome),
                      _row('กองทุนสำรองเลี้ยงชีพ', history.providentFund),
                      _row('ค่าลดหย่อน', history.socialSecurity),
                      const Divider(height: 24),
                      _row(
                        'ภาษีที่ต้องจ่าย',
                        history.tax,
                        isHighlight: true,
                      ),
                    ],
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
    final NumberFormat formatter = NumberFormat('#,##0.00');

    final textStyle = TextStyle(
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
            formatter.format(value),
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
