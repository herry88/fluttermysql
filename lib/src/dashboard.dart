import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttermysql/model/itemmodel.dart';

import '../const.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Future<List<Item>> items;
  final studentListKey = GlobalKey<_DashboardState>();

  @override
  void initState() {
    super.initState();
    items = getItemList();
  }

  //getData API
  Future<List<Item>> getItemList() async {
    final response = await http.get(Uri.parse("${Env.URL_PREFIX}/getdata.php"));
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<Item> items = items.map<Item>((json) {
      return Item.fromJson(json);
    }).toList();

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: studentListKey,
      appBar: AppBar(
        title: Text('Student List'),
      ),
      body: Center(
        child: FutureBuilder<List<Item>>(
          future: items,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // By default, show a loading spinner.
            if (!snapshot.hasData) return CircularProgressIndicator();
            // Render student lists
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                var data = snapshot.data[index];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.person),
                    trailing: Icon(Icons.view_list),
                    title: Text(
                      data.name,
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => Details(student: data)),
                      // );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Navigator.push(context, MaterialPageRoute(builder: (_) {
          //   return Create();
          // }));
        },
      ),
    );
  }
}