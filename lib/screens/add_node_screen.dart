import 'package:flutter/material.dart';
import 'package:hive_database/boxes/boxes.dart';
import 'package:hive_database/models/nodes_model.dart';
import 'package:hive_flutter/adapters.dart';

class AddNodeScreen extends StatefulWidget {
  const AddNodeScreen({super.key});

  @override
  State<AddNodeScreen> createState() => _AddNodeScreenState();
}

class _AddNodeScreenState extends State<AddNodeScreen> {
  TextEditingController textEditingTitleController = TextEditingController();
  TextEditingController textEditingDescriptionController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
          valueListenable: Boxes.getData().listenable(),
          builder: (context, box, state) {
            var notesData = box.values.toList().cast<NotesModel>();
            return ListView.builder(
                itemCount: notesData.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(notesData[index].title!),
                              const Spacer(),
                              InkWell(
                                  onTap: () {
                                    editNotesDialog(notesData[index]);
                                  },
                                  child: const Icon(Icons.edit)),
                              const SizedBox(
                                width: 15,
                              ),
                              InkWell(
                                  onTap: () {
                                    deleteNode(notesData[index]);
                                  },
                                  child: const Icon(Icons.delete)),
                            ],
                          ),
                          Text(notesData[index].description!)
                        ],
                      ),
                    ),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNotesDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> editNotesDialog(NotesModel notes) async {
    textEditingTitleController.text = notes.title!;
    textEditingDescriptionController.text = notes.description!;
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add Notes"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: textEditingTitleController,
                    decoration: const InputDecoration(
                        hintText: 'Enter tilte', border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: textEditingDescriptionController,
                    decoration: const InputDecoration(
                        hintText: 'Enter Description',
                        border: OutlineInputBorder()),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    print("${textEditingDescriptionController.text}");
                    notes.title = textEditingTitleController.text.toString();
                    notes.description =
                        textEditingDescriptionController.text.toString();
                    await notes.save();
                    textEditingTitleController.clear();
                    textEditingDescriptionController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text("Edit")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"))
            ],
          );
        });
  }

  Future<void> showNotesDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add Notes"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: textEditingTitleController,
                    decoration: const InputDecoration(
                        hintText: 'Enter tilte', border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: textEditingDescriptionController,
                    decoration: const InputDecoration(
                        hintText: 'Enter Description',
                        border: OutlineInputBorder()),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    final notesModelData = NotesModel(
                        title: textEditingTitleController.text,
                        description: textEditingDescriptionController.text);
                    final Box box = Boxes.getData();
                    box.add(notesModelData);
                    // notesModelData.save();
                    textEditingTitleController.clear();
                    textEditingDescriptionController.clear();
                    print(box.values.toString());
                    Navigator.pop(context);
                  },
                  child: const Text("Add")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"))
            ],
          );
        });
  }

  void deleteNode(NotesModel nodesModel) async {
    nodesModel.delete();
  }
}
