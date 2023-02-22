import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/homepage_cubit/homepage_cubit.dart';
import '../../cubits/homepage_cubit/homepage_state.dart';
import '../../widgets/custom_model_sheet.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {

  TextEditingController nameconroller = TextEditingController();
  TextEditingController dateconroller = TextEditingController();
  TextEditingController timeconroller = TextEditingController();

  var formkey = GlobalKey<FormState>();
  var scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => HomepageCubit()..createDatabase(),
        child: BlocConsumer<HomepageCubit, HomepageState>(
          listener: (context, state) {
            if (state is InsertIntoDatabaseState) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            var cubt = BlocProvider.of<HomepageCubit>(context);
            return Scaffold(
              key: scaffoldkey,
              appBar: AppBar(
                title: Text(cubt.titles[cubt.currentindex]),
                centerTitle: true,
              ),
              body: state is GetAllRecordsLoading
                  ? const Center(child: CircularProgressIndicator())
                  : cubt.screens[cubt.currentindex],
              floatingActionButton: FloatingActionButton(
                child: cubt.isopened
                    ? const Icon(Icons.add_task_outlined)
                    : const Icon(Icons.add),
                onPressed: () {
                  if (cubt.isopened) {
                    if (formkey.currentState!.validate()) {
                      cubt
                          .insertIntoDatabase(
                        nameconroller.text,
                        dateconroller.text,
                        timeconroller.text,
                      )
                          .then((value) {
                        nameconroller.clear();
                        dateconroller.clear();
                        timeconroller.clear();
                      });
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
                      cubt.changeCondition(sheetopen: false);
                    });

                    cubt.changeCondition(sheetopen: true);
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
