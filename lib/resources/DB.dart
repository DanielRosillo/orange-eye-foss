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
 * Copyright 2022-2023 by Daniel Rosillo (VHS_DREAMS25;)
 * */
import 'dart:collection';

import 'package:orange_eye_foss2/models/Request.dart';
import 'package:orange_eye_foss2/models/SimpleDataBase.dart';

class DB {
  static const String _dbName = "requests";

  Future<List<Request>> fetchRequests() async {
    var items = <Request>[];
    SimpleDatabase classDB = SimpleDatabase(name: _dbName);

    for (LinkedHashMap<String, dynamic>? output in await (classDB.getAll())) {
      late Request request;
      request = Request.fromJson(output!);
      items.add(request);
    }

    return items;
  }

  Future<void> save(Request? plant) async {
    SimpleDatabase classDB = SimpleDatabase(
        name: _dbName, fromJson: (fromJson) => Request.fromJson(fromJson));

    await classDB.add(plant);
  }

  Future<void> remove(Request? plant) async {
    SimpleDatabase classDB = SimpleDatabase(
        name: _dbName, fromJson: (fromJson) => Request.fromJson(fromJson));
    int position = await _findIndex(plant);
    await classDB.removeAt(position);
  }

  Future<int> _findIndex(Request? plant) async {
    List items = await fetchRequests();
    if (items.isEmpty) return 0;
    int result = -1;
    int index = 0;
    while (index < items.length) {
      if (items.elementAt(index).name == plant!.name &&
          items.elementAt(index).id == plant.id) {
        result = index;
        break;
      }
      index++;
    }
    return result;
  }

  Future<void> addBatch(List<Request> requests) async {
    SimpleDatabase classDB = SimpleDatabase(
        name: _dbName, fromJson: (fromJson) => Request.fromJson(fromJson));
    await classDB.addBatch(requests);
  }

  static String get dbName => _dbName;
}
