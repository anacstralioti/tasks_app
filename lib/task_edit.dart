import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'task.dart';
import 'task_screen.dart';

class TaskEditPage extends StatefulWidget {
  final Task task;

  const TaskEditPage({Key? key, required this.task}) : super(key: key);

  @override
  _TaskEditPageState createState() => _TaskEditPageState();
}

class _TaskEditPageState extends State<TaskEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _observationController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _observationController =
        TextEditingController(text: widget.task.observation);
    _selectedDate = widget.task.date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Edit Task',
                  style: TextStyle(
                    color: Color.fromRGBO(67, 91, 227, 1),
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.6,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(241, 241, 241, 1),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Title',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          hintText: 'Enter task title',
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Details',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: _observationController,
                        decoration: const InputDecoration(
                          hintText: 'Write down details',
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Date',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: _pickDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            hintText: 'Select date',
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today),
                              const SizedBox(width: 10),
                              Text(DateFormat('dd/MM/yyyy')
                                  .format(_selectedDate)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _updateTask,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(67, 91, 227, 1),
                          ),
                          child: const Text(
                            'Update Task',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _updateTask() async {
    final String title = _titleController.text.trim();
    final String observation = _observationController.text.trim();
    if (title.isNotEmpty) {
      final updatedTask = Task(
        id: widget.task.id,
        title: title,
        date: _selectedDate,
        observation: observation,
        completed: widget.task.completed,
      );

      try {
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(widget.task.id)
            .update(updatedTask.toDocument());

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TaskScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update task: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The title is required.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _observationController.dispose();
    super.dispose();
  }
}
