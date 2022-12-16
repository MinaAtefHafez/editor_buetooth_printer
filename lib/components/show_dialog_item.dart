




import 'package:flutter/material.dart';

void showDialogs ({
    required String title ,
    required String content ,
    required Color color , 
    required BuildContext context
  }) 
  {  
       showDialog(context: context, builder:  (context) {
        return AlertDialog(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        backgroundColor: color ,
        title: Text(title),
        content: SingleChildScrollView(
          child: Container(
            width: 200 ,
            height: 200 ,
            child: Text(content)),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          } , child: const Text('OK' , style: TextStyle(color: Colors.black ) , ) ),
        ],
       );
       });
   }