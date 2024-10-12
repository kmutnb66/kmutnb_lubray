import 'dart:io';

import 'package:flutter/material.dart';

ImageProvider imageProvider({File? file, String? url}) {
  ImageProvider? img;
  if (file == null) {
    img = NetworkImage(url == null ? '' : url);
  } else {
    img = FileImage(file);
  }
  return img;
}

Widget imagesNf(
    {String? path,
    File? pathFile,
    @required double? width,
    @required double? height,
    double radius = 20,
    double icWidth = 35,
    double icheight = 35,
    double icSize = 18,
    double icRadius = 100,
    IconData icon = Icons.camera_alt_rounded,
    IconData iconEmpty = Icons.image,
    String? iconImageEmpty,
    Color icColor = Colors.white,
    Color icBgColor = Colors.black,
    BoxFit fit = BoxFit.cover,
    bool icShow = false}) {
  return path!.isEmpty
      ? pathFile != null
          ? Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                      image:
                          DecorationImage(image: FileImage(pathFile), fit: fit),
                      borderRadius: BorderRadius.all(Radius.circular(radius))),
                ),
                Positioned(
                    bottom: -12,
                    right: -10,
                    child: icShow
                        ? Container(
                            width: icWidth,
                            height: icheight,
                            child: Icon(
                              icon,
                              size: icSize,
                              color: icColor,
                            ),
                            decoration: BoxDecoration(
                                color: icBgColor,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(icRadius))),
                          )
                        : Container())
              ],
            )
          : iconImageEmpty != null
              ? Container(
                  width: width,
                  height: height,
                  child: Image.asset('assets/icon/$iconImageEmpty'),
                )
              : Container(
                  width: width,
                  height: height,
                  child: Center(
                    child: Icon(
                      iconEmpty,
                      size: 30,
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(240, 240, 240, 1),
                      borderRadius: BorderRadius.all(Radius.circular(radius))),
                )
      : Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: FadeInImage.assetNetwork(
                width: width,
                height: height,
                placeholder: 'assets/images/loadding.gif',
                image: path,
                fit: fit,
                imageErrorBuilder: (context, error, stackTrace) {
                  return iconImageEmpty != null
                      ? Container(
                          width: width,
                          height: height,
                          child: Image.asset('assets/icon/$iconImageEmpty'),
                        )
                      : Container(
                          width: width,
                          height: height,
                          child: Center(
                            child: Icon(
                              Icons.hide_image,
                              size: 30,
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(240, 240, 240, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(radius))),
                        );
                },
              ),
            ),
            Positioned(
                bottom: -12,
                right: -10,
                child: icShow
                    ? Container(
                        width: icWidth,
                        height: icheight,
                        child: Icon(
                          icon,
                          size: icSize,
                          color: icColor,
                        ),
                        decoration: BoxDecoration(
                            color: icBgColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(icRadius))),
                      )
                    : Container())
          ],
        );
}
