import 'package:flutter/material.dart';
import 'package:flutter_framework/common/index.dart';

class ThemeProvider extends ChangeNotifier {
  MaterialColor _primaryColor = ColorConfig.primaryColor;
  MaterialColor get primaryColor => _primaryColor;
  MaterialColor _accentColor = ColorConfig.accentColor;
  MaterialColor get accentColor => _accentColor;

  setPrimaryColor(MaterialColor color) {
    this._primaryColor = color;
    notifyListeners();
  }
}