import 'package:appwrite/models.dart';
import 'package:event_planner_app/controllers/database_logic.dart';
import 'package:event_planner_app/controllers/saved_data.dart';
import 'package:flutter/material.dart';

class RSVPEvents extends StatefulWidget {
  const RSVPEvents({super.key});

  @override
  State<RSVPEvents> createState() => _RSVPEventsState();
}

class _RSVPEventsState extends State<RSVPEvents> {
  List<Document> events = [];
  List<Document> userEvents = [];
  bool isLoading = true;

  @override
  void initState() {
    String userId = SavedData.getUserId();
    getAllEvents().then((value) {
      events = value;
      print("Events: ${events.length}");
      for (var event in events) {
        List<dynamic> participants = event.data['participants'];

        if (participants.contains(userId)) {
          userEvents.add(event);
        }
        setState(() {
          isLoading = false;
        });
      }
      print(userEvents.length);
    });

    super.initState();
  }

  void getEvents() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("RSVP Events")),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : userEvents.isEmpty
              ? const Center(
                  child: Text("You have not participated in any events",
                      style: TextStyle(color: Colors.white)),
                )
              : ListView.builder(
                  itemCount: userEvents.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        textColor: Colors.white,
                        title: Text(userEvents[index].data['name']),
                        subtitle: Text(userEvents[index].data['location']),
                        trailing: const Icon(
                          Icons.check_circle,
                          color: Color.fromARGB(255, 218, 255, 123),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
