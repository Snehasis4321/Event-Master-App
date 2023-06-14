// ignore_for_file: avoid_print

import 'package:appwrite/appwrite.dart';
import 'package:event_planner_app/controllers/saved_data.dart';

import 'auth.dart';

String databaseId = "6486fb8ba23a54a56c21";

final Databases database = Databases(client);

// Save Profile Data for the user
Future<void> saveProfileData(String name, String email, String userId) async {
  return await database
      .createDocument(
        collectionId: "64870372489868698b05",
        data: {
          'name': name,
          'userId': userId,
          'email': email,
        },
        databaseId: databaseId,
        documentId: ID.unique(),
      )
      .then((value) => print("Save to Profile"))
      .catchError((error) => print('Failed to save profile: $error'));
}

// Get Profile Data for the user
Future getProfileData() async {
  final id = SavedData.getUserId();
  try {
    final data = await database.listDocuments(
        collectionId: "64870372489868698b05",
        databaseId: databaseId,
        queries: [Query.equal("userId", id)]);
    SavedData.saveUserName(data.documents[0].data['name']);
    SavedData.saveUserEmail(data.documents[0].data['email']);
    print("Profile Data Loaded");
  } catch (e) {
    print(e);
  }
}

// Create New Event

Future<void> createEvent(
  String? name,
  String description,
  String image,
  String location,
  String dateTime,
  String createdBy,
  bool? inPerson, {
  String? guests,
  String? sponsers,
}) async {
  return await database
      .createDocument(
        collectionId: "648703e226d9d5390ffc",
        data: {
          'name': name,
          'description': description,
          'image': image,
          'location': location,
          'date_time': dateTime,
          'createdBy': createdBy,
          'inPerson': inPerson,
          'guests': guests,
          'sponsers': sponsers,
        },
        databaseId: databaseId,
        documentId: ID.unique(),
      )
      .then((value) => print("Event Created"))
      .catchError((error) => print('Failed to create event: $error'));
}

// Get All Events
Future getAllEvents() async {
  try {
    final data = await database.listDocuments(
      collectionId: "648703e226d9d5390ffc",
      databaseId: databaseId,
    );
    print("Events Data Loaded");
    return data.documents;
  } catch (e) {
    print(e);
  }
}

// manage events created by user

Future manageEvent() async {
  final id = SavedData.getUserId();
  try {
    final data = await database.listDocuments(
      collectionId: "648703e226d9d5390ffc",
      databaseId: databaseId,
      queries: [Query.equal("createdBy", id)],
    );
    print("Events Data Loaded");
    return data.documents;
  } catch (e) {
    print(e);
  }
}

// edit event created by user

Future editEvent(
  String? name,
  String description,
  String image,
  String location,
  String dateTime,
  String createdBy,
  String documentId,
  bool? inPerson, {
  String? guests,
  String? sponsers,
}) async {
  try {
    await database.updateDocument(
      collectionId: "648703e226d9d5390ffc",
      databaseId: databaseId,
      documentId: documentId,
      data: {
        'name': name,
        'description': description,
        'image': image,
        'location': location,
        'date_time': dateTime,
        'createdBy': createdBy,
        'inPerson': inPerson,
        'guests': guests,
        'sponsers': sponsers,
      },
    );
  } catch (e) {
    print(e);
  }
}

// delete event created by user

Future deleteEvent(String id) async {
  try {
    final response = await database.deleteDocument(
      collectionId: "648703e226d9d5390ffc",
      databaseId: databaseId,
      documentId: id,
    );
    print(response);
  } catch (e) {
    print(e);
  }
}

// RSVP for an event

Future rsvpEvent(String id, List participants, String documentId) async {
  final userId = SavedData.getUserId();
  participants.add(userId);
  try {
    await database.updateDocument(
      collectionId: "648703e226d9d5390ffc",
      databaseId: databaseId,
      documentId: documentId,
      data: {
        "participants": participants,
      },
    );
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}
