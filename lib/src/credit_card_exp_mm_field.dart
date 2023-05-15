import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class CreditCardExpMmField extends Widget {
  factory CreditCardExpMmField({
    InputDecoration? decoration,
    TextInputAction? textInputAction,
    TextStyle? style,
    Function? onChanged,
  }) = CreditCardExpMmFieldImpl;
}

class CreditCardExpMmFieldImpl extends StatelessWidget
    implements CreditCardExpMmField {
  final textEditingController = TextEditingController(text: '');
  final InputDecoration? _decoration;
  final TextInputAction? _textInputAction;
  final TextStyle? _style;
  final Function? _onChanged;

  CreditCardExpMmFieldImpl({
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
