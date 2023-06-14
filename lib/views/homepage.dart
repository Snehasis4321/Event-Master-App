// ignore_for_file: avoid_print

import 'dart:math';

import 'package:appwrite/models.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:event_planner_app/containers/event_container.dart';
import 'package:event_planner_app/containers/popular_item.dart';
import 'package:event_planner_app/controllers/database_logic.dart';
import 'package:event_planner_app/controllers/saved_data.dart';
import 'package:event_planner_app/views/create_event_page.dart';
import 'package:event_planner_app/views/profile_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = "User";
  List<Document> events = [];
  int randomIndex = 0;
  bool isExploreOff = true;
  bool isLoading = true;

  @override
  void initState() {
    name = SavedData.getUserName().split(" ")[0];
    getAllEvents().then((value) {
      events = value;
      events.sort((a, b) => b.data['participants'].length
          .compareTo(a.data['participants'].length));
      randomIndex = Random().nextInt(events.length);
      print(randomIndex);
      setState(() {
        isLoading = false;
      });
    });
    print("Events: ${events.length}");
    super.initState();
  }

  void refresh() {
    setState(() {
      isLoading = true;
    });

    getAllEvents().then((value) {
      events = value;
      events.sort((a, b) => b.data['participants'].length
          .compareTo(a.data['participants'].length));
      setState(() {
        isLoading = false;
      });
    });
  }

  List<Document> sortevents() {
    events.sort((a, b) =>
        b.data['participants'].length.compareTo(a.data['participants'].length));
    return events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()));
                refresh();
              },
              icon: const Icon(
                Icons.account_circle,
                size: 30,
                color: Color.fromARGB(255, 218, 255, 123),
              ))
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi $name  👋",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 218, 255, 123),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Explore various events around you. ",
                        style: TextStyle(
                          color: Color.fromARGB(255, 218, 255, 123),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                isLoading
                    ? const SizedBox()
                    : CarouselSlider(
                        options: CarouselOptions(
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 5),
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.95,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                        ),
                        items: [
                          ...List.generate(4, (index) {
                            int eventIndex =
                                (randomIndex + index) % events.length;
                            return EventContainer(
                              data: events[eventIndex],
                            );
                          }),
                        ],
                      ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Popular Events ",
                    style: TextStyle(
                      color: Color.fromARGB(255, 218, 255, 123),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                color: const Color(0xFF2E2E2E),
                child: isLoading
                    ? const SizedBox()
                    : Column(
                        children: [
                          for (int i = 0; i < events.length && i < 5; i++) ...[
                            PopularItem(
                              eventData: events[i],
                              index: i + 1,
                            ),
                            const Divider(),
                          ],
                        ],
                      ),
              )
            ]),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "All Events ",
                  style: TextStyle(
                    color: Color.fromARGB(255, 218, 255, 123),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              isLoading
                  ? const SizedBox()
                  : Column(
                      children: [
                        for (int i = events.length - 1;
                            i >= (isExploreOff ? events.length - 3 : 0);
                            i--) ...[
                          EventContainer(
                            data: events[i],
                          ),
                        ],
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isExploreOff = !isExploreOff;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              isExploreOff
                                  ? "Expore more events"
                                  : "Show less events",
                              style: const TextStyle(
                                color: Color.fromARGB(255, 218, 255, 123),
                                // fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 218, 255, 123),
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreateEvent()));
          refresh();
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
