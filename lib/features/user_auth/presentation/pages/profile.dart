import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wisemoney/features/user_auth/presentation/pages/rate_app_screen.dart';
import 'package:share_plus/share_plus.dart';

import '../widgets/UserBalanceWidget.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  double userBalance = 100.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        toolbarHeight: 150,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 25),
            const CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 35,
              child: Text('A'),
            ),
            const SizedBox(width: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      'John',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Doe',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
                UserBalanceWidget(userBalance: userBalance),
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
                    Icons.add, ''),
                const SizedBox(height: 15),
                listViewContainer(
                    getOptionsTitle('Рекомендовать друзьям'), Icons.share, 'share'),
                listViewContainerForRating(
                    getOptionsTitle('Оцените приложение'), Icons.star, 'rate_app'),
                listViewContainerForBlocADS(
                    getOptionsTitle('Блокировать рекламу'), Icons.block, 'block_ads'),
                listViewContainer(getOptionsTitle('Настройки'), Icons.settings, ''),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector listViewContainerForBlocADS(Widget title, IconData icon, String tag) {
    return GestureDetector(
      onTap: () {
        if (tag == 'block_ads') {
          showBlockAdsDialog();
        }
      },
      child: Container(
        height: 65,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(color: CupertinoColors.systemGrey6),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          leading: listTileLeading(icon),
          title: title,
          trailing: listTileRightArrow(),
        ),
      ),
    );
  }
  GestureDetector listViewContainer(Text text, IconData icon, String route) {
    return GestureDetector(
      onTap: () {
        if (route == 'share') {
          String shareLink = 'https://example.com/app?referral=john_doe';

          Share.share(shareLink, subject: 'Check out this app!');
        }
      },
      child: Container(
        height: 65,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(color: CupertinoColors.systemGrey6),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          leading: listTileLeading(icon),
          title: text,
          trailing: listTileRightArrow(),
        ),
      ),
    );
  }


    GestureDetector listViewContainerForRating(Text text, IconData icon, String route) {
    return GestureDetector(
      onTap: () {
        if (route == 'rate_app') {
          // Навигация на новую страницу
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RateAppScreen()),
          );
        }
      },
      child: Container(
        height: 65,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(color: CupertinoColors.systemGrey6),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          leading: listTileLeading(icon),
          title: text,
          trailing: listTileRightArrow(),
        ),
      ),
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
  void showBlockAdsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Блокировать рекламу'),
          content: const Text('Вы хотите заблокировать рекламу за \$4.99?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалог
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                if (userBalance >= 4.99) {
                  // Вычитаем стоимость блокировки рекламы из баланса пользователя
                  setState(() {
                    userBalance -= 4.99;
                  });
                  // Здесь вы можете реализовать логику для блокировки рекламы
                  Navigator.of(context).pop(); // Закрыть диалог
                } else {
                  // Показать сообщение о недостаточном балансе
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Недостаточно средств'),
                        content: const Text('У вас недостаточно средств для блокировки рекламы.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Закрыть диалог
                            },
                            child: const Text('ОК'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Купить'),
            ),
          ],
        );
      },
    );
  }
}
