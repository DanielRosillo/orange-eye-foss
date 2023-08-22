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
import 'dart:async';

import 'package:orange_eye_foss2/models/Contract.dart';
import 'package:orange_eye_foss2/resources/Repository.dart';

import 'Request.dart';

class HomeModel implements Model {
  List<Request> _items = <Request>[];

  @override
  Future<List<Request>> getItems() async {
    _items = await Repository.manager!.fetchRequests();
    _items.sort();
    return _items;
  }
}
