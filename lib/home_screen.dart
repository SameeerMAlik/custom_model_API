import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Models/posts_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //BUILD API
  List<PostsModel> postList =
      []; //we declare list os this postModel bcz array has no name in this api
  //future function bcz it has to wait first while loading api so
  Future<List<PostsModel>> getPostApi() async {
    final response = await http.get(
      Uri.parse("https://dummyjson.com/posts"),
    );

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      List<dynamic> posts = data['posts'];

      for (var i in posts) {
        postList.add(PostsModel.fromJson(i as Map<String, dynamic>));
      }

      return postList;
    } else {
      throw Exception("Failed to load posts");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text("REST API's"),
      ),
      body: Column(
        children: [
          //SHOW API
           Expanded(
             child: FutureBuilder(
              future: getPostApi(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  final data = snapshot.data!;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(data[index].title.toString()),
                        subtitle: Text(data[index].views.toString()),
                        leading: Text(data[index].id.toString()),


                      );
                    },
                  );
                }
              },
                       ),
           ),
        ],
      ),
    );
  }
}
