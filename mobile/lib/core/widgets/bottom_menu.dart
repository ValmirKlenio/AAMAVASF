import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class BottomMenu extends StatelessWidget {
  final int selectedIndex;

  const BottomMenu({
    super.key,
    required this.selectedIndex,
  });

  void _onItemTap(BuildContext context, int index) {
    if (index == selectedIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;

      case 1:
        // Serviços
        break;

      case 2:
        // Agenda
        break;

      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.contact);
        break;

      case 4:
        // Perfil
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xffFEFEFE),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 65,
          child: Row(
            children: [
              Expanded(
                child: BottomItem(
                  icon: Icons.home,
                  title: 'Início',
                  selected: selectedIndex == 0,
                  onTap: () => _onItemTap(context, 0),
                ),
              ),
              Expanded(
                child: BottomItem(
                  icon: Icons.extension,
                  title: 'Serviços',
                  selected: selectedIndex == 1,
                  onTap: () => _onItemTap(context, 1),
                ),
              ),
              Expanded(
                child: BottomItem(
                  icon: Icons.calendar_month_outlined,
                  title: 'Agenda',
                  selected: selectedIndex == 2,
                  onTap: () => _onItemTap(context, 2),
                ),
              ),
              Expanded(
                child: BottomItem(
                  icon: Icons.forum,
                  title: 'Fale conosco',
                  selected: selectedIndex == 3,
                  onTap: () => _onItemTap(context, 3),
                ),
              ),
              Expanded(
                child: BottomItem(
                  icon: Icons.person,
                  title: 'Perfil',
                  selected: selectedIndex == 4,
                  onTap: () => _onItemTap(context, 4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const BottomItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color itemColor = selected
        ? const Color(0xff053FD8)
        : const Color(0xff000000);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: itemColor,
            size: 21,
          ),
          const SizedBox(height: 7),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: itemColor,
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  height: 1,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}