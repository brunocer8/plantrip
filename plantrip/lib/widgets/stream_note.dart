import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_to_do_list/widgets/task_widgets.dart';
import 'package:flutter_to_do_list/data/firestore_provider.dart';

class Stream_note extends ConsumerWidget {
  final bool done;
  Stream_note(this.done, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestore = ref.read(firestoreRepositoryProvider);
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.stream(done),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        final noteslist = firestore.getNotes(snapshot);
        return ListView.builder(
          shrinkWrap: true,
          itemCount: noteslist.length,
          itemBuilder: (context, index) {
            final note = noteslist[index];
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                firestore.delet_note(note.id);
              },
              child: Task_Widget(note),
            );
          },
        );
      },
    );
  }
}
