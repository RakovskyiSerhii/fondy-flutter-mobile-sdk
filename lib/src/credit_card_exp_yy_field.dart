import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class CreditCardExpYyField extends Widget {
  factory CreditCardExpYyField({
    InputDecoration? decoration,
    TextInputAction? textInputAction,
    TextStyle? style,
    Function? onChanged,
  }) = CreditCardExpYyFieldImpl;
}

class CreditCardExpYyFieldImpl extends StatelessWidget
    implements CreditCardExpYyField {
  final textEditingController = TextEditingController(text: '');
  final InputDecoration? _decoration;
  final TextStyle? _style;
  final TextInputAction? _textInputAction;
  final Function? _onChanged;

  CreditCardExpYyFieldImpl({
    InputDecoration? decoration,
    TextInputAction? textInputAction,
    TextStyle? style,
    Function? onChanged,
  })  : _decoration = decoration,
        _textInputAction = textInputAction,
        _style = style,
        _onChanged = onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      keyboardType: TextInputType.number,
      decoration: _decoration,
      textInputAction: _textInputAction,
      style: _style,
      onChanged: (_) => _onChanged?.call(),
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(2),
      ],
    );
  }
}
