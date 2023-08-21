import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../modules/archived_tasks.dart';
import '../../modules/done_tasks.dart';
import '../../modules/new_tasks.dart';
import '../components/constants.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(TodoInitial());

  static TodoCubit get(context) => BlocProvider.of(context);

  int CurrentInd = 0;
  late Database db;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  List<Widget> Screens = [NewTasks(), DoneTasks(), ArchivedTasks()];
  List<String> titles = [
    "New Tasks",
    "Done Tasks",
    "Archived Tasks",
  ];

  void changeindex(int index) {
    CurrentInd = index;
    emit(changeBottomNavBarState());
  }

//create
  void createDatabase() {
    openDatabase('TODO1.db', version: 1, //structure of
        // database
        onCreate: (db, version) {
      print("database created");

      db
          .execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY,title '
              'TEXT ,date TEXT ,time TEXT,status TEXT)')
          .then((value) {
        print("table created");
      }).catchError((error) {
        print("error ${error.toString()}");
      });
    }, onOpen: (db) {
      getDataFromDatabase(db);
      print("database opened");
    }).then((value) {
      db = value;
      emit(createDatabaseState());
    });
  }

//insert
  insertToDatabase(
      {required String title,
      required String time,
      required String date}) async {
    await db.transaction((txn) async {
      await txn
          .rawInsert("INSERT INTO tasks(title,date,time,status)Values"
              "('$title','$time','$date','new')")
          .then((value) {
        print("$value row inserted");
        emit(insertDatabaseState());
        getDataFromDatabase(db);
      }).catchError((Error) {
        print("error when inserted new raw ${Error.toString()}");
      });
    });
  }

// get data
  void getDataFromDatabase(db) {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
    emit(loadingState());
    db.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(getDatabaseState());
    });

    // emit(getDatabaseState());
  }

//update data
  updateData({
    required String state,
    required int id,
  }) async {
    db.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$state', id]).then((value) {
      getDataFromDatabase(db);
      emit(updateDatabaseState());
    });
  }

  //delete data
  deleteData({
    required int id,
  }) async {
    db.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then(
            (value) {
      getDataFromDatabase(db);
      emit(deleteDatabaseState());
    });
  }

  bool showbottom = false;
  IconData ico = Icons.edit;

  void changeBottomSheetIcon(
      {required bool showIcon, required IconData bottomIcon}) {
    showbottom = showIcon;
    ico = bottomIcon;
    emit(changeBottomIcon());
  }
}
