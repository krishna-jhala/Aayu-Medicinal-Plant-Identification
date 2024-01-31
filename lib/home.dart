import 'dart:convert';
import 'dart:io';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'output.dart';
import 'constraints.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  File? file;
  String selectedImagePath = '';
  String prediction = '';
  var confidence;

  var _recognitions;
  var v = "";
  List? rec;

  @override
  void initState() {
    super.initState();
    loadmodel().then((value) {
      setState(() {});
    });
  }


  loadmodel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  Future<void> _pickImagefromgallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        file = File(image!.path);
        selectedImagePath = image.path;
        print(file);
      });
      detectimage(file!);
    } catch (e) {
      print('Error picking image: $e');
    }
    
  }

  Future<void> _pickImagefromcamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      setState(() {
        _image = image;
        file = File(image!.path);
        selectedImagePath = image.path;
        print(file);
      });

      detectimage(file!);
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future detectimage(File image) async {
    int startTime = new DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _recognitions = recognitions;
      v = recognitions.toString();
      prediction = recognitions?[0]['label'];
      confidence = recognitions?[0]['confidence'];
      confidence = confidence*100;
      confidence = confidence.toStringAsFixed(2);
      // confidence = (confidence*100).toString();
      print(recognitions?[0]['label']);
      // var dataList = List<Map<String, dynamic>>.from(jsonDecode(v));
    });
    print("//////////////////////////////////////////////////");
    print(_recognitions);
    // print(dataList);
    print("//////////////////////////////////////////////////");
    int endTime = new DateTime.now().millisecondsSinceEpoch;
    print("Inference took ${endTime - startTime}ms");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
      backgroundColor: Colors.black,
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: DarkGreen,
          color: DarkGreen,
          items: [
            CurvedNavigationBarItem(
              child: Icon(Icons.explore, color: Colors.white, size: 30,),
              label: 'Explore',labelStyle: TextStyle(color: Colors.white,
            fontWeight: FontWeight.bold)
            ),
            CurvedNavigationBarItem(
                child: Icon(Icons.home_outlined, color: Colors.white,size: 30,),
                label: 'Home',labelStyle: TextStyle(color: Colors.white,
                fontWeight: FontWeight.bold)
            ),
            CurvedNavigationBarItem(
                child: Icon(Icons.person, color: Colors.white,size: 30,),
                label: 'Account',labelStyle: TextStyle(color: Colors.white,
                fontWeight: FontWeight.bold)
            ),
          ],
          onTap: (index){},
        ),

        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height*1,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/leaf.jpg'),fit: BoxFit.cover,
                      opacity: 0.5)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    SizedBox(height: MediaQuery.of(context).size.height*0.1,),
                    Text("Plant Identification",style: TextStyle(
                        fontSize: 35, color: Colors.white , decoration: TextDecoration.none,
                        fontWeight: FontWeight.w900,
                        fontFamily: CupertinoIcons.iconFont
                    ),),

                    Text("Identify and Learn",style: TextStyle(
                    fontSize: 15, color: Colors.white , decoration: TextDecoration.none
                    ) ),

                    SizedBox(height: MediaQuery.of(context).size.height*0.06,),

                    (selectedImagePath == '') ?
                    Container(
                        child: Image.asset('assets/images/searchimage.png',fit: BoxFit.fill),
                        height: MediaQuery.of(context).size.height*0.3,
                        width: MediaQuery.of(context).size.width*0.6,
                        decoration: BoxDecoration(border: Border.all(width: 10,
                          strokeAlign: BorderSide.strokeAlignOutside,color: Colors.white,),
                            boxShadow: [
                                    BoxShadow(color: Gray,
                                        blurRadius: 15.0,
                                        spreadRadius: 8.0,
                                        offset: Offset(1, 1),blurStyle: BlurStyle.outer
                                    ),
                                    BoxShadow(color: LightGreen,
                                        blurRadius: 1.0,
                                        spreadRadius: 1.0,
                                        offset: Offset(0, 0)
                                    ),
                                  ],
                                  borderRadius: BorderRadius.all(Radius.circular(50))
                        )):

                    Container(child: Image.file(File(selectedImagePath),fit: BoxFit.contain,),
                        height: MediaQuery.of(context).size.height*0.3,
                        width: MediaQuery.of(context).size.width*0.6,

                        decoration: BoxDecoration(border: Border.all(width: 10,
                          strokeAlign: BorderSide.strokeAlignOutside,color: Colors.white,),
                            boxShadow: [
                              BoxShadow(color: Gray,
                                  blurRadius: 15.0,
                                  spreadRadius: 8.0,
                                  offset: Offset(1, 1),blurStyle: BlurStyle.outer
                              ),
                              BoxShadow(color: LightGreen,
                                  blurRadius: 1.0,
                                  spreadRadius: 1.0,
                                  offset: Offset(0, 0)
                              ),
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(50))
                        )),

                    SizedBox(height: MediaQuery.of(context).size.height*0.04,),
                    
                    Container(child: Builder(
                      builder: (context) {
                        return ElevatedButton(onPressed:(){

                          showDialog(context: context, builder: (BuildContext context){

                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)
                              ),
                              child: Container(
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      Text("Select Image from !" , style: TextStyle(
                                          fontSize: 20.0, fontWeight: FontWeight.bold,
                                        color: Colors.white
                                      ),),
                                      SizedBox(height: 8,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            child: Card(
                                              elevation: 5,
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Column(children: [
                                                  Icon(Icons.image_outlined, size: 60),
                                                  Text("Gallery")
                                                ],),
                                              ),
                                            ),
                                            onTap: (){
                                              _pickImagefromgallery();
                                                Navigator.pop(context);
                                            }

                                          ),

                                          GestureDetector(
                                            child: Card(
                                              elevation: 5,
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Column(children: [
                                                  Icon(Icons.camera_alt_outlined, size: 60),
                                                  Text("Camera")
                                                ],),
                                              ),
                                            ),
                                            onTap:(){
                                              _pickImagefromcamera();
                                              Navigator.pop(context);
                                            }
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: DarkGreen,
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                                ),
                              ),
                            );

                          });

                        }

                        ,child: Icon(Icons.camera_alt, size: 30, color: Colors.white,),
                          style: ElevatedButton.styleFrom(backgroundColor: DarkGreen),
                        );
                      }
                    ),
                      width: 80, height: 80,
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50)),
                        boxShadow: [
                          BoxShadow(color: Colors.green,
                              blurRadius: 18.0,
                              spreadRadius: 0.1,
                              offset: Offset(1, 1),blurStyle: BlurStyle.outer
                          ),
                          BoxShadow(color: Colors.white,
                              blurRadius: 15.0,
                              spreadRadius: 1.0,
                              offset: Offset(0, 0)
                          ),
                        ],),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height*0.05,),


                    (prediction != '')?
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width*0.7,
                          height: MediaQuery.of(context).size.height*0.05,

                          decoration: BoxDecoration(
                            color: DarkGreen,
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                          ),
                          child: Center(child: Text("${prediction}", style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white
                          ),)),
                        ),
                        Container(child: Center(
                          child: Text("Confidence Score : ${confidence}%",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                          fontSize: 20),),
                        ),),
                        SizedBox(height: 12,),

                         Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                           children: [
                            TextButton(onPressed: (){
                              setState(() {
                                selectedImagePath = '';
                                prediction = '';
                              });
                            }, child: Text("<- Reset", style: TextStyle(
                              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold
                            ),)),
                            TextButton(onPressed: (){}, child: Text("View Details ->", style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white

                            ),))],),],): Text("Click above to select Image", style: TextStyle(
                      color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,
                    ),)

                  ],),)),),),

      debugShowCheckedModeBanner:  false,
    );}}







