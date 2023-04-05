import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ConfigAbout extends StatelessWidget {
  ConfigAbout({super.key});

  final Uri _url = Uri.parse('https://3gxk.net');
  final Uri _url2 = Uri.parse('https://github.com/Curtion/FrpStatus');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('关于'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              // 分别指定四个方向的补白
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(
                '版本: V1.0.0',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const Padding(
              // 分别指定四个方向的补白
              padding: EdgeInsets.fromLTRB(0, 25, 0, 12.5),
              child: Text(
                '作者: Curtion',
                style: TextStyle(fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                }
              },
              child: const Text("https://3gxk.net",
                  style: TextStyle(fontSize: 14)),
            ),
            TextButton(
              child: const Text("https://github.com/Curtion/FrpStatus",
                  style: TextStyle(fontSize: 14)),
              onPressed: () async {
                if (!await launchUrl(_url2)) {
                  throw Exception('Could not launch $_url2');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
