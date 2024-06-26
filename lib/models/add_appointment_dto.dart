// Generated by Dart Safe Data Class Generator. * Change this header on extension settings *
// ignore_for_file: type=lint
import 'package:calendar_exemple/models/appointment_status.dart';
import 'package:flutter/foundation.dart';

@immutable
class AddAppointmentDto {
  final String professionalId;
  final String patientId;
  final DateTime startAt;
  final DateTime endAt;
  final AppointmentStatus status; // enum
  const AddAppointmentDto({
    this.professionalId = '',
    this.patientId = '',
    required this.startAt,
    required this.endAt,
    this.status = AppointmentStatus.scheduled,
  });

  AddAppointmentDto copyWith({
    String? professionalId,
    String? patientId,
    DateTime? startAt,
    DateTime? endAt,
    AppointmentStatus? status,
  }) {
    return AddAppointmentDto(
      professionalId: professionalId ?? this.professionalId,
      patientId: patientId ?? this.patientId,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'professionalId': professionalId,
      'patientId': patientId,
      'startAt': startAt.toIso8601String(),
      'endAt': endAt.toIso8601String(),
      'status': status.name,
    };
  }

  factory AddAppointmentDto.fromMap(Map<String, dynamic> map) {
    T cast<T>(String k) => map[k] is T
        ? map[k] as T
        : throw ArgumentError.value(map[k], k, '$T ← ${map[k].runtimeType}');
    return AddAppointmentDto(
      professionalId: cast<String>('professionalId'),
      patientId: cast<String>('patientId'),
      startAt: DateTime.parse(cast<String>('startAt')),
      endAt: DateTime.parse(cast<String>('endAt')),
      status: AppointmentStatus.values.byName(cast<String>('status')),
    );
  }

  @override
  String toString() {
    return 'AddAppointmentDto(professionalId: $professionalId, patientId: $patientId, startAt: $startAt, endAt: $endAt, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddAppointmentDto &&
        other.professionalId == professionalId &&
        other.patientId == patientId &&
        other.startAt == startAt &&
        other.endAt == endAt &&
        other.status == status;
  }

  @override
  int get hashCode {
    return professionalId.hashCode ^
        patientId.hashCode ^
        startAt.hashCode ^
        endAt.hashCode ^
        status.hashCode;
  }
}
