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

class BottomSheetDialog extends StatelessWidget {
  final String? title;
  final String? content;
  final List<Widget> buttons;
  final IconData icon;

  BottomSheetDialog(
      {required Key key,
      required this.title,
      required this.content,
      required this.buttons,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
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
                      const SizedBox(
                        width: 5,
                      ),
                      Flexible(
                          child: Text(
                        title!,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      )),
                    ]),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Flexible(
                          child: Text(
                        content!,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ))
                    ]),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(child: buttons[0]),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(child: buttons[1]),
                      ],
                    )
                  ],
                )
              ],
            )));
  }
}