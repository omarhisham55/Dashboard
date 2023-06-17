import 'package:dashboard/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/bloc/states.dart';

import '../components/constants.dart';

class DashboardManager extends Cubit<DashboardState> {
  DashboardManager() : super(InitialState());

  DashboardManager get(context) => BlocProvider.of<DashboardManager>(context);

  bool isExpanded = false;
  void openMenu() {
    isExpanded = !isExpanded;
    print(isExpanded);
    emit(ChangeMenuState(isExpanded: isExpanded));
  }

  int selectedIndex = 0;
  void changeMenu(int index) {
    selectedIndex = index;
    emit(ChangeMenuState());
  }

  double pageWidth = double.infinity;
  double changePageWidth(context) {
    (isExpanded)
        ? pageWidth = width(context, .78)
        : pageWidth = width(context, .9);
    print('haha $pageWidth');
    emit(ChangePageWidth());
    return pageWidth;
  }

  TextEditingController tableController = TextEditingController();
  bool sort = true;
  bool filterOpened = false;
  List FilterList = [];

  onsortColum(int columnIndex, bool ascending, tableData) {
    FilterList = tableData;
    if (columnIndex == 0) {
      if (ascending) {
        FilterList.sort((a, b) => a.exerciseName!.compareTo(b.exerciseName!));
        emit(GetTable());
      } else {
        FilterList.sort((a, b) => b.exerciseName!.compareTo(a.exerciseName!));
        emit(GetTable());
      }
      print(FilterList[0].exerciseName);
    }
  }

  changeSort() {
    sort = !sort;
    emit(GetTable());
  }

  onFilter(tableData, value) {
    if (value.isEmpty) {
      filterOpened = false;
      emit(Filter(filter: tableData));
    } else {
      filterOpened = true;
      FilterList = tableData
          .where((element) => element.exerciseName
              .toString()
              .toLowerCase()
              .contains(value.toString().toLowerCase()))
          .toList();
      emit(Filter(filter: FilterList));
    }
  }

  //action Buttons
  Color deleteColor = const Color.fromARGB(255, 238, 82, 71);
  Color editColor = const Color.fromARGB(255, 56, 158, 241);

  void deleteHover() {
    deleteColor = Colors.black;
    print('delete babe');
    emit(ChangeColor());
    // deleteColor = const Color.fromARGB(255, 106, 10, 4);
  }

  void editHover() {
    editColor = Color.fromARGB(255, 9, 76, 131);
    emit(ChangeColor());
  }
}
