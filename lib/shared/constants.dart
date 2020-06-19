import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(

  fillColor: Colors.white,
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderRadius: const BorderRadius.all(
      const Radius.circular(10.0),
    ),
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: const BorderRadius.all(
      const Radius.circular(10.0),
    ),
    borderSide: BorderSide(color: Color(0xffFFE368), width: 2.0),
  ),
);