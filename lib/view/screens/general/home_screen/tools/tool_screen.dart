

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_agri_farmers/constants/colors/constant_colors.dart';
import 'package:e_agri_farmers/helper/text_helper.dart';
import 'package:e_agri_farmers/router/route_paths.dart';
import 'package:e_agri_farmers/view/screens/general/home_screen/schemes/shemadata.dart';
import 'package:e_agri_farmers/view/screens/general/home_screen/techniques/techdata.dart';
import 'package:e_agri_farmers/view/screens/general/home_screen/tools/tooldata.dart';
import 'package:flutter/material.dart';

class ToolScreen extends StatefulWidget {
  const ToolScreen({Key? key}) : super(key: key);

  @override
  _AddCropScreenFarmerState createState() => _AddCropScreenFarmerState();
}

class _AddCropScreenFarmerState extends State<ToolScreen> {
  @override
  Widget build(BuildContext context) {
    fetchData(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Schema'),
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            }),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Center(
          child: yourAuctionWidgetCards(context)
        ),
      ),
    );
  }


  yourAuctionWidgetCards(BuildContext context) {
    return FutureBuilder<List<ToolData>>(
      future: fetchData(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ToolData>? data = snapshot.data;
          print(data?.length);
          return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: data?.length,
              itemBuilder: (BuildContext context, int index) {
                String? s = "nan";
                s = data?[index].name;
                return GestureDetector(
                  onTap: (){Navigator.pushNamed(context, RoutePaths.toolDetailScreen , arguments: {"data": data?[index]});},
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child : Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.all(15),
                            child: TextHelper.textWithColorSize(s!, 20, Colors.red , fontWeight: FontWeight.w700),
                          ),
                          Divider(
                              thickness: 1.2,
                              color: Colors.black
                          )
                        ],
                      )
                  ),
                );
              });
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default show a loading spinner.
        return Container(
          height: 20,
          width: 20,
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            backgroundColor: ConstantColors.mPrimaryColor,
          ),
        );
      },
    );
  }



  static Future<List<ToolData>> fetchData(
      BuildContext context) async {
    try {
      List<ToolData> mReturnVal = [];

      await FirebaseFirestore.instance
          .collection("instruments")
          .get()
          .then((element)  {
        for (var element in element.docs) {
          mReturnVal.add(ToolData.fromJson(element.data()));
        }
      });
      print(mReturnVal.length);
      return mReturnVal;
    } on SocketException {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("No internet Connection"),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something Went Wrong"),
      ));
    }
    return [];
  }
}

