import 'package:flutter/material.dart';

class BottomMenu extends StatelessWidget {
  final int selectedIndex;

  const BottomMenu({
    super.key,
    required this.selectedIndex,
  });

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
                ),
              ),
              Expanded(
                child: BottomItem(
                  icon: Icons.extension,
                  title: 'Serviços',
                  selected: selectedIndex == 1,
                ),
              ),
              Expanded(
                child: BottomItem(
                  icon: Icons.calendar_month_outlined,
                  title: 'Agenda',
                  selected: selectedIndex == 2,
                ),
              ),
              Expanded(
                child: BottomItem(
                  icon: Icons.forum,
                  title: 'Fale conosco',
                  selected: selectedIndex == 3,
                ),
              ),
              Expanded(
                child: BottomItem(
                  icon: Icons.person,
                  title: 'Perfil',
                  selected: selectedIndex == 4,
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

  const BottomItem({
    super.key,
    required this.icon,
    required this.title,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color itemColor = selected
        ? const Color(0xff053FD8)
        : const Color(0xff000000);

    return Column(
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
    );
  }
}