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

  List<Task> newtsks = [];
  List<Task> donetsks = [];
  List<Task> archivedtsks = [];

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
        getAllRecords(db);
      },
    ).then((value) {
      database = value;
    });
    emit(CreateDatabaseState());
  }

  Future insertIntoDatabase(
      {required String title,
      required String date,
      required String time}) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO Tasks(name, date, time, status) VALUES("$title", "$date", "$time", "New")')
          .then((value) {
        getAllRecords(database);
        emit(InsertIntoDatabaseState());
      });
    });
  }

  void getAllRecords(Database database) {
    newtsks.clear();
    donetsks.clear();
    archivedtsks.clear();

    emit(GetAllRecordsLoading());

    database.rawQuery('SELECT * FROM Tasks').then((value) {
    
      for (var element in value) {
        if (element['status'] == 'New') {
          newtsks.add(Task.fromdb(element));
        } else if (element['status'] == 'Done') {
          donetsks.add(Task.fromdb(element));
        } else {
          archivedtsks.add(Task.fromdb(element));
        }
      }
      emit(GetAllRecordsSuccess());
    });
  }

  void deleteRecord(int id) {
    database.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]).then((value) {
      getAllRecords(database);
      emit(DeleteRecordState());
    });
  }

  void updateRecord({required String status, required int id}) {
    database.rawUpdate(
        'UPDATE Tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      getAllRecords(database);
      emit(UpdateRecordState());
    });
  }
}
