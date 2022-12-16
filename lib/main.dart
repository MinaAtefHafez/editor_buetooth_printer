

// ignore_for_file: use_build_context_synchronously

import 'package:example_test/screens/bluetooth_screen.dart';
import 'package:example_test/screens/sceen_shot_text_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

void main() => runApp(HtmlEditorExampleApp());

class HtmlEditorExampleApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'برنامج الطباعة',
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      home: HtmlEditorExample(title: 'برنامج الطابعة'),
    );
  }
}

class HtmlEditorExample extends StatefulWidget {
  HtmlEditorExample({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HtmlEditorExampleState createState() => _HtmlEditorExampleState();
}

class _HtmlEditorExampleState extends State<HtmlEditorExample> {
  String result = '';
  final HtmlEditorController controller = HtmlEditorController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!kIsWeb) {
          controller.clearFocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                if (kIsWeb) {controller.reloadWeb();}
                else {controller.editorController!.reload();}
              },
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () async {
             await controller.getText().then((value) {
               result = value.replaceAll('<p>', '\n');
                result = result.replaceAll('</p>', '\n');
             });
            Navigator.push(context, MaterialPageRoute( builder: (context) => ScreenShotTextScreen(text: result)));
          } ,
          backgroundColor: Colors.blue ,
          child: const Icon(Icons.bluetooth , color: Colors.white , )
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: HtmlEditor(
                  controller: controller,
                  htmlEditorOptions: const HtmlEditorOptions(
                    shouldEnsureVisible: true,
                  ),
                  htmlToolbarOptions: HtmlToolbarOptions(
                    toolbarPosition: ToolbarPosition.aboveEditor,
                    toolbarType: ToolbarType.nativeGrid,
                    onButtonPressed: (ButtonType type, bool? status, Function? updateStatus) {
                      
                      return true;
                    },
                    onDropdownChanged: (DropdownType type, dynamic changed, Function(dynamic)? updateSelectedItem) {
                      
                      return true;
                    },
                    mediaLinkInsertInterceptor: (String url, InsertFileType type) {
                      
                      return true;
                    },
                    mediaUploadInterceptor: (PlatformFile file, InsertFileType type) async {
                      print(file.name); //filename
                      print(file.size); //size in bytes
                      print(file.extension); //file extension (eg jpeg or mp4)
                      return true;
                    },
                  ),
                  callbacks: Callbacks(
                    onBeforeCommand: (String? currentHtml) {
                      print('html before change is $currentHtml');
                    },
                    onChangeContent: (String? changed) {
                      print('content changed to $changed');
                    },
                    onChangeCodeview: (String? changed) {
                      print('code changed to $changed');
                    },
                    onChangeSelection: (EditorSettings settings) {
                      print('parent element is ${settings.parentElement}');
                      print('font name is ${settings.fontName}');
                    },
                    onDialogShown: () {
                      print('dialog shown');
                    },
                    onEnter: () {
                      print('enter/return pressed');
                    },
                    onFocus: () {
                      print('editor focused');
                    },
                    onBlur: () {
                      print('editor unfocused');
                    },
                    onBlurCodeview: () {
                      print('code view either focused or unfocused');
                    },
                    onInit: () {
                      print('init');
                    },

                    //this is commented because it overrides the default Summernote handlers
                    /*
                      onImageLinkInsert: (String? url) {
                        print(url ?? "unknown url");
                      },
                      onImageUpload: (FileUpload file) async {
                        print(file.name);
                        print(file.size);
                        print(file.type);
                        print(file.base64);
                      },
                    */

                    onImageUploadError: (FileUpload? file, String? base64Str, UploadError error) {
                       
                      
                      if (file != null) {
                        
                      }
                    },
                    onKeyDown: (int? keyCode) {
                      
                    },
                    onKeyUp: (int? keyCode) {
                      
                    },
                    onMouseDown: () {
                      
                    },
                    onMouseUp: () {
                     
                    },
                    onNavigationRequestMobile: (String url) {
                      
                      return NavigationActionPolicy.ALLOW;
                    },
                    onPaste: () {
                      
                    },
                    onScroll: () {
                      
                    },
                  ),
                  plugins: [
                    SummernoteAtMention(
                      getSuggestionsMobile: (String value) {
                        var mentions = <String>['test1', 'test2', 'test3'];
                        return mentions.where((element) => element.contains(value)).toList();
                      },
                      mentionsWeb: ['test1', 'test2', 'test3'],
                      onSelect: (String value) {
                      
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  fixedSize: const Size(double.maxFinite, 50),
                ),
                onPressed: () async {
                  result = await controller.getText();
                  await Printing.layoutPdf(
                    onLayout: (PdfPageFormat format) async => await Printing.convertHtml(
                      format: format,
                      html: '<html><body>$result</body></html>',
                    )
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.print, color: Colors.white),
                    SizedBox(width: 10),
                    Text('طباعة', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}