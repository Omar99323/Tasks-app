import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/models/task_model.dart';
import 'package:to_do/screens/nav_screens/archived_tasks.dart';
import 'package:to_do/screens/nav_screens/done_tasks.dart';
import 'package:to_do/screens/nav_screens/new_tasks.dart';
import '../../cubits/homepage_cubit/homepage_cubit.dart';
import '../../cubits/homepage_cubit/homepage_state.dart';
import '../../helpers/constants.dart';
import '../../widgets/custom_model_sheet.dart';

class HomeScreens extends StatelessWidget {
  HomeScreens({super.key});

  TextEditingController nameconroller = TextEditingController();
  TextEditingController dateconroller = TextEditingController();
  TextEditingController timeconroller = TextEditingController();

  var formkey = GlobalKey<FormState>();
  var scaffoldkey = GlobalKey<ScaffoldState>();
  bool isopened = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => HomepageCubit()..createDatabase(),
        child: BlocConsumer<HomepageCubit, HomepageState>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubt = BlocProvider.of<HomepageCubit>(context);
            return Scaffold(
              key: scaffoldkey,
              appBar: AppBar(
                title: Text(cubt.titles[cubt.currentindex]),
                centerTitle: true,
              ),
              body: state is GetAllRecordsLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : cubt.screens[cubt.currentindex],
              floatingActionButton: FloatingActionButton(
                child: isopened
                    ? const Icon(Icons.add_task_outlined)
                    : const Icon(Icons.add),
                onPressed: () {
                  if (isopened) {
                    if (formkey.currentState!.validate()) {
                      Navigator.pop(context);
                      isopened = false;
                      // cubt
                      //     .insertIntoDatabase(nameconroller.text,
                      //         dateconroller.text, timeconroller.text)
                      //     .then((value) {
                      //   nameconroller.clear();
                      //   dateconroller.clear();
                      //   timeconroller.clear();
                      //   cubt.getAllRecords();
                      //
                      // });
                    }
                  } else {
                    scaffoldkey.currentState!
                        .showBottomSheet((context) => CustomBottomSheet(
                              nameconroller: nameconroller,
                              dateconroller: dateconroller,
                              timeconroller: timeconroller,
                              formkey: formkey,
                            ))
                        .closed
                        .then((value) {
                      isopened = false;
                    });

                    isopened = true;
                  }
                },
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: cubt.currentindex,
                type: BottomNavigationBarType.fixed,
                onTap: (value) {
                  cubt.getCurrentIndex(value);
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.list),
                    label: 'Tasks',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.done_outline_rounded),
                    label: 'Done',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined),
                    label: 'Archived',
                  ),
                ],
              ),
            );
          },
        ));
  }
}
