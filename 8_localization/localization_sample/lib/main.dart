import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization_sample/app_localizations.dart';
import 'package:localization_sample/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Localization sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // 多言語対応言語の一覧
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ja', 'JP'),
      ],
      localizationsDelegates: [
        // アプリ固有のdelegateを追加
        AppLocalizations.delegate,

        // Flutter Widgetsの多言語化に使用
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // アプリ内で使用される、localeを返却します
      localeResolutionCallback: (locale, supportedLocales) {
        // 現在の端末で使用されている、localeを確認しています
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale!.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        // デバイスのlocaleがサポートされていない
        return supportedLocales.first;
      },
      home: HomePage(),
    );
  }
}
