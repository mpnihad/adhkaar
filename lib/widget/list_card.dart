import 'package:adhkaar/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:loading/indicator/ball_grid_pulse_indicator.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

class ListCard extends StatelessWidget {
  final String image;
  final String title;
  final String date;
  final bool inverted;
  final Color prevColor;
  final Color palletcolor;

  const ListCard(
      {Key key,
      this.image,
      this.title,
      this.date,
      this.inverted = false,
      this.prevColor,
      this.palletcolor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!inverted) {
      return Padding(
        padding: const EdgeInsets.only(
            top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
          color: Colors.transparent,
          child: Neumorphic(
            boxShape: NeumorphicBoxShape.roundRect(
                borderRadius: BorderRadius.circular(6)),
            style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                depth: 5,
                intensity: 0.5,
                lightSource: LightSource.bottomRight,
                color: palletcolor,
                shadowDarkColor: palletcolor,
                shadowLightColor: palletcolor),
            child: Container(
              color: Colors.transparent,
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Neumorphic(
                      boxShape: NeumorphicBoxShape.roundRect(
                          borderRadius: BorderRadius.circular(8)),
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.concave,
                          depth: 3,
                          intensity: .4,
                          lightSource: LightSource.bottomRight,
                          color: palletcolor,
                          shadowLightColor: whitebg),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),

                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: CachedNetworkImage(
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            imageUrl: image,
                            placeholder: (context, url) => Material(
                              child: Container(
                                width: 5.0,
                                height: 10.0,
                                child: SizedBox(
                                    width: 10.0,
                                    height: 10.0,
                                    child:  Loading(indicator: BallGridPulseIndicator(), size: 10.0,color: Colors.black),),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                          ),
                        ),
//                    Image(
//
//                      image: AssetImage("assets/images/$image"),
//                      height: 100,
//                      fit: BoxFit.cover,
//                      width: 100,
//                    ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
//                      Container(
//                        width: 2,
//                        height: 40,
//                        color: Colors.black,
//                      ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
//                          Row(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Container(
//                                width: 10,
//                                height: 2,
//                                color: Colors.black,
//                              ),
//                              SizedBox(
//                                width: 5,
//                              ),
//                              Text(date.toUpperCase(),
//                                  style: TextStyle(fontSize: 10)),
//                            ],
//                          ),

                            SizedBox(
                              width: MediaQuery.of(context).size.width - 166,
                              child: Text(
                                title.toUpperCase().trim(),
                                style: TextStyle(
                                  fontFamily: "Butler",
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(0.2, 0.2),
                                      blurRadius: 1.0,
                                      color: blueGrey,
                                    ),
                                    Shadow(
                                      offset: Offset(0.2, 0.2),
                                      blurRadius: 2.0,
                                      color: blueGrey,
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),

                            SizedBox(
                              height: 8,
                            ),
                            Text("read more".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(0.2, 0.2),
                                      blurRadius: 1.0,
                                      color: blueGrey,
                                    ),
                                    Shadow(
                                      offset: Offset(0.2, 0.2),
                                      blurRadius: 2.0,
                                      color: blueGrey,
                                    ),
                                  ],
                                ))
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(
            top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
          color: Colors.transparent,
          elevation: 0.0,
          child: Neumorphic(
            boxShape: NeumorphicBoxShape.roundRect(
                borderRadius: BorderRadius.circular(6)),
            style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                depth: 5,
                intensity: .6,
                lightSource: LightSource.topLeft,
                color: Colors.white,
                shadowDarkColor: palletcolor,
                shadowDarkColorEmboss: palletcolor),
            child: Container(
              color: Colors.transparent,
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
//                    Padding(
//                      padding: const EdgeInsets.only(left:8.0),
//                      child: Container(
//                        width: 2,
//                        height: 40,
//                        color: Colors.black,
//                      ),
//                    ),
                      SizedBox(
                        width: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
//                        Row(
//                          crossAxisAlignment: CrossAxisAlignment.center,
//                          children: <Widget>[
//                            Container(
//                              width: 10,
//                              height: 2,
//                              color: Colors.black,
//                            ),
//                            SizedBox(
//                              width: 5,
//                            ),
//                            Text(date.toUpperCase(),
//                                style: TextStyle(fontSize: 10)),
//                          ],
//                        ),

                          SizedBox(
                            width: MediaQuery.of(context).size.width - 166,
                            child: Text(
                              title.toUpperCase().trim(),
                              style: TextStyle(
                                fontFamily: "Butler",
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(0.2, 0.2),
                                    blurRadius: 1.0,
                                    color: whitebg,
                                  ),
                                  Shadow(
                                    offset: Offset(0.2, 0.2),
                                    blurRadius: 2.0,
                                    color: whitebg,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "read more".toUpperCase(),
                            style:TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(0.2, 0.2),
                                  blurRadius: 1.0,
                                  color: whitebg,
                                ),
                                Shadow(
                                  offset: Offset(0.2, 0.2),
                                  blurRadius: 2.0,
                                  color: whitebg,
                                ),
                              ],
                            )
                          )
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Neumorphic(
                      boxShape: NeumorphicBoxShape.roundRect(
                          borderRadius: BorderRadius.circular(8)),
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.concave,
                          depth: 7,
                          intensity: .4,
                          lightSource: LightSource.bottomLeft,
                          color: palletcolor,
                          shadowLightColor: palletcolor),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),

                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: CachedNetworkImage(
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            imageUrl: image,
                            placeholder: (context, url) =>
                                new CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                          ),
                        ),
//                    Image(
//
//                      image: AssetImage("assets/images/$image"),
//                      height: 100,
//                      fit: BoxFit.cover,
//                      width: 100,
//                    ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
