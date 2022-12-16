



// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'dart:typed_data';

import 'package:example_test/components/show_dialog_item.dart';
import 'package:example_test/screens/bluetooth_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';

class ScreenShotTextScreen extends StatefulWidget {
  String text ;

  ScreenShotTextScreen ({required this.text  });

  @override
  State<ScreenShotTextScreen> createState() => _ScreenShotTextScreenState();
}

class _ScreenShotTextScreenState extends State<ScreenShotTextScreen> {
  Uint8List? imageFile;
  ScreenshotController screenshotController = ScreenshotController();

  
  @override
  void initState() {
    super.initState();
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue ,
        title: const Text('Screen Shot') ,
        centerTitle: true ,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        } , icon: const Icon(Icons.arrow_back_ios) ),
      ),
      backgroundColor: Colors.white ,
      body : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all( 20 ),
                
                color: Colors.white ,
                child: Text(
                widget.text ,      
                style:  const TextStyle( color: Colors.black , fontSize: 18 , fontWeight: FontWeight.w400  )),
              ),
            ),
            const SizedBox(height: 15 ),
    
            Row(
              children: [
                InkWell(
                  onTap: (){
                    takeScreenShot();
                    showDialogs(title: 'Screen Shot', content: 'take screen shot is Success', color: Colors.green,
                      context: context
                    );
                  } ,
                  child: ClipRRect(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                       padding: const EdgeInsets.all(10),
                      color: Colors.blue ,
                      child: const Text('take screen shot' , style: TextStyle( color: Colors.white , fontSize: 18 ), ) ,
                    ),
                  ),
                ),
                const Spacer(),
                     
                     InkWell(
                  onTap: (){
                     if ( imageFile != null ) {
                      Navigator.push(context, MaterialPageRoute( builder: (context) => BluetoothScreen(printImage: imageFile!,)));
                     } else {
                         showDialogs(title: 'Take Screen Shot', content: 'please , take Screen shot To Print image ?',
                          color: Colors.red ,
                           context : context
                           );
                     }
                  } ,
                  child: ClipRRect(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                    color: Colors.deepOrange ,
                    child: const Text('Next' , style: TextStyle( color: Colors.white , fontSize: 18   ), ) ,
                  ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void saveImageToGallery ( Uint8List image ) async{
     var saveImage = await ImageGallerySaver.saveImage( image  , quality: 90 , name: 'screenshot-${DateTime.now()}.png'   );
   }

   void takeScreenShot () {
    screenshotController.captureFromWidget(
      Container(
      padding: const EdgeInsets.only( top: 50 , bottom: 30 , left: 40 , right: 40 ),
      
      color: Colors.white ,
      child: Text(
      widget.text ,      
      style:  const TextStyle( color: Colors.black , fontSize: 18 , fontWeight: FontWeight.w400  )),
    ),
    ).then((value) {
         imageFile = value ;
         saveImageToGallery(value);   
    } );
   }
   
  

}