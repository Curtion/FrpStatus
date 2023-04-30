import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'server_add.dart';

class ConfigServer extends StatefulWidget {
  const ConfigServer({super.key});

  @override
  State<ConfigServer> createState() => _ConfigServer();
}

class _ConfigServer extends State<ConfigServer> {
  List<String> _serverList = [];

  @override
  void initState() {
    super.initState();
    _loadServerList();
  }

  Future<void> _loadServerList() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _serverList = (prefs.getStringList('list') ?? <String>[]);
      debugPrint('serverList: $_serverList');
    });
  }

  Future<void> _delServer(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _serverList.removeAt(index);
      prefs.setStringList('list', _serverList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('服务器配置'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Search',
            onPressed: () {
              _navigateAndDisplaySelection(context, _loadServerList);
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          // 服务器列表
          Expanded(
            child: ListView.builder(
              itemCount: _serverList.length,
              itemBuilder: (BuildContext contextItemBuilder, int index) {
                return ListTile(
                  title: Text(jsonDecode(_serverList[index])['host']),
                  subtitle: Text(jsonDecode(_serverList[index])['user']),
                  // 删除和编辑服务器
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _navigateAndDisplaySelection(context, _loadServerList,
                              server: _serverList[index]);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _delServer(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _navigateAndDisplaySelection(
    BuildContext context, Future<void> Function() loadServerList,
    {String? server}) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ServerAdd(server: server)),
  );
  if (result == null) return;

  final prefs = await SharedPreferences.getInstance();
  List<String> serverList = prefs.getStringList('list') ?? <String>[];
  int maxId = 0;
  String id = (result as Map<String, String>)['id'] ?? '';
  if (id.isNotEmpty) {
    serverList.removeWhere((element) => jsonDecode(element)['id'] == id);
  } else {
    if (serverList.isNotEmpty) {
      maxId = serverList
          .map((e) => int.parse(jsonDecode(e)['id']))
          .reduce((value, element) => value > element ? value : element);
    }
    result['id'] = (maxId + 1).toString();
  }
  serverList.add(jsonEncode(result));
  prefs.setStringList('list', serverList);

  // ignore: use_build_context_synchronously
  if (!context.mounted) return;
  loadServerList();
}
