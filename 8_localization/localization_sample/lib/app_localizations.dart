import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(
    this.locale,
  );

  // Widgetから簡潔に使用する為、staticメソッドを定義しています
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  late Map<String, dynamic> _localizedStrings;

  Future<bool> load() async {
    // JSON言語フォルダを指定したディレクトリから取得します
    final jsonString = await rootBundle
        .loadString('lib/languages/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  // 渡されたkeyに応じた文言を返却します
  String translate(String key) {
    return _localizedStrings[key];
  }
}

// ローカライズ文言を使用する為、LocalizationsDelegateを継承します
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  // 多言語対応する言語コードを指定します
  // 今回のサンプルでは、en、jaに対応しています
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // 多言語対応言語を記載します
    return ['en', 'ja'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
