import 'package:flutter/material.dart';

Future<bool?> confirmDialog(BuildContext context,
    {String prompt = 'Are you sure you want to delete?',
    String yesText = 'Yes',
    String noText = 'No'}) {
  return showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          icon: const Icon(
            Icons.info,
            color: Colors.grey,
          ),
          title: Text(
            prompt,
            style: TextStyle(color: Colors.white),
          ),
          content:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                  //INSERT DELETE FUNCTIONALITY HERE
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: SizedBox(
                  width: 60,
                  child: Text(
                    yesText,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                )),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: SizedBox(
                  width: 60,
                  child: Text(
                    noText,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                )),
          ]),
        );
      });
}
