import 'package:flutter/material.dart';
import 'package:flutter_framework/generated/l10n.dart';
import 'package:flutter_framework/service/index.dart';
import 'package:flutter_framework/ui/mine/setting_page.dart';
import 'package:flutter_framework/widget/index.dart';

class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {

  _onClickSetting() {
    locator<NavigationService>().pushPage(SettingPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(S.current.tab_mine),
        leading: Container(),
        actions: [
          IconButton(
            onPressed: _onClickSetting,
            icon: Icon(
              Icons.settings,
            ),
          ),
        ],
      ),
      body: body(),
    );
  }

  Widget body() {
    return Container(
    );
  }
}
