import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({ Key key }) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 300.0),
                Column(
                  children: <Widget>[
                    Container(
                      height: 100,
                      color: Colors.blue,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "10,000",
                            ),
                            trailing: Icon(
                              FontAwesomeIcons.walking,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              'Steps',
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                      Container(
                      height: 100,
                      color: Colors.red,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "3,000",
                            ),
                            trailing: Icon(
                              FontAwesomeIcons.fire,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              'Calories Burned',
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
        ],
          )
    );
  }
}
