import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/homepage_cubit/homepage_cubit.dart';

class CustomTaskView extends StatelessWidget {
  const CustomTaskView({
    super.key,
    required this.cubt,
  });

  final HomepageCubit cubt;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    child: Text(cubt.tsks[index].time),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cubt.tsks[index].title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          cubt.tsks[index].date,
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
                        id: cubt.tsks[index].id,
                      );
                    },
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      print(cubt.tsks[index].status);
                      // BlocProvider.of<HomepageCubit>(context).updateRecord(
                      //   status: 'Archived',
                      //   id: cubt.tsks[index].id,
                      // );
                    },
                    child: const Icon(
                      Icons.archive_outlined,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<HomepageCubit>(context)
                          .deleteRecord(cubt.tsks[index].id);
                    },
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
        separatorBuilder: (context, index) => Container(
              height: 1,
              width: 10,
              color: const Color(0xFFE6E6E6),
            ),
        itemCount: cubt.tsks.length);
  }
}
