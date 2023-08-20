import 'package:flutter/material.dart';

class CustomToolbar extends StatelessWidget {
  final List<ToolbarButton> buttons;

  CustomToolbar({required this.buttons});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.all(8),
      child: Row(
        children: buttons.map((button) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(button.icon),
                onPressed: button.onPressed,
              ),
              SizedBox(height: 4),
              Text(
                button.label,
                style: TextStyle(fontSize: 12),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class ToolbarButton {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  ToolbarButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });
}
