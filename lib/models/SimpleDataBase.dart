/*
 * This file is part of OrangeEye.
 *
 * OrangeEye is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * OrangeEye is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with OrangeEye.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Copyright */
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SimpleDatabase {

  final String name;

  final Function(Map<String, dynamic>)? fromJson;

  SimpleDatabase({
    required this.name,
    this.fromJson,
  });

  Future<void> _saveList(List<dynamic> objList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(name, json.encode(objList).toString());
  }

  Future<int> count() async {
    return (await this.getAll()).length;
  }

  Future<List<dynamic>> getAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString(name) == null) return <dynamic>[];

    List<dynamic> mapList = json.decode(prefs.getString(name)!);
    List<dynamic> objList = <dynamic>[];

    for (dynamic object in mapList) {
      //Attempt to use the user provided fromJson function to rebuild an object
      try {
        objList.add(fromJson!(object));
      } catch (error) {
        objList.add(object);
      }
    }

    return objList;
  }

  Future<dynamic> getAt(int index) async {
    List<dynamic> list = await getAll();

    if (list.length <= index) return null;

    return list[index];
  }

  Future<void> saveList(List<dynamic> list) async {
    await _saveList(list);
  }

  Future<void> addAll(List<dynamic> list) async {
    List<dynamic> current = await getAll();

    for (dynamic item in list) {
      current.add(item);
    }

    await _saveList(current);
  }

  Future<void> insert(dynamic object, int index) async {
    List<dynamic> list = await getAll();

    list.insert(index, object);

    await _saveList(list);
  }

  Future<void> clear() async {
    await _saveList(<dynamic>[]);
  }

  Future<void> removeAt(int index) async {
    List<dynamic> list = await getAll();

    if (index >= list.length) return;

    list.removeAt(index);

    await _saveList(list);
  }

  Future<bool> remove(dynamic object) async {
    List<dynamic> objects = await getAll();
    List<dynamic> newList = <dynamic>[];

    for (dynamic obj in objects) {
      if (obj != object) newList.add(obj);
    }

    await _saveList(newList);

    if (newList.length != objects.length) return true;
    return false;
  }

  Future<bool> contains(dynamic object) async {
    List<dynamic> objects = await getAll();

    for (dynamic obj in objects) {
      if (object == obj) {
        return true;
      }
    }

    return false;
  }

  Future<void> add(dynamic object) async {
    List<dynamic> objList = await this.getAll();
    objList.add(object);
    await _saveList(objList);
  }

  Future<T?> getAtType<T>(int index) async {
    List<dynamic> list = await getAll();

    if (index >= list.length) return null;

    try {
      return list[index];
    } catch (error) {
      return null;
    }
  }

  Future<List<T?>> getAllType<T>() async {
    List<dynamic> dynamicList = await getAll();

    List<T?> list = <T?>[];

    for (dynamic object in dynamicList) {
      try {
        list.add(object);
      } catch (error) {}
    }

    return list;
  }

  Future<void> addBatch(List<dynamic> objects) async {
    List<dynamic> objList = await this.getAll();
    objList.addAll(objects);
    await _saveList(objList);
  }
}
