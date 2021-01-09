import 'package:flutter/material.dart';
import 'package:zeroday/Components/text_field_container.dart';
import 'package:zeroday/constants.dart';

class PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final Function validate;
  final String type;
  final bool isConfirm;
  final Function onChanged;
  final String screen;
  const PasswordInput({
    Key key,
    this.controller,
    this.validate,
    this.type,
    this.isConfirm,
    this.screen,
    this.text,
    this.onChanged,
  });
  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool visibility;
  void initState(){
    super.initState();
    visibility = false;
  }
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        child: TextFormField(
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value){
        if(value.isEmpty){
          return "password is required";
        }
        if(value.length < 8){
          return "password must be 8 char";
        }
        return null;
      },
       onChanged: (value){
            if(widget.type == "password"){
              widget.onChanged("password", value);
            }else{
              widget.onChanged("confirmPassword",value);
            }
            },
          obscureText: visibility,
      decoration: InputDecoration(
        errorText:widget.validate() ? null : "password must match",
        hintText: widget.text,
        prefixIcon: Icon(
          Icons.lock_outline,
          color: kPrimaryColor,
        ),
        suffixIcon: InkWell(
          onTap:(){
            setState(() {
              visibility = !visibility;
            });
          },
          child:Icon(visibility ? Icons.visibility : Icons.visibility_off),

        ),
        border: InputBorder.none,
      ),
    ));
  }
}


