import 'package:flutter/material.dart';

import '../cubit/todo_cubit.dart';

Widget defaultButton({
  double width=double.infinity,
  Color background=Colors.blue,
  required function,
  required String text,
  bool isuppercase=true,
})=>Container(
  width: width,
  height: 54,
  child: MaterialButton(
    onPressed: function,
    child: Text(
      isuppercase?text.toUpperCase():text,
      style:TextStyle(
        color: Colors.white,
        fontSize: 20.0,
      )
      ,),
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Color(0XFF2855AE).withBlue(400),
  ),
);


Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  void Function()?onTappped,
  required  validate,
  required String label,
  IconData? prefix,
  bool clickable=false,

})=>TextFormField(
  readOnly: clickable,
  controller: controller,
  onTap:onTappped,
  validator: validate,
  keyboardType:type ,
  decoration: InputDecoration(
    labelText: label,
    border:UnderlineInputBorder(borderRadius: BorderRadius.circular(10)),

    prefixIcon: Icon(prefix),
  ),



);
Widget buildTaskItem(Map model, BuildContext context)=>Padding(
  padding: const EdgeInsets.all(10.0),
  child: Dismissible(
    key:Key(model['id'].toString()),
    onDismissed: (direction){
      TodoCubit.get(context).deleteData(id: model['id']);

    },
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey[300],
          radius: 50,
          child: Text("${model['date']}",style: TextStyle(fontSize: 18,fontWeight:
          FontWeight.w800),),
        ),
        SizedBox(width: 25,),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${model['title']}",style: TextStyle(fontSize: 20,fontWeight:
              FontWeight.bold),),
              SizedBox(height: 3,),
              Text("${model['time']}",style: TextStyle(fontSize: 15
                  ,color: Colors.grey),),
            ],
          ),
        ),
        SizedBox(width: 25,),
        IconButton(
            onPressed:(){
              TodoCubit.get(context).updateData(state: 'done', id:model['id'] ) ;
              print("donestate");


            },
            icon: Icon(Icons.check_box,color: Colors.green,)
        ),
        IconButton(
            onPressed:(){
              TodoCubit.get(context).updateData(state: 'archived', id:model['id'],
              ) ;
              print("archivedstate");


            },
            icon: Icon(Icons.archive_sharp,color: Colors.red,)

        ),

      ],
    ),
  ),
);
