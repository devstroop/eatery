import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery/data/models/eatery_db.dart';
import 'package:eatery/data/repositories/company_repository.dart';
import 'package:eatery/presentation/providers/database_provider.dart';

/// Provides the [CompanyRepository] singleton.
final companyRepositoryProvider = Provider<CompanyRepository>((ref) {
  final db = ref.read(appDatabaseProvider);
  return CompanyRepository(db: db);
});

/// Exposes the active [Company] and its [KCurrency].
final companyProvider = NotifierProvider<CompanyNotifier, Company?>(
  CompanyNotifier.new,
);

class CompanyNotifier extends Notifier<Company?> {
  @override
  Company? build() {
    final repo = ref.read(companyRepositoryProvider);
    return repo.getCurrentCompany();
  }

  void setCompany(Company? company) {
    state = company;
  }

  KCurrency? get currency {
    final company = state;
    if (company == null || company.currencyCode == null) return null;
    final repo = ref.read(companyRepositoryProvider);
    return repo.getCurrencyByCode(company.currencyCode!);
  }
}
