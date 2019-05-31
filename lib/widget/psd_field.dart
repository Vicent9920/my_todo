import 'package:flutter/material.dart';
import 'package:my_todo/widget/user_name_field.dart';

class PasswordField extends StatefulWidget {
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FormFieldValidator<String> validator;
  final ITextFieldCallBack fieldCallBack;
  final int maxLength;
  final VoidCallback onEditingComplete;
  final String labelText;
  final String hintText;
  final Widget prefixIcon;
  final Widget suffixIcon;

  PasswordField({
    @required this.fieldCallBack,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.maxLength,
    this.onEditingComplete,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  State<StatefulWidget> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;
  TextEditingController _controller = TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      widget.fieldCallBack(
          _controller.text, (_formKey.currentState as FormState).validate());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidate: true,
      key: _formKey,
      child: TextFormField(
        obscureText: _obscureText,
        textInputAction: widget.textInputAction,
        keyboardType: widget.keyboardType,
        maxLength: widget.maxLength,
        focusNode: widget.focusNode,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,color: Colors.grey,
            ),
          ),
        ),

        //校验密码
        validator: widget.validator,
        onEditingComplete: widget.onEditingComplete,
        controller: _controller,
      ),
    );
  }
}
