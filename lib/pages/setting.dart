import 'package:flutter/material.dart';

import 'setting_about.dart';
import 'setting_server.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('服务器列表设置'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ConfigServer()));
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('关于'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ConfigAbout()));
          },
        ),
        const Divider(),
      ],
    );
  }
}
