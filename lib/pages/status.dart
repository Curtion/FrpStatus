import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPage();
}

class _StatusPage extends State<StatusPage> {
  final List<String> _serverList = [];

  @override
  void initState() {
    super.initState();
    _loadServerList();
  }

  Future<void> _loadServerList() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      var data = (prefs.getStringList('list') ?? <String>[]);
      for (var element in data) {
        GetFrpStatusInfo(jsonDecode(element)).getInfo().then((value) {
          if (value != null) {
            var ele = jsonDecode(element);
            ele['status'] = value;
            _serverList.add(jsonEncode(ele));
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // 服务器列表
          Expanded(
            child: ListView.builder(
              itemCount: _serverList.length,
              itemBuilder: (BuildContext contextItemBuilder, int index) {
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                      padding: const EdgeInsets.all(19.0),
                      child: Wrap(
                        spacing: 8.0,
                        children: [
                          TextField(
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                              labelText: '服务器地址',
                              hintText: '服务器地址',
                              border: OutlineInputBorder(),
                            ),
                            controller: TextEditingController(
                                text: jsonDecode(_serverList[index])['host']),
                            readOnly: true,
                          ),
                          Text(
                              '版本:${jsonDecode(_serverList[index])['status']['version']}'),
                          Text(
                              '客户端总数:${jsonDecode(_serverList[index])['status']['client_counts'] ?? 0}'),
                          Text(
                              'TCP:${jsonDecode(_serverList[index])['status']['proxy_type_count']['tcp'] ?? 0}'),
                          Text(
                              'UDP:${jsonDecode(_serverList[index])['status']['proxy_type_count']['udp'] ?? 0}'),
                          Text(
                              'HTTP:${jsonDecode(_serverList[index])['status']['proxy_type_count']['http'] ?? 0}'),
                          Text(
                              'HTTPS:${jsonDecode(_serverList[index])['status']['proxy_type_count']['https'] ?? 0}'),
                        ],
                      )),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GetFrpStatusInfo {
  late Map<String, dynamic> server;

  GetFrpStatusInfo(this.server);

  getInfo() async {
    var url = Uri.parse('${server['host']}/api/serverinfo');
    var response = await http.get(url, headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode('${server['user']}:${server['pwd']}'))}'
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
}
