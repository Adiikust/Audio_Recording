import 'package:flutter/material.dart';

import 'Showdetails.dart';

class PatientDetails extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Voice Disorder",
      theme: ThemeData(primarySwatch: Colors.blue),
      home:  MyHomepage(),
    );
  }
}

class MyHomepage extends StatefulWidget {


  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  final TextEditingController _id = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _tpnumber = TextEditingController();
  final TextEditingController _birthday = TextEditingController();
  final TextEditingController _history = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Enter Patient Detail"),
        elevation: 0,
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(25),
              child: TextField(
                controller: _id,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Enter ID Number"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: TextField(
                controller: _name,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Enter Name"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: TextField(
                controller: _birthday,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Date of Birth"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: TextField(
                controller: _tpnumber,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Contact Number"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: TextField(
                controller: _history,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Medical Histort"),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => showdetails(
                            id: _id.text,
                            name: _name.text,
                            birthday: _birthday.text,
                            tpnumber: _tpnumber.text,
                            history: _history.text,
                          )),
                );
              },
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}

