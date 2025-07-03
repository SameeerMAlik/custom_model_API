import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api/Models/user_model.dart';

class UserModelApi extends StatefulWidget {
  const UserModelApi({super.key});

  @override
  State<UserModelApi> createState() => _UserModelApiState();
}

class _UserModelApiState extends State<UserModelApi> {
  List<UserModel> userList = []; //make list

  //MAke Future function for API
  Future<List<UserModel>> getUser() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
      headers: {'accept': 'application/json'},
    );
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (Map i in data) {
        userList.add(
          UserModel.fromJson(i),
        ); //add data from api to list in json format
      }
      return userList;
    } else {
      return throw Exception('Failed to load photos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Model Api'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getUser(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      return Padding(//gap betwwen cards
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.greenAccent,
                          borderOnForeground: true,
                          elevation: 50,
                          shadowColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),


                          child: Column(
                            children: [
                              ReusableRow(title: 'Name', value: snapshot.data![index].name.toString()),
                              ReusableRow(title: 'Email', value: snapshot.data![index].email.toString()),
                              ReusableRow(title: 'Address', value: snapshot.data![index].address.toString()),
                              ReusableRow(title: 'Address', value: snapshot.data![index].address.toString()),
                              ReusableRow(title: 'city', value: snapshot.data![index].address!.city.toString()),
                              ReusableRow(title: 'GEO_AREA', value: snapshot.data![index].address!.geo!.lat.toString()),


                            ],
                          ),
                        ),
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

//make reusable stateless widget as function
class ReusableRow extends StatelessWidget {
  String title,value;
  ReusableRow({super.key,required this.title,required this.value});


  @override
  Widget build(BuildContext context) {
    return Padding(//gap between rows
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
        Text(title,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
            Text(value,style: TextStyle(fontSize: 15,),),


          ],),
    )
    ;
  }
}
