import 'package:apexo/common_widgets/archive_toggle.dart';
import 'package:apexo/features/appointments/appointment_model.dart';
import 'package:apexo/features/appointments/open_appointment_panel.dart';
import 'package:apexo/services/localization/locale.dart';
import 'package:apexo/services/login.dart';
import 'package:apexo/utils/constants.dart';
import 'package:fluent_ui/fluent_ui.dart';

class AppointmentsListFooter extends StatelessWidget {
  final String? forPatientID;
  const AppointmentsListFooter({
    super.key,
    this.forPatientID,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FilledButton(
              child: Row(
                children: [
                  const Icon(FluentIcons.add_event),
                  const SizedBox(width: 10),
                  Txt(txt("addAppointment"))
                ],
              ),
              onPressed: () {
                openAppointment(Appointment.fromJson({
                  if (forPatientID != null) "patientID": forPatientID,
                  if (login.permissions[PInt.patients] == 1 ||
                      login.permissions[PInt.appointments] == 1 ||
                      login.currentLoginIsOperator)
                    "operatorsIDs": [login.currentAccountID]
                }));
              }),
          const ArchiveToggle()
        ],
      ),
    );
  }
}
