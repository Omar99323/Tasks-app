import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/task_model.dart';
import '../../screens/nav_screens/archived_tasks.dart';
import '../../screens/nav_screens/done_tasks.dart';
import '../../screens/nav_screens/new_tasks.dart';
import 'homepage_state.dart';

class HomepageCubit extends Cubit<HomepageState> {
  HomepageCubit() : super(HomepageInitial());

  List<Task> tsks = [];
  late Database database;

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

  bool isopened = false;

  void changeCondition({required bool sheetopen}) {
    isopened = sheetopen;
    emit(HomepageChangeConditionState());
  }

  void getCurrentIndex(int index) {
    currentindex = index;
    emit(HomepageNavBarState());
    
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, name TEXT, date TEXT, time TEXT,status TEXT)');
      },
      onOpen: (db) {
        getAllRecords(db).then((value) {
          tsks = value;
          emit(GetAllRecordsSuccess());
        });
      },
    ).then((value) {
      database = value;
    });
    emit(CreateDatabaseState());
  }

  insertIntoDatabase(String title, String date, String time) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO Tasks(name, date, time, status) VALUES("$title", "$date", "$time", "New")')
          .then((value) {
        emit(InsertIntoDatabaseState());
        getAllRecords(database).then((value) {
          tsks = value;
          emit(GetAllRecordsSuccess());
        });
      });
    });
  }

  Future<List<Task>> getAllRecords(Database database) async {
    emit(GetAllRecordsLoading());
    List<Map> list = await database.rawQuery('SELECT * FROM Tasks');
    List<Task> tasks = [];
    for (var i = 0; i < list.length; i++) {
      tasks.add(Task.fromdb(list[i]));
    }
    return tasks;
  }

  void deleteRecord(String taskname) {
    database.rawDelete('DELETE FROM Tasks WHERE name = ?', [taskname]).then(
        (value) {
      emit(DeleteRecordState());
      getAllRecords(database).then((value) {
        tsks = value;
        emit(GetAllRecordsSuccess());
      });
    });
  }
}
