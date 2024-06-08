import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'task_screen.dart';
import 'task.dart';

class TaskAddPage extends StatefulWidget {
  final List<Task> tasks;

  const TaskAddPage({Key? key, required this.tasks}) : super(key: key);

  @override
  _TaskAddPageState createState() => _TaskAddPageState();
}

class _TaskAddPageState extends State<TaskAddPage> {
  late TextEditingController _titleController;
  late TextEditingController _observationController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _observationController = TextEditingController();
    _selectedDate = DateTime.now();
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
                  'Add Task',
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
                          onPressed: _addTask,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(67, 91, 227, 1),
                          ),
                          child: const Text(
                            'Create New Task',
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

  Future<void> _addTask() async {
    final String title = _titleController.text.trim();
    final String observation = _observationController.text.trim();
    if (title.isNotEmpty) {
      final Task newTask = Task(
        id: '',
        title: title,
        date: _selectedDate,
        observation: observation,
      );

      try {
        final docRef = await FirebaseFirestore.instance
            .collection('tasks')
            .add(newTask.toDocument());
        final Task updatedTask = Task(
          id: docRef.id, 
          title: newTask.title,
          date: newTask.date,
          observation: newTask.observation,
          completed: newTask.completed,
        );

        widget.tasks.add(updatedTask);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TaskScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add task: $e')),
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
