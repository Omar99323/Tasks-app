import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/homepage_cubit/homepage_cubit.dart';
import '../../cubits/homepage_cubit/homepage_state.dart';
import '../../widgets/custom_task_view.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubt = BlocProvider.of<HomepageCubit>(context);
    return BlocBuilder<HomepageCubit, HomepageState>(
      builder: (context, state) {
        if (cubt.donetsks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.menu,
                  size: 120,
                  color: Colors.black45,
                ),
                Text(
                  'No Tasks Yet, Please Add Some Tasks.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black45,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'And Swipe Left Or Right To Delete.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black45,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          );
        } else {
          return CustomTaskView(
            taks: cubt.donetsks,
          );
        }
      },
    );
  }
}
