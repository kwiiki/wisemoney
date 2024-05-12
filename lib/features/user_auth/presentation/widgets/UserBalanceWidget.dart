import 'package:flutter/material.dart';

class UserBalanceWidget extends StatefulWidget {
  final double userBalance;

  const UserBalanceWidget({Key? key, required this.userBalance})
      : super(key: key);

  @override
  _UserBalanceWidgetState createState() => _UserBalanceWidgetState();
}

class _UserBalanceWidgetState extends State<UserBalanceWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Баланс: \$${widget.userBalance.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }
}