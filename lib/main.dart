import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_troubleshooting/models/class1.dart';
import 'package:firestore_troubleshooting/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'models/class2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AuthService().getOrCreateUser();
  runApp(const MyApp());
}

late var class1Data;
late var class2Data;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: Colors.grey[800],
        textTheme: Theme.of(context)
            .textTheme
            .apply(bodyColor: Colors.white, displayColor: Colors.white),
        splashColor: Colors.grey[800],
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Firestore Troubleshooting'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textController1 = TextEditingController();
  final Stream<QuerySnapshot> class1Stream = FirebaseFirestore.instance
      .collection('users')
      .doc(AuthService().currentUser?.uid)
      .collection('Class 1 Objects')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(children: [
              Expanded(
                child: TextField(
                  controller: textController1,
                ),
              ),
              Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        createClass1Object(textController1.text);
                        textController1.clear();
                        setState(() {});
                      },
                      child: Text('Add Object')))
            ]),
            StreamBuilder(
                stream: class1Stream,
                builder: (context, class1Snapshot) {
                  if (class1Snapshot.hasError) {
                    return Text('client snapshot has error');
                  }
                  if (class1Snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  class1Data = class1Snapshot.requireData;
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: class1Data.size,
                      itemBuilder: (context, class1_index) {
                        final Stream<QuerySnapshot> class2Stream =
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(AuthService().currentUser?.uid)
                                .collection('Class 1 Objects')
                                .doc(class1Data.docs[class1_index]['docID'])
                                .collection('Class 2 Objects')
                                .snapshots();
                        return class1Data.size > 0
                            ? ExpansionTile(
                                initiallyExpanded: true,
                                title:
                                    Text(class1Data.docs[class1_index]['name']),
                                children: [
                                  Row(children: [
                                    Expanded(
                                      child: TextField(
                                        controller: textController1,
                                      ),
                                    ),
                                    Expanded(
                                        child: ElevatedButton(
                                            onPressed: () {
                                              createClass2Object(
                                                  textController1.text,
                                                  class1_index);
                                              textController1.clear();
                                              setState(() {});
                                            },
                                            child: Text('Add Object')))
                                  ]),
                                  StreamBuilder(
                                      stream: class2Stream,
                                      builder: (context, class2Snapshot) {
                                        if (class2Snapshot.hasError) {
                                          return Text(
                                              'client snapshot has error');
                                        }
                                        if (class2Snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        }
                                        class2Data = class2Snapshot.requireData;
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: class2Data.size,
                                            itemBuilder:
                                                (context, class2_index) {
                                              return ExpansionTile(
                                                initiallyExpanded: false,
                                                title: Text('expansion tile 2'),
                                                children: [
                                                  ListView.builder(
                                                      shrinkWrap: true,
                                                      itemBuilder:
                                                          (context, index3) {
                                                        return ListTile(
                                                          title:
                                                              Text('List tile'),
                                                        );
                                                      })
                                                ],
                                              );
                                            });
                                      })
                                ],
                              )
                            : Text('no data');
                      });
                }),
            ElevatedButton(
                onPressed: () {
                  setState(() {});
                },
                child: Text('Set State'))
          ],
        ),
      ),
    );
  }
}

void createDocument() {}
