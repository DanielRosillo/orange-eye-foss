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
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';

class StorageManager {
  static const String _REQUEST_FILENAME = "requests_from_orange_eye_foss";

  Future<String> writeJSONFile(List<Map<String, dynamic>> source,
      [String fileName = _REQUEST_FILENAME]) async {
    var value = DateTime.now();

    fileName = fileName +
        "-" +
        value.day.toString() +
        "-" +
        value.month.toString() +
        "-" +
        value.year.toString() +
        "-" +
        Random().nextInt(1000).toString() +
        ".json";

    late Permission _permission;
    _permission = Permission.storage;

    ///Solicitar el permiso
    if (await _permission.request().isDenied) {
      _permission.request();
    }

    else if (await _permission.request().isPermanentlyDenied ) {
      openAppSettings();
    }

    try {
      var directory = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);

      final File file = File('$directory/$fileName');
      file.writeAsStringSync(json.encode(source));
      return fileName;
    } catch (e) {
      print(e);
      return "ERROR";
    }
  }

  Future<List<dynamic>?> readJSONFile(File file) async {
    List<dynamic>? content = <dynamic>[];

    late Permission _permission;
    _permission = Permission.storage;

    ///Solicitar el permiso
    if (await _permission.request().isDenied) {
      _permission.request();
    }
    else if (await _permission.request().isPermanentlyDenied) {
      openAppSettings();
    }


    try {
      var contents = await file.readAsString();
      content = json.decode(contents);
    } catch (e) {
      print(e);
    }
    return content;
  }
}
