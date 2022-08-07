import React from 'react';
import {Text, ScrollView, StyleSheet, View} from 'react-native';

export default function () {
  let text = [];
  for (let i = 0; i < 20; i++) {
    text.push(
      <View style={style.item} key={i}>
        <View>
          <Text>Settings!</Text>
        </View>
        <View>
          <Text>{i}</Text>
        </View>
      </View>,
    );
  }
  return (
    <View style={style.container}>
      <View style={style.header}>
        <Text style={style.header.btn}>新增服务器</Text>
      </View>
      <ScrollView>{text}</ScrollView>
    </View>
  );
}

const style = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  header: {
    height: 50,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#007AB3',
    btn: {
      color: '#D4E7FA',
      fontSize: 16,
    },
  },
  item: {
    margin: 2,
    padding: 2,
    height: 100,
    backgroundColor: '#D4E7FA',
  },
});
