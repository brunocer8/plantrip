import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import '../model/notes_model.dart';
import 'package:uuid/uuid.dart';


class FirestoreDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<bool> createUser(String email) async {
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
      debugPrint('CreateUser error: $e');
      return false;
    }
  }


  Future<bool> addNote(
    String subtitle,
    String title,
    String? imagePath,
    List<String> tasks,
    List<bool> tasksStatus, {
    DateTime? travelDateTime,
  }) async {
    try {
      final uuid = const Uuid().v4();
      final now = DateTime.now();


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
        'time': '${now.hour}:${now.minute.toString().padLeft(2, '0')}',
        'title': title,
        'tasks': tasks,
        'tasksStatus': tasksStatus,
        'travelDateTime': travelDateTime == null
            ? null
            : Timestamp.fromDate(travelDateTime),
      });


      return true;
    } catch (e) {
      debugPrint('AddNote error: $e');
      return false;
    }
  }


  List<Note> getNotes(AsyncSnapshot snapshot) {
    try {
      final notesList = snapshot.data!.docs.map<Note>((doc) {
        final data = doc.data() as Map<String, dynamic>;


        return Note(
          data['id'] as String,
          data['subtitle'] as String? ?? '',
          data['time'] as String? ?? '',
          data['imagePath'] as String?,
          data['title'] as String? ?? '',
          data['isDon'] as bool? ?? false,
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
      debugPrint('getNotes error: $e');
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
      debugPrint('isdone error: $e');
      return false;
    }
  }


  Future<bool> updateNote(
    String uuid,
    String? imagePath,
    String title,
    String subtitle,
    List<String> tasks,
    List<bool> tasksStatus, {
    DateTime? travelDateTime,
  }) async {
    try {
      final now = DateTime.now();


      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .update({
        'time': '${now.hour}:${now.minute.toString().padLeft(2, '0')}',
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
      debugPrint('Update_Note error: $e');
      return false;
    }
  }


  Future<bool> deletNote(String uuid) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .delete();
      return true;
    } catch (e) {
      debugPrint('delet_note error: $e');
      return false;
    }
  }
}