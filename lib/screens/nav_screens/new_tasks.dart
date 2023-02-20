import 'package:flutter/material.dart';
import '../../helpers/constants.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(15),
              child: Row(children: [
                CircleAvatar(
                  radius: 40,
                  child: Text(tsks[index].time),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tsks[index].title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      tsks[index].date,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              ]),
            ),
        separatorBuilder: (context, index) => const SizedBox(
              height: 5,
            ),
        itemCount: tsks.length);
  }
}
