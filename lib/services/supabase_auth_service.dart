import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_bootstrap.dart';

class SupabaseAuthService {
  SupabaseAuthService();

  SupabaseClient? get _client => SupabaseBootstrap.clientOrNull;

  bool get isConfigured => SupabaseBootstrap.isConfigured;
  bool get isSignedIn => _client?.auth.currentSession != null;
  User? get currentUser => _client?.auth.currentUser;

  Stream<AuthState> get authStateChanges {
    final client = _client;
    if (client == null) {
      return const Stream<AuthState>.empty();
    }
    return client.auth.onAuthStateChange;
  }

  Future<AuthResponse?> signUp({
    required String email,
    required String password,
  }) async {
    final client = _client;
    if (client == null) {
      return null;
    }
    return client.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse?> signIn({
    required String email,
    required String password,
  }) async {
    final client = _client;
    if (client == null) {
      return null;
    }
    return client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    final client = _client;
    if (client == null) {
      return;
    }
    await client.auth.signOut();
  }
}
