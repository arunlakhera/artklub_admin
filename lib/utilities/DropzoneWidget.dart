import 'package:artklub_admin/model/DroppedFile.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

class DropzoneWidget extends StatefulWidget {

  final ValueChanged<DroppedFile> onDroppedFile;

  const DropzoneWidget({Key? key, required this.onDroppedFile}) : super(key: key);

  @override
  _DropzoneWidgetState createState() => _DropzoneWidgetState();
}

class _DropzoneWidgetState extends State<DropzoneWidget> {

  late DropzoneViewController controller;
  bool isHighlighted = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.blue : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(10),
        strokeWidth: 1,
        dashPattern: [8,4],
        color: isHighlighted ? Colors.blue.shade900 : Colors.green.shade900,
        padding: EdgeInsets.zero,
        child: Stack(
          children: [
            DropzoneView(
              onCreated: (controller) => this.controller = controller,
              onHover: () => setState(() {
                isHighlighted = true;
              }),
              onLeave: () => setState(() {
                isHighlighted = false;
              }),
              onDrop: acceptFile,
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload,
                    color: isHighlighted ? Colors.blue.shade900 :Colors.green,
                    size: 80,
                  ),
                  Text(
                    'Drag & Drop Photo here.',
                    style: AppStyles().getTitleStyle(
                      titleWeight: FontWeight.bold,
                      titleSize: 14,
                      titleColor: isHighlighted ? Colors.white : Colors.grey.shade700,
                    ),
                  ),

                  SizedBox(height: 10),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: isHighlighted ? Colors.blue.shade300 : Colors.green.shade300,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      shape: RoundedRectangleBorder(),
                    ),
                    onPressed: () async{
                      final events = await controller.pickFiles();

                      if(events.isEmpty) return;

                      acceptFile(events.first);
                    },
                    icon: Icon(Icons.search, size: 25,),
                    label: Text(
                      'Choose Photo',
                      style: AppStyles().getTitleStyle(
                        titleWeight: FontWeight.bold,
                        titleSize: 14,
                        titleColor: Colors.white,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future acceptFile(dynamic event) async{

    final fileName = event.name;
    final mime = await controller.getFileMIME(event);
    final bytes = await controller.getFileSize(event);
    final url = await controller.createFileUrl(event);
    final fileData = await controller.getFileData(event);

    print('Name: $fileName');
    print('Mime: $mime');
    print('Bytes: $bytes');
    print('Url: $url');

    final droppedFile = DroppedFile(
      url: url,
      fileName: fileName,
      mime: mime,
      bytes: bytes,
      fileData: fileData,
    );

    widget.onDroppedFile(droppedFile);
    setState(() => isHighlighted = false);

  }
}
