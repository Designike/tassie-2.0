import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tassie/constants.dart';

class ViewRecPost extends StatefulWidget {
  const ViewRecPost({
    required this.recs,
  });
  final Map recs;
  @override
  _ViewRecPostState createState() => _ViewRecPostState();
}

class _ViewRecPostState extends State<ViewRecPost> {
  var ingredientPics = [
    {'index': '1', 'url': 'https://picsum.photos/200', 'fileID': 'abcd'},
    {'index': '3', 'url': 'https://picsum.photos/200', 'fileID': 'abcd'}
  ];

  var ingredients = [
    'henlo',
    'henlo',
    'henlo',
    'henlo',
    'henlo',
  ];

  var steps = [
    'henlo',
    'henlo',
    'henlo',
    'henlo',
    'henlo',
  ];

  var stepPics = [
    {'index': '1', 'url': 'https://picsum.photos/200', 'fileID': 'abcd'},
    {'index': '3', 'url': 'https://picsum.photos/200', 'fileID': 'abcd'}
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: kToolbarHeight * 1.1,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Theme.of(context).scaffoldBackgroundColor,
              statusBarIconBrightness:
                  MediaQuery.of(context).platformBrightness == Brightness.light
                      ? Brightness.dark
                      : Brightness.light),
        ),
        body: ListView(
          padding: EdgeInsets.only(top: 0),
          children: [
            GestureDetector(
                onTap: () {},
                child: Container(
                  width: size.width,
                  height: size.width,
                  child: Image(
                    image: NetworkImage('https://picsum.photos/200'),
                    fit: BoxFit.cover,
                  ),
                )),
            Transform.translate(
              offset: Offset(0, -20.0),
              child: Container(
                padding: EdgeInsets.all(kDefaultPadding),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        'Paneer Tikka',
                        style: TextStyle(
                          // color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: size.width * 0.7,
                            child: Wrap(
                              runSpacing: 10.0,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: OutlinedButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Lunch',
                                      style: TextStyle(color: kDark),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      padding: EdgeInsets.all(10.0),
                                      side: BorderSide(
                                        color: kDark,
                                        width: 1,
                                      ),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: OutlinedButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Main course',
                                      style: TextStyle(color: kDark),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      padding: EdgeInsets.all(10.0),
                                      side: BorderSide(
                                        color: kDark,
                                        width: 1,
                                      ),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: OutlinedButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Sweet',
                                      style: TextStyle(color: kDark),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      padding: EdgeInsets.all(10.0),
                                      side: BorderSide(
                                        color: kDark,
                                        width: 1,
                                      ),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 36.0,
                            width: 36.0,
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(color: Colors.red)),
                            child: ClipOval(
                              child: Container(
                                // padding: EdgeInsets.all(10.0),
                                color: Colors.red,
                                // height: 10.0,
                                // width: 10.0,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      ListTile(
                        minLeadingWidth: (size.width - 40.0) / 10,
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        leading: Container(
                          width: (size.width - 40.0) / 10,
                          height: (size.width - 40.0) / 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            child: ClipOval(
                              child: Image(
                                height: (size.width - 40.0) / 10,
                                width: (size.width - 40.0) / 10,
                                image:
                                    NetworkImage('https://picsum.photos/200'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          'Tassie',
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: TextButton(
                          child: Text('SUBSCRIBE'),
                          onPressed: () {},
                          style: TextButton.styleFrom(primary: kPrimaryColor),
                        ),
                      ),
                    ]),
              ),
            ),
            Divider(
              thickness: 5,
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              padding: EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ingredients',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  // ListView.builder(
                  //     padding: EdgeInsets.only(bottom: 30.0),
                  //     itemCount: ingredients.length,
                  //     shrinkWrap: true,
                  //     physics: NeverScrollableScrollPhysics(),
                  //     itemBuilder: (context, index) {
                  //       return ListTile(
                  //         leading: MyBullet(),
                  //         title: Text(listItems[index]),
                  //       );
                  //     })
                ],
              ),
            ),
            Divider(
              thickness: 5,
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              padding: EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recipe steps',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

// class TitleWithCustomUnderline extends StatelessWidget {
//   const TitleWithCustomUnderline({required this.text});

//   final String text;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 24,
//       child: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: kDefaultPadding / 4),
//             child: Text(
//               text,
//               style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   // color: kDark[900],
//                   color: kPrimaryColor),
//             ),
//           ),
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               height: 7,
//               margin: EdgeInsets.only(
//                 right: kDefaultPadding / 4,
//               ),
//               color: kDark.withOpacity(0.4),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

class MyList extends StatelessWidget {
  MyList({required this.listItems});
  final List<String> listItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          padding: EdgeInsets.only(bottom: 30.0),
          itemCount: listItems.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return ListTile(
              leading: MyBullet(),
              title: Text(listItems[index]),
            );
          }),
    );
  }
}

class MyBullet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10.0,
      width: 10.0,
      decoration: BoxDecoration(
        color: kDark[800],
        shape: BoxShape.circle,
      ),
    );
  }
}
