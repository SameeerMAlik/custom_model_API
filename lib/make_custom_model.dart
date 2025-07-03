import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MakeCustomModel extends StatefulWidget {
  const MakeCustomModel({super.key});

  @override
  State<MakeCustomModel> createState() => _MakeCustomModelState();
}

class _MakeCustomModelState extends State<MakeCustomModel> {
  List<Photos> photosList =[];//make list of photos


  
Future<List<Photos>> getPhotos()async{
  
  final response =await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'),

    headers: {//make header for api to access the api data from internet to emulator
      'Accept': 'application/json',
    },);//get photos from api
  var data = jsonDecode(response.body.toString());//decode json data from api and store in data variable


  if (response.statusCode == 200){
    // print(response.statusCode);
    // print("Data length: ${data.length}");
    // print(response);
    for(Map i in data){
      //call constructor of photos and pass required arguments from api and store in photos_data variable .Photos is custom model
      Photos photosData= Photos(title: i["title"], url: i['url'], id: i['id']);
      photosList.add(photosData);//>>>>add/append photos_data in photosList
    }
    return photosList;//return photosList

  }
  else{
    return throw Exception('Failed to load photos');//if response.status code is not 200 then throw exception
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Models Api'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body:
      Column(
        children: [
          Expanded(
            // child: FutureBuilder<List<Photos>>(we can also use this
            child: FutureBuilder<List<Photos>>(//future builder is used to fetch data from api
              future: getPhotos(),
              //he snapshot is an object that contains the current state of the asynchronous operation — like fetching data from an API.
              //it contain all data from list now we can use it instead of photosList
              //   builder: (context, AsyncSnapshot<List<Photos>> snapshot) {can also use this
                builder: (context,  snapshot) {
                if (snapshot.hasData == false) {
                  return Center(child: CircularProgressIndicator());
                }
                else{
                 return ListView.builder(
                 itemCount: photosList.length,
                   // itemCount: snapshot.data!.length,
                 itemBuilder: (context, index) {
                   return ListTile(
                     leading: CircleAvatar(
                       backgroundImage: NetworkImage(snapshot.data![index].url.toString()),
                     ),
                   title:Text( snapshot.data![index].id.toString()),
                   subtitle:Text( snapshot.data![index].title.toString()),
                   );
                 },);
                  }}
                ),
          ),
        ],
      ),
    );
  }
}

//make custom model of Api
class Photos{
  String title;
      String url;
      int id;//only get title and url from api and make custom model
  Photos({required this.title,required this.url,required this.id});//make constructor of photos
}



