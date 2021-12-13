import 'package:flutter/material.dart';

class BottomSheetModel {
  create(BuildContext context, bool status, String message, bool reset,
      [int popCounter = 1]) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(message),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: status ? Colors.green : Colors.red),
                child: Text(
                  'OK',
                  style: const TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  if (status && reset) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false);
                  } else if (status && !reset) {
                    for (int k = 0; k < popCounter; k++) {
                      Navigator.pop(context);
                    }
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
