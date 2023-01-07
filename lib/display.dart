import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Displaycreen extends StatefulWidget {
  const Displaycreen({super.key});

  @override
  State<Displaycreen> createState() => _DisplaycreenState();
}

class _DisplaycreenState extends State<Displaycreen> {
  String? name, id;
  List? imageList;
  Future getData() async {
    FirebaseFirestore.instance
        .collection('product')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        //  print(doc["first_name"]);

        setState(() {
          name = doc['name'];
          id = doc['id'];
          imageList = doc['image'];
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          child: GridView.builder(
            itemCount: imageList!.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
            itemBuilder: (context, index) {
              return Card(
                elevation: 10,
                child: Column(
                  children: [
                    Text('$name'),
                    Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              scale: 1.0,
                              fit: BoxFit.fill,
                              image: NetworkImage('${imageList![index]}')),
                          borderRadius: BorderRadius.circular(10)),
                    )
                  ],
                ),
              );
            },
          )),
    );
  }
}
