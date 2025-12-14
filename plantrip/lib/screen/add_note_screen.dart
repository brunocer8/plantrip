// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../const/colors.dart';
import '../data/firestore_provider.dart';


class AddCreen extends ConsumerStatefulWidget {
  const AddCreen({super.key});


  @override
  ConsumerState<AddCreen> createState() => _AddCreenState();
}


class _AddCreenState extends ConsumerState<AddCreen> {
  final title = TextEditingController();
  final subtitle = TextEditingController();


  final List<String> tasks = [];
  final taskController = TextEditingController();
  final List<bool> tasksChecked = [];


  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();


  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;


  DateTime? _travelDateTime;


  @override
  void dispose() {
    title.dispose();
    subtitle.dispose();
    taskController.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColors,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                titleWidgets(),
                const SizedBox(height: 18),
                subtiteWedgite(),
                const SizedBox(height: 18),
                _dateTimeField(),
                const SizedBox(height: 18),
                imageField(),
                const SizedBox(height: 18),
                todoInput(),
                const SizedBox(height: 10),
                todoList(),
                const SizedBox(height: 22),
                button(),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _dateTimeField() {
    final text = _travelDateTime == null
        ? 'Data e hora da viagem'
        : '${_travelDateTime!.day.toString().padLeft(2, '0')}/'
          '${_travelDateTime!.month.toString().padLeft(2, '0')}/'
          '${_travelDateTime!.year} • '
          '${_travelDateTime!.hour.toString().padLeft(2, '0')}:'
          '${_travelDateTime!.minute.toString().padLeft(2, '0')}';


    return GestureDetector(
      onTap: () async {
        final now = DateTime.now();
        final date = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: now,
          lastDate: DateTime(now.year + 5),
        );
        if (date == null) return;


        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(now),
        );
        if (time == null) return;


        if (!mounted) return;
        setState(() {
          _travelDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          children: [
            const Icon(Icons.event, color: Color(0xffc5c5c5)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: _travelDateTime == null ? Colors.grey : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2F80ED),
            minimumSize: const Size(170, 48),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          onPressed: () async {
            if (title.text.trim().isEmpty || _travelDateTime == null) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('Defina o destino e a data/hora da viagem.'),
                ),
              );
              return;
            }


            final firestore = ref.read(firestoreRepositoryProvider);
            await firestore.addNote(
              subtitle.text,
              title.text,
              _pickedImage?.path,
              tasks,
              tasksChecked,
              travelDateTime: _travelDateTime,
            );


            if (!mounted) return;
            Navigator.pop(context);
          },
          child:
              const Text('adicionar', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            minimumSize: const Size(170, 48),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle:
                const TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'cancelar',
            style: TextStyle(color: Color(0xFF7C6BD7)),
          ),
        ),
      ],
    );
  }


  Widget imageField() {
    return GestureDetector(
      onTap: () => _showImageSourceBottomSheet(),
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          border: Border.all(
            color: _pickedImage == null
                ? const Color(0xffc5c5c5)
                : const Color(0xFF2F80ED),
            width: 2,
          ),
        ),
        child: _pickedImage == null
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_a_photo_outlined,
                        size: 40, color: Color(0xffc5c5c5)),
                    SizedBox(height: 8),
                    Text(
                      'Toque para adicionar uma imagem\n(câmera ou galeria)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(17),
                child: Image.file(
                  File(_pickedImage!.path),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
      ),
    );
  }


Future<void> _showImageSourceBottomSheet() async {
  if (!mounted) return;
  final bottomSheetContext = context;


  await showModalBottomSheet(
    context: bottomSheetContext,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (_) {
      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Tirar foto'),
              onTap: () async {
                Navigator.pop(bottomSheetContext);
                final image =
                    await _picker.pickImage(source: ImageSource.camera);
                if (image != null && mounted) {
                  setState(() => _pickedImage = image);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Escolher da galeria'),
              onTap: () async {
                Navigator.pop(bottomSheetContext);
                final image =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (image != null && mounted) {
                  setState(() => _pickedImage = image);
                }
              },
            ),
          ],
        ),
      );
    },
  );
}



  Widget titleWidgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: TextField(
          controller: title,
          focusNode: _focusNode1,
          style: const TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            hintText: 'destino',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xffc5c5c5),
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(
                color: customBlue,
                width: 2.0,
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget subtiteWedgite() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: TextField(
          maxLines: 3,
          controller: subtitle,
          focusNode: _focusNode2,
          style: const TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            hintText: 'descrição',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xffc5c5c5),
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(
                color: customBlue,
                width: 2.0,
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget todoInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 3)
                ],
              ),
              child: TextField(
                controller: taskController,
                decoration: InputDecoration(
                  hintText: 'nova tarefa',
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 11),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xffc5c5c5),
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 2, 57, 165),
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 7),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2F80ED),
              borderRadius: BorderRadius.circular(11),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 3)
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                if (taskController.text.isNotEmpty) {
                  setState(() {
                    tasks.add(taskController.text);
                    tasksChecked.add(false);
                    taskController.clear();
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget todoList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 3)
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: Text(tasks[index]),
                    activeColor: const Color(0xFF2F80ED),
                    checkColor: Colors.white,
                    value: tasksChecked[index],
                    onChanged: (value) {
                      setState(() {
                        tasksChecked[index] = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      tasks.removeAt(index);
                      tasksChecked.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}