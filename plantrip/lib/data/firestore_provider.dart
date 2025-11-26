import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_to_do_list/data/firestor.dart';

final firestoreRepositoryProvider =
    Provider<Firestore_Datasource>((ref) => Firestore_Datasource());
