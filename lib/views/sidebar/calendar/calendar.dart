import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myveteran/shared/config/constant.dart';
import 'package:myveteran/shared/config/utils.dart';
import 'package:myveteran/views/sidebar/calendar/calendar_util.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarState extends StatefulWidget {
  const CalendarState({Key? key}) : super(key: key);
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<CalendarState> {
  final ScrollController scrollController = ScrollController();
  late final ValueNotifier<List<CalendarUtil>> _selectedEvents;
  
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  double _offSet = 0.0;
  double _paddingTop = 0.0;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

    scrollController.addListener(() => 
      setState(() {
        //<-----------------------------
        _offSet = scrollController.offset;
        // print('_offSet $_offSet');
        // force a refresh so the app bar can be updated
      })
    );
  }

  @override
  void dispose() {
    _selectedEvents.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _paddingTop = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        // For Android.
        // Use [light] for white status bar and [dark] for black status bar.
        statusBarIconBrightness: Brightness.dark,
        // For iOS.
        // Use [dark] for white status bar and [light] for black status bar.
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: _offSet > 6 ? 1.0 : 0.0,
          leading: utils.backHeaderButton(context, backIcon: CupertinoIcons.chevron_back),
          brightness: Brightness.light,
          title: Text(
            utils.getTranslated('calendar', context),
            style: utils.getTextStyleRegular(color: mainColor, fontSize: 22, weight: FontWeight.bold)
          ),
          backgroundColor: Colors.white
        ),
        body: Stack(
          children: <Widget>[
            Container(
              // elevation: 4.0,
              width: MediaQuery.of(context).size.width,
              height: 60,
              margin: const EdgeInsets.only(top: 60, left: 15.0, right: 15.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                // border: Border.all(width: 1.0, color: (Colors.grey[300])!),
                color: Color(0xFFC2AA92),
              )
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              margin: const EdgeInsets.only(top: 10, left: 15.0, right: 15.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                border: Border.all(width: 1.0, color: (Colors.grey[300])!),
                color: const Color(0xFFD2D2D2),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 30,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Pembayaran Pencen Seterusnya',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: utils.getTextStyleRegular(fontSize: 13, color: Colors.black87, fontStyle: FontStyle.italic)
                          ),
                          Text(
                            '5 Apr 2021',
                            style: utils.getTextStyleRegular(fontSize: 18, color: secondColor, weight: FontWeight.w700)
                          )
                        ]
                      )
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 30,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            'Bilangan Hari',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: utils.getTextStyleRegular(fontSize: 13, color: Colors.black87, fontStyle: FontStyle.italic)
                          ),
                          Text(
                            '21 Hari Lagi',
                            style: utils.getTextStyleRegular(fontSize: 18, color: secondColor, weight: FontWeight.w700)
                          )
                        ]
                      )
                    )
                  ],
                )
              )
            ),
            Container(
              margin: const EdgeInsets.only(top: 130, left: 15.0, right: 15.0),
              child: _showCalendar()
            )
          ]
        )
      )
    );
  }

  Widget _showCalendar() {
    return Column(
      children: <Widget>[
        TableCalendar<CalendarUtil>(
          firstDay: kFirstDay,
          lastDay: kLastDay,
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          rangeStartDay: _rangeStart,
          rangeEndDay: _rangeEnd,
          calendarFormat: _calendarFormat,
          rangeSelectionMode: _rangeSelectionMode,
          eventLoader: _getEventsForDay,
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarStyle: const CalendarStyle(
            // Use `CalendarStyle` to customize the UI
            outsideDaysVisible: false,
            markersMaxCount: 1,
          ),
          onDaySelected: _onDaySelected,
          onRangeSelected: _onRangeSelected,
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: ValueListenableBuilder<List<CalendarUtil>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              return ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      onTap: () => debugPrint('${value[index]}'),
                      title: Text('${value[index]}'),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  List<CalendarUtil> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<CalendarUtil> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }
}