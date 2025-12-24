import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:facesdk_plugin/facesdk_plugin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'person.dart';

class UserActivity extends StatefulWidget {
  const UserActivity({super.key});

  @override
  State<UserActivity> createState() => _UserActivityState();
}

class _UserActivityState extends State<UserActivity> {
  final FacesdkPlugin _facesdkPlugin = FacesdkPlugin();
  List<Person> persons = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAllPersons().then((list) {
      setState(() {
        persons = list;
        isLoading = false;
      });
    });
  }

  // ============================================================
  // DATABASE
  // ============================================================

  Future<Database> createDB() async {
    final dbPath = join(await getDatabasesPath(), 'person.db');
    return openDatabase(
      dbPath,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE person(name TEXT, faceJpg BLOB, templates BLOB)',
        );
      },
      version: 1,
    );
  }

  Future<List<Person>> loadAllPersons() async {
    final db = await createDB();
    final maps = await db.query('person');

    return maps.map((e) => Person.fromMap(e)).toList();
  }

  Future<void> insertPerson(Person p) async {
    final db = await createDB();
    await db.insert('person', p.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    setState(() {
      persons.add(p);
    });
  }

  Future<void> deletePerson(int index) async {
    final db = await createDB();

    await db.delete(
      'person',
      where: 'name = ?',
      whereArgs: [persons[index].name],
    );

    setState(() {
      persons.removeAt(index);
    });

    Fluttertoast.showToast(
      msg: "Person deleted",
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  Future<void> deleteAllPersons() async {
    final db = await createDB();
    await db.delete('person');

    setState(() {
      persons.clear();
    });

    Fluttertoast.showToast(
      msg: "All persons deleted",
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  // ============================================================
  // ENROLL PERSON
  // ============================================================

  Future<void> enrollPerson() async {
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final rotated = await FlutterExifRotation.rotateImage(path: image.path);

      final faces = await _facesdkPlugin.extractFaces(rotated.path);

      if (faces.isEmpty) {
        Fluttertoast.showToast(
          msg: "No face detected!",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      for (var face in faces) {
        final int id = 10000 + Random().nextInt(90000);

        final person = Person(
          name: "Person$id",
          faceJpg: face["faceJpg"],
          templates: face["templates"],
        );

        await insertPerson(person);
      }

      Fluttertoast.showToast(
        msg: "Person enrolled!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      print("Enroll Error: $e");
    }
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD0BCFF),

      appBar: AppBar(
        title: const Text("User List"),
        backgroundColor: const Color(0xFF6200EE),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: deleteAllPersons,
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6200EE),
        onPressed: enrollPerson,
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : persons.isEmpty
              ? const Center(
                  child: Text(
                    "No users enrolled",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: persons.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundImage: MemoryImage(persons[index].faceJpg),
                        ),
                        title: Text(persons[index].name),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deletePerson(index),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
