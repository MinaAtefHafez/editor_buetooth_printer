
// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:example_test/components/show_dialog_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BluetoothScreen extends StatefulWidget {
  
  Uint8List printImage ;
  BluetoothScreen({required this.printImage});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState(); 
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  List<BluetoothDevice> devices = []; 

  BluetoothDevice? selectedDevice ;
  BlueThermalPrinter printer = BlueThermalPrinter.instance ;
  
  
  
  void getDevices () async {
    devices = await printer.getBondedDevices(); 
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDevices();
  }

  @override
  void dispose() {
    super.dispose();
    disConnect ();
  }

  void disConnect ( ) async {
   await printer.disconnect();
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white ,
      floatingActionButton: FloatingActionButton(onPressed: ()  {
        print();
      } ,
       backgroundColor: Colors.blue , child: const Text('Print' , style: TextStyle(
      
      color: Colors.white 

      ),), ),
    appBar : AppBar(
        backgroundColor: Colors.blue ,
        title: const Text('Bluetooth Print') ,
        centerTitle: true ,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        } , icon: const Icon(Icons.arrow_back_ios) ),
      ),
         body: Padding(
           padding: const EdgeInsets.all(20.0),
           child: Column(
        
             children: [
               showSelectedDeviceItem(),
               Expanded(
                 child: ListView.builder(itemBuilder: (context ,index) {
                  return InkWell(
                    onTap: ()  {
                        connectWithDevice(device: devices[index]);
                    } ,
                    child: ListTile(
                         leading:  Icon(Icons.print , color: Colors.grey.shade400 ,size: 35,),
                          title: Text( devices[index].name! , style: const TextStyle(color: Colors.black ), ),
                          subtitle: Text(devices[index].address! , style:  TextStyle( color: Colors.grey.shade400  ), ),
                    ),
                  );
                 } ,
                  itemCount: devices.length,
                  ),
               ),
             ],
           ),
         ),
         
    );
   

  }

  Widget showSelectedDeviceItem () {
    return Padding(
      padding: const EdgeInsets.only(left: 40 , right: 40 , bottom: 30   ),
      child: Column(
        
        children: [ 
          ClipRRect(
              borderRadius: BorderRadius.circular(150.0),
             clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              width: 100 ,
              height: 100 ,
              color: Colors.blue ,
              child: Icon(Icons.bluetooth , color: Colors.white , size: 50 , ),
            )),
           const SizedBox(height: 15 ),
           
           
           Builder(builder: (context)  {
              if ( selectedDevice != null ) {
                return ListTile(
                           leading:  const Icon(Icons.print , color: Colors.green ,size: 45,),
                            title: Text( selectedDevice!.name! , style: const TextStyle(color: Colors.black ), ),
                            subtitle: Text(selectedDevice!.address! , style:  TextStyle( color: Colors.grey.shade400  ), ),
                      );
              } else {
                return Container();
              }
           }),

           const SizedBox(height: 15 ) ,
           Divider(height: 1 , color: Colors.grey.shade400 , ),
           
         ],
      ),
    );
  }
  
   void connectWithDevice ({
    required BluetoothDevice device
   }) async 
   {
           try {
                        selectedDevice = device;
                       await printer.connect(device);
                      setState(() {});
                      } catch (e) {
                         debugPrint(e.toString());
                         showDialogs(title: '', content: e.toString(), color: Colors.red, context: context);
                      }
   }

   void print () async {
    if ( (await printer.isConnected)! ) {
            try {
                await printer.printImageBytes(widget.printImage);
            } catch (e) {
                debugPrint(e.toString());
                showDialogs(title: '', content: e.toString(), color: Colors.red, context: context);
            } 
        } else {
          showDialogs(title: 'No Connected Device', content: 'please , choose device to Print ! ', color: Colors.red, context: context);
        }
   }

}




