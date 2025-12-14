import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'task_widgets.dart';
import '../data/firestore_provider.dart';

class StreamNote extends ConsumerWidget {
  final bool done;
  const StreamNote(this.done, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestore = ref.read(firestoreRepositoryProvider);

    return StreamBuilder<QuerySnapshot>(
      stream: firestore.stream(done),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final noteslist = firestore.getNotes(snapshot);
        if (noteslist.isEmpty) {
          return const SizedBox.shrink();
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: noteslist.length,
          itemBuilder: (context, index) {
            final note = noteslist[index];
            return Dismissible(
              key: ValueKey(note.id),
              onDismissed: (direction) {
                firestore.deletNote(note.id);
              },
              child: TaskWidget(note),
            );
          },
        );
      },
    );
  }
}
