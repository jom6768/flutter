import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/tax_history.dart';
import 'tax_provider.dart';

final taxHistoryProvider = StreamProvider<List<TaxHistory>>((ref) {
  final repo = ref.read(taxRepositoryProvider);
  return repo.watchHistory();
});
