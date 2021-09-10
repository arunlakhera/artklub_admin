import 'dart:html';

import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {

  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${DateFormat('MMM, yyyy').format(_focusedDay)}',
                style: AppStyles().getTitleStyle(
                  titleSize: 20,
                  titleColor: Colors.black,
                  titleWeight: FontWeight.bold,
                ),
              ),

              Row(
                children: [
                  InkWell(
                    onTap: (){
                      setState(() {
                        _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
                      });
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      setState(() {
                        _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
                      });
                    },
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(DateTime.now().year - 50),
            lastDay: DateTime.utc(DateTime.now().year + 50),
            headerVisible: false,
            onFormatChanged: (result){},
            daysOfWeekStyle: DaysOfWeekStyle(
              dowTextFormatter: (date, locale){
                return DateFormat('EEE').format(date).toUpperCase();
              },
              weekdayStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              weekendStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPageChanged: (day){
              _focusedDay = day;
              setState(() {

              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: AppColors.colorYellow,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: AppColors.colorYellow,
                shape: BoxShape.circle,
              )
            ),
            eventLoader: (day){
              /// Make event on 22 and 30 of every month
              if(day.day == 22 || day.day == 30){
                return [
                  Event('Event Name', canBubble: true)
                ];
              }
              return [];
            },
          ),
        ],
      ),
    );
  }
}
