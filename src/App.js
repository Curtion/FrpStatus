import React from 'react';
import {NavigationContainer} from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import {createBottomTabNavigator} from '@react-navigation/bottom-tabs';
import Ionicons from 'react-native-vector-icons/Ionicons';
import ServerSceen from './views/Server';
import SettingScreen from './views/Setting';

const Stack = createNativeStackNavigator();

const Tab = createBottomTabNavigator();

export default function App() {
  return (
    <NavigationContainer>
      <Stack.Navigator>
      <Tab.Navigator
        screenOptions={({route}) => ({
          tabBarIcon: ({focused, color, size}) => {
            let iconName;
            if (route.name === '服务器') {
              iconName = focused ? 'laptop-outline' : 'laptop-outline';
            } else if (route.name === '设置') {
              iconName = focused ? 'settings-outline' : 'settings-outline';
            }
            return <Ionicons name={iconName} size={size} color={color} />;
          },
          tabBarActiveTintColor: 'tomato',
          tabBarInactiveTintColor: 'gray',
          headerShown: false,
        })}>
        <Tab.Screen name="服务器" component={ServerSceen} />
        <Tab.Screen name="设置" component={SettingScreen} />
      </Tab.Navigator>
      </Stack.Navigator>
    </NavigationContainer>
  );
}
