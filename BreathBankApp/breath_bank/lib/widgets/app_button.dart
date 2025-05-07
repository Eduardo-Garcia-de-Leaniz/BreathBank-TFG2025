import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final TextStyle? textStyle;
  final Widget? icon;
  final bool isDisabled;
  final BorderSide? border;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 50,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.borderRadius = 12,
    this.textStyle,
    this.icon,
    this.isDisabled = false,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final style =
        textStyle ??
        TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16);

    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: GestureDetector(
        onTap: isDisabled ? null : onPressed,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: border != null ? Border.fromBorderSide(border!) : null,
          ),
          child: Center(
            child:
                icon != null
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        icon!,
                        const SizedBox(width: 8),
                        Text(text, style: style),
                      ],
                    )
                    : Text(text, style: style),
          ),
        ),
      ),
    );
  }
}
