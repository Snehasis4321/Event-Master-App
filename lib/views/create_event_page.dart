// ignore_for_file: unused_field, use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:event_planner_app/containers/custom_input_form.dart';
import 'package:event_planner_app/controllers/auth.dart';
import 'package:event_planner_app/controllers/database_logic.dart';
import 'package:event_planner_app/controllers/saved_data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _locController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _guestController = TextEditingController();
  final TextEditingController _sponserController = TextEditingController();

  bool _isInPersonEvent = true;
  FilePickerResult? _filePickerResult;
  bool _uploading = false;
  String id = "";

  Storage storage = Storage(client);

  @override
  void initState() {
    id = SavedData.getUserId();
    super.initState();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDateTime != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime selectedDateTime = DateTime(
          pickedDateTime.year,
          pickedDateTime.month,
          pickedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          _dateTimeController.text = selectedDateTime.toString();
        });
      }
    }
  }

  Future uploadEventPic() async {
    setState(() {
      _uploading = true;
    });

    try {
      if (_filePickerResult != null) {
        PlatformFile file = _filePickerResult!.files.first;
        final fileBytes = await File(file.path!).readAsBytes();
        final inputFile = InputFile.fromBytes(
          bytes: fileBytes,
          filename: file.name,
          contentType: 'image/jpeg', // Adjust the content type as per your file
        );

        final response = await storage.createFile(
          bucketId: '6487074849d89dcf51ac',
          fileId: ID.unique(),
          file: inputFile,
        );

        print(response.$id);
        return response.$id;
      } else {
        // User canceled the file picker
        print('File picker canceled');
      }
    } catch (e) {
      print('Error while uploading the profile picture: $e');
    } finally {
      setState(() {
        _uploading = false;
      });
    }
  }

  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    setState(() {
      _filePickerResult = result;
    });
  }

  @override
  void dispose() {
    _dateTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 8.0, right: 8.0, top: 32, bottom: 8),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Create Event",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Color.fromARGB(255, 218, 255, 123)),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                _openFilePicker();
              },
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 218, 255, 123),
                      borderRadius: BorderRadius.circular(8)),
                  child: _filePickerResult != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image(
                            image: FileImage(
                                File(_filePickerResult!.files.first.path!)),
                            fit: BoxFit.fill,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.add_a_photo,
                              size: 42,
                              color: Colors.black,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Add Event Image",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            CustomInputForm(
              controller: _nameController,
              label: "Event Name",
              icon: Icons.event_outlined,
              hint: "Add Event Name",
            ),
            const SizedBox(height: 8),
            CustomInputForm(
              controller: _descController,
              maxLines: 5,
              label: "Description",
              icon: Icons.description_outlined,
              hint: "",
            ),
            const SizedBox(height: 8),
            CustomInputForm(
              controller: _locController,
              label: "Location",
              icon: Icons.location_on_outlined,
              hint: "Add Location",
            ),
            const SizedBox(height: 8),
            // TextField(
            //   controller: _dateTimeController,
            //   readOnly: true,
            //   onTap: () => _selectDateTime(context),
            // )
            CustomInputForm(
              controller: _dateTimeController,
              icon: Icons.date_range_rounded,
              label: "Date & Time",
              hint: "Pick Event Date & Time",
              readOnly: true,
              onTap: () => _selectDateTime(context),
            ),

            const SizedBox(
              height: 8,
            ),

            CustomInputForm(
              controller: _guestController,
              icon: Icons.people,
              label: "Special Guests",
              hint: "Add Special Guests",
            ),
            const SizedBox(
              height: 8,
            ),
            CustomInputForm(
              controller: _sponserController,
              icon: Icons.attach_money,
              label: "Sponsors",
              hint: "Add Sponsors",
            ),

            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                const Text(
                  "In Person Event",
                  style: TextStyle(
                      color: Color.fromARGB(255, 218, 255, 123), fontSize: 20),
                ),
                const Spacer(),
                Switch(
                  activeColor: const Color.fromARGB(255, 218, 255, 123),
                  focusColor: Colors.green,
                  value: _isInPersonEvent,
                  onChanged: (value) {
                    setState(() {
                      _isInPersonEvent = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: MaterialButton(
                onPressed: () {
                  uploadEventPic().then((value) => createEvent(
                              _nameController.text,
                              _descController.text,
                              value,
                              _locController.text,
                              _dateTimeController.text,
                              id,
                              _isInPersonEvent,
                              guests: _guestController.text,
                              sponsers: _sponserController.text)
                          .then((value) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Event Created Successfully"),
                        ));
                        Navigator.pop(context);
                      }));
                },
                color: const Color.fromARGB(255, 218, 255, 123),
                child: const Text("Create Event",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w900)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
