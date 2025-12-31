import '../domain/models/tax_history.dart';

abstract class TaxRepository {
  Future<void> save(TaxHistory history);
  Stream<List<TaxHistory>> watchHistory();
}
