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

import 'package:background_fetch/background_fetch.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:orange_eye_foss2/resources/DB.dart';
import 'package:orange_eye_foss2/resources/Repository.dart';
import 'package:orange_eye_foss2/resources/Translate.dart';
import 'package:orange_eye_foss2/ui/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Developed by: DanielRosillo;
/// 23/02/2022
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await Repository.flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  Repository.manager!.sharedPreferences = await SharedPreferences.getInstance();
  Repository.priority = Repository.manager!.sharedPreferences
          .getBool(Repository.NOTIFICATIONS_MODE_NAME) ??
      false;
  Repository.state =
      Repository.manager!.sharedPreferences.getBool(Repository.ACTIVE_NAME) ??
          true;
  Repository.interval =
      Repository.manager!.sharedPreferences.getInt(Repository.INTERVAL_NAME) ??
          5;

  runApp(EasyDynamicThemeWidget(child: App()));
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask2);
}

void backgroundFetchHeadlessTask2(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
    print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  late var host;
  late var type;
  late var onFire;
  late var body;

  //Leer DB
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  bool active = sharedPreferences.getBool(Repository.ACTIVE_NAME) ?? true;
  bool notificationsMode =
      sharedPreferences.getBool(Repository.NOTIFICATIONS_MODE_NAME) ?? false;
  String? db = sharedPreferences.getString(DB.dbName);
  List<dynamic> mapList = [];
  if (db != null) {
    mapList = json.decode(db);
    if (active) {
      for (dynamic object in mapList) {
        try {
          var map = object;
          host = map["host"];
          type = map["type"];
          onFire = map["active"];
          var headers = Map<String, String>.from(jsonDecode(map['headers']));
          body = map["body"];

          if (onFire) {
            //Construir peticion
            final HttpClient client = HttpClient();
            late HttpClientRequest request;

            if (type == Repository.types[0]) {
              request = await client.getUrl(
                Uri.parse(host),
              );
            } else if (type == Repository.types[1]) {
              request = await client.postUrl(Uri.parse(host));
            } else if (type == Repository.types[2]) {
              request = await client.putUrl(Uri.parse(host));
            } else if (type == Repository.types[3]) {
              request = await client.deleteUrl(Uri.parse(host));
            } else if (type == Repository.types[4]) {
              request = await client.headUrl(Uri.parse(host));
            } else if (type == Repository.types[5]) {
              request = await client.patchUrl(Uri.parse(host));
            }

            headers.forEach((key, value) {
              if (value.isNotEmpty)
                request.headers.set(key, value, preserveHeaderCase: true);
            });

            //Asignar body si existe
            if (body.isNotEmpty) request.write(body);

            //Flush de la peticion para obtener el response
            HttpClientResponse response = await request.close();

            if (notificationsMode) {
              int status = response.statusCode;

              if (status >= 400) {
                //Desplegar resultado al usuario
                int automaticID = Random().nextInt(100000);
                AndroidNotificationDetails androidPlatformChannelSpecifics =
                    AndroidNotificationDetails(Repository.careNotification[0],
                        Repository.careNotification[1],
                        channelDescription: Repository.careNotification[2],
                        autoCancel: true,
                        importance: Importance.defaultImportance,
                        priority: Priority.defaultPriority,
                        enableLights: true,
                        enableVibration: true);

                NotificationDetails platformChannelSpecifics =
                    NotificationDetails(
                        android: androidPlatformChannelSpecifics);

                await Repository.flutterLocalNotificationsPlugin.show(
                  automaticID,
                  type + " - " + host,
                  "status: " +
                      response.statusCode.toString() +
                      " - " +
                      response.reasonPhrase,
                  platformChannelSpecifics,
                );
              }
            } else {
              //Desplegar resultado al usuario
              int automaticID = Random().nextInt(100000);
              AndroidNotificationDetails androidPlatformChannelSpecifics =
                  AndroidNotificationDetails(Repository.careNotification[0],
                      Repository.careNotification[1],
                      channelDescription: Repository.careNotification[2],
                      autoCancel: true,
                      importance: Importance.defaultImportance,
                      priority: Priority.defaultPriority,
                      enableLights: true,
                      enableVibration: true);

              NotificationDetails platformChannelSpecifics =
                  NotificationDetails(android: androidPlatformChannelSpecifics);

              await Repository.flutterLocalNotificationsPlugin.show(
                automaticID,
                type + " - " + host,
                "status: " +
                    response.statusCode.toString() +
                    " - " +
                    response.reasonPhrase,
                platformChannelSpecifics,
              );
            }
          }
        } on Exception catch (exception) {
          int automaticID = Random().nextInt(100000);
          AndroidNotificationDetails androidPlatformChannelSpecifics =
              AndroidNotificationDetails(Repository.careNotification[0],
                  Repository.careNotification[1],
                  channelDescription: Repository.careNotification[2],
                  autoCancel: true,
                  importance: Importance.defaultImportance,
                  priority: Priority.defaultPriority,
                  enableLights: true,
                  enableVibration: true);

          NotificationDetails platformChannelSpecifics =
              NotificationDetails(android: androidPlatformChannelSpecifics);

          await Repository.flutterLocalNotificationsPlugin.show(
            automaticID,
            type + " - " + host,
            "status: " + exception.toString(),
            platformChannelSpecifics,
          );
        }
        //Dormir para evitar overflow
        sleep(Duration(seconds: 1));
      }
    }
  }
  BackgroundFetch.finish(taskId);
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Started at: " + DateTime.now().toString());
    return MaterialApp(
        title: Repository.appName,
        theme: Repository.lightTheme,
        darkTheme: Repository.darkTheme,
        themeMode: EasyDynamicTheme.of(context).themeMode,
        home: Home(),
        supportedLocales: [
          Locale('es'),
          Locale('en'),
        ],
        localizationsDelegates: [
          // Traducciones para recursos de material
          GlobalMaterialLocalizations.delegate,
          // Traducciones para los widgets
          GlobalWidgetsLocalizations.delegate,
          // Traducciones si usamos CupertinoApp
          GlobalCupertinoLocalizations.delegate,
          // Tu archivo donde configuraras las traducciones.
          Translate.delegate,
        ]);
  }
}
