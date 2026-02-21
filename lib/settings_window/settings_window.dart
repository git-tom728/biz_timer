import 'package:flutter/material.dart';
import 'package:biz_timer/const.dart';
// ============================================================
// WidgetName ；SettingsWindow
// Overview   ；選択した設定項目を本体に保存して、Home画面に反映させる
// return     ；アラーム
// return     ；設定時間
// return     ；自動クローズ
// ============================================================
class SettingsWindow extends StatelessWidget {
  const SettingsWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SettingsWindow')
      ),
      body: ListView(
        children: [
          // アラーム設定ラジオボタン
          SettingsRadioGroup<AlarmSetting>(
            title: 'アラーム',
            values: AlarmSetting.values,
            initialValue: AlarmSetting.sound,
            labelBuilder: (v) => v.label,
            onChanged: (value) {
              debugPrint(value.name);
            },
          ),
          const Divider(),
          // 時間設定ラジオボタン
          SettingsRadioGroup<SettingMethod>(
            title: '時間設定',
            values: SettingMethod.values,
            initialValue: SettingMethod.scroll,
            labelBuilder: (v) => v.label,
            onChanged: (value) {
              debugPrint(value.name);
            },
          ),
          const Divider(),
          // 自動クローズラジオボタン
          SettingsRadioGroup<AutoClose>(
            title: '自動クローズ',
            values: AutoClose.values,
            initialValue: AutoClose.enabled,
            labelBuilder: (v) => v.label,
            onChanged: (value) {
              debugPrint(value.name);
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}

// ============================================================
// WidgetName ；SettingsRadioGroup
// Overview   ；設定用ラジオボタンの生成
// Param      ；タイトル
// Param      ；選択肢
// ============================================================
class SettingsRadioGroup<T extends Enum> extends StatefulWidget { 
  final String title;
  final List<T> values;
  final T initialValue;
  final ValueChanged<T> onChanged;
  final String Function(T) labelBuilder;
  
  const SettingsRadioGroup({
    super.key,
    required this.title,
    required this.values,
    required this.initialValue,
    required this.onChanged,
    required this.labelBuilder,
  });

  @override
  State<SettingsRadioGroup<T>> createState() => _SettingsRadioGroupState<T>();
}

class _SettingsRadioGroupState<T extends Enum> extends State<SettingsRadioGroup<T>> {
  late T  _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        for (final value in widget.values)
        RadioListTile<T>(
          title: Text(widget.labelBuilder(value)),
          value: value,
          groupValue: _selected,
          onChanged: (v) {
            if (v == null) return;
            setState(() {
              _selected = v;
            });
            widget.onChanged(v);
          },
        ),
      ],
    );
  }
}
