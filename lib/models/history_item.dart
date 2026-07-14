// File: lib/models/history_item.dart

import 'dart:convert';

class HistoryItem {
  final String id;
  final String expression;
  final String result;
  final DateTime timestamp;
  final bool isScientific;

  HistoryItem({
    required this.id,
    required this.expression,
    required this.result,
    required this.timestamp,
    required this.isScientific,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expression': expression,
      'result': result,
      'timestamp': timestamp.toIso8601String(),
      'isScientific': isScientific,
    };
  }

  factory HistoryItem.fromMap(Map<String, dynamic> map) {
    return HistoryItem(
      id: map['id'] ?? '',
      expression: map['expression'] ?? '',
      result: map['result'] ?? '',
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      isScientific: map['isScientific'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoryItem.fromJson(String source) => HistoryItem.fromMap(json.decode(source));
}
