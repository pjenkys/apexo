import 'package:apexo/features/appointments/appointment_model.dart';
import 'package:apexo/features/appointments/appointments_store.dart';
import 'package:apexo/features/patients/patient_model.dart';
import 'package:apexo/features/patients/patients_store.dart';

class _LabworksController {
  List<Appointment> get appointmentsWithLabworks => appointments.present.values.where((appointment) => appointment.hasLabwork).toList();
  List<Appointment> get due => appointments.present.values.where((appointment) => appointment.hasLabwork && !appointment.labworkReceived).toList();
  List<Patient> get notDelivered => patients.present.values.where((p)=>p.allAppointments.isNotEmpty && p.allAppointments.last.hasLabwork && p.allAppointments.last.labworkReceived).toList();
}


final labworks = _LabworksController();