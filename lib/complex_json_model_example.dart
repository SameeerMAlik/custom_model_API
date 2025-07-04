import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'Models/complex_json_model.dart';

class ComplexJsonModelExample extends StatefulWidget {
  const ComplexJsonModelExample({super.key});

  @override
  State<ComplexJsonModelExample> createState() =>
      _ComplexJsonModelExampleState();
}

class _ComplexJsonModelExampleState extends State<ComplexJsonModelExample> {
  //Hit API
  Future<ComplexJsonModel> getComplexApi() async {
    final response = await http.get(
      Uri.parse('https://webhook.site/ded2ddec-4f5f-49e4-908a-4c22dade08c4'),
      // headers: {
      //   'Accept': 'application/json',//must be application json type of content
      // }
    );
    // print('Status: ${response.statusCode}');
    // print('Content-Type header: ${response.headers['content-type']}');
    // print('Body: ${response.body}');

    // print("enter");

    if (response.statusCode == 200) {
      // print("code 200");
      var data = jsonDecode(response.body.toString()); //convert to json

      return ComplexJsonModel.fromJson(data); //convert to model from json
    } else {
      return throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complex Json Model'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        titleTextStyle: GoogleFonts.sansita(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<ComplexJsonModel>(
              //pass model to fetch length
              future: getComplexApi(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot
                        .data!
                        .data!
                        .length, //from ComplexJsonModel data fetch length od data list/array
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                snapshot.data!.data![index].shop!.name
                                    .toString(),
                              ),
                              subtitle: Text(
                                snapshot.data!.data![index].shop!.shopemail
                                    .toString(),
                              ),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  snapshot.data!.data![index].shop!.image
                                      .toString(),
                                ),
                              ),
                            ),
                            //for images
                            Container(
                              // NOW MAKE THE  CONCEPT TO FETCH IMAGES LIST IN API CHECK IN BROWSER

                              ///Technically you need two layers of constraints:
                              //
                              // A parent that tells the list itself how tall it can be.
                              //
                              // A child that tells each item its own width/height.
                              ///screenSize.height * .3 = 30% of the screen’s height
                              //
                              // screenSize.width * .1 = 10% of the screen’s width
                              //
                              // This makes your widget responsive—no hard-coded “200px tall” or “50px wide.”
                              height: MediaQuery.of(context).size.height * .3,
                              width: MediaQuery.of(context).size.width * 1,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot
                                    .data!
                                    .data![index]
                                    .images!
                                    .length, //from data then images then fetch those images list length
                                itemBuilder: (context, position) {
                                  //change name of index to position bcz index is alredy use so mixup

                                  //this container is for  pictures
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                          .25,
                                      width:
                                          MediaQuery.of(context).size.width *
                                          .5,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,

                                          image: NetworkImage(
                                            //fetch image url of image list in api
                                            snapshot
                                                .data!
                                                .data![index]
                                                .images![position]
                                                .url
                                                .toString(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                           Icon( snapshot.data!.data![index].inWishlist! == true ? Icons.favorite_outlined : Icons.favorite_border_outlined),

                          ],
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
