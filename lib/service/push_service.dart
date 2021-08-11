import 'dart:convert';

import 'package:flutter_framework/util/index.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

class PushService {
  JPush _jPush = new JPush();

  init() async {
    LogUtil.v('init push service...');
    registerJPushEvent();
    _jPush.setup(
      appKey: "14990e488561e3052eb4c813",
      channel: "developer-default",
      production: false,
      debug: true, // 设置是否打印 debug 日志
    );
    _jPush.applyPushAuthority(new NotificationSettingsIOS(sound: true, alert: true, badge: true));
  }

  registerJPushEvent() {
    _jPush.addEventHandler(
      // 接收通知回调方法。
      onReceiveNotification: (Map<String, dynamic> message) async {
        LogUtil.v("flutter onReceiveNotification: $message");
        _handleNotification(message);
      },
      // 点击通知回调方法。
      onOpenNotification: (Map<String, dynamic> message) async {
        LogUtil.v("flutter onOpenNotification: $message");
        _handleNotification(message);
      },
      // 接收自定义消息回调方法。
      onReceiveMessage: (Map<String, dynamic> message) async {
        LogUtil.v("flutter onReceiveMessage: $message");
        _handleMessage(message);
      },
    );
  }

  _handleNotification(Map<String, dynamic> message) async {
    var extras = message['extras'];
    var extra = extras['cn.jpush.android.EXTRA'] ?? extras;
    var data = jsonDecode(extra)['data'];
    var json = jsonDecode(data);
    await _deliverHandle(json);
  }

  _handleMessage(Map<String, dynamic> message) async {
    var extra = message['message'];
    var data = jsonDecode(extra);
    await _deliverHandle(data);
  }

  _deliverHandle(Map<String, dynamic> json) async {
    LogUtil.v('json: $json');
    var operation = json['operation'];
    var data = json['data'];
  }

  Future stopPush() async {
    await _jPush.stopPush();
  }

  Future resumePush() async {
    await _jPush.resumePush();
  }

  Future setAlias(String alias) async {
    LogUtil.v('setAlias: $alias');
    /// 未跟极光确认这种错误问题，暂先如此处理，影响的只是推送消息收不到
    try {
      if (alias != null && alias.isNotEmpty) {
        // await _jPush.deleteAlias();
        return await _jPush.setAlias(alias);
      }
    } catch (e) {
      LogUtil.e('推送别名设置出错:');
      LogUtil.e(e);
    }
  }

  sendLocalNotification(LocalNotification notification) async {
    await _jPush.sendLocalNotification(notification);
  }
}