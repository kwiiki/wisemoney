import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        toolbarHeight: 150,
        title: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 25),
            CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 35,
              child: Text('A'),
            ),
            SizedBox(width: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('John',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25)),
                    SizedBox(width: 5),
                    Text('Doe',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25)),
                  ],
                ),
                Row(
                  children: [Text('ID:000000', style: TextStyle(fontSize: 15))],
                )
              ],
            )
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                listViewContainer(
                    const Text('Премиум участник',
                        style: TextStyle(
                            fontSize: 20,
                            letterSpacing: -1,
                            fontWeight: FontWeight.bold)),
                    Icons.add),
                const SizedBox(height: 15),
                listViewContainer(
                    getOptionsTitle('Рекомендовать друзьям'), Icons.share),
                listViewContainer(
                    getOptionsTitle('Оцените приложение'), Icons.star),
                listViewContainer(
                    getOptionsTitle('Блокировать рекламу'), Icons.block),
                listViewContainer(getOptionsTitle('Настройки'), Icons.settings),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container listViewContainer(Text text, IconData icon) {
    return Container(
      height: 65,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: CupertinoColors.systemGrey6),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
          leading: listTileLeading(icon),
          title: text,
          trailing: listTileRightArrow()),
    );
  }

  Icon listTileRightArrow() {
    return const Icon(
      Icons.chevron_right,
      size: 35,
      color: Colors.black38,
    );
  }

  Icon listTileLeading(IconData icon) {
    return Icon(
      icon,
      color: Colors.orangeAccent,
      size: 35,
    );
  }

  getOptionsTitle(String s) {
    return Text(s,
        style: const TextStyle(
            fontSize: 18, letterSpacing: -1, color: Colors.black54));
  }
}
