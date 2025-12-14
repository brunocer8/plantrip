import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firestore.dart';

final firestoreRepositoryProvider =
    Provider<FirestoreDatasource>((ref) => FirestoreDatasource());
