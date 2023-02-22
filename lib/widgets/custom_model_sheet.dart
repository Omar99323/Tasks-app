import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'custom_form_field.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key,
    required this.nameconroller,
    required this.dateconroller,
    required this.timeconroller,
    required this.formkey,
  });

  final TextEditingController nameconroller;
  final TextEditingController dateconroller;
  final TextEditingController timeconroller;

  final GlobalKey formkey;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formkey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomFormField(
              controler: nameconroller,
              icon: Icons.title,
              label: 'Task Title',
              type: TextInputType.text,
              validator: (data) {
                if (data!.isEmpty) {
                  return 'Empty Title Field';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            CustomFormField(
              controler: dateconroller,
              icon: Icons.calendar_today,
              label: 'Task Date',
              type: TextInputType.datetime,
              validator: (p0) {
                if (p0!.isEmpty) {
                  return 'Empty Date Field';
                }
                return null;
              },
              ontap: () {
                final f = DateFormat('dd-MM-yyyy');
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.parse('2035-12-30'),
                ).then((value) => dateconroller.text = f.format(value!));
              }, 
            ),
            const SizedBox(
              height: 10,
            ),
            CustomFormField(
              controler: timeconroller,
              icon: Icons.watch,
              label: 'Task Time',
              type: TextInputType.number,
              validator: (p0) {
                if (p0!.isEmpty) {
                  return 'Empty Time Field';
                }
                return null;
              },
              
              ontap: () {
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                ).then((value) => timeconroller.text = value!.format(context));
              },
            ),
          ],
        ),
      ),
    );
  }
}
