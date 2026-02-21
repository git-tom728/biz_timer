import 'package:flutter/material.dart';
import 'package:biz_timer/const.dart';
import 'dart:async';

// ============================================================
// WidgetName ；HomeWindow
// Overview   ；モニターとキーパッドの表示を行う
// return     ；モニターの表示
// return     ；キーパッドの表示
// ============================================================
class HomeWindow extends  StatelessWidget {
  const HomeWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeContainer();
  }
}

// ============================================================
// WidgetName ；_HomeContainer(_HomeContainerState含む)
// Overview   ；モニターと入力部の「あいだ」で値の受け渡しを行う
// return     ；表示値
// return     ；キーパッドの入力値
// ============================================================
class _HomeContainer extends StatefulWidget {
  const _HomeContainer();

  @override
  State<_HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<_HomeContainer> {
  String value = ''; // 最大6桁　"hhMMss"
  Timer? _timer;
  Timer? _blinkTimer;
  int _remainingSeconds = 0;
  // bool _isRunning = false;
  // bool _isFinished = false;
  // bool _isBlinkOn = false;
  TimerState _state = TimerState.setting;
  bool _isBlinkOn = false;

  // 数字の追加0〜9(判別ロジック)
  void addNumber(String number) {
    if (value.length >= 6)return;
    
    setState(() {
      value += number;
    });
  }

  // 数字の削除(判別ロジック)
  void delete() {
    if (value.isNotEmpty) {
      setState(() {
        value = value.substring(0, value.length -1);
      });
    }
  }

  // 押した数字のケース分け(判別ロジック)
  void onKeyTap(KeypadKey key) {
    switch (_state) {

      // 入力中
      case TimerState.setting:
        _handleSettingState(key);
        break;

      //　カウント中
      case TimerState.running:
        _handleRunningState(key);
        break;

      // 終了
      case TimerState.finished:
        _handleFinishedState(key);
        break;
    
    }    
  }

  // 入力中の動作
  void _handleSettingState(KeypadKey key) {
    switch (key) {
      case KeypadKey.clear:
        delete();
        break;

      case KeypadKey.ok:
        _startTimer();
        break;

      default:
        addNumber(key.label);
    }
  }

  // カウント中の動作
  void _handleRunningState(KeypadKey key) {
    if (key == KeypadKey.ok) {
      _stopTimer();
    }
  }

  // 終了の動作
  void _handleFinishedState(KeypadKey key) {
    if (key == KeypadKey.ok) {
      _blinkTimer?.cancel();

      setState(() {
        _state = TimerState.setting;
        _isBlinkOn =false;
        value = '';
      });
    }
  }

  // タイマー開始
  void _startTimer() {
    if (value.isEmpty) return;

    final padded = value.padLeft(6, '0');
    final hours = int.parse(padded.substring(0, 2));
    final minutes = int.parse(padded.substring(2, 4));
    final seconds = int.parse(padded.substring(4, 6));

    _remainingSeconds = hours * 3600 + minutes * 60 + seconds;

    if (_remainingSeconds <= 0) return;

    setState(() {
      _state = TimerState.running;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        timer.cancel();

        setState(() {
          _remainingSeconds = 0;
          _state = TimerState.finished;
          value = _formatSeconds(0);
        });

        _startBlink();
        return;
      }

      setState(() {
        _remainingSeconds--;
        value = _formatSeconds(_remainingSeconds);
      });
    });
  }

  // タイマー停止
  void _stopTimer() {
    _timer?.cancel();

    setState(() {
      _state = TimerState.setting;
      value = '';
    });
  }

  // 終了時の表示部点滅
  void _startBlink() {
    _blinkTimer?.cancel();

    _blinkTimer = 
        Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _isBlinkOn = !_isBlinkOn;
      });
    });
  }

  String _formatSeconds(int totalSeconds) {
    final h = totalSeconds ~/ 3600;
    final m = (totalSeconds % 3600) ~/ 60;
    final s = totalSeconds % 60;

    return '${h.toString().padLeft(2, '0')}'
           '${m.toString().padLeft(2, '0')}'
           '${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _blinkTimer?.cancel();
    super.dispose();
  }

  // 判別ロジックの結果を表示(表示ロジック)
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          DisplayArea(
            value: value,
            isInverted: _state == TimerState.finished && _isBlinkOn,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: KeypadArea(
              onKeyTap: onKeyTap,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// WidgetName ；DisplayArea
// Overview   ；表示値に対して入力値を反映させる
// return     ；表示値
// ============================================================
class DisplayArea extends StatelessWidget {
  final String value;
  final bool isInverted;

  const DisplayArea({
    super.key,
    required this.value,
    required this.isInverted,
  });

  String _formatTime(String raw) {
    final padded = raw.padLeft(6, '0');

    final h = padded.substring(0, 2);
    final m = padded.substring(2, 4);
    final s = padded.substring(4, 6);

    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: isInverted ? Colors.black : Colors.transparent,
      child: Text(
        _formatTime(value),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 56,
          fontWeight: FontWeight.bold,
          fontFeatures: const [FontFeature.tabularFigures()],
          color: isInverted ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}

// ============================================================
// WidgetName ；KeypadArea(_KeypadAreaState含む)
// Overview   ；入力値を更新する
// return     ；入力値
// ============================================================
class KeypadArea extends StatefulWidget {
  final void Function(KeypadKey key) onKeyTap;

  const KeypadArea({
    super.key,
    required this.onKeyTap,
  });

  @override
  State<KeypadArea> createState() => _KeypadAreaState();
}

class _KeypadAreaState extends State<KeypadArea> {
  Widget _key(KeypadKey key) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: ElevatedButton(
        onPressed: () => widget.onKeyTap(key),
        child: Text(
          key.label,
          style: const TextStyle(fontSize: 24),
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const columns = 3;
        const rows = 4;
        const spacing = 12.0;

        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        final cellWidth =
              (maxWidth - spacing * (columns - 1)) / columns;
        final cellHeight =
              (maxHeight - spacing * (rows - 1)) / rows;
        
        final aspectRatio = cellWidth / cellHeight;

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            childAspectRatio: aspectRatio,
          ),
          itemCount: KeypadKey.values.length,
          itemBuilder: (context, index) {
            final key = KeypadKey.values[index];
            return _key(key);
          },
        );
      },
    );
  }
}
