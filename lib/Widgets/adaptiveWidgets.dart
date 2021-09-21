import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveFlatButton extends StatelessWidget {

  final Widget? child;
  final GestureTapCallback? handler;
  const AdaptiveFlatButton({ this.child, this.handler});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(

        child: child!,
        onPressed: handler,
        // _popDatePicker,
    )
        : TextButton(
      onPressed: handler,
      child: child!,
    );
  }
}
