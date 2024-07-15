import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/language_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final Color? fillColor;
  final int maxLines;
  final bool isPassword;
  final bool isBorderStyle;
  final bool isCountryPicker;
  final bool isShowBorder;
  final bool isIcon;
  final bool isShowSuffixIcon;
  final bool isShowPrefixIcon;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final void Function()? onSuffixTap;
  final String? suffixIconUrl;
  final String? prefixIconUrl;
  final bool isSearch;
  final bool isReadOnly;
  final Function? onSubmit;
  final bool isEnabled;
  final TextCapitalization capitalization;
  final LanguageProvider? languageProvider;
  final InputDecoration? inputDecoration;

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText = 'Write something...',
    this.isEnabled = true,
    this.isReadOnly = false,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.maxLines = 1,
    this.isBorderStyle = false,
    this.capitalization = TextCapitalization.none,
    this.isCountryPicker = false,
    this.isShowBorder = false,
    this.isShowSuffixIcon = false,
    this.isShowPrefixIcon = false,
    this.isIcon = false,
    this.isPassword = false,
    this.isSearch = false,
    this.focusNode,
    this.nextFocus,
    this.onSuffixTap,
    this.fillColor,
    this.onSubmit,
    this.onChanged,
    this.onTap,
    this.suffixIconUrl,
    this.prefixIconUrl,
    this.languageProvider,
    this.inputDecoration,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: widget.maxLines,
      controller: widget.controller,
      focusNode: widget.focusNode,
      style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: Dimensions.FONT_SIZE_LARGE,
          ),
      textInputAction: widget.inputAction,
      keyboardType: widget.inputType,
      cursorColor: Theme.of(context).primaryColor,
      textCapitalization: widget.capitalization,
      readOnly: widget.isReadOnly,
      enabled: widget.isEnabled,
      autofocus: false,
      obscureText: widget.isPassword ? _obscureText : false,
      inputFormatters: widget.inputType == TextInputType.phone
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[0-9+]'))
            ]
          : null,
      decoration: widget.inputDecoration ??
          InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                  style: widget.isBorderStyle
                      ? BorderStyle.solid
                      : BorderStyle.none,
                  width: 0),
            ),
            isDense: true,
            hintText: widget.hintText,
            fillColor: widget.fillColor ?? Theme.of(context).cardColor,
            hintStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: Dimensions.FONT_SIZE_SMALL,
                  color: ColorResources.COLOR_GREY_CHATEAU,
                ),
            filled: true,
            prefixIcon: widget.isShowPrefixIcon
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: Dimensions.PADDING_SIZE_LARGE,
                        right: Dimensions.PADDING_SIZE_SMALL),
                    child: Image.asset(widget.prefixIconUrl!),
                  )
                : const SizedBox.shrink(),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 23, maxHeight: 20),
            suffixIcon: widget.isShowSuffixIcon
                ? widget.isPassword
                    ? IconButton(
                        icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color:
                                Theme.of(context).hintColor.withOpacity(0.3)),
                        onPressed: _toggle)
                    : widget.isIcon
                        ? IconButton(
                            onPressed: widget.onSuffixTap,
                            icon: Image.asset(
                              widget.suffixIconUrl!,
                              width: 15,
                              height: 15,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          )
                        : null
                : null,
          ),
      onTap: widget.onTap,
      onSubmitted: (text) => widget.nextFocus != null
          ? FocusScope.of(context).requestFocus(widget.nextFocus)
          : widget.onSubmit != null
              ? widget.onSubmit!(text)
              : null,
      onChanged: widget.onChanged,
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
