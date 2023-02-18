import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/screens/nav_screens/archived_tasks.dart';
import 'package:to_do/screens/nav_screens/done_tasks.dart';
import 'package:to_do/screens/nav_screens/new_tasks.dart';
import 'package:to_do/widgets/custom_form_field.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  late Database database;

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

  TextEditingController nameconroller = TextEditingController();
  TextEditingController dateconroller = TextEditingController();
  TextEditingController timeconroller = TextEditingController();

  var formkey = GlobalKey<FormState>();
  var scaffoldkey = GlobalKey<ScaffoldState>();
  bool isopened = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text(titles[currentindex]),
        centerTitle: true,
      ),
      body: screens[currentindex],
      floatingActionButton: FloatingActionButton(
        child: isopened ? const Icon(Icons.add) : const Icon(Icons.edit),
        onPressed: () {
          if (isopened) {
            if (formkey.currentState!.validate()) {
              insertIntoDatabase(nameconroller.text, dateconroller.text,
                      timeconroller.text)
                  .then((value) {
                Navigator.pop(context);
                isopened = false;
              });
            }
          } else {
            scaffoldkey.currentState!
                .showBottomSheet((context) => CustomBottomSheet(
                      nameconroller: nameconroller,
                      dateconroller: dateconroller,
                      timeconroller: timeconroller,
                      formkey: formkey,
                    ));
            isopened = true;
          }
          setState(() {});
        },
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
    database = await openDatabase(
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

  Future insertIntoDatabase(
    String title,
    String date,
    String time,
  ) async {
    await database.transaction((txn)  async{
       txn.rawInsert(
          'INSERT INTO Tasks(name, date, time, status) VALUES("$title", "$date", "$time", "New")')
          .then((value) => print('$value inserted'));
    });
  }

  void getAllRecords() async {
    List<Map> list = await database.rawQuery('SELECT * FROM Tasks');
    List<Map> expectedList = [
      {
        'name': 'some name',
        'id': 1,
        'date': "1234",
        'time': "456",
        'status': "on"
      },
      {
        'name': 'another name',
        'id': 2,
        'date': "12034",
        'time': "4556",
        'status': "off"
      }
    ];
    print(list);
    print(expectedList);
  }

  void deleteRecord() async {
    int count = await database
        .rawDelete('DELETE FROM Test WHERE name = ?', ['another name']);
    assert(count == 1);
  }
}

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key,
    required this.nameconroller,
    required this.dateconroller,
    required this.timeconroller,
    required this.formkey,
  });

  final TextEditingController nameconroller;
  final TextEditingController dateconroller;
  final TextEditingController timeconroller;

  final GlobalKey formkey;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formkey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomFormField(
              controler: nameconroller,
              icon: Icons.title,
              label: 'Task Title',
              type: TextInputType.text,
              validator: (data) {
                if (data!.isEmpty) {
                  return 'Empty Title Field';
                }
              },
              onsubmit: (data) {},
            ),
            const SizedBox(
              height: 10,
            ),
            CustomFormField(
              controler: dateconroller,
              icon: Icons.calendar_today,
              label: 'Task Date',
              type: TextInputType.datetime,
              validator: (p0) {
                if (p0!.isEmpty) {
                  return 'Empty Date Field';
                }
              },
              onsubmit: (data) {},
              ontap: () {
                final f = DateFormat('yyyy-MM-dd');
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.parse('2035-12-30'),
                ).then((value) => dateconroller.text = f.format(value!));
              },
            ),
            const SizedBox(
              height: 10,
            ),
            CustomFormField(
              controler: timeconroller,
              icon: Icons.watch,
              label: 'Task Time',
              type: TextInputType.number,
              validator: (p0) {
                if (p0!.isEmpty) {
                  return 'Empty Time Field';
                }
              },
              onsubmit: (data) {},
              ontap: () {
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                ).then((value) => timeconroller.text = value!.format(context));
              },
            ),
          ],
        ),
      ),
    );
  }
}
