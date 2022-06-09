import 'package:flutter/material.dart';
import 'package:tassie/constants.dart';

class ShowMoreText extends StatefulWidget {
  const ShowMoreText({ required this.text, Key? key}) : super(key: key);

  final String text;

  @override
  ShowMoreTextState createState() => ShowMoreTextState();
}

class ShowMoreTextState extends State<ShowMoreText> {
  String firstPart = "";
  String secondPart = "";
  bool isMore = false;
  @override
  void initState() {
    super.initState();
    
    if(widget.text.length > 100){
      firstPart = "${widget.text.substring(0,60)}...";
      secondPart = widget.text.substring(61, widget.text.length);
    } else {
      firstPart = widget.text;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondPart == "" ? Text(widget.text) : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isMore ? widget.text : firstPart),
          InkWell(child: Text( isMore ? 'Show less' : 'Show more', style: const TextStyle(color: kDark),), onTap: () {
            setState(() {
              isMore = !isMore;
            });
          },)
        ],
      ),
    );
  }
}