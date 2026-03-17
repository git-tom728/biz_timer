import 'package:flutter/material.dart';
import 'package:biz_timer/home_window/home_window.dart';
// import 'package:biz_timer/settings_window/settings_window.dart'; // 20250312_DELETE_apple審査通過のため一時的に機能を削除

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  } 
}

// スイッチング用ページ
// 配列に設定したページにbottomNavigationBarで設定したボタンからボディの中身を切り替える
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeWindow(),
    // SettingsWindow(),　// 20250312_DELETE_apple審査通過のため一時的に機能を削除
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      // bottomNavigationBar: BottomNavigationBar(  // 20250312_DELETE_apple審査通過のため一時的に機能を削除 ※ナビゲーションバーを使用する場合は項目が２個以上必要のため
      //   currentIndex: _selectedIndex,
      //   onTap: (index) {
      //     setState(() {
      //       _selectedIndex = index;
      //     });
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     // BottomNavigationBarItem(   // 20250312_DELETE_apple審査通過のため一時的に機能を削除
      //     //   icon: Icon(Icons.settings),
      //     //   label: 'Settings',
      //     // ),
      //   ],
      //   ),
    );
  }
}
