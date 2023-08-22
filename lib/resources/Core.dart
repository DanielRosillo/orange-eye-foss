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

import 'package:about/about.dart';
import 'package:connectivity/connectivity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:luhn/luhn.dart';
import 'package:orange_eye_foss2/blocs/BottomSheetDialog.dart';
import 'package:orange_eye_foss2/blocs/CreateRequest.dart';
import 'package:orange_eye_foss2/blocs/HostDialog.dart';
import 'package:orange_eye_foss2/blocs/InformationDialog.dart';
import 'package:orange_eye_foss2/blocs/OutDialog.dart';
import 'package:orange_eye_foss2/blocs/Settings.dart';
import 'package:orange_eye_foss2/blocs/WidgetDialog.dart';
import 'package:orange_eye_foss2/models/Contract.dart';
import 'package:orange_eye_foss2/models/Request.dart';
import 'package:orange_eye_foss2/resources/StorageManager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:status_alert/status_alert.dart';
import 'package:url_launcher/url_launcher.dart';

import 'DB.dart';
import 'Repository.dart';
import 'Translate.dart';

class Core {
  static Core? _manager;
  late DB _database;
  late StorageManager _storage;
  late SharedPreferences _sharedPreferences;

  Core._() {
    _database = DB();
    _storage = StorageManager();
  }

  static core() {
    if (_manager == null) _manager = Core._();
    return _manager;
  }

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch as Map<int, Color>);
  }

  bool onDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Future<bool> checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile)
      return true;
    else if (connectivityResult == ConnectivityResult.wifi) return true;

    return false;
  }

  void showBottomSheetDialog(BuildContext context, String? title,
      String? content, List<Widget> buttons, IconData icon) {
    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      enableDrag: true,
      isScrollControlled: true,
      builder: (context) {
        return BottomSheetDialog(
            key: UniqueKey(),
            title: title,
            content: content,
            buttons: buttons,
            icon: icon);
      },
    );
  }

  void showCreateRequest(BuildContext context, Presenter presenter) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context) {
        return CreateRequest(
          presenter: presenter,
        );
      },
    );
  }

  void showSettings(BuildContext context) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context) {
        return Settings();
      },
    );
  }

  void showRequest(BuildContext context, Request request) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context) {
        return InformationDialog(
          request: request,
        );
      },
    );
  }

  void showChangeHost(
      BuildContext context, Request request, Presenter presenter) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context) {
        return HostDialog(
          presenter: presenter,
          request: request,
        );
      },
    );
  }

  void showBottomWidget(BuildContext context, Widget widget) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context) {
        return WidgetDialog(widget: widget);
      },
    );
  }

  Future<void> saveRequest(Request request) async {
    _database.save(request);
  }

  Future<void> removeRequest(Request request) async {
    await _database.remove(request);
  }

  Future<void> updateRequest(Request request) async {
    await _database.remove(request);
    await saveRequest(request);
  }

  Future<List<Request>> fetchRequests() async {
    var result = await _database.fetchRequests();
    return result;
  }

  Future<void> launchHost(String host) async {
    if (await checkNetwork()) {
      await FlutterShare.share(
        title: Repository.appName,
        text: "SELECT A BROWSER",
        linkUrl: host,
      );
    }
  }

  Future<void> shareApp(BuildContext context) async {
    Translate _localizations = Translate.of(context)!;
    await FlutterShare.share(
      title: _localizations.translate("share.title") + Repository.appName,
      text:
          Repository.appName + " " + _localizations.translate("share.content"),
      linkUrl: "https://play.google.com/store/apps/details?id=" +
          Repository.packageID,
    );
  }

  Future<void> requestTo(
      Request item, BuildContext context, Presenter presenter) async {
    //Construir peticion
    final HttpClient client = HttpClient();
    late HttpClientRequest request;
    late HttpClientResponse response;
    var result = new StringBuffer();
    Translate? _localizations = Translate.of(context);

    if (await checkNetwork()) {
      try {
        if (item.type == Repository.types[0]) {
          request = await client.getUrl(
            Uri.parse(item.host),
          );
        } else if (item.type == Repository.types[1]) {
          request = await client.postUrl(Uri.parse(item.host));
        } else if (item.type == Repository.types[2]) {
          request = await client.putUrl(Uri.parse(item.host));
        } else if (item.type == Repository.types[3]) {
          request = await client.deleteUrl(Uri.parse(item.host));
        } else if (item.type == Repository.types[4]) {
          request = await client.headUrl(Uri.parse(item.host));
        } else if (item.type == Repository.types[5]) {
          request = await client.patchUrl(Uri.parse(item.host));
        }

        item.headers.forEach((key, value) {
          if (value.isNotEmpty)
            request.headers.set(key, value, preserveHeaderCase: true);
        });

        //Asignar body si existe
        if (item.body.isNotEmpty) {
          request.write(item.body);
        }
        //Flush de la peticion para obtener el response
        response = await request.close();

        //Esto causa bugs con algunas paginas como google.
        await for (var contents in response.transform(Utf8Decoder())) {
          result.write(contents);
        }

        Clipboard.setData(ClipboardData(text: result.toString()));

        //Desplegar resultado al usuario
        int automaticID = Random().nextInt(100000);
        AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
                Repository.careNotification[0], Repository.careNotification[1],
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
          item.type + " - " + item.host,
          "status: " +
              response.statusCode.toString() +
              " - " +
              response.reasonPhrase,
          platformChannelSpecifics,
        );

        item.status = response.statusCode;
        DateTime now = DateTime.now();
        item.date = now.day.toString() +
            "/" +
            now.month.toString() +
            "/" +
            now.year.toString() +
            " " +
            now.hour.toString() +
            ":" +
            now.minute.toString();

        await updateRequest(item);
        await presenter.viewDisplayed();

        StatusAlert.show(
          context,
          duration: const Duration(seconds: 2),
          title: _localizations!.translate("core.paste"),
          configuration: const IconConfiguration(icon: Icons.copy),
        );
      } on Exception catch (exception) {
        print(exception.toString());

        Clipboard.setData(ClipboardData(text: result.toString()));

        int automaticID = Random().nextInt(100000);
        AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
                Repository.careNotification[0], Repository.careNotification[1],
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
          item.type + " - " + item.host,
          "status: " + exception.toString(),
          platformChannelSpecifics,
        );

        item.status = 0;
        DateTime now = DateTime.now();
        item.date = now.day.toString() +
            "/" +
            now.month.toString() +
            "/" +
            now.year.toString() +
            " " +
            now.hour.toString() +
            ":" +
            now.minute.toString();
        await updateRequest(item);
        await presenter.viewDisplayed();

        StatusAlert.show(
          context,
          duration: const Duration(seconds: 2),
          title: _localizations!.translate("core.paste"),
          configuration: const IconConfiguration(icon: Icons.copy),
        );
      }
    } else {
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 2),
        title: _localizations!.translate("core.no_network"),
        configuration: const IconConfiguration(icon: Icons.error),
      );
    }
  }

  Future<void> exportData(BuildContext context, List<Request> requests) async {
    Translate? _localizations = Translate.of(context);

    List<Map<String, dynamic>> json = <Map<String, dynamic>>[];
    Map<String, dynamic> source = Map();
    requests.forEach((element) async {
      source = element.toJson();
      json.add(source);
    });

    await _storage.writeJSONFile(json).then((value) {
      /*  var source = value.split("/");
        source[0] = "";
        source[1] = "";
        source[2] = "";
        source[3] = "";
        source.removeWhere((value) => value == "");
        value = source.join("/");*/
      showOutDialog(context, _localizations!.translate("export.title"),
          _localizations.translate("export.body"), Icons.save_alt, value);
    });
  }

  Future<void> importData(BuildContext context, Presenter presenter) async {
    Translate? _localizations = Translate.of(context);

    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (file != null) {
      PlatformFile result = file.files.first;
      final File out = File(result.path!);

      List<Widget> buttons = [
        OutlinedButton.icon(
          label: Text(
            _localizations!.translate("import.cancel"),
          ),
          icon: const Icon(
            Icons.cancel_outlined,
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
        ElevatedButton.icon(
          label: Text(
            _localizations.translate("import.continue"),
          ),
          icon: const Icon(
            Icons.import_export,
          ),
          onPressed: () async {
            Navigator.pop(context);
            List<Request> newRequests = await parseRequestsFromJSON(out);
            await _database.addBatch(newRequests);
            await presenter.viewDisplayed();
          },
        ),
      ];

      Repository.manager!.showBottomSheetDialog(
          context,
          _localizations.translate("import.title"),
          file.names.first,
          buttons,
          Icons.import_export);
    }
  }

  Future<List<Request>> parseRequestsFromJSON(
    File file,
  ) async {
    List<dynamic>? contents;
    List<Request> requests = <Request>[];

    await _storage.readJSONFile(file).then((value) {
      contents = value;

      contents!.forEach((element) {
        Map data = element;
        Request request = Request();

        request.date = data['date'];
        request.status = data['status'];
        request.name = data['name'];
        request.host = data['host'];
        request.type = data['type'];
        request.headers = Map<String, String>.from(jsonDecode(data['headers']));
        request.body = data['body'];
        request.note = data['note'];
        request.active = data['active'];
        request.id = data['id'];

        requests.add(request);
      });
    });
    return requests;
  }

  Widget about(BuildContext context, Translate _localizations) {
    Translate? _localizations = Translate.of(context);

    return AboutPage(
      values: {
        'version': Repository.version,
        'buildNumber':
            Repository.codeVersion.toString() + " (" + Repository.update + ")",
        'year': DateTime.now().year.toString(),
        'author': "Rosillo Labs",
      },
      title: Text('About'),
      applicationVersion: 'Version {{ version }}, build #{{ buildNumber }},' +
          ' Since ' +
          Repository.release,
      applicationDescription: Text(
        "Project Manager: Daniel Rosillo\n" +
            'Variant: ' +
            Repository.variant +
            "\n" +
            'Reference: ' +
            Repository.reference +
            "\n" +
            'Luhn: ' +
            Luhn.computeAndAppendCheckDigit((Repository.version.toString() +
                    Repository.codeVersion.toString())
                .hashCode
                .toString()) +
            '\nDebug: ' +
            Repository.onDebug.toString() +
            "\n" +
            'In God we trust.',
        textAlign: TextAlign.justify,
      ),
      applicationLegalese:
          'Copyright © {{ author }}, {{ year }}, Powered by Flutter2, Made with love 💚',
      applicationIcon: SizedBox(
        width: 200,
        height: 200,
        child: Image(
          image: AssetImage(Repository.manager!.onDark(context)
              ? "assets/logo-dark.png"
              : "assets/logo.png"),
        ),
      ),
      children: <Widget>[
        ListTile(
          title: Text("ROSILLO LABS"),
          leading: const Icon(Icons.link_sharp),
          onTap: () => Repository.manager!.launchRosilloLabs(),
        ),
        ListTile(
          title: Text(_localizations!.translate("about.support")),
          leading: const Icon(Icons.support_agent),
          onTap: () => Repository.manager!.launchSupport(),
          /*     onLongPress: () {
            if (_count <= 7) _count++;

            if (_count == 2) {
              StatusAlert.show(
                context,
                duration: const Duration(seconds: 1),
                subtitle: "A secret will be showing",
                configuration: const IconConfiguration(icon: Icons.android),
              );
            } else if (_count == 7) {
              StatusAlert.show(
                context,
                duration: const Duration(seconds: 2),
                subtitle: "You are a super user!",
                configuration: const IconConfiguration(icon: Icons.android),
              );
              Repository.personalPlan = !Repository.personalPlan;
            }
          },*/
        ),
        MarkdownPageListTile(
          icon: const Icon(Icons.list),
          title: const Text('CHANGELOG'),
          filename: 'CHANGELOG.md',
        ),
        LicensesPageListTile(
          title: Text(_localizations.translate("about.licenses")),
          icon: const Icon(Icons.favorite),
        ),
        ListTile(
          title: Text("TEST NOTIFICATIONS"),
          leading: const Icon(Icons.notifications),
          onTap: () async =>
              await Repository.manager!.testNotifications(context),
        ),
      ],
    );
  }

  Future<void> launchSupport() async {
    if (await checkNetwork()) {
      await launch(
        "${Repository.rosillolabs_web}#contact",
        forceSafariVC: true,
        forceWebView: true,
      );
    }
  }

  Future<void> launchRosilloLabs() async {
    if (await checkNetwork()) {
      await launch(
        Repository.rosillolabs_web,
        forceSafariVC: true,
        forceWebView: true,
      );
    }
  }

  void showOutDialog(BuildContext context, String? title, String? msg,
      IconData icon, String content) {
    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context) {
        return OutDialog(
          key: UniqueKey(),
          title: title,
          msg: msg,
          icon: icon,
          content: content,
        );
      },
    );
  }

  Future<void> testNotifications(BuildContext context) async {
    Translate _localizations = Translate.of(context)!;

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      Repository.careNotification[3],
      Repository.careNotification[4],
      channelDescription: Repository.careNotification[5],
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await Repository.flutterLocalNotificationsPlugin.show(
      Random().nextInt(100000),
      _localizations.translate("notification.title"),
      _localizations.translate("notification.body"),
      platformChannelSpecifics,
    );
  }

  SharedPreferences get sharedPreferences => _sharedPreferences;

  set sharedPreferences(SharedPreferences value) {
    _sharedPreferences = value;
  }
}
