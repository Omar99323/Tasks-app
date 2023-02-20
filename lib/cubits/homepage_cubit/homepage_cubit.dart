import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../helpers/constants.dart';
import '../../models/task_model.dart';
import '../../screens/nav_screens/archived_tasks.dart';
import '../../screens/nav_screens/done_tasks.dart';
import '../../screens/nav_screens/new_tasks.dart';
import 'homepage_state.dart';

class HomepageCubit extends Cubit<HomepageState> {
  HomepageCubit() : super(HomepageInitial());

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

  void getCurrentIndex(int index) {
    currentindex = index;
    emit(HomepageNavBarState());
  }

  Future<void> createDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'todo.db');
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, name TEXT, date TEXT, time TEXT,status TEXT)');
      },
      onOpen: (db) {},
    );
    emit(CreateDatabaseState());
  }

  Future insertIntoDatabase(
    String title,
    String date,
    String time,
  ) async {
    await database.transaction((txn) async {
      txn.rawInsert(
          'INSERT INTO Tasks(name, date, time, status) VALUES("$title", "$date", "$time", "New")');
    });

    emit(InsertIntoDatabaseState());
  }

  Future<List<Task>> getAllRecords() async {
    emit(GetAllRecordsLoading());
    List<Map> list = await database.rawQuery('SELECT * FROM Tasks');

    for (var i = 0; i < list.length; i++) {
      tsks.add(Task.fromdb(list[i]));
    }
    emit(GetAllRecordsSuccess());
    return tsks;
  }

  void deleteRecord() async {
    int count = await database
        .rawDelete('DELETE FROM Test WHERE name = ?', ['another name']);
    assert(count == 1);
  }
}
