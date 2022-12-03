
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trialing_api/src/presentation/movie_list_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
 late TextEditingController _controller;
 var _name;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      setState(() {
        _name = _controller.text;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcome to Omedia"),
            const Text("Please insert your name: "),
            Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                  controller: _controller,



                ),
              ]
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MovieListPage(title: 'OMEDIA', username: '${_name}',)));
              },
              child: const Text('Submit'),
            ),


          ],

        ),
      ),
    );
  }
}