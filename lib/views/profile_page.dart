import 'package:event_planner_app/controllers/auth.dart';
import 'package:event_planner_app/views/check_session.dart';
import 'package:event_planner_app/views/manage_events.dart';
import 'package:event_planner_app/views/rsvp_event.dart';
import 'package:flutter/material.dart';

import '../controllers/saved_data.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "";
  String email = "";
  @override
  void initState() {
    name = SavedData.getUserName();
    email = SavedData.getUserEmail();
    print(SavedData.getUserId());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 218, 255, 123)),
                ),
                Text(
                  email,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 218, 255, 123)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RSVPEvents())),
                    title: const Text(
                      "RSVP Events",
                      style:
                          TextStyle(color: Color.fromARGB(255, 218, 255, 123)),
                    ),
                  ),
                  ListTile(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ManageEvents())),
                      title: const Text("Manage Events",
                          style: TextStyle(
                              color: Color.fromARGB(255, 218, 255, 123)))),
                  ListTile(
                      onTap: () {
                        logoutUser();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CheckSession()));
                      },
                      title: const Text("Logout",
                          style: TextStyle(
                              color: Color.fromARGB(255, 218, 255, 123)))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
