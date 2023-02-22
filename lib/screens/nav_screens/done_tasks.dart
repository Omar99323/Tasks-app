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
        return CustomTaskView(taks: cubt.donetsks,); 
      },
    );
  }
}
