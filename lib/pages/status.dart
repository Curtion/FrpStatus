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
  List<String> _serverList = [];

  Future<dynamic> _getInfo(server) async {
    try {
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
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('错误'),
              content: Text(e.toString()),
              actions: <Widget>[
                TextButton(
                  child: const Text('确定'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  Future<void> _loadServerList() async {
    final prefs = await SharedPreferences.getInstance();
    var data = (prefs.getStringList('list') ?? <String>[]);
    var newServerList = <String>[];
    for (var element in data) {
      var value = await _getInfo(jsonDecode(element));
      debugPrint(value.toString());
      if (value != null) {
        var ele = jsonDecode(element);
        ele['status'] = value;
        newServerList.add(jsonEncode(ele));
      }
    }
    setState(() {
      _serverList = newServerList;
    });
  }

  String _formatTraffic(int num) {
    // num 字节
    return (num / 1024 / 1024).toStringAsFixed(2);
  }

  @override
  void initState() {
    super.initState();
    _loadServerList();
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
                        spacing: 12.0,
                        children: [
                          TextField(
                            style: const TextStyle(fontSize: 12),
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
                              '端口:${jsonDecode(_serverList[index])['status']['bind_port']}'),
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
                          Text(
                              '当前连接:${jsonDecode(_serverList[index])['status']['cur_conns'] ?? 0}'),
                          Text(
                              '流入流量:${_formatTraffic(jsonDecode(_serverList[index])['status']['total_traffic_in'] ?? 0)}MB'),
                          Text(
                              '流出流量:${_formatTraffic(jsonDecode(_serverList[index])['status']['total_traffic_out'] ?? 0)}MB'),
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
