import 'package:flutter/material.dart';

class ConfigAbout extends StatelessWidget {
  const ConfigAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('关于'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '作者: Curtion',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '网站: https://3gxk.net',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '版本: V1.0.0',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'https://github.com/Curtion/FrpStatus',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
