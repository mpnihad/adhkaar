import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

import 'ColorChoice.dart';

enum TodoCardSettings { edit_color, delete }

class TodoObject {
  TodoObject(String title, IconData icon, int totcount) {
    this.title = title;
    this.icon = icon;
    ColorChoice choice = ColorChoices.choices[Random().nextInt(ColorChoices.choices.length)];
    this.color = choice.primary;
    this.colors=choice.gradient;
    this.gradient = LinearGradient(colors: choice.gradient, begin: Alignment.bottomCenter, end: Alignment.topCenter);
    tasks = Map<DateTime, List<TaskObject>>();
    this.uuid = Uuid().v1();
    this.count=0;
    this.playStatus = 0;
    this.totcount = totcount;

  }

  TodoObject.import(String uuidS, String title, int sortID, ColorChoice color, IconData icon, Map<DateTime, List<TaskObject>> tasks,int totcount) {
    this.sortID = sortID;
    this.title = title;
    this.color = color.primary;
    this.colors=color.gradient;
    this.gradient = LinearGradient(colors: color.gradient, begin: Alignment.bottomCenter, end: Alignment.topCenter);
    this.icon = icon;
    this.tasks = tasks;
    this.uuid = uuidS;
    this.count=0;
    this.playStatus = 0;
    this.totcount = totcount;
  }

  String uuid;
  int count;
  int totcount;
  int sortID;
  String title;
  Color color;
  List<Color> colors;
  LinearGradient gradient;
  IconData icon;
  Map<DateTime, List<TaskObject>> tasks;
  int playStatus = 0;
  int taskAmount() {
    int amount = 0;
    tasks.values.forEach((list) {
      amount += list.length;
    });
    return amount;
  }

  //List<TaskObject> tasks;

  double percentComplete() {
    if (tasks.isEmpty) {
      return 1.0;
    }
    int completed = 0;
    int amount = 0;
    tasks.values.forEach((list) {
      amount += list.length;
      list.forEach((task) {
        if (task.isCompleted()) {
          completed++;
        }
      });
    });
    return completed / amount;
  }
}

class TaskObject {
  DateTime date;
  String task;
  bool _completed;

  TaskObject(String task, DateTime date) {
    this.task = task;
    this.date = date;
    this._completed = false;
  }

  TaskObject.import(String task, DateTime date, bool completed) {
    this.task = task;
    this.date = date;
    this._completed = completed;
  }

  void setComplete(bool value) {
    _completed = value;
  }

  isCompleted() => _completed;
}
