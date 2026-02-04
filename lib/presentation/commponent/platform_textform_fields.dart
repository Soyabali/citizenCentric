import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';


class PlatformTextFormField extends StatefulWidget {

  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final Stream<bool>? validationStream;
  final String errorText;
  final ValueChanged<String> onChanged;
  final bool isPassword;
  final IconData? icon;
  final Color? iconColor;
  final Color? labelColor;
  final Color? passwordIconColor;
  final int? maxLength;
  final bool digitsOnly;

  const PlatformTextFormField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.onChanged,
    required this.errorText,
    this.validationStream,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.icon,
    this.iconColor,
    this.labelColor,
    this.passwordIconColor,
    this.maxLength,
    this.digitsOnly = false,
  }) : super(key: key);

  @override
  State<PlatformTextFormField> createState() => _PlatformTextFormFieldState();
}

class _PlatformTextFormFieldState extends State<PlatformTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final bool isIOS = defaultTargetPlatform == TargetPlatform.iOS;

    return StreamBuilder<bool>(
      stream: widget.validationStream,
      builder: (context, snapshot) {
        final bool isValid = snapshot.data ?? true;

        return isIOS
            ? _buildCupertinoField(isValid)
            : _buildMaterialField(isValid);
      },
    );
  }

  // 🍎 iOS Field
  Widget _buildCupertinoField(bool isValid) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ MANUAL LABEL WITH COLOR
        Text(
          widget.label,
          style: TextStyle(
            color: widget.labelColor ?? CupertinoColors.systemGrey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),

        CupertinoTextField(
          controller: widget.controller,
          placeholder: widget.hint,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          inputFormatters: [
            if (widget.digitsOnly)
              FilteringTextInputFormatter.digitsOnly,
            if (widget.maxLength != null)
              LengthLimitingTextInputFormatter(widget.maxLength),
          ],
          padding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 12,
          ),
          prefix: widget.icon != null
              ? Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Icon(
              widget.icon,
              size: 20,
              color: widget.iconColor ?? CupertinoColors.systemGrey,
            ),
          )
              : null,

          suffix: widget.isPassword
              ? CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(
              _obscureText
                  ? CupertinoIcons.eye_slash
                  : CupertinoIcons.eye,
                 // ? CupertinoIcons.eye
                  //: CupertinoIcons.eye_slash,
              size: 20,
              color: widget.passwordIconColor ?? widget.labelColor ??
              CupertinoColors.systemGrey,
              //color: CupertinoColors.systemGrey,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          )
              : null,
          decoration: BoxDecoration(
            border: Border.all(
              color: isValid
                  ? CupertinoColors.systemGrey4
                  : CupertinoColors.systemRed,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }

  // 🤖 Android Field
  Widget _buildMaterialField(bool isValid) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.isPassword ? _obscureText : false,
      onChanged: widget.onChanged,
      maxLength: widget.maxLength,
      inputFormatters: [
        if (widget.digitsOnly)
          FilteringTextInputFormatter.digitsOnly,
        if (widget.maxLength != null)
          LengthLimitingTextInputFormatter(widget.maxLength),
      ],
      decoration: InputDecoration(
        counterText: "",//hide 0 10 counter
        labelText: widget.label,
        hintText: widget.hint,
        errorText: isValid ? null : widget.errorText,
        // ✅ NORMAL label color
        labelStyle: TextStyle(
          color: widget.labelColor ?? Colors.grey,
        ),

        // ✅ FOCUSED label color
        floatingLabelStyle: TextStyle(
          color: widget.labelColor ?? Theme.of(context).primaryColor,
        ),

        prefixIcon: widget.icon != null
            ? Icon(
          widget.icon,
          color: widget.iconColor ?? Colors.grey, // 👈 default color
        )
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscureText
                ? Icons.visibility_off
                : Icons.visibility,
            color: widget.passwordIconColor ?? widget.labelColor ?? Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : null,
      ),
    );
  }
}
