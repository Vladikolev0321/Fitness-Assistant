import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DistanceForActvity extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;
  final String typeActivity;

  const DistanceForActvity(
      {Key key, this.color, this.title, this.subtitle, this.typeActivity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          iconBasedOnTypeActivity(typeActivity),
          color: color,
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          children: [
            Text(
              title,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Text(
              subtitle,
              style: TextStyle(
                  color: Color(0xffc4bbcc), fontWeight: FontWeight.bold),
            )
          ],
        )
      ],
    );
  }

  IconData iconBasedOnTypeActivity(String type){
    if(type == "run"){
      return FontAwesomeIcons.running;
    }else if(type == "ride"){
      return FontAwesomeIcons.biking;
    }else if(type == "walk"){
      return FontAwesomeIcons.walking;
    }else if(type == "hike"){
      return FontAwesomeIcons.hiking;
    }
  }

}
