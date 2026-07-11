import 'package:flutter/material.dart';

class NumericKeypadDialog extends StatefulWidget {
  final String title;
  final Function(double) onNumberSelected;

  const NumericKeypadDialog({
    super.key,
    required this.title,
    required this.onNumberSelected,
  });

  @override
  State<NumericKeypadDialog> createState() => _NumericKeypadDialogState();
}

class _NumericKeypadDialogState extends State<NumericKeypadDialog> {
  String _displayValue = '';

  void _onKeyPressed(String key) {
    setState(() {
      if (key == 'C') {
        _displayValue = '';
      } else if (key == '⌫') {
        if (_displayValue.isNotEmpty) {
          _displayValue = _displayValue.substring(0, _displayValue.length - 1);
        }
      } else if (key == '✓') {
        if (_displayValue.isNotEmpty) {
          double value = double.tryParse(_displayValue) ?? 0;
          widget.onNumberSelected(value);
          Navigator.of(context).pop();
        }
      } else {
        if (_displayValue.length < 8) {
          _displayValue += key;
        }
      }
    });
  }

  Widget _buildKey(String key, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(4),
        child: ElevatedButton(
          onPressed: () => _onKeyPressed(key),
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey.shade200,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            key,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Irish Grover',
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _displayValue.isEmpty ? '0' : _displayValue,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            SizedBox(height: 16),
            Column(
              children: [
                Row(children: [
                  _buildKey('1'),
                  _buildKey('2'),
                  _buildKey('3'),
                ]),
                Row(children: [
                  _buildKey('4'),
                  _buildKey('5'),
                  _buildKey('6'),
                ]),
                Row(children: [
                  _buildKey('7'),
                  _buildKey('8'),
                  _buildKey('9'),
                ]),
                Row(children: [
                  _buildKey('C', color: Colors.red.shade200),
                  _buildKey('0'),
                  _buildKey('⌫', color: Colors.orange.shade200),
                ]),
                SizedBox(height: 8),
                Row(children: [
                  _buildKey('✓', color: Colors.green.shade200),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}