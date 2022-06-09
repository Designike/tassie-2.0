import 'package:flutter/material.dart';
import 'package:tassie/constants.dart';

class ExploreSearchHashtagTab extends StatefulWidget {
  const ExploreSearchHashtagTab(
      {required this.hashtags,
      required this.isEndT,
      required this.isLazyLoadingT,
      Key? key}): super(key: key);
  final List hashtags;
  final bool isEndT;
  final bool isLazyLoadingT;
  @override
  ExploreSearchHashtagTabState createState() => ExploreSearchHashtagTabState();
}

class ExploreSearchHashtagTabState extends State<ExploreSearchHashtagTab> {
  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Center(
        child: Opacity(
          opacity: widget.isLazyLoadingT ? 0.8 : 00,
          child: const CircularProgressIndicator(
            color: kPrimaryColor,
            strokeWidth: 2.0,
          ),
        ),
      ),
    );
  }

  Widget _endMessage() {
    return const Padding(
      padding: EdgeInsets.all(kDefaultPadding),
      child: Center(
        child: Opacity(
          opacity: 0.8,
          child: Text('That\'s all for now!'),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List hashtags = widget.hashtags;
    return ListView.builder(
      itemBuilder: (context, index) {
        return index == hashtags.length
            ? widget.isEndT
                ? _endMessage()
                : _buildProgressIndicator()
            : ListTile(
                title: Text(hashtags[index]['name']),
                leading: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: kDark),
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  padding: const EdgeInsets.all(5.0),
                  child: const Text(
                    '#',
                    style:
                        TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
                  ),
                ),
              );
      },
      itemCount: hashtags.length,
    );
  }
}
