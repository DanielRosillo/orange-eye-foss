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
import 'package:flutter/material.dart';
import "package:keyboard_dismisser/keyboard_dismisser.dart";
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:orange_eye_foss2/models/Contract.dart';
import 'package:orange_eye_foss2/models/Request.dart';
import 'package:orange_eye_foss2/resources/Repository.dart';
import 'package:orange_eye_foss2/resources/Translate.dart';

import 'BottomSheetListDialog.dart';

class CreateRequest extends StatefulWidget {
  final Presenter presenter;

  CreateRequest({Key? key, required this.presenter}) : super(key: key);

  @override
  _CreateRequestState createState() => _CreateRequestState();
}

class _CreateRequestState extends State<CreateRequest> {
  Request request = Request();
  TextEditingController? _typeController;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController header1KeyController = TextEditingController();
  TextEditingController header1ValueController = TextEditingController();
  TextEditingController header2KeyController = TextEditingController();
  TextEditingController header2ValueController = TextEditingController();
  TextEditingController header3KeyController = TextEditingController();
  TextEditingController header3ValueController = TextEditingController();
  var myInterstitial00;

  @override
  void initState() {
    super.initState();
    _typeController = TextEditingController();
    _typeController!.text = Repository.types[0];
    request.active = true;
    request.host = "https://";
  }

  @override
  Widget build(BuildContext context) {
    Translate _localizations = Translate.of(context)!;

    final name = TextFormField(
      maxLength: 30,
      maxLines: 1,
      onChanged: (String value) {
        request.name = value;
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        icon: const Icon(
          Icons.account_box_sharp,
        ),
        border: const OutlineInputBorder(),
        labelText: _localizations.translate("add_request.name"),
        hintText: _localizations.translate("add_request.hint"),
      ),
    );

    final host = TextFormField(
      maxLength: 900,
      maxLines: 1,
      validator: (value) {
        value = value!.trim();
        if (value.isEmpty || value == "") {
          return _localizations.translate("add_request.error");
        }
      },
      onChanged: (String value) {
        request.host = value;
      },
      initialValue: request.host,
      keyboardType: TextInputType.url,
      decoration: InputDecoration(
        icon: const Icon(
          Icons.desktop_windows,
        ),
        border: const OutlineInputBorder(),
        labelText: _localizations.translate("add_request.host"),
        hintText: _localizations.translate("add_request.host_hint"),
      ),
    );

    final note = TextFormField(
      maxLength: 300,
      maxLines: 3,
      onChanged: (String value) {
        request.note = value;
      },
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        icon: const Icon(
          Icons.note,
        ),
        border: const OutlineInputBorder(),
        labelText: _localizations.translate("add_request.notes"),
        hintText: _localizations.translate("add_request.notes_hint"),
      ),
    );

    final body = TextFormField(
      maxLength: 2000,
      maxLines: 5,
      onChanged: (String value) {
        request.body = value;
      },
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        icon: const Icon(
          Icons.code,
        ),
        border: const OutlineInputBorder(),
        labelText: _localizations.translate("add_request.body"),
        hintText: _localizations.translate("add_request.body_hint"),
      ),
    );

    final cancel = OutlinedButton.icon(
      label: Text(
        _localizations.translate("add_request.cancel"),
      ),
      icon: const Icon(
        Icons.cancel,
      ),
      onPressed: () async {
        Navigator.pop(context);
      },
    );

    BottomSheetListDialog dialog = BottomSheetListDialog(
        key: UniqueKey(),
        source: Repository.types,
        icon: Icons.miscellaneous_services,
        title: _localizations.translate("add_request.type"),
        icons: <Icon>[]);

    final type = TextFormField(
      controller: _typeController,
      enableInteractiveSelection: false,
      onTap: () async {
        await showModalBottomSheet<void>(
          isDismissible: false,
          shape: const RoundedRectangleBorder(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          context: context,
          builder: (context) {
            return dialog;
          },
        );
        if (dialog.content != null)
          setState(() {
            request.type = dialog.content!;
            _typeController!.value = TextEditingValue(text: dialog.content!);
          });
      },
      readOnly: true,
      autocorrect: false,
      maxLines: 1,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        icon: const Icon(
          Icons.miscellaneous_services,
          size: 25,
        ),
        labelText: _localizations.translate("add_request.type"),
        hintText: _localizations.translate("add_request.type"),
      ),
    );

    var active = ListTileSwitch(
      value: request.active,
      switchActiveColor: Color(0XFFa30000),
      title: Text(_localizations.translate("add_request.active")),
      subtitle: Text(_localizations.translate("add_request.active_hint")),
      leading: Icon(Icons.notifications),
      onChanged: (bool value) {
        setState(() {
          request.active = !request.active;
        });
      },
    );

    final TextFormField header1Key = TextFormField(
      maxLines: 1,
      controller: header1KeyController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        icon: const Icon(
          Icons.menu,
        ),
        border: const OutlineInputBorder(),
        labelText: _localizations.translate("add_request.header_key"),
        hintText: _localizations.translate("add_request.header_key_hint"),
      ),
    );

    final header1Value = TextFormField(
      maxLines: 1,
      controller: header1ValueController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        icon: const Icon(
          Icons.assistant_photo_outlined,
        ),
        border: const OutlineInputBorder(),
        labelText: _localizations.translate("add_request.header_value"),
        hintText: _localizations.translate("add_request.header_value_hint"),
      ),
    );

    final header2Key = TextFormField(
      maxLines: 1,
      controller: header2KeyController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        icon: const Icon(
          Icons.menu,
        ),
        border: const OutlineInputBorder(),
        labelText: _localizations.translate("add_request.header_key"),
        hintText: _localizations.translate("add_request.header_key_hint"),
      ),
    );

    final header2Value = TextFormField(
      maxLines: 1,
      controller: header2ValueController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        icon: const Icon(
          Icons.assistant_photo_outlined,
        ),
        border: const OutlineInputBorder(),
        labelText: _localizations.translate("add_request.header_value"),
        hintText: _localizations.translate("add_request.header_value_hint"),
      ),
    );

    final header3Key = TextFormField(
      maxLines: 1,
      controller: header3KeyController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        icon: const Icon(
          Icons.menu,
        ),
        border: const OutlineInputBorder(),
        labelText: _localizations.translate("add_request.header_key"),
        hintText: _localizations.translate("add_request.header_key_hint"),
      ),
    );

    final header3Value = TextFormField(
      maxLines: 1,
      controller: header3ValueController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        icon: const Icon(
          Icons.assistant_photo_outlined,
        ),
        border: const OutlineInputBorder(),
        labelText: _localizations.translate("add_request.header_value"),
        hintText: _localizations.translate("add_request.header_value_hint"),
      ),
    );

    final save = ElevatedButton.icon(
      label: Text(
        _localizations.translate("add_request.save"),
      ),
      icon: const Icon(
        Icons.save,
      ),
      onPressed: () async {
        if (!Repository.onDebug) {
          if (myInterstitial00 != null)
            myInterstitial00.show();
          else {
            Map<String, String> headers = {
              header1KeyController.text: header1ValueController.text,
              header2KeyController.text: header2ValueController.text,
              header3KeyController.text: header3ValueController.text,
            };
            request.headers = headers;
            await _saveRequest();
          }
        } else {
          await _saveRequest();
        }
      },
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
                      height: 40,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(
                          width: 40,
                          height: 40,
                          padding: const EdgeInsets.all(8),
                          child: Icon(Icons.add_to_queue)),
                      InkWell(
                        child: Text(
                          _localizations.translate("add_request.title"),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                        onTap: () async {
                          if (!Repository.onDebug) {
                            if (myInterstitial00 != null)
                              myInterstitial00.show();
                            else {
                              Map<String, String> headers = {
                                header1KeyController.text:
                                    header1ValueController.text,
                                header2KeyController.text:
                                    header2ValueController.text,
                                header3KeyController.text:
                                    header3ValueController.text,
                              };
                              request.headers = headers;
                              await _saveRequest();
                            }
                          } else {
                            await _saveRequest();
                          }
                        },
                      ),
                    ]),
                    const SizedBox(
                      height: 20,
                    ),
                    Divider(),
                    Form(
                        key: _formKey,
                        child: Column(children: [
                          const SizedBox(
                            height: 5,
                          ),
                          host,
                          const SizedBox(
                            height: 20,
                          ),
                          Divider(),
                          active,
                          const SizedBox(
                            height: 20,
                          ),
                          name,
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          type,
                          const SizedBox(
                            height: 20,
                          ),
                          body,
                          const SizedBox(
                            height: 20,
                          ),
                          note,
                          const SizedBox(
                            height: 10,
                          ),
                          Divider(),
                          const SizedBox(
                            height: 10,
                          ),
                          header1Key,
                          const SizedBox(
                            height: 10,
                          ),
                          header1Value,
                          const SizedBox(
                            height: 10,
                          ),
                          Divider(),
                          const SizedBox(
                            height: 10,
                          ),
                          header2Key,
                          const SizedBox(
                            height: 10,
                          ),
                          header2Value,
                          const SizedBox(
                            height: 10,
                          ),
                          Divider(),
                          header3Key,
                          const SizedBox(
                            height: 10,
                          ),
                          header3Value,
                          const SizedBox(
                            height: 10,
                          ),
                          Divider(),
                          Row(children: [
                            Expanded(child: cancel),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(child: save)
                          ]),
                        ]))
                  ],
                ))));
  }

  Future<void> _saveRequest() async {
    final FormState? formState = _formKey.currentState;

    if (formState!.validate()) {
      formState.save();
      if (request.name == "default") request.name = request.host;
      request.type = _typeController!.text;
      DateTime now = DateTime.now();
      request.date = now.day.toString() +
          "/" +
          now.month.toString() +
          "/" +
          now.year.toString() +
          " " +
          now.hour.toString() +
          ":" +
          now.minute.toString();

      await Repository.manager!.saveRequest(request);
      await widget.presenter.viewDisplayed();
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      /*StatusAlert.show(
        context,
        duration: const Duration(seconds: 2),
        title: _localizations.translate("editform.error"),
        subtitle: _localizations.translate("editform.errormsg"),
        configuration: const IconConfiguration(icon: Icons.error),
      );*/
    }
  }
}
