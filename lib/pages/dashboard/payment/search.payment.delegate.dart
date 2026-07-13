import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';
import 'package:eatery/core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';

class SearchPaymentDelegate extends SearchDelegate<Payment?> {
  final List<Payment> payments;
  final Function(Payment payment) callback;
  final String currencySymbol;

  SearchPaymentDelegate(
    this.payments,
    this.callback, {
    this.currencySymbol = '',
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
        icon: const Icon(Icons.clear),
      ),
      IconButton(
        onPressed: () {
          GoRouter.of(context).pushNamed('addPayment').then((payment) {
            if (payment != null) {
              callback(payment as Payment);
              close(context, payment as Payment?);
            }
          });
        },
        icon: const Icon(Icons.add),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context, query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      // Show recent payments
      return _buildRecentPayments(context);
    } else {
      // Show search results
      return _buildSearchResults(context, query);
    }
  }

  Widget _buildRecentPayments(BuildContext context) {
    List<Payment> recentPayments = payments;
    recentPayments.sort((a, b) => b.date.compareTo(a.date));
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        ...recentPayments.map((payment) {
          return ListTile(
            title: Text('${payment.id ?? 'NA'}'),
            subtitle: Text(payment.date.toString()),
            trailing: Text(
              '$currencySymbol${payment.amount}',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              callback(payment);
              close(context, payment);
            },
          );
        }),
      ],
    );
  }

  Widget _buildSearchResults(BuildContext context, String query) {
    List<Payment> searchResults = payments
        .where(
          (element) => element.id?.toString().contains(query.trim()) ?? false,
        )
        .toList();
    searchResults.sort((a, b) => b.date.compareTo(a.date));
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        ...searchResults.map((payment) {
          return ListTile(
            title: Text('${payment.id ?? 'NA'}'),
            subtitle: Text(payment.date.toString()),
            trailing: Text(
              '$currencySymbol${payment.amount}',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              callback(payment);
              close(context, payment);
            },
          );
        }),
      ],
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.menuCategories,
        foregroundColor: AppColors.white,
      ),
    );
  }
}
