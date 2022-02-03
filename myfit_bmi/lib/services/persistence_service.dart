import 'package:flutter/material.dart';
import 'package:myfit_bmi/model/bmi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersistenceService {
  static PersistenceService instance = PersistenceService();

  Future<List<Bmi>> loadAll() async {
    debugPrint('loadAll');

    var pref = await SharedPreferences.getInstance();
    var bmis = pref.getStringList("bmi") ?? <String>[];

    List<Bmi> bmiList = [];
    for(var bmi in bmis) {
      var splitted = bmi.split(';');
      bmiList.add(Bmi(double.parse(splitted[0]), double.parse(splitted[1])));
    }

    debugPrint('loaded: ' + bmiList.length.toString());
    return bmiList;
  }

  Future saveNew(Bmi bmi) async {
    var current = await loadAll();
    current.add(bmi);

    List<String> bmisAsString = [];
    for(var singleBmi in current) {
      bmisAsString.add(singleBmi.weight.toString() + ";" + singleBmi.size.toString());
    }

    var pref = await SharedPreferences.getInstance();
    pref.setStringList("bmi", bmisAsString);
  }

  Future deleteLast() async {
    var current = await loadAll();
    current.removeAt(current.length - 1);

    List<String> bmisAsString = [];
    for(var singleBmi in current) {
      bmisAsString.add(singleBmi.weight.toString() + ";" + singleBmi.size.toString());
    }

    var pref = await SharedPreferences.getInstance();
    pref.setStringList("bmi", bmisAsString);
  }
}