import 'package:flutter/material.dart';


class SplacshScreen extends StatefulWidget {
  final Widget? child;
  const SplacshScreen({super.key, this.child});

  @override
  State<SplacshScreen> createState() => _SplacshScreenState();
}

class _SplacshScreenState extends State<SplacshScreen> {

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => widget.child!), (
          route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Welcome to MoneyWise",
          style: TextStyle(color: Colors.lightBlue, fontSize: 25),
        ),
      ),
    );
  }
}
