import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart';

class CustomSpreadsheetBlockEmbed extends CustomBlockEmbed {
  const CustomSpreadsheetBlockEmbed(String value)
      : super(spreadsheetType, value);

  static const String spreadsheetType = 'custom_spreadsheet';

  Map<String, Map<String, String>> convertToCustomJson(
      List<List<String>> data) {
    Map<String, Map<String, String>> result = {};

    List<String> columnLabels = data[0];

    for (int columnIndex = 0;
        columnIndex < columnLabels.length;
        columnIndex++) {
      String columnLabel =
          String.fromCharCode(65 + columnIndex); // Convert to A, B, C...
      Map<String, String> columnValues = {};

      for (int rowIndex = 1; rowIndex < data.length; rowIndex++) {
        String cellValue = data[rowIndex][columnIndex];
        columnValues[rowIndex.toString()] = cellValue;
      }

      result[columnLabel] = columnValues;
    }

    return result;
  }

  static CustomSpreadsheetBlockEmbed fromDocument(Document document) =>
      CustomSpreadsheetBlockEmbed(jsonEncode(document.toDelta().toJson()));

  Document get document => Document.fromJson(jsonDecode(data));
}
