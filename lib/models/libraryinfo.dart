import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../url.dart';

class LibraryInfo {
  int id;
  String name;
  bool open;
  bool power;
  bool wifi;
  bool ethernet;
  String location;
  ComputerValue computer;
  SeatValue seat;
  HoursValue hours;
  String phone;

  LibraryInfo({
    required this.id,
    required this.wifi,
    required this.open,
    required this.power,
    required this.location,
    required this.ethernet,
    required this.name,
    required this.computer,
    required this.seat,
    required this.hours,
    required this.phone,
  });

  factory LibraryInfo.fromJson(Map<String, dynamic> json) {
    return LibraryInfo(
      id: json["id"] as int,
      name: json["name"] as String,
      wifi: json["wifi"] as bool,
      open: json["open"] as bool,
      power: json["power"] as bool,
      ethernet: json["ethernet"] as bool ,
      location: json["location"] as String,
      computer: ComputerValue.fromJson(json["computer"]),
      seat: SeatValue.fromJson(json["seat"]),
      hours: HoursValue.fromJson(json["hours"]),
      phone: json["phone"],
    );
  }

  static Future<Iterable<LibraryInfo>> fetchAll() async {
    final response = await http.get(URL.requirementsUrl());

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as Iterable)
          .map((e) => LibraryInfo.fromJson(e));
    } else {
      throw Exception("Failed to load products.");
    }
  }

  static Future<LibraryInfo> fetch(int id) async {
    final response = await http.get(URL.requirementsUrlId(id));

    if (response.statusCode == 200) {
      return LibraryInfo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load products.");
    }
  }
}

class SeatValue {
  int capacity;
  int occupied;

  SeatValue({required this.occupied, required this.capacity});

  factory SeatValue.fromJson(Map<String, dynamic> json) {
    return SeatValue(occupied: json["occupied"] as int, capacity: json["capacity"] as int);
  }
}

class ComputerValue {
  int capacity;
  int occupied;

  ComputerValue({required this.capacity, required this.occupied});

  factory ComputerValue.fromJson(Map<String, dynamic> json) {
    final capacity = json["capacity"] as int;
    final occupied = json["occupied"] as int;
    return ComputerValue(capacity: capacity, occupied: occupied);
  }
}

class HoursValue {
  Map<int, TimePeriod> mapping;

  HoursValue({required this.mapping});

  factory HoursValue.fromJson(Map<String, dynamic> json) {
    return HoursValue(
        mapping: Map.fromEntries(json.entries.map(
                (e) => MapEntry(int.parse(e.key), TimePeriod.fromJson(e.value)))));
  }

  TimePeriod get standard => mapping[0]!;

  TimePeriod getDay(final int n) {
    if (mapping.containsKey(n)) {
      return mapping[n]!;
    } else {
      return standard;
    }
  }

  TimePeriod get today {
    return getDay(DateTime.now().weekday);
  }

  String get todayDate {
    DateTime date = DateTime.now();
    String day = DateFormat('EEEE').format(date);
    return day;
  }

  Iterable<List<dynamic>> get weekdays {
    const dayNames = [
      "",
      "Pazartesi",
      "Salı",
      "Çarşamba",
      "Perşembe",
      "Cuma",
      "Cumartesi",
      "Pazar"
    ];
    return Iterable<int>.generate(8).skip(1).map((e) {
      final tp = getDay(e);
      return [dayNames[e], tp];
    });
  }
}

class TimePeriod {
  TimeOfDay end;
  TimeOfDay start;

  TimePeriod({required this.end, required this.start});

  factory TimePeriod.fromJson(Map<String, dynamic> json) {
    final endStr = json["end"] as String;
    final startStr = json["start"] as String;

    try {
      final end = TimeOfDay.fromDateTime(DateTime.parse("2000-01-01 $endStr"));
      final start = TimeOfDay.fromDateTime(DateTime.parse("2000-01-01 $startStr"));
      return TimePeriod(end: end, start: start);
    } on FormatException {
      throw TypeError();
    }
  }
}
