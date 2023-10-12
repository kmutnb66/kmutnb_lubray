import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<String?> datePicker(BuildContext context,
    {required DateTime todate,
    DateTime? date,
    int? step_,
    bool back = true}) async {
  return await showDialog(
      context: context,
      builder: (BuildContext datepicker) {
        List<int> days = [];
        int step = 1;
           if (step_ != null) {
          step = step_;
          date = date!.add(Duration(days:1));
          var inday = DateTimeRange(
                  start: DateTime(date!.year, date!.month, 1),
                  end: DateTime(date!.year, date!.month + 1))
              .duration
              .inDays;
          days = [];
          for (int i = 1; i <= inday; i++) {
            days.add(i);
          }
        }
        int year = date != null ? date!.year : todate.year;
        int month = date != null ? date!.month : todate.month;
        int day = date != null ? date!.day : todate.day;
        return StatefulBuilder(builder: (context, setState) {
          List<String> years = [];
          List<String> months = [
            'ม.ค.',
            'ก.พ.',
            'มี.ค.',
            'เม.ย.',
            'พ.ค.',
            'มิ.ย.',
            'ก.ค.',
            'ส.ค.',
            'ก.ย.',
            'ต.ค.',
            'พ.ย.',
            'ธ.ค.'
          ];
          for (int i = todate.year; i <= (todate.year + 25); i++) {
            years.add('$i');
          }
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                step == 1
                    ? Expanded(flex: 10, child: SizedBox())
                    : Expanded(
                        flex: 10,
                        child: (back || step > 2)
                            ? IconButton(
                                onPressed: () {
                                  step -= 1;
                                  setState(() {});
                                },
                                icon: Icon(Icons.arrow_back,
                                    color: Color.fromRGBO(18, 52, 82, 1)))
                            : Container(),
                      ),
                Text(step_ != null ? 'เลือกวันคืน\n ${months[month-1]} $year' : step == 1
                    ? 'เลือกปี'
                    : step == 2
                        ? 'เลือกเดือน'
                        : 'เลือกวัน',textAlign:TextAlign.center),
                Expanded(
                    flex: 10,
                    child: Icon(
                      Icons.calendar_today,
                      color: Color.fromRGBO(18, 52, 82, 1),
                    ))
              ],
            ),
            content: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(datepicker).size.width,
                child: GridView.count(
                    shrinkWrap: true,
                    primary: false,
                    padding: const EdgeInsets.all(10),
                    crossAxisCount: 5,
                    children: step == 1
                        ? years
                            .map((item) => InkWell(
                                  onTap: () {
                                    year = int.parse(item);
                                    step = 2;
                                    setState(() {});
                                  },
                                  child: Card(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      color: '$year' == item
                                          ? Color.fromRGBO(18, 52, 82, 1)
                                          : null,
                                      child: Center(
                                          child: Text(
                                        item,
                                        style: TextStyle(
                                            color: '$year' == item
                                                ? Colors.white
                                                : Colors.black),
                                      ))),
                                ))
                            .toList()
                        : step == 2
                            ? months
                                .map((item) => InkWell(
                                      onTap: () {
                                        month = months.indexOf(item) + 1;
                                        var inday = DateTimeRange(
                                                start: DateTime(year, month, 1),
                                                end: DateTime(year, month + 1))
                                            .duration
                                            .inDays;
                                        days = [];
                                        for (int i = 1; i <= inday; i++) {
                                          days.add(i);
                                        }
                                        step = 3;
                                        setState(() {});
                                      },
                                      child: Card(
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          color: months.indexOf(item) + 1 ==
                                                  month
                                              ? Color.fromRGBO(18, 52, 82, 1)
                                              : null,
                                          child: Center(
                                              child: Text(
                                            item,
                                            style: TextStyle(
                                                color:
                                                    months.indexOf(item) + 1 ==
                                                            month
                                                        ? Colors.white
                                                        : Colors.black),
                                          ))),
                                    ))
                                .toList()
                            : days
                                .map((item) => InkWell(
                                      onTap: () {
                                        day = item;
                                        Navigator.pop(datepicker,
                                            "$year-${month < 10 ? 0 : ''}$month-${day < 10 ? 0 : ''}$day");
                                        setState(() {});
                                      },
                                      child: Card(
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          color: item == day
                                              ? Color.fromRGBO(18, 52, 82, 1)
                                              : null,
                                          child: Center(
                                              child: Text(
                                            '$item',
                                            style: TextStyle(
                                                color: item == day
                                                    ? Colors.white
                                                    : Colors.black),
                                          ))),
                                    ))
                                .toList()),
              ),
            ),
          );
        });
      });
}

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = this.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}

String dateform(DateTime? date) {
  return DateFormat("dd/MM/yyyy").format(date!);
}
