import 'package:flutter/material.dart';

mixin Alerts {

  Future<void> errorDialog(BuildContext context,{String title="Error", String content="Error"}) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(content),
        title: Text(title),
      ),
    );
  }

  Future<void> loadingDialog(BuildContext context) async{
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(height: 50,child: Row(
          children: [
            Center(child: CircularProgressIndicator()),
            SizedBox(width: 15,),
            Text("Loading")
          ],
        )),
        title: Text("Loading"),
      ),
    );
  }
}