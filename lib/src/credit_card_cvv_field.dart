import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class CreditCardCvvField extends Widget {
  factory CreditCardCvvField({
    InputDecoration? decoration,
    TextInputAction? textInputAction,
    TextStyle? style,
    Function? onChanged,
    FocusNode? focusNode,
  }) = CreditCardCvvFieldImpl;
}

class CreditCardCvvFieldImpl extends StatelessWidget
    implements CreditCardCvvField {
  final textEditingController = TextEditingController(text: '');
  final InputDecoration? _decoration;
  final TextInputAction? _textInputAction;
  final TextStyle? _style;
  final Function? _onChanged;
  final FocusNode? _focusNode;

  final GlobalKey<CreditCardCvvFieldInternalState> _key =
      GlobalKey<CreditCardCvvFieldInternalState>();

  CreditCardCvvFieldImpl({
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

  setCvv4(bool enabled) {
    _key.currentState?.setCvv4(enabled);
  }

  @override
  Widget build(BuildContext context) {
    return CreditCardCvvFieldInternal(
      _key,
      textEditingController,
      _decoration,
      _textInputAction,
      _style,
      _onChanged,
      _focusNode,
    );
  }
}

class CreditCardCvvFieldInternal extends StatefulWidget {
  final TextEditingController _textEditingController;
  final InputDecoration? _decoration;
  final TextInputAction? _textInputAction;
  final TextStyle? _style;
  final Function? _onChanged;
  final FocusNode? _focusNode;

  CreditCardCvvFieldInternal(
    Key key,
    this._textEditingController,
    this._decoration,
    this._textInputAction,
    this._style,
    this._onChanged,
    this._focusNode,
  ) : super(key: key);

  @override
  CreditCardCvvFieldInternalState createState() {
    return CreditCardCvvFieldInternalState(
        this._textEditingController,
        this._decoration,
        this._textInputAction,
        this._style,
        this._onChanged,
        _focusNode);
  }
}

class CreditCardCvvFieldInternalState
    extends State<CreditCardCvvFieldInternal> {
  final TextEditingController _textEditingController;
  final TextInputAction? _textInputAction;
  final TextStyle? _style;
  final InputDecoration? _decoration;
  final Function? _onChanged;
  final FocusNode? _focusNode;

  int _maxLength = 3;

  CreditCardCvvFieldInternalState(
    this._textEditingController,
    this._decoration,
    this._textInputAction,
    this._style,
    this._onChanged,
    this._focusNode,
  );

  setCvv4(bool enabled) {
    setState(() {
      if (enabled) {
        _maxLength = 4;
      } else {
        _maxLength = 3;
        if (_textEditingController.text.length == 4) {
          _textEditingController.text =
              _textEditingController.text.substring(0, 3);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textEditingController,
      keyboardType: TextInputType.number,
      decoration: _decoration,
      textInputAction: _textInputAction,
      style: _style,
      focusNode: _focusNode,
      onChanged: (_) => _onChanged?.call(),
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(_maxLength),
      ],
    );
  }
}
