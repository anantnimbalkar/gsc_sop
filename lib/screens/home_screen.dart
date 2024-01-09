import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hive tutorial"),
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: Hive.openBox('SampleData'),
              builder: (context, snapshot) {
                print('${(snapshot.data!.get('name'))!=null}=============data');
                return Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ((snapshot.data!.get('name'))!=null)
                          ? ListTile(
                              title: Text(snapshot.data!.get('name')),
                              subtitle: Text(snapshot.data!.get('gender')),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        snapshot.data!
                                            .put('name', 'Kanchan Patil111111');
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () {
                                        snapshot.data!.delete('name');
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.delete)),
                                ],
                              ))
                          : Container()
                    ],
                  ),
                );
              }),
          FutureBuilder(
              future: Hive.openBox('SampleData1'),
              builder: (context, snapshot) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(snapshot.data!.get('You tube')),
                      )
                    ],
                  ),
                );
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var box = await Hive.openBox('SampleData'); //Hive box name.
          box.put("name", 'Kanchan');
          box.put('age', 23);
          box.put('gender', 'Female');
          box.put('details', {'Pro': "developer", 'orgnisation': 'nullplex'});

          var box2 = await Hive.openBox('SampleData1'); //Hive box name.
          box2.put("You tube", 'You Tube Channel');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
