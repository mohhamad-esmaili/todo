import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:todo/controller/event_controller.dart';
import 'package:todo/model/event_model.dart';

import 'package:todo/view/event/widget/widget_exporter.dart';

class EditEventScreen extends StatefulWidget {
  const EditEventScreen({Key? key}) : super(key: key);

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final EventController _eventController = Get.find<EventController>();

  final TextEditingController _titleEditingController = TextEditingController();

  final TextEditingController _descriptionEditingCotroller =
      TextEditingController();

  final int index = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final Event editingEvent = _eventController.getEditingEvent(index);
    _titleEditingController.text = editingEvent.title;
    _descriptionEditingCotroller.text = editingEvent.description;
    DateTime pickedDateTime = _eventController.selectedDay.value;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Edit Todo'),
        leading: IconButton(
          onPressed: () {
            Get.closeAllSnackbars();
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              TitleTextformfieldWidget(
                  titleEditingController: _titleEditingController),
              const SizedBox(height: 20),
              DescriptionTextformfieldWidget(
                  descriptionEditingCotroller: _descriptionEditingCotroller),
              const SizedBox(height: 20),
              checkIfTimeIsEqual(_eventController.selectedDay.value)
                  ? ReminderSectionRowWidget(
                      remindMeBool: editingEvent.remindMe,
                      switchReminderFunction: (remindInNewValue) {
                        setState(() {
                          editingEvent.remindMe = remindInNewValue;
                        });
                      },
                    )
                  : const SizedBox(),
              AnimatedOpacity(
                opacity: editingEvent.remindMe ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 1000),
                child: editingEvent.remindMe
                    ? AlarmSectionColumnWidget(
                        initialDateTimeForSelector: editingEvent.dateTime,
                        remindInFunction: (value) =>
                            editingEvent.remindIn = value,
                        cupertinoDatePickerFunction: (DateTime value) =>
                            pickedDateTime = value)
                    : const SizedBox(height: 20),
              ),
              PrioritySectionRowWidget(
                eventPrioritySelectorFunction: (value) =>
                    editingEvent.priority = value,
              ),
              const SizedBox(height: 40),
              InkWell(
                onTap: () {
                  if (_titleEditingController.text.isNotEmpty) {
                    if (checkTimes(pickedDateTime, editingEvent.dateTime,
                        editingEvent.remindMe)) {
                      editingEvent.dateTime = pickedDateTime;
                      editingEvent.title = _titleEditingController.text;
                      editingEvent.description =
                          _descriptionEditingCotroller.text;
                      _eventController.editEvent(
                          index: index, newEvent: editingEvent);
                      _titleEditingController.clear();
                      Get.closeAllSnackbars();
                      Get.back();
                    } else {
                      showErrorNotification();
                    }
                  }
                },
                child: const InkwellChildSaveBTNWidget(title: "EDIT"),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}