import 'dart:convert';

import 'package:flutter/material.dart';

class ServerAdd extends StatefulWidget {
  final String? server;
  const ServerAdd({super.key, this.server});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<ServerAdd> {
  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();
  var _id = '';

  @override
  Widget build(BuildContext context) {
    if (widget.server != null) {
      final server = jsonDecode(widget.server!);
      _hostController.text = server['host'];
      _userController.text = server['user'];
      _pwdController.text = server['pwd'];
      _id = server['id'];
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('服务器配置'),
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _hostController,
                decoration: const InputDecoration(
                  labelText: "服务器地址",
                  hintText: "http://127.0.0.1:7500",
                  icon: Icon(Icons.home),
                ),
                validator: (v) {
                  return v!.trim().isNotEmpty ? null : "服务器地址不能为空";
                },
              ),
              TextFormField(
                controller: _userController,
                decoration: const InputDecoration(
                  labelText: "账号",
                  hintText: "frp webui账号",
                  icon: Icon(Icons.person),
                ),
                validator: (v) {
                  return v!.trim().isNotEmpty ? null : "账号不能为空";
                },
              ),
              TextFormField(
                controller: _pwdController,
                decoration: const InputDecoration(
                  labelText: "密码",
                  hintText: "frp webui密码",
                  icon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (v) {
                  return v!.trim().isNotEmpty ? null : "密码不能为空";
                },
              ),
              // 登录按钮
              Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("保存"),
                        ),
                        onPressed: () {
                          if ((_formKey.currentState as FormState).validate()) {
                            Navigator.pop(context, {
                              'host': _hostController.text,
                              'user': _userController.text,
                              'pwd': _pwdController.text,
                              'id': _id,
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
