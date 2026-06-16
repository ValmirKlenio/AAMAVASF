import 'package:flutter/material.dart';

class NotificationBellButton extends StatefulWidget {
  final double scale;
  final Color iconColor;
  final int count;

  const NotificationBellButton({
    super.key,
    this.scale = 1,
    this.iconColor = Colors.white,
    this.count = 3,
  });

  @override
  State<NotificationBellButton> createState() => _NotificationBellButtonState();
}

class _NotificationBellButtonState extends State<NotificationBellButton> {
  final GlobalKey _buttonKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  bool get _isOpen => _overlayEntry != null;

  void _toggleOverlay() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    final contextBox = _buttonKey.currentContext;
    if (contextBox == null) return;

    final renderBox = contextBox.findRenderObject() as RenderBox;
    final buttonPosition = renderBox.localToGlobal(Offset.zero);
    final buttonSize = renderBox.size;

    final screenWidth = MediaQuery.of(context).size.width;
    final scale = widget.scale;

    final double cardWidth = (306 * scale).clamp(260.0, screenWidth - 16);
    final double top = buttonPosition.dy + buttonSize.height + (8 * scale);

    final double left = (buttonPosition.dx +
            (buttonSize.width / 2) -
            cardWidth +
            (36 * scale))
        .clamp(8.0, screenWidth - cardWidth - 8);

    final double arrowX =
        (buttonPosition.dx + (buttonSize.width / 2) - left).clamp(
      22 * scale,
      cardWidth - (22 * scale),
    );

    _overlayEntry = OverlayEntry(
      builder: (_) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _removeOverlay,
                behavior: HitTestBehavior.translucent,
                child: const SizedBox.expand(),
              ),
            ),
            Positioned(
              top: top,
              left: left,
              child: Material(
                color: Colors.transparent,
                child: NotificationDropdownCard(
                  width: cardWidth,
                  scale: scale,
                  arrowX: arrowX,
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.scale;

    return GestureDetector(
      key: _buttonKey,
      onTap: _toggleOverlay,
      child: SizedBox(
        width: 32 * scale,
        height: 32 * scale,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: Icon(
                Icons.notifications_none,
                color: widget.iconColor,
                size: 24 * scale,
              ),
            ),
            if (widget.count > 0)
              Positioned(
                top: 1 * scale,
                right: 1 * scale,
                child: Container(
                  width: 13 * scale,
                  height: 13 * scale,
                  decoration: const BoxDecoration(
                    color: Color(0xffFF2001),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${widget.count}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 7 * scale,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class NotificationDropdownCard extends StatelessWidget {
  final double width;
  final double scale;
  final double arrowX;

  const NotificationDropdownCard({
    super.key,
    required this.width,
    required this.scale,
    required this.arrowX,
  });

  @override
  Widget build(BuildContext context) {
    final double cardHeight = 476 * scale;

    return SizedBox(
      width: width,
      height: cardHeight + (13 * scale),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: arrowX - (8.5 * scale),
            child: CustomPaint(
              size: Size(17 * scale, 13 * scale),
              painter: _TrianglePainter(),
            ),
          ),
          Positioned(
            top: 12 * scale,
            left: 0,
            right: 0,
            child: Container(
              height: cardHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8 * scale),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 18 * scale,
                    offset: Offset(0, 8 * scale),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  14 * scale,
                  20 * scale,
                  14 * scale,
                  14 * scale,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notificações',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20 * scale,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),

                    SizedBox(height: 28 * scale),

                    const _NotificationItem(
                      icon: Icons.calendar_month_outlined,
                      title: 'Novo evento disponível',
                      description: 'Você possui um evento\nhoje às 09:00.',
                      time: 'Agora',
                    ),

                    SizedBox(height: 32 * scale),

                    const _NotificationItem(
                      icon: Icons.check_circle_outline,
                      title: 'Compromisso Confirmado',
                      description:
                          'Seu compromisso foi\nconfirmado com sucesso.',
                      time: '15 minutos atrás',
                    ),

                    SizedBox(height: 32 * scale),

                    const _NotificationItem(
                      icon: Icons.notifications_none,
                      title: 'Lembrete importante',
                      description: 'Verifique seus compromissos\ndo dia',
                      time: '1 hora atrás',
                    ),

                    const Spacer(),

                    Container(
                      height: 30 * scale,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xffECF0FD),
                        borderRadius: BorderRadius.circular(8 * scale),
                      ),
                      child: Center(
                        child: Text(
                          'Ver todas as notificações',
                          style: TextStyle(
                            color: const Color(0xff0A37CF),
                            fontSize: 10 * scale,
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String time;

  const _NotificationItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = _getScale(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60 * scale,
          height: 60 * scale,
          decoration: const BoxDecoration(
            color: Color(0xffECF0FD),
          ),
          child: Icon(
            icon,
            color: const Color(0xff0A37CF),
            size: 28 * scale,
          ),
        ),

        SizedBox(width: 14 * scale),

        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 3 * scale),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 11 * scale,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),

                SizedBox(height: 12 * scale),

                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xffB7BBC6),
                    fontSize: 11 * scale,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),

                SizedBox(height: 12 * scale),

                Text(
                  time,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xff9BA8D8),
                    fontSize: 10 * scale,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  double _getScale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return (width / 402).clamp(0.78, 1.0).toDouble();
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}