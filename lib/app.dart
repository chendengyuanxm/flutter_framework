import 'package:flutter/material.dart';
import 'package:flutter_framework/common/index.dart';
import 'package:flutter_framework/provider/localization_provider.dart';
import 'package:flutter_framework/provider/theme_provider.dart';
import 'package:flutter_framework/service/index.dart';
import 'package:flutter_framework/ui/main/main_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'generated/l10n.dart';
import 'route.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Framework',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Provider.of<ThemeProvider>(context).primaryColor,
        accentColor: Provider.of<ThemeProvider>(context).accentColor,
      ),
      home: MainPage(),
      navigatorKey: locator<NavigationService>().navigationKey,
      onGenerateRoute: generateRoute,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        // RefreshLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: Provider.of<LocalizationProvider>(context).locale,
    );
  }
}