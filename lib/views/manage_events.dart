import 'package:appwrite/models.dart';
import 'package:event_planner_app/controllers/database_logic.dart';
import 'package:event_planner_app/views/edit_event_page.dart';
import 'package:event_planner_app/views/event_page.dart';
import 'package:flutter/material.dart';

class ManageEvents extends StatefulWidget {
  const ManageEvents({super.key});

  @override
  State<ManageEvents> createState() => _ManageEventsState();
}

class _ManageEventsState extends State<ManageEvents> {
  bool isLoading = true;
  List<Document> userEvents = [];
  @override
  void initState() {
    manageEvent().then((value) => setState(() {
          userEvents = value;
          isLoading = false;
        }));

    super.initState();
  }

  void refresh() {
    setState(() {
      isLoading = true;
    });
    manageEvent().then((value) => setState(() {
          userEvents = value;
          isLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Events"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userEvents.isEmpty
              ? const Center(
                  child: Text("You have not created any events",
                      style: TextStyle(color: Colors.white)),
                )
              : ListView.builder(
                  itemCount: userEvents.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EventPage(data: userEvents[index]))),
                        textColor: Colors.white,
                        iconColor: const Color.fromARGB(255, 218, 255, 123),
                        title: Text(
                          userEvents[index].data["name"],
                        ),
                        subtitle: Text(
                            "${userEvents[index].data["participants"].length} Participants"),
                        trailing: IconButton(
                            onPressed: () async {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditEvent(
                                            eventId: userEvents[index].$id,
                                            name:
                                                userEvents[index].data["name"],
                                            desc: userEvents[index]
                                                .data["description"],
                                            image:
                                                userEvents[index].data["image"],
                                            location: userEvents[index]
                                                .data["location"],
                                            dateTime: userEvents[index]
                                                .data["date_time"],
                                            guests: userEvents[index]
                                                .data["guests"],
                                            sponsers: userEvents[index]
                                                .data["sponsers"],
                                            inPerson: userEvents[index]
                                                .data["inPerson"],
                                            documentId: userEvents[index].$id,
                                          )));
                              refresh();
                            },
                            icon: const Icon(
                              Icons.mode_edit,
                              size: 30,
                            )),
                      ),
                    );
                  },
                ),
    );
  }
}
