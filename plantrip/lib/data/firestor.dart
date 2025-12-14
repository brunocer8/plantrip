import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_to_do_list/model/notes_model.dart';
import 'package:uuid/uuid.dart';

class Firestore_Datasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> CreateUser(String email) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set({
        'id': _auth.currentUser!.uid,
        'email': email,
      });
      return true;
    } catch (e) {
      print(e);
      return true;
    }
  }

  Future<bool> AddNote(
    String subtitle,
    String title,
    String? imagePath,
    List<String> tasks,
    List<bool> tasksStatus, {
    DateTime? travelDateTime,
  }) async {
    try {
      final uuid = const Uuid().v4();
      final data = DateTime.now();

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .set({
        'id': uuid,
        'subtitle': subtitle,
        'isDon': false,
        'imagePath': imagePath,
        'time': '${data.hour}:${data.minute}',
        'title': title,
        'tasks': tasks,
        'tasksStatus': tasksStatus,
        'travelDateTime': travelDateTime == null
            ? null
            : Timestamp.fromDate(travelDateTime),
      });

      return true;
    } catch (e) {
      print(e);
      return true;
    }
  }

  List<Note> getNotes(AsyncSnapshot snapshot) {
    try {
      final notesList = snapshot.data!.docs.map<Note>((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return Note(
          data['id'],
          data['subtitle'],
          data['time'],
          data['imagePath'],
          data['title'],
          data['isDon'],
          data['tasks'] == null ? [] : List<String>.from(data['tasks']),
          data['tasksStatus'] == null
              ? []
              : List<bool>.from(data['tasksStatus']),
          data['travelDateTime'] == null
              ? null
              : (data['travelDateTime'] as Timestamp).toDate(),
        );
      }).toList();

      return notesList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Stream<QuerySnapshot> stream(bool isDone) {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('notes')
        .where('isDon', isEqualTo: isDone)
        .snapshots();
  }

  Future<bool> isdone(String uuid, bool isDon) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .update({'isDon': isDon});
      return true;
    } catch (e) {
      print(e);
      return true;
    }
  }

  Future<bool> Update_Note(
    String uuid,
    String? imagePath,
    String title,
    String subtitle,
    List<String> tasks,
    List<bool> tasksStatus, {
    DateTime? travelDateTime,
  }) async {
    try {
      final data = DateTime.now();

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .update({
        'time': '${data.hour}:${data.minute}',
        'subtitle': subtitle,
        'title': title,
        'imagePath': imagePath,
        'tasks': tasks,
        'tasksStatus': tasksStatus,
        'travelDateTime': travelDateTime == null
            ? null
            : Timestamp.fromDate(travelDateTime),
      });

      return true;
    } catch (e) {
      print(e);
      return true;
    }
  }

  Future<bool> delet_note(String uuid) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .delete();
      return true;
    } catch (e) {
      print(e);
      return true;
    }
  }
}
