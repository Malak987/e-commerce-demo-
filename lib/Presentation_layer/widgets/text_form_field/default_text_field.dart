import 'package:e_commerce_prof/styles/color.dart';
import 'package:flutter/material.dart';

class DefaultTextField extends StatefulWidget { // 1. حولناها لـ StatefulWidget
  const DefaultTextField({
    super.key,
    this.label,
    this.hintText,
    this.obscureText = false, // القيمة الافتراضية
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.suffixIcon,
    this.prefixIcon,
    this.cursorColor,
    this.errorText,
    this.borderColor,
    this.focusBorderColor,
    this.fillColor,
    this.borderRadius,
    this.borderWidth,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.width,
    this.contentPadding,
  });

  final double? width;
  final String? label;
  final String? hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  final Color? cursorColor;
  final String? errorText;
  final Color? borderColor;
  final Color? focusBorderColor;
  final Color? fillColor;

  final double? borderRadius;
  final double? borderWidth;

  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final Function(String)? onSubmitted;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? contentPadding;

  @override
  State<DefaultTextField> createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  // متغير داخلي عشان نتحكم في حالة الباسورد (مخفي/ظاهر)
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText; // ناخد القيمة اللي جت من الـ Constructor
  }

  // دالة عشان نقلب حالة الباسورد
  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: TextFormField(
        validator: widget.validator,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        // هنا بنربط المتغير الداخلي مش اللي جاي من الـ Constructor عشان نقدر نغيره
        obscureText: _isObscure,
        onTap: widget.onTap,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        cursorColor: widget.cursorColor ?? primColor,
        textAlignVertical: TextAlignVertical.center,

        decoration: InputDecoration(
          isDense: true,
          // زودنا المسافة اليمين عشان النص ميلمسش الأيقونة
          contentPadding: widget.contentPadding ??
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0,),

          labelText: widget.label,
          hintText: widget.hintText,
          errorText: widget.errorText,
          prefixIcon: widget.prefixIcon,

          // هنا الحل: لو الـ obscureText مفعل، بنحط أيقونة العين أوتوماتيك
          // لو المستخدم جاب أيقونة تانية في suffixIcon، بنحطها جنب أيقونة العين
          suffixIcon: widget.obscureText
              ? Row(
            mainAxisSize: MainAxisSize.min, // عشان الـ Row تاخد مساحة محتواها بس
            children: [
              // لو المستخدم عايز أيقونة تانية مع العين (زي مسح)
              if (widget.suffixIcon != null) widget.suffixIcon!,

              // أيقونة العين بتاعتنا
              IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                  color:_isObscure ? Colors.grey: primColor,
                ),
                onPressed: _togglePasswordVisibility,
                padding: EdgeInsets.zero, // عشان نلغي الـ padding الزيادة بتاع الـ IconButton
                constraints: const BoxConstraints(),
              ),
            ],
          )
              : widget.suffixIcon, // لو مش باسورد، خلي الـ suffixIcon زي ما هو

          filled: true,
          fillColor: widget.fillColor ?? Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
            borderSide: BorderSide(
              color: widget.borderColor ?? Colors.grey,
              width: widget.borderWidth ?? 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
            borderSide: BorderSide(
              color: widget.focusBorderColor ?? primColor,
              width: widget.borderWidth ?? 1.5,
            ),
          ),
        ),
      ),
    );
  }
}