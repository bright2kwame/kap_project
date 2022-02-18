import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:knowledge_access_power/model/tutorial_item.dart';
import 'package:knowledge_access_power/onboard/create_account_page.dart';
import 'package:knowledge_access_power/resources/image_resource.dart';
import 'package:knowledge_access_power/util/app_button_style.dart';
import 'package:knowledge_access_power/util/app_color.dart';
import 'package:knowledge_access_power/util/app_decoration.dart';
import 'package:knowledge_access_power/util/app_text_style.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({Key? key}) : super(key: key);

  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final controller = PageController(viewportFraction: 1, keepPage: true);
  final _pages = [
    TutorialItem(
        title: "Welcome To KAP",
        message: "Your Virtual Gift Voucher That Keeps on Giving",
        imageResource: ImageResource.onboardOne),
    TutorialItem(
        title: "Your Health",
        message: "A Gift That Gives Endless Options",
        imageResource: ImageResource.onboardTwo),
    TutorialItem(
        title: "Stay Informed",
        message: "A Gift That You Can Take Anywhere",
        imageResource: ImageResource.onboardThree),
  ];

  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _pages.length; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  List<Widget> _buildPages() {
    List<Widget> list = [];
    for (int i = 0; i < _pages.length; i++) {
      list.add(_sliderItem(_pages[i]));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 16.0 : 8.0,
      decoration: BoxDecoration(
        color:
            isActive ? AppColor.primaryDarkColor : AppColor.primaryLightColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Stack(
            children: [
              _createPagerContent(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: Container()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicator(),
                  ),
                  _actionContent()
                ],
              ),
            ],
          )),
    );
  }

  Widget _actionContent() {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(32),
      child: ElevatedButton(
        onPressed: () {
          _navigateToNextScreen();
        },
        child: const Text("Get Started"),
        style: AppButtonStyle.roundedColoredEdgeButton,
      ),
    );
  }

  Widget _createPagerContent() {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(_pages[_currentPage].imageResource),
        fit: BoxFit.cover,
      )),
      child: Stack(
        children: [
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: SafeArea(
                child: Image(
              image: AssetImage(ImageResource.appLogoPlain),
              height: 80,
              width: 100,
              fit: BoxFit.contain,
            )),
          ),
          PageView(
              physics: const ClampingScrollPhysics(),
              controller: controller,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: _buildPages())
        ],
      ),
    );
  }

  void _navigateToNextScreen() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const CreateAccountPage()));
  }

  Widget _sliderItem(TutorialItem tutorialItem) {
    return Container(
      padding: const EdgeInsets.only(top: 64, bottom: 200),
      decoration: AppDecoration.appBoardBackgroundDecoration,
      child: Column(
        children: [
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 32),
            child: Text(
              tutorialItem.title,
              textAlign: TextAlign.center,
              style: AppTextStyle.semiBoldTextStyle(Colors.white, 24.0),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 8, top: 8, left: 32, right: 32),
            child: Text(
              tutorialItem.message,
              textAlign: TextAlign.center,
              style: AppTextStyle.normalTextStyle(Colors.white, 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
