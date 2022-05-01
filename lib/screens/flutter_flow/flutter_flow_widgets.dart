/*import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class FFButtonOptions {
  const FFButtonOptions({
    required this.textStyle,
   required this.elevation,
 required   this.height,
  required  this.width,
  required  this.padding,
  required  this.color,
  required  this.disabledColor,
  required  this.disabledTextColor,
  required  this.splashColor,
 required   this.iconSize,
 required   this.iconColor,
 required   this.iconPadding,
  required  this.borderRadius,
 required   this.borderSide,
  });

  final TextStyle textStyle;
  final double elevation;
  final double height;
  final double width;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color disabledColor;
  final Color disabledTextColor;
  final Color splashColor;
  final double iconSize;
  final Color iconColor;
  final EdgeInsetsGeometry iconPadding;
  final double borderRadius;
  final BorderSide borderSide;
}

class FFButtonWidget extends StatelessWidget {
  const FFButtonWidget({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.icon,
    required this.iconData,
    required this.options,
  }) : super(key: key);

  final String text;
  final Widget icon;
  final IconData iconData;
  final VoidCallback onPressed;
  final FFButtonOptions options;

  @override
  Widget build(BuildContext context) {
    final textWidget = AutoSizeText(
      text,
      style: options.textStyle,
      maxLines: 1,
    );
    if (icon != null || iconData != null) {
      return Container(
        height: options.height,
        width: options.width,
        child: RaisedButton.icon(
          icon: Padding(
            padding: options.iconPadding ?? EdgeInsets.zero,
            child: icon ??
                FaIcon(
                  iconData,
                  size: options.iconSize,
                  color: options.iconColor ?? options.textStyle.color,
                ),
          ),
          label: textWidget,
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(options.borderRadius),
            side: options.borderSide ?? BorderSide.none,
          ),
          color: options.color,
          colorBrightness: ThemeData.estimateBrightnessForColor(options.color),
          textColor: options.textStyle.color,
          disabledColor: options.disabledColor,
          disabledTextColor: options.disabledTextColor,
          elevation: options.elevation,
          splashColor: options.splashColor,
        ),
      );
    }

    return Container(
      height: options.height,
      width: options.width,
      child: RaisedButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(options.borderRadius ?? 28),
          side: options.borderSide ?? BorderSide.none,
        ),
        textColor: options.textStyle.color,
        color: options.color,
        colorBrightness: ThemeData.estimateBrightnessForColor(options.color),
        disabledColor: options.disabledColor,
        disabledTextColor: options.disabledTextColor,
        padding: options.padding,
        elevation: options.elevation,
        child: textWidget,
      ),
    );
  }
}
*/