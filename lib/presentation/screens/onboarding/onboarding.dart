import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:traintastic/core/utils/constants/colors.dart';
import 'package:traintastic/presentation/screens/auth/login.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      showDoneButton: true,
      key: introKey,
      globalBackgroundColor: CColors.tertiary,
      allowImplicitScrolling: true,
      pages: [
        PageViewModel(
          title: "Welcome to Traintastic!",
          body: "Ride the Rails, Skip the Lines!",
          image: Image.asset(
            "assets/images/tren.png",
            width: 150,
          ),
        ),
        PageViewModel(
          title: "Book On the Go!",
          body: "Book your Train Rides, anywhere, everywhere!",
          image: SvgPicture.asset(
            "assets/images/booking.svg",
            width: 250,
          ),
        ),
        PageViewModel(
          title: "SKip the Line!",
          body: "Cut ahead of the Queue and Save your Time!",
          image: SvgPicture.asset(
            "assets/images/queue.svg",
            width: 250,
          ),
        ),
      ],
      onSkip: () => _onIntroEnd(context),
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      skipOrBackFlex: 1,
      nextFlex: 1,
      showBackButton: true,
      back: const Icon(CupertinoIcons.chevron_left),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(CupertinoIcons.chevron_right),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.all(12.0),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        color: CColors.secondary,
        activeSize: const Size(22.0, 10.0),
        activeShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
