import 'package:flutter/material.dart';

class Plan {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String type;
  final String details;

  Plan({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.details,
  });

  Plan copyWith({
    String? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? type,
    String? details,
  }) {
    return Plan(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      type: type ?? this.type,
      details: details ?? this.details,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'startTime': '${startTime.hour}:${startTime.minute}',
      'endTime': '${endTime.hour}:${endTime.minute}',
      'type': type,
      'details': details,
    };
  }

  factory Plan.fromJson(Map<String, dynamic> json) {
    final startTimeParts = json['startTime'].split(':');
    final endTimeParts = json['endTime'].split(':');

    return Plan(
      id: json['id'],
      name: json['name'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      startTime: TimeOfDay(
        hour: int.parse(startTimeParts[0]),
        minute: int.parse(startTimeParts[1]),
      ),
      endTime: TimeOfDay(
        hour: int.parse(endTimeParts[0]),
        minute: int.parse(endTimeParts[1]),
      ),
      type: json['type'],
      details: json['details'],
    );
  }
}