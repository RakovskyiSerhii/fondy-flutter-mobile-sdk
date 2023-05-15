import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class CreditCardExpYyField extends Widget {
  factory CreditCardExpYyField({
    InputDecoration? decoration,
    TextInputAction? textInputAction,
    TextStyle? style,
    Function? onChanged,
    FocusNode? focusNode,
  }) = CreditCardExpYyFieldImpl;
}

class CreditCardExpYyFieldImpl extends StatelessWidget
    implements CreditCardExpYyField {
  final textEditingController = TextEditingController(text: '');
  final InputDecoration? _decoration;
  final TextStyle? _style;
  final TextInputAction? _textInputAction;
  final Function? _onChanged;
  final FocusNode? _focusNode;

  CreditCardExpYyFieldImpl({
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
      key: UniqueKey(),
      controller: textEditingController,
      keyboardType: TextInputType.number,
      decoration: _decoration,
      textInputAction: _textInputAction,
      style: _style,
      focusNode: _focusNode,
      onChanged: (_) => _onChanged?.call(),
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(2),
      ],
    );
  }
}
