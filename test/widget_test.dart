// This is a basic Flutter page.widget test.
//
// To perform an interaction with a page.widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the page.widget
// tree, read text, and verify that the values of page.widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_todo/entity/base_dto.dart';

import 'package:my_todo/main.dart';

void main() {
  Map<String, dynamic> json = new Map();
  json["data"] = null;
  json["errorMsg"] = "";
  json["errorCode"] = 0;
  BaseDTO dto = BaseDTO.fromJson(json);
  print(dto);
}
