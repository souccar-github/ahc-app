import 'dart:core';
import 'dart:core';
import 'dart:core';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

Widget viewCalender(
    DateTime dateTime,
    Function(DateTime, List<Event>) onDayPressed,
    dynamic Function(DateTime) onDayLongPressed,
    List<Event> events,
    Widget icon) {
  EventList<Event> _events = new EventList<Event>();
  for (int i = 0; i < events.length; i++) {
    var e = new Event(date: events[i].date, icon: icon);
    _events.add(events[i].date, e);
  }
  return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: CalendarCarousel<Event>(
        weekdayTextStyle: TextStyle(color: Color.fromRGBO(7, 163, 163, 1)),
        onDayPressed: (DateTime date, List<Event> events) =>
            onDayPressed(date, events),
        weekendTextStyle: TextStyle(
          color: Colors.black,
        ),
        onDayLongPressed: onDayLongPressed,
        headerTextStyle: TextStyle(
          color: Color.fromRGBO(7, 163, 163, 1),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        showHeaderButton: false,
        showOnlyCurrentMonthDate: true,
        showHeader: true,
        selectedDayButtonColor: Color.fromRGBO(7, 163, 163, 0.3),
        selectedDayBorderColor: Color.fromRGBO(7, 163, 163, 0.3),
        thisMonthDayBorderColor: Color.fromRGBO(7, 163, 163, 0.3),
        weekFormat: false,
        markedDateIconMaxShown: 0,
        markedDateMoreCustomTextStyle:
            TextStyle(fontSize: 8, color: Colors.white),
        markedDateMoreCustomDecoration: BoxDecoration(
          color: Color.fromRGBO(7, 163, 163, 1),
          shape: BoxShape.circle,
        ),
        showIconBehindDayText: true,
        
        markedDateShowIcon: true,
        markedDateIconBuilder: (event) {
          return event.icon;
        },
        markedDatesMap: _events,
        markedDateMoreShowTotal: true,
        height: 350.0,
        selectedDateTime: dateTime,
        isScrollable: false,
      ));
}
