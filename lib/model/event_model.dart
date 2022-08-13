import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

part 'event_model.g.dart';

@HiveType(typeId: 1)
class Event extends HiveObject {
  @HiveField(0)
  DateTime dateTime;

  @HiveField(1)
  String title;

  Event({required this.dateTime, required this.title});
}
