import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:eatery_core/widgets/app_page_shell.dart";
import "package:eatery_core/theme/app_typography.dart";
import "package:eatery_core/theme/app_colors.dart";
import "package:eatery_core/providers/database_provider.dart";
import "package:eatery_core/data/repositories/reservation_repository.dart";
import "package:eatery_core/data/models/eatery_db.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

class ReservationsPage extends ConsumerStatefulWidget {
  const ReservationsPage({super.key});
  @override
  ConsumerState<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends ConsumerState<ReservationsPage> {
  DateTime _selectedDate = DateTime.now();
  final _statusNames = ["Pending", "Confirmed", "Seated", "Completed", "Cancelled"];

  @override
  Widget build(BuildContext context) {
    final repo = ReservationRepository(ref.read(eateryStoreProvider));
    final reservations = repo.getReservationsForDate(_selectedDate);

    return AppPageShell(
      title: "Reservations",
      color: AppColors.primary,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary, foregroundColor: AppColors.white,
        label: const Text("Add Reservation"), icon: const Icon(Icons.add),
        onPressed: () => GoRouter.of(context).pushNamed("addReservation").then((_) => setState(() {})),
      ),
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              leading: const Icon(Icons.date_range),
              title: Text(DateFormat.yMMMd().format(_selectedDate)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
                  lastDate: DateTime.now().add(const Duration(days: 90)),
                  initialDate: _selectedDate,
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
            ),
          ),
          Expanded(
            child: reservations.isEmpty
                ? const Center(child: Opacity(opacity: 0.5, child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.event_busy, size: 64), SizedBox(height: 16),
                      Text("No reservations for this date")])))
                : ListView(
                    children: reservations.map((r) {
                      final statusColor = switch (r.status) { 0 => Colors.orange, 1 => Colors.blue, 2 => Colors.green, 3 => Colors.grey, _ => Colors.red };
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ListTile(
                          title: Text("${r.customerName} (${r.partySize})", style: AppTypography.titleMedium),
                          subtitle: Text("${DateFormat('hh:mm a').format(r.dateTime)}  |  ${_statusNames[r.status.clamp(0, 4)]}"),
                          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(8)),
                              child: Text(_statusNames[r.status.clamp(0, 4)], style: const TextStyle(color: Colors.white, fontSize: 10)),
                            ),
                            IconButton(icon: const Icon(Icons.delete, size: 20),
                              onPressed: () { repo.deleteReservation(r.id!); setState(() {}); }),
                          ]),
                          onTap: () => GoRouter.of(context).pushNamed("editReservation", extra: r).then((_) => setState(() {})),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
