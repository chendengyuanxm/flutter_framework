import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnSelected<T> = void Function(T item);
typedef PositiveCallback = void Function();
typedef NegativeCallback = void Function();
typedef String ItemAsString<T>(T item);

class DialogUtil {
  static Future<bool> showConfirmDialog(BuildContext context, {
    String? content,
    String? positiveText,
    Function? onConfirm,
    String? negativeText,
    Function? onCancel,
    bool showCancel = true,
  }) async {
    return await showDialog(context: context, builder: (context) => AlertDialog(
      content: Text(content ?? ''),
      actions: [
        Visibility(
          visible: showCancel,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              if (onCancel != null) onCancel();
            },
            child: Text(negativeText ?? '取消'),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            if (onConfirm != null) onConfirm();
          },
          child: Text(positiveText ?? '确定'),
        ),
      ],
    ),);
  }

  static Future showAlertDialog(BuildContext context, {
    String? content,
    String? buttonText,
    Function? onConfirm,
  }) async {
    await showConfirmDialog(context, content: content, positiveText: buttonText, onConfirm: onConfirm, showCancel: false);
  }
}