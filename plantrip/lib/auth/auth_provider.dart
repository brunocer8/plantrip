import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_to_do_list/data/auth_data.dart';

final authPageProvider = StateProvider<bool>((ref) => true);
final authStateProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);
final authRepositoryProvider = Provider<AuthenticationDatasource>((ref) => AuthenticationRemote());
