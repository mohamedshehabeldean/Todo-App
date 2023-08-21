part of 'todo_cubit.dart';

abstract class TodoState {}

class TodoInitial extends TodoState {}

class changeBottomNavBarState extends TodoState {}

class createDatabaseState extends TodoState {}

class insertDatabaseState extends TodoState {}

class getDatabaseState extends TodoState {}

class updateDatabaseState extends TodoState {}

class deleteDatabaseState extends TodoState {}

class changeBottomIcon extends TodoState {}

class loadingState extends TodoState {}
