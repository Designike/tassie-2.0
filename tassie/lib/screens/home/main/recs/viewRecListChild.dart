import 'package:flutter/material.dart';
import 'package:tassie/constants.dart';

class MyBullet extends StatelessWidget {
  const MyBullet({required this.index, Key? key}) : super(key: key);
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
      style: const TextStyle(fontSize: 30.0, color: kPrimaryColor),
    );
  }
}

class StepIngImage extends StatefulWidget {
  const StepIngImage(
      {Key? key,
      required this.index,
      required this.text,
      required this.count,
      // required this.size,
      required this.isImage,
      required this.url,
      required this.storedFuture})
      : super(key: key);
  final int index;
  final int count;
  final String text;
  final bool isImage;
  // final Size size;
  final String Function(int) url;
  final Future Function(int) storedFuture;

  @override
  StepIngImageState createState() => StepIngImageState();
}

class StepIngImageState extends State<StepIngImage> {
  late Future _storedFuture1;
  bool _isLoading1 = true;
  Future<void> _getImage() async {
    // _storedFuture1 = loadImg(widget.url(widget.index), _memoizer1);
    // _storedFuture1 = widget.storedFuture(widget.index);
    if (mounted) {
      setState(() {
        _storedFuture1 = widget.storedFuture(widget.index);
        _isLoading1 = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getImage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return (_isLoading1)
        ? const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          )
        : Column(
            children: [
              ListTile(
                leading: MyBullet(index: (widget.index + 1).toString()),
                title: Text(widget.text),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
              ),
              !widget.isImage
                  ? const SizedBox(
                      height: 0,
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: SizedBox(
                          width: size.width - (2 * kDefaultPadding),
                          height: size.width - (2 * kDefaultPadding),
                          // child: Image(
                          //   // image: NetworkImage(url),
                          //   image:
                          //       NetworkImage('https://picsum.photos/200'),
                          //   fit: BoxFit.cover,
                          // ),
                          child: FutureBuilder(
                              future: _storedFuture1,
                              builder:
                                  (BuildContext context, AsyncSnapshot text) {
                                if ((text.connectionState ==
                                        ConnectionState.waiting) ||
                                    text.hasError) {
                                  return Image.asset(
                                      "assets/images/broken.png");
                                } else if (text.hasError) {
                                  return Image.asset(
                                      "assets/images/broken.png");
                                } else {
                                  if (!text.hasData) {
                                    return const Center(
                                      child: Icon(
                                        Icons.refresh,
                                        size: 50.0,
                                        color: kDark,
                                      ),
                                    );
                                  }
                                  return GestureDetector(
                                    onTap: () {},
                                    child: Image(
                                      image: NetworkImage(text.data.toString()),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }
                              }),
                        ),
                      ),
                    ),
              if (widget.index != widget.count - 1) ...[
                const SizedBox(
                  height: 15.0,
                ),
                const Divider(
                  thickness: 1.0,
                )
              ],
            ],
          );
  }
}
