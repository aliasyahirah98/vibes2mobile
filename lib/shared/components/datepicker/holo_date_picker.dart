import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

class HoloDatePickerState extends StatefulWidget {
  const HoloDatePickerState({Key? key}) : super(key: key);

  @override
  _HoloDatePickerState createState() => _HoloDatePickerState();
}

class _HoloDatePickerState extends State<HoloDatePickerState> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: DatePickerWidget(
              looping: false, // default is not looping
              firstDate: DateTime.now(), //DateTime(1960),
            //  lastDate: DateTime(2002, 1, 1),
//              initialDate: DateTime.now(),// DateTime(1994),
              dateFormat:
              "MM-dd(E)",
           //   "dd-MMMM-yyyy",
         //     locale: DatePicker.localeFromString('he'),
              onChange: (DateTime newDate, _) {
                _selectedDate = newDate;
                debugPrint(_selectedDate.toString());
              },
              pickerTheme: const DateTimePickerTheme(
                itemTextStyle: TextStyle(color: Colors.black, fontSize: 19),
                dividerColor: Colors.blue,
              ),

            ),
          ),
        ),
      ),
    );
  }
}