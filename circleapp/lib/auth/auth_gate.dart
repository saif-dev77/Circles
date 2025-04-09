/*

AUTH GATE = This will continuosly listen to auth state changes

--------------------------------------------------------------------------------------------------

unauthenticated -> Login page
authenticated -> Homepage

*/
import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:learningdart/Pages/First_page.dart';
import 'package:learningdart/Pages/login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      //Listen to auth state changes
        stream: Supabase.instance.client.auth.onAuthStateChange,

        // Build appropriate page based on auth state
        builder: (context, snapshot) {
          // Loading.....
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              )
            );
          }

          //check if there is a valid session currently 
          final session = snapshot.hasData ? snapshot.data!.session: null;
          
          if(session != null){
            return const FirstPage();
          }  else {
            return const LoginPage();
          }  
              });
  }
}
