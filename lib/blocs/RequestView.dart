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
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:orange_eye_foss2/models/Contract.dart';
import 'package:orange_eye_foss2/models/Request.dart';
import 'package:orange_eye_foss2/resources/Repository.dart';
import 'package:orange_eye_foss2/resources/Translate.dart';

abstract class RequestView {
  static Widget buildListRow(
      Request item, BuildContext context, Presenter presenter) {
    //Translate _localizations = Translate.of(context)!;

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ExpansionTileCard(
          shadowColor: item.status >= 400
              ? Colors.red
              : item.status == 0
                  ? Colors.grey
                  : Colors.green,
          baseColor: Repository.manager!.onDark(context)
              ? Repository.manager!.createMaterialColor(const Color(0xFF424242))
              : Colors.white,
          elevation: 8,
          initialElevation: 8,
          leading: InkWell(
              onLongPress: () async {
                Repository.manager!.showChangeHost(context, item, presenter);
              },
              onTap: () async =>
                  await Repository.manager!.launchHost(item.host),
              child: item.active
                  ? Icon(
                      Icons.desktop_windows,
                      color: Colors.blueAccent,
                      size: 35,
                    )
                  : Icon(Icons.desktop_windows, size: 35)),
          title: SizedBox(
              child: Text(
            item.type + " - " + item.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )),
          subtitle: Text(item.host,
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
            const SizedBox(
              height: 10,
            ),
            Text(
              "✨ " + item.status.toString(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Repository.manager!.onDark(context)
                      ? Colors.white54
                      : const Color(0xff89A097)),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              "🗓️ " + item.dateTime(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Repository.manager!.onDark(context)
                      ? Colors.white54
                      : const Color(0xff89A097)),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton.icon(
                      label: Text(""),
                      icon: const Icon(
                        Icons.auto_fix_high,
                      ),
                      onPressed: () async {
                        Repository.manager!.requestTo(item, context, presenter);
                      },
                    )
                  ],
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    OutlinedButton.icon(
                      label: item.active ? Text("") : Text(""),
                      icon: item.active
                          ? const Icon(
                              Icons.pause,
                            )
                          : const Icon(
                              Icons.play_arrow,
                            ),
                      onPressed: () async {
                        await _changeState(item, presenter);
                      },
                    )
                  ],
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    OutlinedButton.icon(
                      label: Text(""),
                      icon: const Icon(
                        Icons.info_outline,
                      ),
                      onPressed: () async {
                        Repository.manager!.showRequest(context, item);
                      },
                    )
                  ],
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    OutlinedButton.icon(
                      label: Text(""),
                      icon: const Icon(
                        Icons.delete,
                      ),
                      onPressed: () async {
                        await _removeRequest(context, item, presenter);
                      },
                    )
                  ],
                ),
              ],
            )
          ],
        ));
  }

  static Future<void> _removeRequest(
      BuildContext context, Request request, Presenter presenter) async {
    Translate? _localizations = Translate.of(context);

    List<Widget> buttons = [
      OutlinedButton.icon(
        label: Text(
          _localizations!.translate("add_request.cancel"),
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
          _localizations.translate("request_view.delete"),
        ),
        icon: const Icon(
          Icons.delete,
        ),
        onPressed: () async {
          await Repository.manager!.removeRequest(request);
          // await presenter.viewDisplayed();
          await presenter.viewDisplayed();
          Navigator.pop(context);
        },
      )
    ];
    Repository.manager!.showBottomSheetDialog(
        context,
        _localizations.translate("request_view.delete_title"),
        _localizations.translate("request_view.delete_body"),
        buttons,
        Icons.delete);
  }

  static Future<void> _changeState(Request request, Presenter presenter) async {
    request.active = !request.active;
    await Repository.manager!.updateRequest(request);
    await presenter.viewDisplayed();
  }
}
