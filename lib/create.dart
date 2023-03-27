import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:writeblog/Services/crud.dart';
import 'package:image_picker/image_picker.dart';

class CreateBlog extends StatefulWidget {
  const CreateBlog({Key? key}) : super(key: key);

  @override
  State<CreateBlog> createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  late String author, title, descp;
  CrudOPs crudops = new CrudOPs();
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  uploadBlog() async {
    if (_image != null) {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageRef =
          storage.ref().child("blogImages").child("${randomAlphaNumeric(9)}");
      final UploadTask uploadTask = storageRef.putFile(_image!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
        print('Upload image completed');
      }).catchError((e) {
        print('Upload task failed: ');
      });
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      Map<String, String> dataMap = {
        "image_url": downloadUrl,
        "author": author,
        "title": title,
        "description": descp,
      };
      crudops.addData(dataMap).then((res) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Data uploaded successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error while uploading data!"),
          backgroundColor: Colors.red,
        ),
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('please check your Data fields'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Color.fromARGB(224, 10, 0, 0),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "WriteYour",
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 23),
            ),
            Text(
              "Blog",
              style: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontSize: 27,
                  color: Colors.teal),
            )
          ],
        ),
        actions: [
          
        ],
      ),
      body: ListView(children: [
        Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => {getImage()},
                  child: _image == null
                      ? Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: Icon(Icons.add_a_photo_rounded),
                          color: Color.fromARGB(255, 192, 224, 240),
                        )
                      : Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: _image != null
                              ? Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                )
                              : Container(),
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Author'),
                  onChanged: (val) {
                    author = val;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Title'),
                  onChanged: (val) {
                    title = val;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Description'),
                  onChanged: (val) {
                    descp = val;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    uploadBlog();
                  },
                  child: Text("Upload", style: TextStyle(fontSize: 18.0)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 50),
                  ),
                ),
              ],
            )),
      ]),
    );
  }
}
