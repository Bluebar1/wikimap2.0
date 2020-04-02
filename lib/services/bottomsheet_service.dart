import 'package:flutter/material.dart';

class BottomSheetService {
  Future<Widget> showBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(208, 208, 208, 0),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(30),
                topRight: const Radius.circular(30),
              ),
            ),
            child: Center(child: Text('test')),
          );
        });
  }
}
