import 'package:flutter/material.dart';
import 'package:zeroday/Components/text_field_container.dart';

class NumberInput extends StatefulWidget {
  final TextEditingController controller;
  final Function validate;
  final Function onChanged;
  const NumberInput({
    Key key,
    this.controller,
    this.validate,
    this.onChanged,
  });
  @override
  _NumberInputState createState() => _NumberInputState();
}

class _NumberInputState extends State<NumberInput> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        child: TextFormField(
          validator: (value){
            if(value.isEmpty){
              return "Number is required";
            }
            if(!RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$').hasMatch(value)){
              return "Only numbers";
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,
      onChanged: (value) => widget.onChanged(value),
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        errorText: widget.validate() ? null : "enter a valid number",
        prefixIcon: Icon(Icons.phone),
        hintText: "Number",
        border: InputBorder.none,
      ),
    ));
  }
}
