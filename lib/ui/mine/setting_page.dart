import 'package:flutter/material.dart';
import 'package:flutter_framework/generated/l10n.dart';
import 'package:flutter_framework/provider/localization_provider.dart';
import 'package:flutter_framework/service/index.dart';
import 'package:flutter_framework/ui/mine/language_setting_page.dart';
import 'package:flutter_framework/ui/mine/theme_setting_page.dart';
import 'package:flutter_framework/widget/index.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _isChines = true;

  _onClickToggleLocalization() {
    locator<NavigationService>().pushPage(LanguageSettingPage());
  }

  _onClickToggleTheme() {
    locator<NavigationService>().pushPage(ThemeSettingPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('Setting'),
      ),
      body: body(),
    );
  }

  Widget body() {
    return Container(
      child: Column(
        children: [
          ListTile(
            onTap: () => _onClickToggleLocalization(),
            leading: Icon(Icons.language),
            title: Text('切换语言'),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () => _onClickToggleTheme(),
            leading: Icon(Icons.language),
            title: Text('切换主题'),
            trailing: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
