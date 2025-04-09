import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  //SignIn with Email and Password
  Future<AuthResponse> signInWithEmailPassword(String email, String password) async {
    return await _supabase.auth.signInWithPassword(email: email, password: password);
  }


  // Check for college email
  


  //SignUp with Email and Password
  Future<AuthResponse> signUpWithEmailPassword(String email, String password) async {
    return await _supabase.auth.signUp(email: email, password: password);
  }

  //Sign Out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // show user email
  String? getcurrentUseremail(){
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email ;
  }

  // Add this function to get current user ID
  String? getCurrentUserId() {
    final user = Supabase.instance.client.auth.currentUser;
    return user?.id;
  }
}