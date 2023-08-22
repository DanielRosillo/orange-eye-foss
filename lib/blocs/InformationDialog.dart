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
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';
import 'package:orange_eye_foss2/models/Request.dart';
import 'package:orange_eye_foss2/resources/Repository.dart';

class InformationDialog extends StatefulWidget {
  InformationDialog({Key? key, required this.request}) : super(key: key);

  final Request request;

  @override
  _InformationDialogState createState() => _InformationDialogState();
}

class _InformationDialogState extends State<InformationDialog> {
  @override
  Widget build(BuildContext context) {
    //Translate _localizations = Translate.of(context)!;

    return KeyboardDismisser(
        gestures: [
          GestureType.onTap,
          GestureType.onForcePressUpdate,
          GestureType.onPanUpdateDownDirection,
        ],
        child: SingleChildScrollView(
            child: Card(
                elevation: 4,
                color: Repository.manager!.onDark(context)
                    ? Repository.manager!
                        .createMaterialColor(const Color(0xFF424242))
                    : Colors.white,
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                    foregroundDecoration: RotatedCornerDecoration.withColor(
                        color: widget.request.status >= 400
                            ? Colors.red
                            : Colors.green,
                        badgeSize: Size(48,48),
                        textSpan: TextSpan(
                          text: widget.request.type,
                          style: const TextStyle(
                            fontSize: 10,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              const BoxShadow(
                                  color: Colors.yellowAccent, blurRadius: 4)
                            ],
                          ),
                        )),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.request.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900)),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                "🌐 " + widget.request.host,
                                maxLines: 5,
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
                                "🔔 " + widget.request.active.toString(),
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
                                "🗓️ " + widget.request.dateTime(),
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
                                "✨ " + widget.request.status.toString(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Repository.manager!.onDark(context)
                                        ? Colors.white54
                                        : const Color(0xff89A097)),
                              ),
                            ],
                          )),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "🗒️ " + widget.request.note,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 15,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Repository.manager!.onDark(context)
                                    ? Colors.white54
                                    : const Color(0xff89A097)),
                          ),
                          Divider(),
                          Text(
                            widget.request.headers.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 15,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Repository.manager!.onDark(context)
                                    ? Colors.white54
                                    : const Color(0xff89A097)),
                          ),
                          Divider(),
                          Text(
                            widget.request.body.toString(),
                            maxLines: 15,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Repository.manager!.onDark(context)
                                    ? Colors.white54
                                    : const Color(0xff89A097)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )))));
  }
}
