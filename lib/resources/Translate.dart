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

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

class Translate {
  final String localName;

  Translate(this.localName);

  static const LocalizationsDelegate<Translate> delegate =
      _AppLocalizationsDelegate();
  YamlMap? translations;
  YamlMap? translationsFallback;

  Future load() async {
    String yamlString = await rootBundle.loadString('lang/$localName.yml');
    translations = loadYaml(yamlString);
    String yamlString1 = await rootBundle.loadString('lang/en.yml');
    translationsFallback = loadYaml(yamlString1);
  }

  dynamic translate(String key) {
    try {
      var keys = key.split(".");
      dynamic translated = translations;
      keys.forEach((k) => translated = translated[k]);
      if (translated == null) {
        return _fallback(key);
      }
      return translated;
    } catch (e) {
      return _fallback(key);
    }
  }

  dynamic _fallback(String key) {
    try {
      var keys = key.split(".");
      dynamic translated = translationsFallback;
      keys.forEach((k) => translated = translated[k]);
      if (translated == null) {
        return "Key not found....: $key";
      }
      return translated;
    } catch (e) {
      return "Key not found: $key";
    }
  }

  static Translate? of(BuildContext context) {
    return Localizations.of<Translate>(context, Translate);
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<Translate> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es'].contains(locale.languageCode);
  }

  @override
  Future<Translate> load(Locale locale) async {
    var translate = Translate(locale.languageCode);
    await translate.load();
    return translate;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
