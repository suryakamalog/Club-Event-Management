import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AdminPostPage extends StatefulWidget {
  final Function(String, String, String, String, String) callback;

  AdminPostPage(this.callback);

  @override
  _AdminPostPageState createState() => _AdminPostPageState();
}

class _AdminPostPageState extends State<AdminPostPage> {
  String _workshopName;
  String _date = "2000-01-01";
  String _time = "00:00:00";
  String _venue;
  String _detail;

  bool validateWorkshopName = false;
  bool validateDate = false;
  bool validateTime = false;
  bool validateVenue = false;
  bool validateDetail = false;

  TextEditingController workshopNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController venueController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  void dispose() {
    super.dispose();
    workshopNameController.dispose();
    dateController.dispose();
    timeController.dispose();
    venueController.dispose();
    detailController.dispose();
  }

  void click() {
    widget.callback(workshopNameController.text, _date, _time,
        venueController.text, detailController.text);
    workshopNameController.clear();
    dateController.clear();
    timeController.clear();
    venueController.clear();
    detailController.clear();

    FocusScope.of(context).unfocus();

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now();

    Future<void> _selectDate(BuildContext context) async {
      DateTime selectedDate = DateTime.now();

      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2020, 1),
          lastDate: DateTime(2120));
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
        });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF4747),
        title: Text('Add Event'),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
          child: ListView(
            children: <Widget>[
              Container(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 6.0,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Workshop name",
                            style: TextStyle(
                                fontFamily: "Poppins-Medium",
                                fontSize: ScreenUtil().setSp(45))),
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              value.isEmpty
                                  ? validateWorkshopName = true
                                  : validateWorkshopName = false;
                            });
                          },
                          controller: workshopNameController,
                          decoration: InputDecoration(
                              errorText: validateWorkshopName
                                  ? "Workshop Name can\'t be empty"
                                  : null,
                              hintText: "Workshop Name",
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(30)),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Date: $_date",
                                  style: TextStyle(
                                      fontFamily: "Poppins-Medium",
                                      fontSize: ScreenUtil().setSp(45))),
                              RaisedButton(
                                  splashColor: Colors.white10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.red)),
                                  color: Color(0xFFFF4747),
                                  onPressed: () {
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime(2020, 1, 1),
                                        maxTime: DateTime(2030, 1, 1),
                                        onChanged: (date) {
                                      print('change $date');
                                    }, onConfirm: (date) {
                                      print('confirm $date');

                                      setState(() {
                                        String year = '$date.toLocal()'
                                            .split(' ')[0]
                                            .split('-')[0];
                                        String month = '$date.toLocal()'
                                            .split(' ')[0]
                                            .split('-')[1];
                                        String day = '$date.toLocal()'
                                            .split(' ')[0]
                                            .split('-')[2];

                                        _date = day + '-' + month + '-' + year;
                                      });
                                    },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.en);
                                  },
                                  child: Text(
                                    'Select Date',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Time: $_time",
                                style: TextStyle(
                                    fontFamily: "Poppins-Medium",
                                    fontSize: ScreenUtil().setSp(45))),
                            RaisedButton(
                                splashColor: Colors.white10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.red)),
                                color: Color(0xFFFF4747),
                                onPressed: () {
                                  DatePicker.showTime12hPicker(context,
                                      showTitleActions: true,
                                      onChanged: (date) {
                                    print('change $date in time zone ' +
                                        date.timeZoneOffset.inHours.toString());
                                  }, onConfirm: (date) {
                                    print('confirm $date');
                                    setState(() {
                                      _time = '$date.toLocal()'
                                          .split(' ')[1]
                                          .split('.')[0];
                                    });
                                  }, currentTime: DateTime.now());
                                },
                                child: Text(
                                  'Select Time',
                                  style: TextStyle(color: Colors.white),
                                )),
                          ],
                        ),
                        SizedBox(height: ScreenUtil().setHeight(30)),
                        Text("Venue",
                            style: TextStyle(
                                fontFamily: "Poppins-Medium",
                                fontSize: ScreenUtil().setSp(45))),
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              value.isEmpty
                                  ? validateVenue = true
                                  : validateVenue = false;
                            });
                          },
                          controller: venueController,
                          decoration: InputDecoration(
                              errorText: validateVenue
                                  ? "Venue can\'t be empty"
                                  : null,
                              hintText: "Venue",
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(30)),
                        Text("Other Details",
                            style: TextStyle(
                                fontFamily: "Poppins-Medium",
                                fontSize: ScreenUtil().setSp(45))),
                        TextField(
                          maxLines: 3,
                          onChanged: (value) {
                            setState(() {
                              value.isEmpty
                                  ? validateDetail = true
                                  : validateDetail = false;
                            });
                          },
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            errorText: validateDetail
                                ? "Detail can\'t be empty"
                                : null,
                            border: OutlineInputBorder(),
                          ),
                          controller: detailController,
                        ),
                        SizedBox(height: ScreenUtil().setHeight(30)),
                        Center(
                            child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)),
                          color: Color(0xFFFF4747),
                          textColor: Colors.white,
                          padding: EdgeInsets.all(8.0),
                          splashColor: Colors.white10,
                          onPressed: this.click,
                          child: Text(
                            "Submit",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
