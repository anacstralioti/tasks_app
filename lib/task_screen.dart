import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'task_add.dart';
import 'task_edit.dart';
import 'task.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late Future<List<Task>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = _fetchTasks();
  }

  Future<List<Task>> _fetchTasks() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('tasks').get();
    return querySnapshot.docs.map((doc) {
      return Task.fromDocument(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<Task>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tasks found'));
          } else {
            final tasks = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Existing Tasks',
                    style: TextStyle(
                      color: Color.fromRGBO(67, 91, 227, 1),
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(67, 91, 227, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat('dd/MM/yyyy').format(task.date),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.white),
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('tasks')
                                              .doc(task.id)
                                              .delete();
                                          setState(() {
                                            _tasksFuture =
                                                _fetchTasks(); 
                                          });
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.check,
                                            color: Colors.white),
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('tasks')
                                              .doc(task.id)
                                              .delete();
                                          setState(() {
                                            _tasksFuture =
                                                _fetchTasks();
                                          });
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.white),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TaskEditPage(task: task),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              if (task.observation != null)
                                const SizedBox(height: 5),
                              if (task.observation != null)
                                Text(
                                  task.observation!,
                                  style: const TextStyle(color: Colors.white),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskAddPage(tasks: []),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Color.fromRGBO(67, 91, 227, 1),
        ),
      ),
    );
  }
}
