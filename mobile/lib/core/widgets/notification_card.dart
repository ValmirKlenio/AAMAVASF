import 'package:flutter/material.dart';

class NotificationBellButton extends StatelessWidget {
  final double scale;
  final Color iconColor;

  const NotificationBellButton({
    super.key,
    this.scale = 1,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Notificacoes estarao disponiveis em breve.'),
            ),
          );
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 32 * scale,
        height: 32 * scale,
        child: Center(
          child: Icon(
            Icons.notifications_none,
            color: iconColor,
            size: 24 * scale,
          ),
        ),
      ),
    );
  }
}
