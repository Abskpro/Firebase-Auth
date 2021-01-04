import 'package:flutter/material.dart';
import 'package:zeroday/Components/text_field_container.dart';

class EmailInput extends StatefulWidget {
  final TextEditingController controller;
  final Function validate;
  final Function onChanged;
  const EmailInput({
    Key key,
    this.controller,
    this.validate,
    this.onChanged,
  });
  @override
  _EmailInputState createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInput> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        child: TextFormField(
      controller: widget.controller,
      validator: (value) {
        if (value.isEmpty) {
          return "email is required";
        }
        return null;
      },
      onChanged: (value) => widget.onChanged("email", value),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.supervisor_account),
        errorText: widget.validate() ? null : "enter a valid email",
        hintText: "Email",
        border: InputBorder.none,
      ),
    ));
  }
}
