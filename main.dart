import 'package:flutter/material.dart';

import 'material_basic.dart';
import 'list_basic.dart';
import 'callfakeapi.dart';
import 'form_basic.dart';
import 'cua_hang_demo.dart';
import 'bai_mau_cua_hang.dart';
import 'example.dart';
import 'Bai_tap_1.dart';
import 'kiem_tra_gk.dart';

void main() {
  runApp(Tin_tuc_demo());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget createColumn(String data, IconData icons){
    Color color = Colors.red;
    double size = 30;
    return Column(
      children: [
        Icon(
          icons,
          textDirection: TextDirection.ltr,
          color: color,
          size: size,
        ),
        Text(data,
          textDirection: TextDirection.ltr,
          style: TextStyle(
              color: color,
              fontSize: size
          ),
        )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            textDirection: TextDirection.ltr,
            children: [
              createColumn("Call", Icons.call),
              createColumn("Route", Icons.router),
              createColumn("Share", Icons.share)

            ],
          )
      ),
      decoration: BoxDecoration(
          color: Colors.white
      ),
      padding: EdgeInsets.all(50),
    );
  }

}