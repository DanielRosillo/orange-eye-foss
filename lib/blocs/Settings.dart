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
import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:keyboard_dismisser/keyboard_dismisser.dart";
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:orange_eye_foss2/resources/Repository.dart';
import 'package:orange_eye_foss2/resources/Translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  Settings({
    Key? key,
  }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController _intervalController = TextEditingController();

  @override
  void dispose() {
    _intervalController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _intervalController.text = Repository.interval.toString();
    _intervalController.addListener(() async {
      if (_intervalController.text.isNotEmpty) {
        int interval = int.tryParse(_intervalController.text)!;
        await Repository.manager!.sharedPreferences
            .setInt(Repository.INTERVAL_NAME, interval);
        Repository.interval = interval;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Translate _localizations = Translate.of(context)!;

    var notificationsOnlyIf = ListTileSwitch(
      value: Repository.priority,
      switchActiveColor: Color(0XFFa30000),
      title: Text(_localizations.translate("settings.notifications")),
      subtitle:
          Text(_localizations.translate("settings.notifications_descripcion")),
      leading: Icon(Icons.notifications_active),
      onChanged: (bool value) async {
        Repository.priority = value;
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setBool(
            Repository.NOTIFICATIONS_MODE_NAME, Repository.priority);
        setState(() {});
      },
    );

    var _intervalTextField = TextFormField(
      minLines: 1,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (int.tryParse(value!)! < 0) {
          return _localizations.translate("editform.entername");
        }
        return null;
      },
      controller: _intervalController,
      autocorrect: false,
      decoration: InputDecoration(
          icon: SizedBox(
            child: Icon(Icons.access_time_outlined),
            height: 25,
            width: 25,
          ),
          border: const OutlineInputBorder(),
          labelText: _localizations.translate("settings.delay"),
          hintText: _localizations.translate("settings.delay_description"),
          //filled: true,
          labelStyle:
              const TextStyle(decorationStyle: TextDecorationStyle.solid)),
    );

    var autoStart = ListTile(
      title: Text(_localizations.translate("settings.autostart")),
      leading: const Icon(
        Icons.android,
      ),
      onTap: () async => await initAutoStart(),
    );

    var battery = ListTile(
      title: Text(_localizations.translate("settings.battery")),
      leading: const Icon(
        Icons.battery_charging_full,
      ),
      onTap: () async =>
          DisableBatteryOptimization.showDisableBatteryOptimizationSettings(),
    );

    return KeyboardDismisser(
        gestures: [
          GestureType.onTap,
          GestureType.onForcePressUpdate,
          GestureType.onPanUpdateDownDirection,
        ],
        child: SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(
                          width: 40,
                          height: 40,
                          padding: const EdgeInsets.all(8),
                          child: Icon(Icons.settings)),
                      Text(
                        _localizations.translate("settings.title"),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ]),
                    const SizedBox(
                      height: 20,
                    ),
                    Divider(),
                    Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        ExpansionTileCard(
                          baseColor: Repository.manager!.onDark(context)
                              ? Repository.manager!
                                  .createMaterialColor(const Color(0xFF424242))
                              : Colors.white,
                          elevation: 8,
                          initialElevation: 8,
                          leading: Icon(Icons.notifications),
                          title: SizedBox(
                              child: Text(
                            _localizations
                                .translate("settings.notifications_menu_title"),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                          subtitle: Text(
                              _localizations.translate(
                                  "settings.notifications_menu_body"),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: (Repository.manager!.onDark(context)
                                    ? Colors.white54
                                    : const Color(0xff879D95)),
                              )),
                          children: <Widget>[
                            const Divider(
                              thickness: 1.0,
                              height: 1.0,
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: notificationsOnlyIf),
                            const Divider(
                              thickness: 1.0,
                              height: 1.0,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _intervalTextField)
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Divider(),
                        autoStart,
                        Divider(),
                        battery
                      ],
                    )
                  ],
                ))));
  }

  Future<void> initAutoStart() async {
    try {
      //check auto-start availability.
      var test = await isAutoStartAvailable;
      print(test);
      //if available then navigate to auto-start setting page.
      if (test!) await getAutoStartPermission();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
  }
}
