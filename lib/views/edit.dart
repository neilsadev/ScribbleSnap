import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delta_to_html/delta_to_html.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:scribblesnap/views/widgets/table/table.dart';
import '../models/notes.dart';
import 'package:html2md/html2md.dart' as html2md;

class EditScreen extends StatefulWidget {
  final Note? note;
  const EditScreen({super.key, this.note});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  QuillController _quillController = QuillController.basic();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  ScrollController scrollController = ScrollController();
  late AnimationController _controller;
  FocusNode focusNode = FocusNode();
  bool showMenu = false;

  String quillDeltaToHtml(Delta delta) {
    final html = DeltaToHTML.encodeJson(delta.toJson());
    print(html);
    return html;
  }

  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: const Duration(seconds: 1),
    );
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
                  height: 250,
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
                // const SizedBox(
                //     height: 300, width: 500, child: CustomSpreadSheetWidget()),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          _quillController.undo();
                        },
                        icon: const Icon(Icons.undo),
                      ),
                      IconButton(
                        onPressed: () {
                          _quillController.redo();
                        },
                        icon: const Icon(Icons.redo),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            showMenu = !showMenu;
                          });
                        },
                        icon: const Icon(Icons.text_fields),
                      ),
                      IconButton(
                        onPressed: () {
                          _quillController
                              .formatSelection(Attribute.leftAlignment);
                        },
                        icon: const Icon(Icons.align_horizontal_left_sharp),
                      ),
                      IconButton(
                        onPressed: () {
                          _quillController
                              .formatSelection(Attribute.rightAlignment);
                        },
                        icon: const Icon(Icons.align_horizontal_right),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: showMenu,
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            final index = _quillController.selection.baseOffset;
                            final isBold = _quillController
                                .getSelectionStyle()
                                .attributes
                                .containsKey(Attribute.bold.key);

                            if (isBold) {
                              _quillController.formatSelection(
                                  Attribute.clone(Attribute.bold, null));
                            } else {
                              _quillController.formatSelection(Attribute.bold);
                            }
                          },
                          icon: const Icon(Icons.format_bold),
                        ),
                        IconButton(
                          onPressed: () {
                            final index = _quillController.selection.baseOffset;
                            final isItalic = _quillController
                                .getSelectionStyle()
                                .attributes
                                .containsKey(Attribute.italic.key);

                            if (isItalic) {
                              _quillController.formatSelection(
                                  Attribute.clone(Attribute.italic, null));
                            } else {
                              _quillController
                                  .formatSelection(Attribute.italic);
                            }
                          },
                          icon: const Icon(Icons.format_italic),
                        ),
                        IconButton(
                          onPressed: () {
                            final index = _quillController.selection.baseOffset;
                            final isItalic = _quillController
                                .getSelectionStyle()
                                .attributes
                                .containsKey(Attribute.h1.key);

                            if (isItalic) {
                              _quillController.formatSelection(
                                  Attribute.clone(Attribute.h1, null));
                            } else {
                              _quillController.formatSelection(Attribute.h1);
                            }
                          },
                          icon: const Icon(Icons.h_plus_mobiledata),
                        ),
                        IconButton(
                          onPressed: () {
                            final index = _quillController.selection.baseOffset;
                            final isItalic = _quillController
                                .getSelectionStyle()
                                .attributes
                                .containsKey(Attribute.h2.key);

                            if (isItalic) {
                              _quillController.formatSelection(
                                  Attribute.clone(Attribute.h2, null));
                            } else {
                              _quillController.formatSelection(Attribute.h2);
                            }
                          },
                          icon: const Icon(Icons.h_mobiledata),
                        ),
                        IconButton(
                          onPressed: () {
                            final index = _quillController.selection.baseOffset;
                            final isItalic = _quillController
                                .getSelectionStyle()
                                .attributes
                                .containsKey(Attribute.strikeThrough.key);

                            if (isItalic) {
                              _quillController.formatSelection(Attribute.clone(
                                  Attribute.strikeThrough, null));
                            } else {
                              _quillController
                                  .formatSelection(Attribute.strikeThrough);
                            }
                          },
                          icon: const Icon(Icons.strikethrough_s),
                        ),
                        IconButton(
                          onPressed: () {
                            final index = _quillController.selection.baseOffset;
                            final isItalic = _quillController
                                .getSelectionStyle()
                                .attributes
                                .containsKey(Attribute.underline.key);

                            if (isItalic) {
                              _quillController.formatSelection(
                                  Attribute.clone(Attribute.underline, null));
                            } else {
                              _quillController
                                  .formatSelection(Attribute.underline);
                            }
                          },
                          icon: const Icon(Icons.format_underline),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ))
          ]),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     sendRequest();
        //     Navigator.pop(context, [
        //       _titleController.text,
        //       quillDeltaToHtml(_quillController.document.toDelta()).trim(),
        //     ]);
        //   },
        //   elevation: 10,
        //   backgroundColor: Colors.grey.shade800,
        //   child: const Icon(
        //     Icons.save,
        //     color: Colors.white,
        //   ),
        // ),
      ),
    );
  }

  void _showExpandedMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          // Adjust the height of your bottom sheet here
          height: 300,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Take a Photo'),
                onTap: () {
                  // Handle the action
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Choose from Gallery'),
                onTap: () {
                  // Handle the action
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text('Share Location'),
                onTap: () {
                  // Handle the action
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
              // Add more ListTiles for additional menu items
            ],
          ),
        );
      },
    );
  }
}
