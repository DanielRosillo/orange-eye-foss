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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:orange_eye_foss2/blocs/HomePresenter.dart';
import 'package:orange_eye_foss2/blocs/RequestView.dart';
import 'package:orange_eye_foss2/models/Contract.dart';
import 'package:orange_eye_foss2/models/HomeModel.dart';
import 'package:orange_eye_foss2/models/Request.dart';
import 'package:orange_eye_foss2/resources/DB.dart';
import 'package:orange_eye_foss2/resources/Repository.dart';
import 'package:orange_eye_foss2/resources/Translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  Home({
    Key? key,
  }) : super(key: key);

  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<Home> implements View {
  static final _items = ValueNotifier<List<Request>>(<Request>[]);

  late HomePresenter _presenter;

  Future<void> initPlatformState() async {
    int status = await BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: Repository.interval,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            forceAlarmManager: true,
            requiresCharging: false,
            requiresStorageNotLow: false,
            startOnBoot: true,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.ANY), (String taskId) async {
      late var host;
      late var type;
      late var onFire;
      late var body;

      //Leer DB
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      bool active = sharedPreferences.getBool(Repository.ACTIVE_NAME) ?? true;
      bool notificationsMode =
          sharedPreferences.getBool(Repository.NOTIFICATIONS_MODE_NAME) ??
              false;
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
              body = map["body"];

              var headers =
                  Map<String, String>.from(jsonDecode(map['headers']));

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
                        AndroidNotificationDetails(
                            Repository.careNotification[0],
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
    }, (String taskId) async {
      // <-- Task timeout handler.
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });
    print('[BackgroundFetch] configure success: $status');
    //setState(() {});

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  void dispose() {
    _items.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _presenter = HomePresenter(HomeModel(), this);
    _presenter.viewDisplayed();
    initPlatformState();
  }

  Widget _buildList() {
    Translate _localizations = Translate.of(context)!;
    return ValueListenableBuilder<List<Request>>(
        valueListenable: _items,
        builder: (_, value, __) {
          List tasks = value.toList();

          if (tasks.isNotEmpty) {
            return Expanded(
                child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return RequestView.buildListRow(
                    tasks[index], context, _presenter);
              },
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
            ));
          } else {
            return ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Image(
                    image: AssetImage(Repository.manager!.onDark(context)
                        ? "assets/logo-dark.png"
                        : "assets/logo.png"),
                  ),
                ),
                Center(
                    child: Text(
                  _localizations.translate("home.no_request"),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                )),
              ],
            );
          }
        });
  }

  @override
  void showItems(List<Request> items) {
    _items.value = items;
  }

  Future<bool> _onWillPop() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    Translate? _localizations = Translate.of(context);

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission();

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          key: UniqueKey(),
          resizeToAvoidBottomInset: false,
          body: RefreshIndicator(
              onRefresh: () async {
                await _presenter.viewDisplayed();
                _items.value.forEach((element) async {
                  if (element.active)
                    await Repository.manager!
                        .requestTo(element, context, _presenter);
                });
              },
              child: Column(children: [_buildList()])),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Repository.manager!.showCreateRequest(context, _presenter);
            },
            child: const Icon(
              Icons.add,
            ),
          ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                EasyDynamicThemeBtn(),
                const Divider(
                  thickness: 1,
                ),
                ListTile(
                  title: Text(_localizations!.translate("drawer_menu.export")),
                  leading: const Icon(Icons.download_sharp),
                  onTap: () async {
                    if (_items.value.isNotEmpty)
                      await Repository.manager!
                          .exportData(context, _items.value);
                    else
                      Navigator.pop(context);
                  }, //solo export si hay items
                ),
                ListTile(
                  title: Text(_localizations.translate("drawer_menu.import")),
                  leading: const Icon(Icons.upload_sharp),
                  onTap: () async =>
                      await Repository.manager!.importData(context, _presenter),
                ),
                ListTile(
                  title: Text(_localizations.translate("drawer_menu.share")),
                  leading: const Icon(Icons.share),
                  onTap: () async {
                    Navigator.pop(context);
                    Repository.manager!.shareApp(context);
                  },
                ),
                Repository.onDebug
                    ? ListTile(
                        title: Text("TESTS"),
                        leading: const Icon(Icons.code),
                        onTap: () async {},
                      )
                    : Container(),
                const Divider(
                  thickness: 1,
                ),
                ListTile(
                  title: Text(Repository.appName.toUpperCase() +
                      " " +
                      Repository.version +
                      "@" +
                      Repository.codeVersion.toString()),
                  leading: const Icon(Icons.beach_access),
                  onTap: () async {
                    Navigator.pop(context);
                    var aux =
                        Repository.manager!.about(context, _localizations);
                    Repository.manager!.showBottomWidget(context, aux);
                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
            title: Row(
              children: [
                Text("🍊 " + Repository.appName),
                Spacer(),
                InkWell(
                  child: Repository.state
                      ? Icon(Icons.pause)
                      : Icon(Icons.play_arrow),
                  onTap: () async {
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    Repository.state = !Repository.state;
                    await sharedPreferences.setBool(
                        Repository.ACTIVE_NAME, Repository.state);
                    setState(() {});
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                  child: Icon(Icons.settings),
                  onTap: () async {
                    Repository.manager!.showSettings(context);
                  },
                )
              ],
            ),
          )),
    );
  }
}
