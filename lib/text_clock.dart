library text_clock;

import 'dart:async';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart';
import 'package:flutter/material.dart';


class TextClock extends StatefulWidget {
  var DEFAULT_STYLE_TIME;

  TextStyle timeStyle;
  String timezone;
  String timeFormat;
  var location;

  TextClock(
      {this.timeStyle,
        this.timezone,
        this.timeFormat});

  @override
  _TextClockState createState() => _TextClockState();
}

class _TextClockState extends State<TextClock> {
  String _currentTime;

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
    _currentTime = formatDateTime(now);
    clock = Timer.periodic(Duration(seconds: 1), (timer) => _refreshTime());
    super.initState();
  }

  @override
  void dispose() {
    clock?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.DEFAULT_STYLE_TIME =
        TextStyle(fontSize: 45);

    return Text(_currentTime,
        style: widget.timeStyle ?? widget.DEFAULT_STYLE_TIME);
  }

  String formatDateTime(DateTime date) {
    return DateFormat(widget.timeFormat ?? "HH:mm")
        .format(date);
  }

  void _refreshTime() {
    DateTime now;

    if (widget.location == null && widget.timezone != null) {
      widget.location = getLocation(widget.timezone ?? "Europe/Rome");
    }

    try {
      now = widget.location != null ? TZDateTime.now(widget.location) : DateTime.now();
      setState(() {
        _currentTime = formatDateTime(now);
      });
    } on Exception catch (e) {
      print(e);
    }
  }
}
