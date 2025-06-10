import 'package:breath_bank/constants/constants.dart';
import 'package:breath_bank/constants/strings.dart';
import 'package:breath_bank/widgets/image.dart';
import 'package:flutter/material.dart';

class PageContent extends StatelessWidget {
  const PageContent({
    super.key,
    this.routeName = '',
    required this.titleText,
    required this.descText,
    required this.imagePath,
    required this.imageWidth,
    required this.imageHeight,
    this.args = const {},
    this.isLastPage = false,
  });

  final String routeName;
  final String titleText;
  final String descText;
  final String imagePath;
  final double imageWidth;
  final double imageHeight;
  final Map<String, dynamic> args;
  final bool isLastPage;

  static const TextStyle titlesStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: kPrimaryColor,
  );

  static const TextStyle descStyle = TextStyle(
    fontSize: 14,
    color: kPrimaryColor,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(titleText, style: titlesStyle, textAlign: TextAlign.center),
          ImageWidget(
            imageWidth: imageWidth,
            imageHeight: imageHeight,
            photoString: imagePath,
          ),
          Text(descText, style: descStyle, textAlign: TextAlign.justify),
          if (isLastPage) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, routeName, arguments: args);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  Strings.startInvestment,
                  style: TextStyle(fontSize: 16, color: kWhiteColor),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
