import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class ListWidget extends StatelessWidget {
  final Function itemBuilder;
  final int itemCount;
  final String emptyListImage;
  final String emptyListMessage;

  const ListWidget({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
    this.emptyListImage = '',
    this.emptyListMessage = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (itemCount > 0) {
      return ListView.builder(
        itemBuilder: (context, i) => itemBuilder(context, i),
        itemCount: itemCount,
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SvgPicture.asset(
            emptyListImage,
            height: 120,
          ),
          SizedBox(
            height: 15,
          ),
          Center(
            child: Text(
              emptyListMessage,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ],
      );
    }
  }
}
