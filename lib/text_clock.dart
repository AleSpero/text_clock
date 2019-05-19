library text_clock;

import 'dart:async';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart';
import 'package:flutter/material.dart';


class TextClock extends StatefulWidget {
  var DEFAULT_STYLE_TIME;
  var DEFAULT_STYLE_DATE;

  TextStyle timeStyle;
  TextStyle dateStyle;
  String timezone;
  String dateFormat;
  String timeFormat;
  var location;
  bool showDate = true;

  TextClock(
      {this.timeStyle,
        this.dateStyle,
        this.timezone,
        this.dateFormat,
        this.timeFormat,
        this.showDate});

  @override
  _TextClockState createState() => _TextClockState();
}

class _TextClockState extends State<TextClock> {
  String _currentTime;
  String _currentDate;

  Timer clock;

  @override
  void initState() {
    DateTime now;

      if (widget.timezone != null) {
        widget.location = getLocation(widget.timezone ?? "Europe/Rome");
        now = TZDateTime.now(widget.location);
    } else {
      now = DateTime.now();
    }
    _currentTime = formatDateTime(now, true);
    _currentDate = formatDateTime(now, false);
    clock = Timer.periodic(Duration(seconds: 1), (timer) => _refreshTime());
    super.initState();
  }

  @override
  void dispose() {
    //Stoppo timer
    clock?.cancel();
    super.dispose();
  }

  //Ogni secondo refresha

  @override
  Widget build(BuildContext context) {
    widget.DEFAULT_STYLE_DATE =
        TextStyle(fontSize: 18);
    widget.DEFAULT_STYLE_TIME =
        TextStyle(fontSize: 45);

    return (widget.showDate ?? true)
        ? Column(
      children: <Widget>[
        Text(_currentTime,
            style: widget.timeStyle ?? widget.DEFAULT_STYLE_TIME),
        Text(_currentDate,
            style: widget.dateStyle ?? widget.DEFAULT_STYLE_DATE),
      ],
    )
        : Text(_currentTime, style: widget.timeStyle);
  }

  String formatDateTime(DateTime date, bool isTime) {
    return DateFormat(isTime
        ? widget.timeFormat ?? "HH:mm" //Todo locale nel caso default
        : widget.dateFormat)
        .format(date);
  }

  void _refreshTime() {
    //Refresh time + applico format

    DateTime now;

    if (widget.location == null && widget.timezone != null) {
      widget.location = getLocation(widget.timezone ?? "Europe/Rome");
    }

    try {
      now = widget.location != null ? TZDateTime.now(widget.location) : DateTime.now();
      setState(() {
        _currentTime = formatDateTime(now, true);
        _currentDate = formatDateTime(now, false);
      });
    } on Exception catch (e) {
      print(e);
    }
  }
}
