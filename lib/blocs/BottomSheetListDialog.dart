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

// ignore: must_be_immutable
class BottomSheetListDialog extends StatelessWidget {
  String? content;
  final List<Object?> source;
  final IconData icon;
  final String? title;
  List<Icon> icons = <Icon>[];

  BottomSheetListDialog(
      {required Key key,
      required this.source,
      required this.icon,
      required this.title,
      required this.icons})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  const SizedBox(
                    width: 5,
                  ),
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
                Container(
                    height: 150,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: source.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ListTile(
                                title: Text(source[index] as String),
                                leading: icons.isEmpty
                                    ? Icon(icon)
                                    : SizedBox(
                                        height: 32,
                                        width: 32,
                                        child: icons[index]),
                                onTap: () {
                                  content = source[index] as String?;
                                  Navigator.pop(context);
                                }),
                          );
                        })),
                const SizedBox(
                  height: 20,
                ),
              ],
            )
          ],
        ));
  }
}
