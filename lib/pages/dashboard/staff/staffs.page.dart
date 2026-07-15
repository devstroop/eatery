import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery_core/utils/responsive.dart';
import 'package:eatery/widgets/responsive/responsive_list_view.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/providers/database_provider.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:go_router/go_router.dart';

Color _pageColor = const Color(0xFFC2592F);

class StaffsPage extends ConsumerStatefulWidget {
  const StaffsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<StaffsPage> createState() => _StaffsPageState();
}

class _StaffsPageState extends ConsumerState<StaffsPage> {
  @override
  void initState() {
    super.initState();
  }

  final List<FocusNode> _focusNodes = [FocusNode(), FocusNode()];
  @override
  Widget build(BuildContext context) {
    List<Staff> staffs = ref.read(staffRepositoryProvider).getAllStaff();
    return AppPageShell(
      title: 'Staffs',
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
        label: const Text('Add Staff'),
        icon: const Icon(Icons.add),
        onPressed: () {
          GoRouter.of(
            context,
          ).pushNamed('addStaff').then((_) => setState(() {}));
        },
      ),
      child: staffs.isNotEmpty
          ? ResponsiveListView(
              itemCount: staffs.length,
              childAspectRatio: 3.5,
              itemBuilder: (context, index) {
                final e = staffs[index];
                return _StaffCard(staff: e, pageColor: _pageColor);
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
                      'No Staffs',
                      style: AppTypography.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Add a staff to get started',
                      style: AppTypography.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

/// Desktop-friendly card wrapper for a staff list item.
class _StaffCard extends ConsumerStatefulWidget {
  final Staff staff;
  final Color pageColor;

  const _StaffCard({required this.staff, required this.pageColor});

  @override
  ConsumerState<_StaffCard> createState() => _StaffCardState();
}

class _StaffCardState extends ConsumerState<_StaffCard> {
  @override
  Widget build(BuildContext context) {
    final s = widget.staff;
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
                GoRouter.of(
                  context,
                ).pushNamed('editStaff', extra: s).then((_) => setState(() {}));
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: widget.pageColor),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Delete Staff'),
                      content: const Text(
                        'Are you sure you want to delete this Staff?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            ref
                                .read(staffRepositoryProvider)
                                .deleteStaff(s.id!)
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
