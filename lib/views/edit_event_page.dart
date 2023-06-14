import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:event_planner_app/containers/custom_input_form.dart';
import 'package:event_planner_app/controllers/auth.dart';
import 'package:event_planner_app/controllers/database_logic.dart';
import 'package:event_planner_app/controllers/saved_data.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';

class EditEvent extends StatefulWidget {
  final String name,
      desc,
      image,
      location,
      eventId,
      dateTime,
      guests,
      sponsers,
      documentId;
  final bool inPerson;

  const EditEvent({
    super.key,
    required this.name,
    required this.desc,
    required this.image,
    required this.location,
    required this.dateTime,
    required this.guests,
    required this.sponsers,
    required this.inPerson,
    required this.eventId,
    required this.documentId,
  });

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
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
  bool isLoading = true;
  Storage storage = Storage(client);
  String eventId = "";

  @override
  void initState() {
    id = SavedData.getUserId();
    _nameController.text = widget.name;
    _descController.text = widget.desc;
    _locController.text = widget.location;
    _dateTimeController.text = widget.dateTime;
    _guestController.text = widget.guests;
    _sponserController.text = widget.sponsers;
    _isInPersonEvent = widget.inPerson;
    isLoading = false;

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
                "Update Event",
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
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              "https://cloud.appwrite.io/v1/storage/buckets/6487074849d89dcf51ac/files/${widget.image}/view?project=6486f854bd95ae96b223&mode=admin",
                              fit: BoxFit.fill,
                            ),
                          )),
              ),
            ),
            const SizedBox(height: 8),
            const Text("Tap on Image to Change it.",
                style: TextStyle(
                    color: Color.fromARGB(255, 218, 255, 123),
                    fontWeight: FontWeight.w500)),
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
                  _filePickerResult == null
                      ? editEvent(
                              _nameController.text,
                              _descController.text,
                              widget.image,
                              _locController.text,
                              _dateTimeController.text,
                              id,
                              widget.documentId,
                              _isInPersonEvent,
                              guests: _guestController.text,
                              sponsers: _sponserController.text)
                          .then((value) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Event Updated Successfully"),
                          ));
                          Navigator.pop(context);
                        })
                      : uploadEventPic().then((value) => editEvent(
                                  _nameController.text,
                                  _descController.text,
                                  value,
                                  _locController.text,
                                  _dateTimeController.text,
                                  id,
                                  widget.documentId,
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
                child: const Text("Update Event",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w900)),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              "Danger Zone",
              style: TextStyle(
                  color: Color.fromARGB(255, 243, 138, 131),
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: MaterialButton(
                  color: const Color.fromARGB(255, 243, 138, 131),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text("Are You Sure ?",
                                  style: TextStyle(color: Colors.white)),
                              content: const Text("Your event will be deleted",
                                  style: TextStyle(color: Colors.white)),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      deleteEvent(widget.eventId).then((value) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                              "Event Deleted Successfully"),
                                        ));
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: const Text("Yes")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("No")),
                              ],
                            ));
                  },
                  child: const Text("Delete Event",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w900))),
            ),
          ]),
        ),
      ),
    );
  }
}
