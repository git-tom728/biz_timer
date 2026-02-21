// ============================================================
// HomeWindow
// ============================================================

// キーボード
enum KeypadKey {
  one('1'),
  two('2'),
  three('3'),
  four('4'),
  five('5'),
  six('6'),
  seven('7'),
  eight('8'),
  nine('9'),
  zero('0'),
  clear('C'),
  ok('OK');

  final String label;
  const KeypadKey(this.label);

  bool get isNumber =>
    this != KeypadKey.clear && this != KeypadKey.ok;

  int? get number {
    if (!isNumber) return null;
    return int.parse(label);
  }
}

// 状態管理
enum TimerState {
  setting,    //  入力中
  running,    //  カウント中
  finished,   //  終了
}

// ============================================================
// SettingsWindow
// ============================================================

// アラーム設定
enum AlarmSetting {
  sound('音声'),  // 通常モード
  light('光');  // 光通知

  final String label;
  const AlarmSetting(this.label);
}

// 設定方法
enum SettingMethod {
   scroll('スクロール'),              // 純正に近い設定方法
   sexagesimalNumber('押しボタン'),   // 60進数（例 xx:xx:xx）
   decimalNumber('キーボード');       // 10進数（例 x.xxh）

  final String label;
  const SettingMethod(this.label);
}

// 自動クローズ
enum AutoClose {
   enabled('有効'),  // 純正の自動クローズ機能を「キャンセルしない」
   disabled('無効'); // 純正の自動クローズ機能を「キャンセルする」

  final String label;
  const AutoClose(this.label);
}
