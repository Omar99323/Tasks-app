import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/models/task_model.dart';
import '../cubits/homepage_cubit/homepage_cubit.dart';

class CustomTaskView extends StatelessWidget {
  const CustomTaskView({
    super.key,
    required this.taks,
  });

  final List<Task> taks;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) => Dismissible(
              key: Key(taks[index].title),
              onDismissed: (direction) =>
                  BlocProvider.of<HomepageCubit>(context)
                      .deleteRecord(taks[index].id),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      child: Text(taks[index].time),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            taks[index].title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            taks[index].date,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 60,
                    ),
                    GestureDetector(
                      onTap: () {
                        BlocProvider.of<HomepageCubit>(context).updateRecord(
                          status: 'Done',
                          id: taks[index].id,
                        );
                      },
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 25,
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        BlocProvider.of<HomepageCubit>(context).updateRecord(
                          status: 'Archived',
                          id: taks[index].id,
                        );
                      },
                      child: const Icon(
                        Icons.archive_outlined,
                        size: 25,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
        separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 1,
                color: const Color(0xFFCACACA),
              ),
            ),
        itemCount: taks.length);
  }
}
