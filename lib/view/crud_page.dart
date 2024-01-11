// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:trashbin/controller/db_helper.dart';

class CrudPage extends StatefulWidget {
  const CrudPage({super.key});

  @override
  State<CrudPage> createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  List<Map<String, dynamic>> allData = [];

  bool isLoading = true;
//GET ALL DATA from DATABASE
  void refreshData() async {
    final data = await SQLHelper.getAllData();
    setState(() {
      allData = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshData();
  }

//CREATE
  Future<void> addData() async {
    await SQLHelper.createData(titleController.text, descController.text);
    refreshData();
  }

//UPDATE
  Future<void> updateData(int id) async {
    await SQLHelper.updateData(id, titleController.text, descController.text);
    refreshData();
  }

//DELETE
  Future<void> deleteData(int id) async {
    await SQLHelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Deleted Successfully!"),
      backgroundColor: Colors.redAccent,
    ));
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  // jika id != null maka data akan terupdate serta akan ada data baru
  // ketika icon edit di tekan akn menavigasikan ke fungsi bottomsheet dan akan teredit

  void showBottomSheet(int? id) async {
    if (id != null) {
      final existingData = allData.firstWhere((element) => element['id'] == id);
      titleController.text = existingData['title'];
      descController.text = existingData['desc'];
    }

    showModalBottomSheet(
        elevation: 5,
        isScrollControlled: true,
        context: context,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 30,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 50,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: descController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (id != null) {
                          await addData();
                        }
                        if (id != null) {
                          await updateData(id);
                        }

                        titleController.text = "";
                        descController.text = "";

                        //hide bottom sheet
                        Navigator.of(context).pop();
                        print("Data berhasil ditambahkan");
                      },
                      child: Padding(
                        padding: EdgeInsets.all(18),
                        child: Text(
                          id != null ? 'Update' : 'Add Data',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('CRUD OPERATION'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: allData.length,
              itemBuilder: (context, index) => Card(
                margin: EdgeInsets.all(15),
                child: ListTile(
                  title: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      allData[index]['title'],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      allData[index]['desc'],
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showBottomSheet(allData[index]['id']);
                        },
                        icon: Icon(Icons.edit),
                        color: Colors.greenAccent,
                      ),
                      IconButton(
                        onPressed: () {
                          deleteData(allData[index]['id']);
                        },
                        icon: Icon(Icons.delete),
                        color: Colors.redAccent,
                      ),
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomSheet(null);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
