import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/cubits/homepage_cubit/homepage_cubit.dart';
import 'package:to_do/cubits/homepage_cubit/homepage_state.dart';
import '../../widgets/custom_task_view.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var cubt = BlocProvider.of<HomepageCubit>(context);
    return BlocBuilder<HomepageCubit, HomepageState>(
      builder: (context, state) {
        return CustomTaskView(cubt: cubt); 
      },
    );
  }
}

