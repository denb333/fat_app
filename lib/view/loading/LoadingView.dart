import 'package:fat_app/constants/routes.dart';
import 'package:flutter/material.dart';

class LoadingView extends StatefulWidget {
  final int duration;
  const LoadingView({Key? key, required this.duration}) : super(key: key);

  @override
  _LoadingViewState createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  int _progress = 0;

  @override
  void initState() {
    super.initState();
    _simulateLoading();
  }

  Future<void> _simulateLoading() async {
    for (int i = 0; i <= 50; i++) {
      await Future.delayed(const Duration(milliseconds: 30));
      setState(() {
        _progress = i;
      });
    }

    Navigator.of(context).pushNamedAndRemoveUntil(
      interactlearningpage,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.greenAccent,
              backgroundColor: Colors.blueGrey,
            ),
            const SizedBox(height: 20),
            //     Text('$_progress%'),
          ],
        ),
      ),
    );
  }
}
