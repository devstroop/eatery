import 'package:eatery_core/theme/app_typography.dart';

import 'package:eatery/references.dart';
import 'package:go_router/go_router.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:intl/intl.dart';

class SearchCustomerDelegate extends SearchDelegate<Customer?> {
  final List<Customer> customers;
  final Function(Customer customer) callback;

  SearchCustomerDelegate(this.customers, this.callback);

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
      TextButton(
        onPressed: () {
          GoRouter.of(context).pushNamed('addCustomer').then((customer) {
            if (customer != null) {
              customers.add(customer as Customer);
              showSuggestions(context);
            }
          });
        },
        child: Row(
          children: [
            Icon(Icons.person_add),
            SizedBox(width: 6),
            Text(
              'New',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
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
      // Show recent customers
      return _buildRecentCustomers(context);
    } else {
      // Show search results
      return _buildSearchResults(context, query);
    }
  }

  Widget _buildRecentCustomers(BuildContext context) {
    List<Customer> recentCustomers = customers.reversed.toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Recent Customers',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: recentCustomers.length,
            itemBuilder: (context, index) {
              Customer customer = recentCustomers[index];
              return _buildCustomerListItem(context, customer);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults(BuildContext context, String query) {
    List<Customer> searchResults = customers
        .where(
          (element) =>
              (element.name ?? '').toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              element.phone.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    if (searchResults.isEmpty) {
      return const Center(
        child: Text('No customers found', style: AppTypography.bodyMedium),
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Search results',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.black500),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              Customer customer = searchResults[index];
              return _buildCustomerListItem(context, customer);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerListItem(BuildContext context, Customer customer) {
    return ListTile(
      onTap: () {
        callback(customer);
        close(context, customer);
      },
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: AppColors.grey300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            (customer.name ?? 'NA')[0],
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.grey600,
            ),
          ),
        ),
      ),
      title: Text(
        customer.name ?? 'NA',
        style: AppTypography.titleLarge.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.black600,
        ),
      ),
      subtitle: Text(
        customer.phone,
        style: AppTypography.bodyMedium.copyWith(color: AppColors.black500),
      ),
      trailing: Text(
        timeAgo(customer.lastOrderAt),
        style: AppTypography.labelMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.black600,
        ),
      ),
    );
  }

  String timeAgo(DateTime? lastOrderTime) {
    if (lastOrderTime == null) {
      return 'Never ordered';
    }

    Duration difference = DateTime.now().difference(lastOrderTime);
    if (difference.inDays > 0) {
      return DateFormat.yMMMd().format(
        lastOrderTime,
      ); // Display date if more than a day
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
