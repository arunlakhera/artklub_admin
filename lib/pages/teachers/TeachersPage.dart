import 'dart:html';

import 'package:artklub_admin/services/SideBarMenu.dart';
import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class TeachersPage extends StatefulWidget {
  const TeachersPage({Key? key}) : super(key: key);

  static const String id = 'teachers-page';

  @override
  State<TeachersPage> createState() => _TeachersPageState();
}

class _TeachersPageState extends State<TeachersPage> {

  final ScrollController _firstController = ScrollController();
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  String? imageURL;

  @override
  Widget build(BuildContext context) {
    SideBarWidget _sideBar = SideBarWidget();

    return AdminScaffold(
        backgroundColor: AppColors.colorBackground,
        appBar: AppBar(
          backgroundColor: AppColors.colorBlack,
          iconTheme: IconThemeData(color: AppColors.colorLightGreen),
          title: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.colorLightGreen,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              'Artklub Admin',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        sideBar: _sideBar.sideBarMenus(context, TeachersPage.id),
        body: SingleChildScrollView(
          controller: _firstController,
          child: Center(
            child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.colorBackground,
                borderRadius: BorderRadius.circular(30),
              ),
              child: FutureBuilder(
                future: _initialization,
                builder: (context, snapshot){
                  if(snapshot.hasError) {
                    return Center(child: Text('Error'),);
                  }

                  if(snapshot.connectionState == ConnectionState.done){
                    return Column(
                      children: [
                        imageURL == null ? Placeholder(
                          fallbackHeight: 400,
                          fallbackWidth: 200,
                        ): Image.network(imageURL!, fit: BoxFit.fill,),
                        SizedBox(height: 50),
                        ElevatedButton(
                          onPressed: (){
                            uploadStorage();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                          ),
                          child: Text('Upload'),
                        ),
                      ],
                    );
                  }

                  return Center(child: CircularProgressIndicator(),);
                },
              ),//Text('Teachers'),
            ),
          ),
        )
    );
  }

  uploadStorage(){

    FileUploadInputElement uploadInput = FileUploadInputElement()..accept = 'image/*';
    FirebaseStorage fs = FirebaseStorage.instance;
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      final file = uploadInput.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) async{
        var snapshot = await fs.ref().child('coordinator').putBlob(file);
        String downloadURL = await snapshot.ref.getDownloadURL();
        setState(() {
          imageURL = downloadURL;
        });
      });
    });


  }
}