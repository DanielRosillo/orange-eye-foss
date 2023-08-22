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
import 'package:orange_eye_foss2/models/Contract.dart';
import 'package:orange_eye_foss2/models/Request.dart';
import 'package:orange_eye_foss2/resources/Repository.dart';
import 'package:orange_eye_foss2/resources/Translate.dart';

class HostDialog extends StatefulWidget {
  final Request request;
  final Presenter presenter;

  HostDialog({
    Key? key,
    required this.presenter,
    required this.request,
  }) : super(key: key);

  @override
  _HostDialogState createState() => _HostDialogState();
}

class _HostDialogState extends State<HostDialog> {
  @override
  void dispose() {
    _hostController.dispose();
    super.dispose();
  }

  TextEditingController _hostController = TextEditingController();

  @override
  void initState() {
    _hostController.text = widget.request.host;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Translate _localizations = Translate.of(context)!;
    return SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  _localizations.translate("host_dialog.title"),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  minLines: 1,
                  controller: _hostController,
                  keyboardType: TextInputType.url,
                  autocorrect: false,
                  //initialValue: 'Aseem Wangoo',
                  decoration: InputDecoration(
                      icon: SizedBox(
                        child: Icon(Icons.desktop_windows),
                        height: 25,
                        width: 25,
                      ),
                      border: const OutlineInputBorder(),
                      labelText: _localizations.translate("add_request.host"),
                      hintText:
                          _localizations.translate("add_request.host_hint"),
                      //filled: true,
                      labelStyle: const TextStyle(
                          decorationStyle: TextDecorationStyle.solid)),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                        child: OutlinedButton.icon(
                      label: Text(
                        _localizations.translate("add_request.cancel"),
                      ),
                      icon: const Icon(
                        Icons.cancel_outlined,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                        child: ElevatedButton.icon(
                      label: Text(
                        _localizations.translate("add_request.save"),
                      ),
                      icon: const Icon(
                        Icons.save,
                      ),
                      onPressed: () async {
                        widget.request.host = _hostController.text;
                        await Repository.manager!.updateRequest(widget.request);
                        await widget.presenter.viewDisplayed();
                        Navigator.pop(context);
                      },
                    )),
                  ],
                )
              ],
            )));
  }
}
