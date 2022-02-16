import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/google_sign_in.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = FirebaseAuth.instance.currentUser;
    return Center(
      child: Column(
        children: [
          SizedBox(height: 70),
          Text("Profile",
          style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          SizedBox(height: 30),
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(_user.photoURL),
          ),
          SizedBox(height: 30),
          Text("Username: ${_user.displayName}"),
          SizedBox(height: 30),
          Text("Email: ${_user.email}"),
          SizedBox(height: 30),
          OutlinedButton(child: Text("Log out"), onPressed: (){
            Provider.of<GoogleSignInProvider>(context, listen:false).logout();
          }),
        ],
      ),
      
    );
  }
}