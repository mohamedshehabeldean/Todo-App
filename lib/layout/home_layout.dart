import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import '../modules/archived_tasks.dart';
import '../modules/done_tasks.dart';
import '../modules/new_tasks.dart';
import '../shared/components/components.dart';
import '../shared/components/constants.dart';
import '../shared/cubit/todo_cubit.dart';

class HomePage extends StatelessWidget {
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();
  var titleControler = TextEditingController();
  var timeControler = TextEditingController();
  var dateControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit()..createDatabase(),
      child: BlocConsumer<TodoCubit, TodoState>(
        listener: (context, state) {
          if (state is insertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          TodoCubit cubit = TodoCubit.get(context);
          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              backgroundColor: Colors.black,
              systemOverlayStyle: SystemUiOverlayStyle(
                  systemNavigationBarColor: Colors.black,
                  statusBarColor: Colors.black,
                  statusBarBrightness: Brightness.dark),
              title: Text(
                cubit.titles[cubit.CurrentInd],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.showbottom) {
                  if (formkey.currentState!.validate()) {
                    cubit.insertToDatabase(
                        title: titleControler.text,
                        time: timeControler.text,
                        date: dateControler.text);
                  }
                } else {
                  scaffoldkey.currentState
                      ?.showBottomSheet(
                        (context) => Container(
                          color: Colors.grey[100],
                          padding: EdgeInsets.all(20),
                          child: Form(
                            key: formkey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormField(
                                  controller: titleControler,
                                  validate: (value) {
                                    if (value.isEmpty) {
                                      return "title must not be empty";
                                    }
                                    return null;
                                  },
                                  type: TextInputType.text,
                                  label: "Task Title",
                                  prefix: Icons.title,
                                ),
                                defaultFormField(
                                  clickable: true,
                                  controller: timeControler,
                                  validate: (value) {
                                    if (value.isEmpty) {
                                      return "time must not be empty";
                                    }
                                    return null;
                                  },
                                  onTappped: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timeControler.text =
                                          value!.format(context).toString();
                                      print(value?.format(context));
                                    });
                                  },
                                  type: TextInputType.datetime,
                                  label: "Task Time",
                                  prefix: Icons.watch_later_outlined,
                                ),
                                defaultFormField(
                                  clickable: true,
                                  controller: dateControler,
                                  validate: (value) {
                                    if (value.isEmpty) {
                                      return "date must not be empty";
                                    }
                                    return null;
                                  },
                                  onTappped: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2023-08-29'))
                                        .then((value) {
                                      dateControler.text =
                                          DateFormat.yMMMd().format(value!);
                                      print(DateFormat.yMMMd().format(value!));
                                    });
                                  },
                                  type: TextInputType.datetime,
                                  label: "Task Date",
                                  prefix: Icons.date_range,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetIcon(
                        showIcon: false, bottomIcon: Icons.edit);
                  });

                  cubit.changeBottomSheetIcon(
                      showIcon: true, bottomIcon: Icons.add);
                }
              },
              child: Icon(
                cubit.ico,
                size: 35,
              ),
              backgroundColor: Colors.black,

            ),
            bottomNavigationBar: BottomNavigationBar(
                // mouseCursor: MouseCursor.defer,
                backgroundColor: Colors.white,
                currentIndex: cubit.CurrentInd,
                onTap: (index) {
                  cubit.changeindex(index);
                },
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.note_alt_rounded), label: "Tasks"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle), label: "Done"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive), label: "Archived")
                ]),
            body: (state is! loadingState)
                ? cubit.Screens[cubit.CurrentInd]
                : Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

//database created>>table created>>database open
//create
}
