// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MyCarousel extends StatelessWidget {
  final double caro_height;

  const MyCarousel({
    super.key,
    required this.caro_height,
  });
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        items: [
          Container(
              width: 380,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color.fromRGBO(117, 216, 216, 1),
                    width: 4,
                  )),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(
                        text: 'Pop Culture Exposed!!\n',
                        style: TextStyle(
                          fontSize: 18,
                          color: const Color.fromRGBO(117, 216, 216, 1),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text:
                            'A Fresh 6 Lawsuit has been filed recently against a popular rapper for allegedly assaulting college student and threatening to kill',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color.fromRGBO(117, 216, 216, 1),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          Container(
              width: 380,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color.fromRGBO(117, 216, 216, 1),
                    width: 4,
                  )),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(
                        text: 'Pop Culture Exposed!!\n',
                        style: TextStyle(
                          fontSize: 18,
                          color: const Color.fromRGBO(117, 216, 216, 1),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text:
                            'A Fresh 6 Lawsuit has been filed recently against a popular rapper for allegedly assaulting college student and threatening to kill',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color.fromRGBO(117, 216, 216, 1),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          Container(
              width: 380,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color.fromRGBO(117, 216, 216, 1),
                    width: 4,
                  )),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(
                        text: 'Pop Culture Exposed!!\n',
                        style: TextStyle(
                          fontSize: 18,
                          color: const Color.fromRGBO(117, 216, 216, 1),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text:
                            'A Fresh 6 Lawsuit has been filed recently against a popular rapper for allegedly assaulting college student and threatening to kill',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color.fromRGBO(117, 216, 216, 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ))
        ],
        options: CarouselOptions(
          height: caro_height,
          enableInfiniteScroll: true,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 5),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          pauseAutoPlayOnTouch: true,
          enlargeCenterPage: true,
        ));
  }
}
