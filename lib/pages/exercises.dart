import 'package:dashboard/bloc/cubit.dart';
import 'package:dashboard/bloc/states.dart';
import 'package:dashboard/components/components.dart';
import 'package:dashboard/components/constants.dart';
import 'package:dashboard/data/exercise_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../storage/data_tables.dart';

class Exercise extends StatelessWidget {
  const Exercise({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List filterList = [];
    return BlocProvider(
      create: (context) => DashboardManager(),
      child: BlocConsumer<DashboardManager, DashboardState>(
          listener: (context, state) {
        if (state is Filter) {
          filterList = state.filter!;
        }
      }, builder: (context, state) {
        return FutureBuilder(
            future: getDataMapValues(allValues: true),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                DashboardManager table = DashboardManager().get(context);
                var tableData =
                    table.filterOpened ? filterList : snapshot.data!;
                return SizedBox(
                  width: width(context, 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: DefaultButton(
                          function: () {},
                          text: '+ exercise',
                          width: width(context, .2),
                        ),
                      ),
                      PaginatedDataTable(
                        sortColumnIndex: 0,
                        sortAscending: table.sort,
                        header: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(12)),
                          child: TextField(
                              controller: table.tableController,
                              decoration: const InputDecoration(
                                  hintText: "Enter something to filter"),
                              onChanged: (value) {
                                table.onFilter(tableData, value);
                              }),
                        ),
                        source: RowSource(
                            myData: tableData,
                            count: tableData.length,
                            context: context),
                        rowsPerPage: 8,
                        columnSpacing: 8,
                        columns: [
                          const DataColumn(
                            label: Text(
                              "Actions",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                          DataColumn(
                              label: const Text(
                                "Name",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 14),
                              ),
                              onSort: (columnIndex, ascending) {
                                table.changeSort();
                                table.onsortColum(
                                    columnIndex, ascending, tableData);
                              }),
                          const DataColumn(
                            label: Text(
                              "Id",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                          const DataColumn(
                            label: Text(
                              "Body Part",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                          const DataColumn(
                            label: Text(
                              "Type",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                          const DataColumn(
                            label: Text(
                              "Description",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                          const DataColumn(
                            label: Text(
                              "Level",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                          const DataColumn(
                            label: Text(
                              "Equipment",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                          const DataColumn(
                            label: Text(
                              "Repetitions",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                          const DataColumn(
                            label: Text(
                              "Sets",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                          const DataColumn(
                            label: Text(
                              "Image Url",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                    child: titleText(text: 'error ${snapshot.error}'));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            });
      }),
    );
  }
}
