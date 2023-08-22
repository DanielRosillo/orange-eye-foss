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

class WidgetDialog extends StatefulWidget {
  final Widget widget;

  WidgetDialog({Key? key, required this.widget}) : super(key: key);

  @override
  _HostDialogState createState() => _HostDialogState();
}

class _HostDialogState extends State<WidgetDialog> {
  @override
  Widget build(BuildContext context) {
    return widget.widget;
  }
}
