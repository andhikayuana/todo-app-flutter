import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_flutter/models/todo.dart';

class Database {
  final FirebaseFirestore firestore;

  Database({this.firestore});

  /**
   * @param uid of user
   */
  Stream<List<Todo>> streamTodos({String uid}) {
    try {
      return firestore
          .collection("todos")
          .doc(uid)
          .collection("todos")
          .where("done", isEqualTo: false)
          .snapshots()
          .map((QuerySnapshot querySnapshot) {
        final List<Todo> retVal = <Todo>[];
        querySnapshot.docs.forEach((doc) {
          retVal.add(Todo.fromDocumentSnapshot(documentSnapshot: doc));
        });
        return retVal;
      });
    } catch (e) {
      rethrow;
    }
  }

  /**
   * @param uid of user
   * @param content of todo
   */
  Future<void> addTodo({String uid, String content}) async {
    try {
      firestore
          .collection("todos")
          .doc(uid)
          .collection("todos")
          .add({"content": content, "done": false});
    } catch (e) {
      rethrow;
    }
  }

  /**
   * @param uid of user
   * @param id of todo
   */
  Future<void> updateTodo({String uid, String id}) async {
    try {
      firestore
          .collection("todos")
          .doc(uid)
          .collection("todos")
          .doc(id)
          .update({
        "done": true,
      });
    } catch (e) {
      rethrow;
    }
  }
}
