import 'package:flutter/material.dart';
import 'package:test_app/utils/helpers/date_utils.dart';

class NewTaskView extends StatefulWidget {
  const NewTaskView({super.key});

  @override
  State<NewTaskView> createState() => _NewTaskViewState();
}

class _NewTaskViewState extends State<NewTaskView> {
  /* CONTROLLERS */
  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskDescController = TextEditingController();
  List<String> taskTags = ['Study Hour', 'School', 'Other'];
  late String selectedValue = '';

  //DATE
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _deadline;

  @override
  void initState() {
    _selectedDay = _focusedDay;
    super.initState();
  }

  _onRangeSelected(DateTime? deadline, DateTime focusDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusDay;
      _deadline = deadline;
    });
  }


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}