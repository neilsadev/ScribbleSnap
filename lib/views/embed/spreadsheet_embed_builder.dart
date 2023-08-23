import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:scribblesnap/views/embed/spreadsheet_embed.dart';

import '../widgets/table/table.dart';

class CustomSpreadsheetEmbedBuilder extends EmbedBuilder {
  @override
  String get key => 'custom_spreadsheet';

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
    TextStyle? textStyle,
  ) {
    // final spreadsheetData =
    //     CustomSpreadsheetBlockEmbed(node.value.data).document;
    return CustomSpreadSheetWidget();
  }
}
