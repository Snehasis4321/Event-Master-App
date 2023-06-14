import 'package:appwrite/appwrite.dart';
import 'package:event_planner_app/controllers/database_logic.dart';
import 'package:event_planner_app/controllers/saved_data.dart';

Client client = Client()
    .setEndpoint('https://cloud.appwrite.io/v1')
    .setProject('6486f854bd95ae96b223')
    .setSelfSigned(
        status: true); // For self signed certificates, only use for development

// create an user account instance
Account account = Account(client);

// Registering the User (Sign Up)
Future<String> createUser(String name, String email, String password) async {
  try {
    final user = await account.create(
        userId: ID.unique(), email: email, password: password, name: name);
    print("New User created");
    saveProfileData(name, email, user.$id);
    return "success";
  } on AppwriteException catch (e) {
    return e.message.toString();
  }
}

// Login the user

Future loginUser(String email, String password) async {
  try {
    final user =
        await account.createEmailSession(email: email, password: password);
    SavedData.saveUserId(user.userId);
    getProfileData();
    print("User logged in");

    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

// Logout the user

Future logoutUser() async {
  await account.deleteSession(sessionId: 'current');
  print("User Logged out");
}

// check user active session available or not

Future checkUserSession() async {
  try {
    //check if session exist or not
    await account.getSession(sessionId: 'current');
    print(await account.getSession(sessionId: 'current'));
    // if exist return true
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}
