import 'dart:convert';

import 'package:flutter/foundation.dart';
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
  // late Future<List<Item>> items;
  // final studentListKey = GlobalKey<_DashboardState>();

  // @override
  // void initState() {
  //   super.initState();
  //   items = getItemList();

  // }

  //getData API
  // Future<List<Item>> getItemList() async {
  //   final response = await http.get(Uri.parse("${Env.URL_PREFIX}/getdata.php"));
  //   final items = json.decode(response.body).cast<Map<String, dynamic>>();
  //   List<Item> subItem = items.map<Item>((json) {
  //     return Item.fromJson(json);
  //   }).toList();

  //   return items.map<Item>((json)=>Item.fromJson(json)).toList();
  // }

  Future<List<Item>> fetchItem(http.Client client) async {
    final response =
        await client.get(Uri.parse("${Env.URL_PREFIX}/getdata.php"));

    // Use the compute function to run parsePhotos in a separate isolate.
    return parseItem(response.body);
  }

  List<Item> parseItem(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Item>((json) => Item.fromJson(json)).toList();
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item List'),
      ),
      body: FutureBuilder<List<Item>>(
        future: fetchItem(http.Client()),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? ItemList(
                  items: snapshot.data!,
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List<Item> items;

  ItemList({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Text(items[index].item_name);
      },
    );
  }
}
