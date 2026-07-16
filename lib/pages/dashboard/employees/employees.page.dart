import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery_core/utils/responsive.dart';
import 'package:eatery/widgets/responsive/responsive_list_view.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:go_router/go_router.dart';

Color _pageColor = const Color(0xFFC2592F);

class EmployeesPage extends ConsumerStatefulWidget {
  const EmployeesPage({super.key});

  @override
  ConsumerState<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends ConsumerState<EmployeesPage> {
  @override
  void initState() {
    super.initState();
  }

  final List<FocusNode> _focusNodes = [FocusNode(), FocusNode()];
  @override
  Widget build(BuildContext context) {
    List<Employee> employees = ref
        .read(employeeRepositoryProvider)
        .getAllEmployees();
    return AppPageShell(
      title: 'Employees',
      color: _pageColor,
      actions: [
        if (_focusNodes[0].hasFocus || _focusNodes[1].hasFocus)
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              FocusScope.of(context).unfocus();
            },
          ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _pageColor,
        foregroundColor: AppColors.white,
        label: const Text('Add Employee'),
        icon: const Icon(Icons.add),
        onPressed: () {
          GoRouter.of(
            context,
          ).pushNamed('addEmployee').then((_) => setState(() {}));
        },
      ),
      child: employees.isNotEmpty
          ? ResponsiveListView(
              itemCount: employees.length,
              childAspectRatio: 3.5,
              itemBuilder: (context, index) {
                final e = employees[index];
                return _EmployeeCard(employee: e, pageColor: _pageColor);
              },
            )
          : Center(
              child: Opacity(
                opacity: 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person, size: 64),
                    AppSpacing.gapLg,
                    Text(
                      'No Employees',
                      style: AppTypography.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Add an employee to get started',
                      style: AppTypography.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

/// Desktop-friendly card wrapper for an employee list item.
class _EmployeeCard extends ConsumerStatefulWidget {
  final Employee employee;
  final Color pageColor;

  const _EmployeeCard({required this.employee, required this.pageColor});

  @override
  ConsumerState<_EmployeeCard> createState() => _EmployeeCardState();
}

class _EmployeeCardState extends ConsumerState<_EmployeeCard> {
  @override
  Widget build(BuildContext context) {
    final s = widget.employee;
    final isDesktop = Responsive.isDesktop(context);
    return Card(
      margin: EdgeInsets.symmetric(horizontal: isDesktop ? 4 : 0, vertical: 2),
      child: ListTile(
        title: Text(s.name, style: AppTypography.titleMedium),
        subtitle: s.phone != null ? Text(s.phone!) : null,
        leading: LeadingImageWidget(
          image: LibraryImage(
            s.photo ?? '',
            defaultImage: 'assets/images/man.png',
          ).image,
          size: 48,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: widget.pageColor),
              onPressed: () {
                GoRouter.of(context)
                    .pushNamed('editEmployee', extra: s)
                    .then((_) => setState(() {}));
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: widget.pageColor),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Delete Employee'),
                      content: const Text(
                        'Are you sure you want to delete this Employee?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            ref
                                .read(employeeRepositoryProvider)
                                .deleteEmployee(s.id!)
                                .whenComplete(() {
                                  Navigator.pop(context);
                                  setState(() {});
                                });
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
