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
import 'package:orange_eye_foss2/resources/Translate.dart';

class OutDialog extends StatelessWidget {
  final String? title;
  final String? msg;
  final IconData icon;
  final String? content;

  OutDialog(
      {required Key key,
      required this.title,
      required this.msg,
      required this.icon,
      this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Translate _localizations = Translate.of(context)!;

    return Container(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
        child: Wrap(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(icon),
                  Text(
                    title!,
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
                Text(
                  msg!,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                content != null
                    ? Text(
                        content!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      )
                    : Container(),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  label: Text(
                    _localizations.translate("out_dialog.close"),
                  ),
                  icon: const Icon(
                    Icons.cancel_outlined,
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                )
              ],
            )
          ],
        ));
  }
}
