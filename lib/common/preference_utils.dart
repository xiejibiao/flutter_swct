import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static PreferenceUtils _instance;

  static PreferenceUtils get instance => PreferenceUtils();

  PreferenceUtils._internal();

  factory PreferenceUtils() {
    if (_instance == null) _instance = PreferenceUtils._internal();
    return _instance;
  }

  saveInteger({@required String key, @required int value}) => SharedPreferences.getInstance().then((sp) => sp.setInt(key, value));

  saveString({@required String key, @required String value}) => SharedPreferences.getInstance().then((sp) => sp.setString(key, value));

  saveBool({@required String key, @required bool value}) => SharedPreferences.getInstance().then((sp) => sp.setBool(key, value));

  saveDouble({@required String key, @required double value}) => SharedPreferences.getInstance().then((sp) => sp.setDouble(key, value));

  saveStringList({@required String key, @required List<String> value}) => SharedPreferences.getInstance().then((sp) => sp.setStringList(key, value));

  Future<int> getInteger({@required String key, int defaultValue = 0}) async {
    var sp = await SharedPreferences.getInstance();
    var value = sp.getInt(key);
    return value ?? defaultValue;
  }

  Future<String> getString({@required String key, String defaultValue}) async {
    var sp = await SharedPreferences.getInstance();
    var value = sp.getString(key);
    return value ?? defaultValue;
  }

  Future<bool> getBool({@required String key, bool defaultValue = false}) async {
    var sp = await SharedPreferences.getInstance();
    var value = sp.getBool(key);
    return value ?? defaultValue;
  }

  Future<double> getDouble({@required String key, double defaultValue = 0.0}) async {
    var sp = await SharedPreferences.getInstance();
    var value = sp.getDouble(key);
    return value ?? defaultValue;
  }

  Future<List<String>> getStringList({@required String key, List<String> defaultValue = const <String>[]}) async {
    var sp = await SharedPreferences.getInstance();
    var value = sp.getStringList(key);
    return value ?? defaultValue;
  }
}