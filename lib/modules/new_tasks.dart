import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/components/components.dart';
import '../shared/components/constants.dart';
import '../shared/cubit/todo_cubit.dart';

class NewTasks extends StatefulWidget {
  const NewTasks({Key? key}) : super(key: key);

  @override
  State<NewTasks> createState() => _NewTasksState();
}

class _NewTasksState extends State<NewTasks> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var tasks=TodoCubit.get(context).newTasks;
        return ScrollConfiguration(
          behavior:MyBehavior() ,//called from down
          child: tasks.length>0?
          ListView.separated(
              itemBuilder: (context, index) =>buildTaskItem
        (tasks[index],
                  context),
              separatorBuilder: (context, index) =>
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: 1.0,
                      color: Colors.grey[300],
                    ),
                  ),
              itemCount: tasks.length):Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text("Pls enter some tasks",style: TextStyle(fontSize: 20,
                  fontWeight: FontWeight.w700),),
              Icon(Icons.error_outline,size: 80,color: Colors.blue,),
            ],),
          ),
        );
      },
    );
  }
}

//to remove bouncing from listview
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}