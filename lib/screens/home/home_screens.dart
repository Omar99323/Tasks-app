import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/screens/nav_screens/archived_tasks.dart';
import 'package:to_do/screens/nav_screens/done_tasks.dart';
import 'package:to_do/screens/nav_screens/new_tasks.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  int currentindex = 0;
  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentindex]),
        centerTitle: true,
      ),
      body: screens[currentindex],
      floatingActionButton: FloatingActionButton(
        child:const Icon(Icons.add),
        onPressed: () {},
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentindex,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setState(() {
            currentindex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done_outline_rounded),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive_outlined),
            label: 'Archived',
          ),
        ],
      ),
    );
  }

  void createDatabase() async {
    var database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) async {
        print('db created');
        await db.execute(
            'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, name TEXT, date TEXT, time TEXT,status TEXT)');
        print('table created');
      },
      onOpen: (db) {
        print('db opened');
      },
    );
  }
}
