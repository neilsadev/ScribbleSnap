import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart';

class CustomSpreadsheetBlockEmbed extends CustomBlockEmbed {
  const CustomSpreadsheetBlockEmbed(String value)
      : super(spreadsheetType, value);

  static const String spreadsheetType = 'custom_spreadsheet';

  static CustomSpreadsheetBlockEmbed fromDocument(Document document) =>
      CustomSpreadsheetBlockEmbed(jsonEncode(document.toDelta().toJson()));

  Document get document => Document.fromJson(jsonDecode(data));
}
