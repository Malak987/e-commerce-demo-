import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    super.key,
    this.text,
    this.onPressed,
    this.onSubmitted,
    this.onTap,
    this.width,
    this.height,
    this.radius,
    this.color,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.elevation,
    this.borderWidth,
    this.borderColor,
    this.horizontalPadding,
    this.verticalPadding,
    this.horizontalMargin,
    this.verticalMargin,
    this.textPadding,
    this.textFontSize,
    this.textFontWeight,
    this.prefixIcon, this.child,
  });
  final Widget? child;
  final String? text;
  final VoidCallback? onPressed;
  final Function? onSubmitted;
  final Function? onTap;
  final double? width;
  final double? height;
  final double? radius;
  final Color? color;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? elevation;
  final double? borderWidth;
  final Color? borderColor;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? horizontalMargin;
  final double? verticalMargin;
  final double? textPadding;
  final double? textFontSize;
  final FontWeight? textFontWeight;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 50,
      width: width ?? double.infinity,
      child: ElevatedButton(

        onPressed: onPressed,
        style: ButtonStyle(

          backgroundColor: WidgetStateProperty.all(color),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),

          elevation: WidgetStateProperty.all(elevation),
        ),
        child: child ??
            Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            if (prefixIcon != null) ...[
              prefixIcon!,
              const SizedBox(width: 15),
            ],

            Text(
              text  ?? "",
              style: TextStyle(
                color: textColor,
                fontSize: textFontSize,
                fontWeight: textFontWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
