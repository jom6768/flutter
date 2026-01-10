import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tax_calculation/features/tax/domain/models/tax_history.dart';
import 'package:tax_calculation/features/tax/presentation/providers/tax_provider.dart';

final taxHistoryProvider = StreamProvider<List<TaxHistory>>((ref) {
  final repo = ref.read(taxRepositoryProvider);
  return repo.watchHistory();
});
