import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delta_to_html/delta_to_html.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../models/notes.dart';
import 'package:html2md/html2md.dart' as html2md;

class EditScreen extends StatefulWidget {
  final Note? note;
  const EditScreen({super.key, this.note});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  QuillController _quillController = QuillController.basic();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  ScrollController scrollController = ScrollController();
  FocusNode focusNode = FocusNode();

  String quillDeltaToHtml(Delta delta) {
    final html = DeltaToHTML.encodeJson(delta.toJson());
    print(html);
    return html;
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.note != null) {
      _titleController = TextEditingController(text: widget.note!.title);
      _contentController = TextEditingController(text: widget.note!.content);
      _quillController = QuillController(
          document: Document()
            ..insert(0, html2md.convert(widget.note!.content))
            ..toDelta(),
          selection: const TextSelection.collapsed(offset: 0));
    }

    super.initState();
  }

  sendRequest() {
    // Create a new user with a first and last name
    final note = <String, dynamic>{
      "userId": auth.currentUser?.uid,
      "title": _titleController.text,
      "content": quillDeltaToHtml(_quillController.document.toDelta()).trim(),
      "createdAt":
          widget.note == null ? DateTime.now() : widget.note!.createdAt,
      "modifiedAt": DateTime.now(),
    };
    if (widget.note == null) {
      db.collection("notes").add(note).then((DocumentReference doc) =>
          print('DocumentSnapshot added with ID: ${doc.id}'));
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    padding: const EdgeInsets.all(0),
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                    ))
              ],
            ),
            Expanded(
                child: ListView(
              children: [
                TextField(
                  controller: _titleController,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Note Title Here ...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                // TextField(
                //   controller: _contentController,
                //   style: const TextStyle(
                //     color: Colors.white,
                //   ),
                //   maxLines: null,
                //   decoration: const InputDecoration(
                //       border: InputBorder.none,
                //       hintText: 'Type something here',
                //       hintStyle: TextStyle(
                //         color: Colors.grey,
                //       )),
                // ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    border: Border.all(color: Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: QuillEditor(
                      controller: _quillController,
                      readOnly: false,
                      autoFocus: true,
                      focusNode: focusNode,
                      scrollController: scrollController,
                      scrollable: true,
                      padding: const EdgeInsets.all(10),
                      expands: true,
                      paintCursorAboveText: false,
                      placeholder: "Note ...",
                      showCursor: true,
                      scrollBottomInset: 100,
                      keyboardAppearance: Brightness.dark,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: QuillToolbar.basic(
                      controller: _quillController,
                      color: Colors.grey.shade800,
                      showDividers: false,
                      showFontFamily: false,
                      showFontSize: false,
                      showBoldButton: false,
                      showItalicButton: false,
                      showSmallButton: false,
                      showUnderLineButton: false,
                      showStrikeThrough: false,
                      showInlineCode: false,
                      showColorButton: false,
                      showBackgroundColorButton: false,
                      showClearFormat: false,
                      showAlignmentButtons: false,
                      showLeftAlignment: false,
                      showCenterAlignment: false,
                      showRightAlignment: false,
                      showJustifyAlignment: false,
                      showHeaderStyle: false,
                      showListNumbers: false,
                      showListBullets: false,
                      showListCheck: false,
                      showCodeBlock: false,
                      showQuote: false,
                      showIndent: false,
                      showLink: false,
                      showUndo: false,
                      showRedo: false,
                      showDirection: false,
                      showSearchButton: false,
                      showSubscript: false,
                      showSuperscript: false,
                      customButtons: [
                        QuillCustomButton(icon: Icons.ac_unit, onTap: () {}),
                        QuillCustomButton(
                            icon: Icons.ac_unit,
                            onTap: () {
                              //TODO: Solution
                              _quillController.formatSelection(Attribute.bold);
                            }),
                        QuillCustomButton(
                            icon: Icons.ac_unit,
                            onTap: () {
                              debugPrint('snowflake3');
                            }),
                      ]),
                ),
              ],
            ))
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            sendRequest();
            Navigator.pop(context, [
              _titleController.text,
              quillDeltaToHtml(_quillController.document.toDelta()).trim(),
            ]);
          },
          elevation: 10,
          backgroundColor: Colors.grey.shade800,
          child: const Icon(
            Icons.save,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
