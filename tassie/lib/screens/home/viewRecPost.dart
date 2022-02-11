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
  bool isSubscribed = true;
  bool isExpandedIng = false;
  bool isExpandedSteps = false;

  var ingredientPics = [
    {'index': '1', 'url': 'https://picsum.photos/200', 'fileID': 'abcd'},
    {'index': '3', 'url': 'https://picsum.photos/200', 'fileID': 'abcd'}
  ];

  var ingredients = [
    'henlooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo',
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

  Column myList(size, listItems, listImages, showMoreBtn, isIng) {
    return Column(
      children: [
        ListView.builder(
            padding: EdgeInsets.all(0.0),
            itemCount: listItems.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              String url = "";
              for (var i = 0; i < listImages.length; i++) {
                if (listImages[i]["index"] == (index + 1).toString()) {
                  url = listImages[i]['url'];
                }
              }
              return Column(
                children: [
                  ListTile(
                    leading: MyBullet(index: (index + 1).toString()),
                    title: Text(listItems[index]),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                  ),
                  url == ""
                      ? SizedBox(
                          height: 0,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: GestureDetector(
                            onTap: () {},
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: SizedBox(
                                width: size.width - (2 * kDefaultPadding),
                                height: size.width - (2 * kDefaultPadding),
                                child: Image(
                                  image: NetworkImage(url),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                  if (index != listItems.length - 1) ...[
                    SizedBox(
                      height: 15.0,
                    ),
                    Divider(
                      thickness: 1.0,
                    )
                  ],
                ],
              );
            }),
        showMoreBtn ?    
        TextButton.icon(
          icon: isIng
              ? isExpandedIng
                  ? Icon(Icons.keyboard_arrow_up_rounded)
                  : Icon(Icons.keyboard_arrow_down_rounded)
              : isExpandedSteps
                  ? Icon(Icons.keyboard_arrow_up_rounded)
                  : Icon(Icons.keyboard_arrow_down_rounded),
          label: isIng
              ? isExpandedIng
                  ? Text('Show less')
                  : Text('Show more')
              : isExpandedSteps
                  ? Text('Show less')
                  : Text('Show more'),
          onPressed: () {
            setState(() {
              if (isIng == true) {
                isExpandedIng = !isExpandedIng;
              } else {
                isExpandedSteps = !isExpandedSteps;
              }
            });
          },
          style: TextButton.styleFrom(primary: kPrimaryColor),
        ) : SizedBox(height: 0.0,),
      ],
    );
  }

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
              ),
            ),
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
                      Row(
                        children: [
                          Icon(Icons.timer),
                          SizedBox(
                            width: 5.0,
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '15',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: MediaQuery.of(context)
                                                .platformBrightness ==
                                            Brightness.dark
                                        ? kLight
                                        : kDark[900],
                                  ),
                                ),
                                TextSpan(
                                  text: 'm',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: MediaQuery.of(context)
                                                .platformBrightness ==
                                            Brightness.dark
                                        ? kLight
                                        : kDark[900],
                                  ),
                                ),
                              ],
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
                        trailing: isSubscribed
                            ? TextButton.icon(
                                icon: Icon(Icons.check_circle),
                                label: Text('SUBSCRIBED'),
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                    primary: kPrimaryColor),
                              )
                            : TextButton(
                                child: Text('SUBSCRIBE'),
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                    primary: kPrimaryColor),
                              ),
                      ),
                    ]),
              ),
            ),
            Divider(
              thickness: 5,
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ingredients',
                        style: TextStyle(
                          // color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      ingredients.length > 2
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  isExpandedIng = !isExpandedIng;
                                });
                              },
                              icon: isExpandedIng
                                  ? Icon(Icons.keyboard_arrow_up_rounded)
                                  : Icon(Icons.keyboard_arrow_down_rounded),
                              iconSize: 35.0,
                              padding: EdgeInsets.all(0.0),
                              color: kDark,
                            )
                          : SizedBox(
                              width: 0.0,
                            ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  // !isExpandedIng
                  //     ? ingredients.length > 2
                  //         ? myList(size, ingredients.sublist(0, 2),
                  //             ingredientPics, true, true)
                  //         : myList(
                  //             size, ingredients, ingredientPics, false, true)
                  //     : myList(size, ingredients, ingredientPics, true, true),

                    ingredients.length > 2
                    ? !isExpandedIng 
                        ? myList(size, ingredients.sublist(0, 2),
                            ingredientPics, true, true)
                        : myList(size, ingredients, ingredientPics, true, true)
                    : myList(
                              size, ingredients, ingredientPics, false, true),
                  // MyList(listItems: ingredients, listImages: ingredientPics)
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
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recipe steps',
                        style: TextStyle(
                          // color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      steps.length > 2 ? IconButton(
                        onPressed: () {
                          setState(() {
                            isExpandedSteps = !isExpandedSteps;
                          });
                        },
                        icon: isExpandedSteps
                            ? Icon(Icons.keyboard_arrow_up_rounded)
                            : Icon(Icons.keyboard_arrow_down_rounded),
                        iconSize: 35.0,
                        padding: EdgeInsets.all(0.0),
                        color: kDark,
                      ) : SizedBox(
                              width: 0.0,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  // !isExpandedSteps
                  //     ? steps.length > 2
                  //         ? myList(
                  //             size, steps.sublist(0, 2), stepPics, true, false)
                  //         : myList(size, steps, stepPics, false, false)
                  //     : myList(size, steps, stepPics, true, false),
                    
                    steps.length > 2
                    ? !isExpandedSteps 
                        ? myList(size, steps.sublist(0, 2),
                            stepPics, true, false)
                        : myList(size, steps, stepPics, true, false)
                    : myList(
                              size, steps, stepPics, false, false),
                ],
              ),
            ),
            Divider(
              thickness: 5,
            ),
            SizedBox(
              height: 10.0,
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

// class MyList extends StatelessWidget {
//   MyList(
//       {required this.listItems,
//       required this.listImages,
//       required this.showMoreBtn,
//       required this.showLessBtn, required this.expandToggle});
//   final List<String> listItems;
//   final List<Map> listImages;
//   final bool showMoreBtn;
//   final bool showLessBtn;
//   final void Function() expandToggle;

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Column(
//       children: [
//         ListView.builder(
//             padding: EdgeInsets.only(bottom: 30.0),
//             itemCount: listItems.length,
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemBuilder: (context, index) {
//               String url = "";
//               for (var i = 0; i < listImages.length; i++) {
//                 if (listImages[i]["index"] == (index + 1).toString()) {
//                   url = listImages[i]['url'];
//                 }
//               }
//               return Column(
//                 children: [
//                   ListTile(
//                     leading: MyBullet(index: (index + 1).toString()),
//                     title: Text(listItems[index]),
//                     contentPadding:
//                         EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
//                   ),
//                   url == ""
//                       ? Container()
//                       : Padding(
//                           padding: const EdgeInsets.only(top: 10.0),
//                           child: GestureDetector(
//                             onTap: () {},
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(15.0),
//                               child: SizedBox(
//                                 width: size.width - (2 * kDefaultPadding),
//                                 height: size.width - (2 * kDefaultPadding),
//                                 child: Image(
//                                   image: NetworkImage(url),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                   if (index != listItems.length - 1) ...[
//                     SizedBox(
//                       height: 15.0,
//                     ),
//                     Divider(
//                       thickness: 1.0,
//                     )
//                   ],
//                 ],
//               );
//             }),
//           TextButton.icon(icon: Icon(Icons.keyboard_arrow_down_rounded),
//                                 label: Text('Show more'),
//                                 onPressed: expandToggle,
//                                 style: TextButton.styleFrom(
//                                     primary: kPrimaryColor),
//                               )
//       ],
//     );
//   }
// }

class MyBullet extends StatelessWidget {
  MyBullet({required this.index});
  final String index;
  @override
  Widget build(BuildContext context) {
    // return Container(
    //   height: 10.0,
    //   width: 10.0,
    //   decoration: BoxDecoration(
    //     color: kDark[800],
    //     shape: BoxShape.circle,
    //   ),
    // );
    return Text(
      index,
      style: TextStyle(fontSize: 30.0, color: kPrimaryColor),
    );
  }
}
