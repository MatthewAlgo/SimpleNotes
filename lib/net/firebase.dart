import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Adds a user to the database
Future<void> AddUserToDatabase(
    String? email, String? uid, bool? emailVerified) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  DocumentReference reference =
      FirebaseFirestore.instance.doc("users/${email!}");

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    // Add a new user to the database

    return users
        .doc(email)
        .set({
          'email': email, // John Doe
          'uid': uid, // Stokes and Sons
          'emailVerified': emailVerified, // check if the user is verified
          'notes': [], // empty array of notes
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  return addUser();
}

// Update the user
Future<void> updateUser(String? email, String? uid, bool? emailVerified) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  DocumentReference user = users.doc(email);
  Future<void> updateUser() {
    // Call the user's CollectionReference to add a new user
    return user
        .update({
          'email': email, // John Doe
          'uid': uid, // Stokes and Sons
          'emailVerified': emailVerified, // check if the user is verified
        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  return updateUser();
}

// Read data from the database
Future<Iterable<Map<String, dynamic>>> getData() async {
  // Get docs from collection reference
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('users').get();

  // Get data from docs and convert map to List
  final allData = querySnapshot.docs.map((doc) => {
        'email': doc['email'],
        'uid': doc['uid'],
        'emailVerified': doc['emailVerified'],
      }); // An iterable of optional objects

  for (final user in allData) {
    // Show the key and value for each user
    for (int i = 0; i < user.length; i++) {
      // print('${user.keys.elementAt(i)}: ${user.values.elementAt(i)}'); // To get user key value pairs
    }
  }
  return allData;
}

// Function to get a user's notes
Future<Iterable<Map<String, dynamic>>> getUserNotes(String? email) async {
  // Get docs from collection reference
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(email)
      .collection('notes')
      .get();
  // Get data from docs and convert map to List
  final allData = querySnapshot.docs.map((doc) => {
        'title': doc['title'],
        'content': doc['content'],
      }); // An iterable of optional objects
  return allData;
}

// Add a note to the database
Future<void> addNote(String? email, String? title, String? content) async {
  CollectionReference notes = FirebaseFirestore.instance.collection('users');
  Future<void> addNote() {
    // Call the user's CollectionReference to add a new user
    // Add a document with the title of title
    return notes
        .doc(email)
        .collection('notes')
        .doc(title)
        .set({
          'title': title, // John Doe
          'content': content, // Stokes and Sons
        })
        .then((value) => print("Note Added"))
        .catchError((error) => print("Failed to add note: $error"));
  }

  return addNote();
}

// Remove a note from the database
Future<void> removeNote(String? email, String? title) async {
  CollectionReference notes = FirebaseFirestore.instance.collection('users');
  DocumentReference reference =
      FirebaseFirestore.instance.doc("users/${email!}/notes/${title!}");
  Future<void> removeNote() {
    // Call the user's CollectionReference to add a new user
    return notes
        .doc(email)
        .collection('notes')
        .doc(title)
        .delete()
        .then((value) => print("Note Removed"))
        .catchError((error) => print("Failed to remove note: $error"));
  }

  return removeNote();
}

// Remove a user from the database
Future<void> removeUser(String? email) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  DocumentReference user = users.doc(email);
  Future<void> removeUser() {
    // Call the user's CollectionReference to add a new user
    return user
        .delete()
        .then((value) => print("User Removed"))
        .catchError((error) => print("Failed to remove user: $error"));
  }

  return removeUser();
}

// Log out the user
Future<void> logOutUser() async {
  FirebaseAuth.instance.signOut();
}
