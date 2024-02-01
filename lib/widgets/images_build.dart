import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trip_planner/database/db_helper.dart';

class ImagesGrid extends StatefulWidget {
  const ImagesGrid({super.key, this.TripData});
  final TripData;
  @override
  State<ImagesGrid> createState() => _ImagesGridState();
}

class _ImagesGridState extends State<ImagesGrid> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DatabaseHelper.instance.getImages(widget.TripData['id']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Erorr${snapshot.error}');
          } else {
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Container(
                color: Colors.amber,
              );
            }
            return Container(
              height: 250,
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  dynamic images = snapshot.data![index];
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(
                                File(images[DatabaseHelper.imageLocation])))),
                  );
                },
              ),
            );

         
          }
        });
  }
}
