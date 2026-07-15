import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:eatery_core/widgets/app_page_shell.dart";
import "package:eatery_core/theme/app_typography.dart";
import "package:eatery_core/theme/app_colors.dart";
import "package:eatery_core/providers/database_provider.dart";
import "package:eatery_core/data/repositories/reservation_repository.dart";
import "package:eatery_core/data/repositories/dining_table_repository_sqlite.dart";
import "package:eatery_core/data/models/eatery_db.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

class AddReservationPage extends ConsumerStatefulWidget {
  final Reservation? reservation;
  const AddReservationPage({super.key, this.reservation});
  @override
  ConsumerState<AddReservationPage> createState() => _AddReservationPageState();
}

class _AddReservationPageState extends ConsumerState<AddReservationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController(),
      _phoneCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  DateTime _dateTime = DateTime.now().add(const Duration(hours: 2));
  int _partySize = 2, _duration = 60, _status = 0;
  int? _tableId;

  @override
  void initState() {
    super.initState();
    if (widget.reservation != null) {
      _nameCtrl.text = widget.reservation!.customerName;
      _phoneCtrl.text = widget.reservation!.customerPhone ?? "";
      _dateTime = widget.reservation!.dateTime;
      _partySize = widget.reservation!.partySize;
      _duration = widget.reservation!.duration;
      _status = widget.reservation!.status;
      _tableId = widget.reservation!.diningTableId;
      _noteCtrl.text = widget.reservation!.note ?? "";
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = ReservationRepository(ref.read(eateryStoreProvider));
    await repo.saveReservation(
      Reservation(
        customerName: _nameCtrl.text.trim(),
        customerPhone: _phoneCtrl.text.trim().isEmpty
            ? null
            : _phoneCtrl.text.trim(),
        diningTableId: _tableId,
        partySize: _partySize,
        dateTime: _dateTime,
        duration: _duration,
        status: _status,
        note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
        createdAt: widget.reservation?.createdAt ?? DateTime.now(),
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final tables = SqliteDiningTableRepository(
      store: ref.read(eateryStoreProvider),
    ).getAllTables();
    return AppPageShell(
      title: widget.reservation != null
          ? "Edit Reservation"
          : "Add Reservation",
      color: AppColors.primary,
      actions: [IconButton(icon: const Icon(Icons.save), onPressed: _save)],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: "Customer Name",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneCtrl,
                decoration: const InputDecoration(
                  labelText: "Phone (optional)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Party Size",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: _partySize.toString(),
                      onChanged: (v) => _partySize = int.tryParse(v) ?? 2,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Duration (min)",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: _duration.toString(),
                      onChanged: (v) => _duration = int.tryParse(v) ?? 60,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.schedule),
                title: Text(DateFormat.yMMMd().add_jm().format(_dateTime)),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final dt = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                    initialDate: _dateTime,
                  );
                  if (dt == null) return;
                  final tm = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_dateTime),
                  );
                  if (tm != null)
                    setState(
                      () => _dateTime = DateTime(
                        dt.year,
                        dt.month,
                        dt.day,
                        tm.hour,
                        tm.minute,
                      ),
                    );
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: "Table",
                  border: OutlineInputBorder(),
                ),
                value: _tableId,
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text("Auto-assign"),
                  ),
                  ...tables
                      .where(
                        (t) =>
                            t.status == DiningTableStatus.available ||
                            t.id == _tableId,
                      )
                      .map(
                        (t) => DropdownMenuItem(
                          value: t.id,
                          child: Text("${t.name} (Cap: ${t.capacity})"),
                        ),
                      ),
                ],
                onChanged: (v) => setState(() => _tableId = v),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(),
                ),
                value: _status,
                items: const [
                  DropdownMenuItem(value: 0, child: Text("Pending")),
                  DropdownMenuItem(value: 1, child: Text("Confirmed")),
                  DropdownMenuItem(value: 2, child: Text("Seated")),
                  DropdownMenuItem(value: 3, child: Text("Completed")),
                  DropdownMenuItem(value: 4, child: Text("Cancelled")),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _status = v);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteCtrl,
                decoration: const InputDecoration(
                  labelText: "Notes",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
