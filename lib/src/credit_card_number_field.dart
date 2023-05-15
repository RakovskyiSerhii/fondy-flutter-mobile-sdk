import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class CreditCardNumberField extends Widget {
  factory CreditCardNumberField({
    InputDecoration? decoration,
    TextInputAction? textInputAction,
    TextStyle? style,
    Function? onChanged,
    FocusNode? focusNode,
  }) = CreditCardNumberFieldImpl;
}

class CreditCardNumberFieldImpl extends StatelessWidget
    implements CreditCardNumberField {
  final textEditingController = TextEditingController(text: '');
  final InputDecoration? _decoration;
  final TextInputAction? _textInputAction;
  final TextStyle? _style;
  final Function? _onChanged;
  final FocusNode? _focusNode;

  CreditCardNumberFieldImpl({
    InputDecoration? decoration,
    TextInputAction? textInputAction,
    TextStyle? style,
    Function? onChanged,
    FocusNode? focusNode,
  })  : _decoration = decoration,
        _textInputAction = textInputAction,
        _style = style,
        _onChanged = onChanged,
        _focusNode = focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      keyboardType: TextInputType.number,
      decoration: _decoration,
      textInputAction: _textInputAction,
      style: _style,
      focusNode: _focusNode,
      onChanged: (_) => _onChanged?.call(),
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(19),
      ],
    );
  }
}
