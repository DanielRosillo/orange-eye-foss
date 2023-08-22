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
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:orange_eye_foss2/resources/Core.dart';

class Repository {
  static const _fontStyle = 'Montserrat';
  static const String _appName = "OrangeEye FOSS";
  static const String _rosillolabs_web = "https://rosillolabs.com/";
  static const String _publisher = "Rosillo Labs";
  static const String _release = "23/02/2022";
  static const String _update = "13/03/2022";
  static const String _version = "1.1";
  static const bool _onDebug = true;
  static const String _variant = "GLOBAL-ALLVARIANTS";
  static const String _reference = "CUSTOM-STORE";
  static const int _codeVersion = 3;
  static const String _packageID = "rosillolabs.development.orange_eye_foss";
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static int _interval = 5;
  static const String _INTERVAL_NAME = "interval";
  static const String _NOTIFICATIONS_MODE_NAME = "notificationsMode";
  static const String _ACTIVE_NAME = "active";
  static final DateFormat _formatter = DateFormat("dd/MM/yyyy HH:mm");

  static final TextStyle _buttonStyle = TextStyle(
      fontSize: 18, color: Colors.white, fontFamily: Repository.fontStyle);

  static final TextStyle _text18 =
      TextStyle(fontSize: 18, fontFamily: _fontStyle);

  static final TextStyle _text16 =
      TextStyle(fontSize: 16, fontFamily: _fontStyle);

  static final TextStyle _defaultText =
      TextStyle(fontSize: 14, fontFamily: _fontStyle);

  static final TextStyle _title = TextStyle(
      fontSize: 24, fontFamily: _fontStyle, fontWeight: FontWeight.w900);

  static final ThemeData _lightTheme = ThemeData(
    fontFamily: fontStyle,
    primaryColor: manager!.createMaterialColor(Color(0XFFdd2c00)),
    accentColor: manager!.createMaterialColor(Color(0XFFbf360c)),
    primarySwatch: manager!.createMaterialColor(Color(0XFFdd2c00)),
    brightness: Brightness.light,
    /* textSelectionTheme: TextSelectionThemeData(
      cursorColor: _defaultColor,
    ),*/
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static final ThemeData _darkTheme = ThemeData(
    fontFamily: fontStyle,
    primaryColor: manager!.createMaterialColor(Color(0XFFa30000)),
    accentColor: manager!.createMaterialColor(Color(0XFF870000)),
    primarySwatch: manager!.createMaterialColor(Color(0XFFa30000)),
    brightness: Brightness.dark,
    /*  textSelectionTheme: TextSelectionThemeData(
      cursorColor: _defaultColor,
    ),*/
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static final Widget _appBarTitle = Text(
    _appName,
    style: _title,
  );
  static const List<String> _careNotification = [
    "1",
    "Automatic fetch",
    "Automatic fetch for active hosts",
    "8",
    "Autotest",
    "Automatic test.",
  ];

  static const List<String> _types = [
    "GET",
    "POST",
    "PUT",
    "DELETE",
    "HEAD",
    "PATCH"
  ];

  static bool _state = false;

  static bool _priority = false;

  static Core? get manager => Core.core();

  static get fontStyle => _fontStyle;

  static get title => _title;

  static TextStyle get text18 => _text18;

  static TextStyle get defaultText => _defaultText;

  static TextStyle get text16 => _text16;

  static String get appName => _appName;

  static Widget get appBarTitle => _appBarTitle;

  static String get version => _version;

  static String get publisher => _publisher;

  static int get codeVersion => _codeVersion;

  static String get release => _release;

  static get buttonStyle => _buttonStyle;

  static String get packageID => _packageID;

  static bool get onDebug => _onDebug;

  static ThemeData get darkTheme => _darkTheme;

  static ThemeData get lightTheme => _lightTheme;

  static List<String> get careNotification => _careNotification;

  static String get update => _update;

  static FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin =>
      _flutterLocalNotificationsPlugin;

  static String get variant => _variant; // LATAM,GLOBAL

  static String get reference => _reference;

  static bool get state => _state;

  static set state(bool value) {
    _state = value;
  }

  static int get interval => _interval;

  static set interval(int value) {
    _interval = value;
  }

  static bool get priority => _priority;

  static set priority(bool value) {
    _priority = value;
  }

  static String get ACTIVE_NAME => _ACTIVE_NAME;

  static String get NOTIFICATIONS_MODE_NAME => _NOTIFICATIONS_MODE_NAME;

  static String get INTERVAL_NAME => _INTERVAL_NAME;

  static String get rosillolabs_web => _rosillolabs_web;

  static DateFormat get formatter => _formatter;

  static List<String> get types => _types;
}
