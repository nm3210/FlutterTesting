import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:apptest01_component/classes/DateTimeCustom.dart';

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class DateTimeEntry extends StatefulWidget {
  DateTimeEntry(
      {Key key,
      String displayText,
      bool defaultOverride,
      DateTimeCustom dateTime,
      @required this.onChanged})
      : assert(onChanged != null),
        date = dateTime,
        time = new TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
        inputDisplayText = displayText;

  final DateTimeCustom date;
  final TimeOfDay time;
  final ValueChanged<DateTimeCustom> onChanged;
  final String inputDisplayText;

  @override
  DateTimeItemState createState() => new DateTimeItemState();
}

class DateTimeItemState extends State<DateTimeEntry> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return new DefaultTextStyle(
      style: theme.textTheme.subhead,
      child: new Container(
        height: 42.0,
        child: new Row(
          mainAxisAlignment: (!widget.date.specialCheck)
              ? MainAxisAlignment.spaceEvenly
              : MainAxisAlignment.start,
          children: <Widget>[
            (!widget.date.specialCheck)
                ? new Container(
                    child: new Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: new BoxDecoration(
                        border: new Border(
                          bottom: new BorderSide(
                            color: theme.dividerColor,
                          ),
                        ),
                      ),
                      child: new InkWell(
                        onTap: () {
                          setState(() {
                            showDatePicker(
                                    context: context,
                                    initialDatePickerMode: DatePickerMode.day,
                                    initialDate: widget.date,
                                    firstDate: new DateTime(1900),
                                    lastDate: widget.date
                                        .add(const Duration(days: 14)))
                                .then<Null>((DateTime value) {
                              if (value != null)
                                widget.onChanged(new DateTimeCustom(
                                    year: value.year,
                                    month: value.month,
                                    day: value.day,
                                    hour: widget.date.hour,
                                    minute: widget.date.minute));
                            });
                          });
                        },
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text(new DateFormat('EEE, MMM d yyyy')
                                .format(widget.date)),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : new Container(width: 0.0),
            (!widget.date.specialCheck)
                ? new Container(
                    child: new Container(
                      margin: const EdgeInsets.only(left: 8.0),
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      width: 95.0,
                      decoration: new BoxDecoration(
                        border: new Border(
                          bottom: new BorderSide(
                            color: theme.dividerColor,
                          ),
                        ),
                      ),
                      child: new InkWell(
                        onTap: () {
                          showTimePicker(
                                  context: context, initialTime: widget.time)
                              .then<Null>((TimeOfDay value) {
                            setState(() {
                              if (value != null)
                                widget.onChanged(new DateTimeCustom(
                                    year: widget.date.year,
                                    month: widget.date.month,
                                    day: widget.date.day,
                                    hour: value.hour,
                                    minute: value.minute));
                            });
                          });
                        },
                        child: new Row(
                          children: <Widget>[
                            new Text('${widget.time.format(context)}'),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : new Container(),
            new Container(
              margin: (widget.date.specialCheck)
                  ? const EdgeInsets.only(left: 8.0)
                  : null,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  (!widget.date.specialCheck)
                      ? new Text("Toggle")
                      : new Text('${widget.inputDisplayText}'),
                  new Checkbox(
                    value: widget.date.specialCheck,
                    onChanged: (bool value) {
                      setState(() {
                        if (value != null) {
                          widget.date.specialCheck = value;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
