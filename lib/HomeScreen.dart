import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:writeblog/Services/crud.dart';
import 'package:writeblog/constraints.dart';

class HomeScreen extends StatefulWidget {
  final void Function(bool) updateIconBool;
  const HomeScreen({Key? key, required this.updateIconBool}) : super(key: key);
  

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CrudOPs ops = new CrudOPs();
  QuerySnapshot? blogssnapshot;
  Widget My_Blogs() {
    return Container(
      child: SingleChildScrollView(
        child: Column(children: [
          blogssnapshot == null
              ? Container(
                  child: CircularProgressIndicator(),
                  alignment: Alignment.center,
                )
              : Container(
                  height: MediaQuery.of(context).size.height - 200,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    shrinkWrap: true,
                    itemCount: blogssnapshot!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final doc = blogssnapshot!.docs[index];
                      //print(doc.data());
                      return BlogsTile(
                        img: doc.get('image_url'),
                        title: doc.get('title'),
                        desc: doc.get('description'),
                        author: doc.get('author'),
                      );
                    },
                  ),
                ),
        ]),
      ),
    );
  }

  void initState() {
    super.initState();
    ops.getData().then((res) {
      setState(() {
        blogssnapshot = res;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          IconButton(
              onPressed: () {
                 widget.updateIconBool(!iconBool);
                // setState(() {
                //   iconBool = !iconBool;
                // });
              },
              icon: Icon(iconBool ? iconDark : iconLight))
        ],
      ),
      body: My_Blogs(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/create');
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: Icon(Icons.add),
      ),
    );
  }
}

class BlogsTile extends StatelessWidget {
  String img, title, desc, author;
  BlogsTile(
      {required this.img,
      required this.title,
      required this.desc,
      required this.author});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 10, top: 3),
        child: Stack(
          children: [
            ClipRRect(
                child: Image.network(
                  img,
                  fit: BoxFit.cover,
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                ),
                borderRadius: BorderRadius.circular(6)),
            Container(
              height: 150,
              decoration: BoxDecoration(
                  color: Colors.black45.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6)),
            ),
            Container(
                child: Center(
              child: Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(author,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )),
                  Text(desc,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ))
                ],
              ),
            ))
          ],
        ));
  }
}
