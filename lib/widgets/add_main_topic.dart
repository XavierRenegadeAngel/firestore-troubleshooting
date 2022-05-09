import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_troubleshooting/models/main_topic.dart';
import 'package:firestore_troubleshooting/services/auth_service.dart';
import 'package:flutter/material.dart';

class AddMainTopic extends StatelessWidget {
  AddMainTopic({Key? key}) : super(key: key);
  TextEditingController textController1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration.collapsed(

                hintText: 'Main topic name..',
                filled: true,
                border: UnderlineInputBorder(),
                hintStyle: Theme.of(context).textTheme.subtitle1),
            controller: textController1,
          ),
        ),
        const SizedBox(width: 8.0,),
        Expanded(
            child: ElevatedButton(
                onPressed: () {
                  createClass1Object(textController1.text);
                  textController1.clear();
                },
                child: const Text('Add main topic')))
      ],
    );
  }
}

Future createClass1Object(name) async {
  final class1_ref = FirebaseFirestore.instance
      .collection('users')
      .doc(AuthService().currentUser?.uid)
      .collection('Class 1 Objects')
      .doc();
  final class1Object = MainTopic(name: name, docID: class1_ref.id);
  final json = class1Object.toJson();
  await class1_ref.set(json);
}
