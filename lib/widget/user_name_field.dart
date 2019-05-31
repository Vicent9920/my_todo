import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///自带删除的ITextField
typedef void ITextFieldCallBack(String content, bool isValid);

class UserNameField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserNameFiledState();

  UserNameField(
      {@required this.fieldCallBack,
      this.focusNode,
      this.keyboardType,
      this.textInputAction,
      this.autofocus,
      this.maxLength,
      this.onEditingComplete,
      this.labelText,
      this.hintText,
      this.prefixIcon,
      this.suffixIcon,
      this.validator});

  final FocusNode focusNode;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool autofocus;
  final FormFieldValidator<String> validator;
  final ITextFieldCallBack fieldCallBack;
  final int maxLength;
  final VoidCallback onEditingComplete;
  final String labelText;
  final String hintText;
  final Widget prefixIcon;
  final Widget suffixIcon;
}

class _UserNameFiledState extends State<UserNameField> {
  bool _isShowCleanIcon = false;
  TextEditingController _controller = TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller?.addListener(() {
      widget.fieldCallBack(
          _controller?.text, (_formKey.currentState as FormState).validate());
      bool state = _controller?.text?.length != 0;
      if (_isShowCleanIcon != state) {
        setState(() {
          _isShowCleanIcon = state;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      //开启自动校验
      autovalidate: true,
      key: _formKey,
      child: TextFormField(
        controller: _controller,
        focusNode: widget.focusNode,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        autofocus: widget.autofocus,
        maxLength: widget.maxLength,
        onEditingComplete: widget.onEditingComplete,
        validator: widget.validator,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: GestureDetector(
            onTap: () {
              widget.fieldCallBack("", false);
              setState(() {
                _isShowCleanIcon = !_isShowCleanIcon;
              });
              _controller.clear();
            },
            child: _isShowCleanIcon
                ? widget.suffixIcon
                : IgnorePointer(
                    ignoring: true,
                    child: new Opacity(
                      opacity: 0.0,
                      child: widget.suffixIcon,
                    )),
          ),
        ),
      ),
    );
  }
}
