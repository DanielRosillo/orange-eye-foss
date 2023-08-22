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
import 'dart:math';

import 'package:orange_eye_foss2/resources/Repository.dart';

class Request implements Comparable<Request> {
  String? _date;
  int? _status;
  String? _name;
  String? _host;
  String? _type;
  Map<String, String>? _headers;
  String? _body;
  String? _note;
  int? _id;
  bool? _active;

  Request.fromJson(Map<String, dynamic> json)
      : _date = json['date'],
        _status = json['status'],
        _name = json['name'],
        _host = json['host'],
        _type = json['type'],
        _headers = Map<String, String>.from(jsonDecode(json['headers'])),
        _body = json['body'],
        _note = json['note'],
        _active = json['active'],
        _id = json['id'];

  Map<String, dynamic> toJson() => {
        'date': _date,
        'status': _status,
        'name': _name,
        'host': _host,
        'type': _type,
        'headers': jsonEncode(_headers),
        'body': _body,
        'note': _note,
        'active': _active,
        'id': _id
      };

  DateTime fetched() {
    return (_date != null && _date!.isNotEmpty)
        ? Repository.formatter.parse(_date!)
        : DateTime.now();
  }

  String dateTime() {
    DateTime date = fetched();

    return Repository.formatter.format(date);
    //return _date!;
  }

  set date(String? value) {
    _date = value;
  }

  Request() {
    var value = DateTime.now();
    _date = value.day.toString() +
        "/" +
        value.month.toString() +
        "/" +
        value.year.toString() +
        " " +
        value.hour.toString() +
        ":" +
        value.minute.toString();
    _status = 0;
    _name = "default";
    _host = "default";
    _type = "GET";
    _headers = Map<String, String>();
    _body = "";
    _note = "no notes";
    _id = Random().nextInt(100000);
    _active = false;
  }

  Request.build(
      String date,
      int status,
      String name,
      String host,
      String type,
      Map<String, String> headers,
      String body,
      String note,
      int id,
      bool active) {
    _date = date;
    _status = status;
    _name = name;
    _host = host;
    _type = type;
    _headers = headers;
    _body = body;
    _note = note;
    _id = id;
    _active = _active;
  }

  @override
  String toString() {
    return 'Request{_date: $_date, _status: $_status, _name: $_name, _host: $_host, _type: $_type, _headers: $_headers, _body: $_body, _note: $_note, _id: $_id, _active: $_active}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Request &&
          runtimeType == other.runtimeType &&
          _date == other._date &&
          _status == other._status &&
          _name == other._name &&
          _host == other._host &&
          _type == other._type &&
          _headers == other._headers &&
          _body == other._body &&
          _note == other._note &&
          _id == other._id &&
          _active == other._active;

  @override
  int get hashCode =>
      _date.hashCode ^
      _status.hashCode ^
      _name.hashCode ^
      _host.hashCode ^
      _type.hashCode ^
      _headers.hashCode ^
      _body.hashCode ^
      _note.hashCode ^
      _id.hashCode ^
      _active.hashCode;

  int get status => _status!;

  int get id => _id!;

  set id(int value) {
    _id = value;
  }

  String get note => _note!;

  set note(String value) {
    _note = value;
  }

  String get body => _body!;

  set body(String value) {
    _body = value;
  }

  Map<String, String> get headers => _headers!;

  set headers(Map<String, String> value) {
    _headers = value;
  }

  String get type => _type!;

  set type(String value) {
    _type = value;
  }

  String get host => _host!;

  set host(String value) {
    _host = value;
  }

  String get name => _name!;

  set name(String value) {
    _name = value;
  }

  set status(int value) {
    _status = value;
  }

  @override
  int compareTo(Request other) {
    int id = this.name.compareTo(other.name);
    if (id == 0) {
      return -this.name.compareTo(other.name); // '-' for descending
    }
    return id;
  }

  bool get active => _active!;

  set active(bool value) {
    _active = value;
  }
}
