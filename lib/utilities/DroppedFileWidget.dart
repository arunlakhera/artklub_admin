import 'package:artklub_admin/model/DroppedFile.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:flutter/material.dart';

class DroppedFileWidget extends StatelessWidget {

  final DroppedFile? fileName;
  const DroppedFileWidget({Key? key, required this.fileName}) : super(key: key);

  @override
  Widget build(BuildContext context) => buildImage();

  Widget buildImage(){

    if(fileName == null) return buildEmptyFile('No Image');

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Image.network(
        fileName!.url,
        width: 120,
        height: 120,
        fit: BoxFit.fill,
        errorBuilder: (context, _error, _) => buildEmptyFile('No Preview'),
      ),
    );
  }

  Widget buildEmptyFile(String text) => Container(
    width: 120,
    height: 120,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      text,
      style: AppStyles.tableBodyStyle,
    ),
  );
}
