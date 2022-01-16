// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tassie/screens/home/viewRecPost.dart';

import '../../constants.dart';

class RecPost extends StatefulWidget {
  const RecPost({
    required this.index,
    required this.recs,
  });

  final List recs;
  final int index;

  @override
  _RecPostState createState() => _RecPostState();
}

class _RecPostState extends State<RecPost> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List recs = widget.recs;
    int index = widget.index;
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        height: ((size.width - 40.0)/2) + 50.0, // minus padding, plus list tile
        decoration: BoxDecoration(
          color: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? kDark[900]
              : kLight,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Column(
          children: [
            Column(
              children: [
                
                InkWell(
                  onDoubleTap: () => print('Bookmark recipe'),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    width: double.infinity,
                    height: ((size.width - 40.0)/2) - 20, // minus padding, minus margin
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      image: DecorationImage(
                        image: NetworkImage(recs[index]['url']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  dense: true,
                  leading: Container(
                    width: (size.width - 40.0)/12,
                    height: (size.width - 40.0)/12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      child: ClipOval(
                        child: Image(
                          height: (size.width - 40.0)/12,
                          width: (size.width - 40.0)/12,
                          image: NetworkImage(recs[index]['profilePic']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.bookmark_border),
                    // color: Colors.black,
                    onPressed: () => print('Bookmark recipe'),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) => ViewRecPost(
                        //       recs: recs[index],
                        //     ),
                        //   ),
                        // );
                  },
                  child: ListTile(
                    title: Text(
                      recs[index]['name'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      recs[index]['username'],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: MediaQuery.of(context).platformBrightness ==
                                  Brightness.dark
                              ? kLight
                              : kDark[900]),
                    ),
                    isThreeLine: true,
                   
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 20.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Row(
                //         children: [
                //           Row(
                //             children: [
                //               IconButton(
                //                 icon: Icon(Icons.favorite_border),
                //                 iconSize: 30.0,
                //                 onPressed: () => print('Like post'),
                //               ),
                //               Text(
                //                 '2,515',
                //                 style: TextStyle(
                //                   fontSize: 14.0,
                //                   fontWeight: FontWeight.w600,
                //                 ),
                //               ),
                //             ],
                //           ),
                //           SizedBox(width: 20.0),
                //           Row(
                //             children: <Widget>[
                //               IconButton(
                //                 icon: Icon(Icons.chat),
                //                 iconSize: 30.0,
                //                 onPressed: () {
                //                   Navigator.push(
                //                     context,
                //                     MaterialPageRoute(
                //                       builder: (_) => ViewRecPost(
                //                         recs: recs[index],
                //                       ),
                //                     ),
                //                   );
                //                 },
                //               ),
                //               Text(
                //                 '350',
                //                 style: TextStyle(
                //                   fontSize: 14.0,
                //                   fontWeight: FontWeight.w600,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ],
                //       ),
                //       IconButton(
                //         icon: Icon(Icons.bookmark_border),
                //         iconSize: 30.0,
                //         onPressed: () => print('Save post'),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
            // Padding(
            //   padding:
            //       const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 20.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       // Text(
            //       //   recs[index]['description'],
            //       //   overflow: TextOverflow.ellipsis,
            //       //   textAlign: TextAlign.start,
            //       // ),
            //       Flexible(
            //         child: GestureDetector(
            //           onTap: () {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (_) => ViewRecPost(
            //                   recs: recs[index],
            //                 ),
            //               ),
            //             );
            //           },
            //           child: RichText(
            //             overflow: TextOverflow.ellipsis,
            //             text: TextSpan(
            //               children: [
            //                 TextSpan(
            //                   text: recs[index]['username'],
            //                   style: TextStyle(
            //                     fontWeight: FontWeight.bold,
            //                     color:
            //                         MediaQuery.of(context).platformBrightness ==
            //                                 Brightness.light
            //                             ? kDark[900]
            //                             : kLight,
            //                   ),
            //                 ),
            //                 TextSpan(text: " "),
            //                 TextSpan(
            //                   text: recs[index]['description'],
            //                   style: TextStyle(
            //                     color:
            //                         MediaQuery.of(context).platformBrightness ==
            //                                 Brightness.light
            //                             ? kDark[900]
            //                             : kLight,
            //                   ),
            //                 )
            //               ],
            //             ),
            //             textAlign: TextAlign.start,
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}