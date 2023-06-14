import 'package:appwrite/models.dart';
import 'package:event_planner_app/containers/format_datetime.dart';
import 'package:event_planner_app/controllers/database_logic.dart';
import 'package:event_planner_app/controllers/saved_data.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class EventPage extends StatefulWidget {
  final Document data;
  const EventPage({super.key, required this.data});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  bool isUserRSVP = false;
  String id = "";
  bool isUserPresent(List<dynamic> participants, String userId) {
    return participants.contains(userId);
  }

  @override
  void initState() {
    id = SavedData.getUserId();
    isUserRSVP = isUserPresent(widget.data.data["participants"], id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(children: [
          Stack(children: [
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.green,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
                child: Image.network(
                  "https://cloud.appwrite.io/v1/storage/buckets/6487074849d89dcf51ac/files/${widget.data.data["image"]}/view?project=6486f854bd95ae96b223&mode=admin",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
                top: 25,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () => Navigator.pop(context),
                )),
            Positioned(
              bottom: 45,
              left: 8,
              child: Row(
                children: [
                  const Icon(Icons.calendar_month_outlined, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    " ${formatDate(widget.data.data["date_time"])}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Icon(Icons.access_time_rounded, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    " ${formatTime(widget.data.data["date_time"])}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: 20,
                left: 8,
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      widget.data.data["location"],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ))
          ]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        widget.data.data["name"],
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Share.share(
                              "Hey! I am inviting you to ${widget.data.data["name"]} on ${formatDate(widget.data.data["date_time"])} at ${formatTime(widget.data.data["date_time"])} at ${widget.data.data["location"]}. RSVP the event on Event Planner App.",
                              subject: 'Look what I made!');
                        },
                        icon: const Icon(
                          Icons.share,
                          color: Colors.white,
                          size: 30,
                        ))
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.data.data["description"],
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                    "${widget.data.data["participants"].length} people are attending.",
                    style: const TextStyle(
                        color: Color.fromARGB(255, 218, 255, 123),
                        fontSize: 16,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 16),
                const Text("Special Guests",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  widget.data.data["guests"],
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text("Sponsors",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                  widget.data.data["sponsers"],
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text("More Info",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                const SizedBox(height: 8),
                Text(
                    "Event Type : ${widget.data.data["inPerson"] == true ? "In Person" : "Virtual"}",
                    style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 8),
                Text("Time : ${formatTime(widget.data.data["date_time"])}",
                    style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 8),
                Text("Location : ${widget.data.data["location"]}",
                    style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                    onPressed: () {
                      _launchUrl(
                          "https://www.google.com/maps/search/?api=1&query=${widget.data.data["location"]}");
                    },
                    icon: const Icon(Icons.map),
                    label: const Text("Open in Google Maps")),
                const SizedBox(height: 16),
                isUserRSVP
                    ? SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: MaterialButton(
                          onPressed: () {},
                          color: const Color.fromARGB(255, 218, 255, 123),
                          child: const Text("Attending Event",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900)),
                        ),
                      )
                    : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: MaterialButton(
                          onPressed: () {
                            rsvpEvent(id, widget.data.data["participants"],
                                    widget.data.$id)
                                .then((value) {
                              if (value) {
                                setState(() {
                                  isUserRSVP = true;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('RSVP Successful'),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('RSVP Failed'),
                                  ),
                                );
                              }
                            });
                          },
                          color: const Color.fromARGB(255, 218, 255, 123),
                          child: const Text("RSVP Event",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900)),
                        ),
                      ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch $url');
  }
}
