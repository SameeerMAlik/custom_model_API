//APPLY THIS IF MODEL CANNOT BE MADE
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserApiWithoutModel extends StatefulWidget {
  const UserApiWithoutModel({super.key});

  @override
  State<UserApiWithoutModel> createState() => _UserApiWithoutModelState();
}

class _UserApiWithoutModelState extends State<UserApiWithoutModel> {
  var data;
  Future<void> getUSerApi() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
      // headers: {
      //   'Accept': 'application/json',
      // }
    );
    if (response.statusCode == 200) {
      data = jsonDecode(response.body.toString());
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Api Without Model'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getUSerApi(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  //loading state
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Column(
                          children:
                            [
                              ReusableRow(title: 'Name', value: data[index]['name'].toString()),
                            ReusableRow(title: 'UserName', value: data[index]['username'].toString()),
                            ReusableRow(title: 'zipcode', value: data[index]['address']['zipcode'].toString()),
                            ReusableRow(title: 'LAT', value: data[index]['address']['geo']['lat'].toString()),
                            ],
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

//function for reusability
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
    );
  }
}

