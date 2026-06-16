import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/widgets/bottom_menu.dart';
import '../../core/widgets/notification_card.dart';
import '../../core/widgets/wave_header.dart';
import 'models/servico.dart';
import 'repositories/servicos_repository.dart';
import 'widgets/service_booking_sheet.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  static const Color primaryBlue = Color(0xff012A9F);
  static const Color background = Color(0xffF6F8FC);

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  late final Future<List<Servico>> _servicesFuture;
  _ServiceFilter _selectedFilter = _ServiceFilter.todos;

  @override
  void initState() {
    super.initState();
    _servicesFuture = ServicosRepository().listarServicos();
  }

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);
    final double horizontalPadding = _Responsive.horizontalPadding(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemStatusBarContrastEnforced: false,
      ),
      child: Scaffold(
        backgroundColor: ServicesPage.background,
        body: Column(
          children: [
            const _ServicesHeader(),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    SizedBox(height: 14 * scale),

                    _CategoryRow(
                      selectedFilter: _selectedFilter,
                      onFilterSelected: (filter) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                    ),

                    SizedBox(height: 18 * scale),

                    Expanded(
                      child: _ServicesList(
                        servicesFuture: _servicesFuture,
                        selectedFilter: _selectedFilter,
                      ),
                    ),

                    SizedBox(height: 10 * scale),

                    const _InfoBox(),

                    SizedBox(height: 24 * scale),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const BottomMenu(selectedIndex: 1),
      ),
    );
  }
}

class _Responsive {
  static const double baseWidth = 402;

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double scale(BuildContext context) {
    final width = screenWidth(context);
    return (width / baseWidth).clamp(0.78, 1.0).toDouble();
  }

  static double horizontalPadding(BuildContext context) {
    final width = screenWidth(context);
    return (width * 0.055).clamp(16.0, 24.0).toDouble();
  }

  static bool isSmallScreen(BuildContext context) {
    return screenWidth(context) < 380;
  }

  static bool isVerySmallScreen(BuildContext context) {
    return screenWidth(context) < 340;
  }
}

enum _ServiceFilter { todos, terapias, apoioFamiliar, atividades, inclusao }

class _ServicesHeader extends StatelessWidget {
  const _ServicesHeader();

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);
    final bool isSmallScreen = _Responsive.isSmallScreen(context);
    final bool isVerySmallScreen = _Responsive.isVerySmallScreen(context);

    final double topSafe = MediaQuery.of(context).padding.top;

    final double headerHeight =
        topSafe +
        (isVerySmallScreen
            ? 168 * scale
            : isSmallScreen
            ? 176 * scale
            : 184 * scale);

    return WaveHeader(
      height: headerHeight,
      backgroundColor: ServicesPage.primaryBlue,
      child: Stack(
        children: [
          Positioned(
            top: topSafe + (8 * scale),
            left: 0,
            right: 0,
            child: Text(
              'Serviços',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xffD8DFF3),
                fontSize: 17 * scale,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ),

          Positioned(
            top: topSafe + (32 * scale),
            left: 0,
            right: 0,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 105 * scale,
                  height: 45 * scale,
                  fit: BoxFit.contain,
                ),

                Text(
                  'AAMAVASF',
                  style: TextStyle(
                    color: const Color(0xffD6DCF0),
                    fontSize: 13.5 * scale,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),

                Text(
                  'ASSOCIACAO DE AMIGOS DO AUTISTA\nDO VALE DO SAO FRANCISCO',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xff8699DA),
                    fontSize: 5.3 * scale,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: topSafe + (13 * scale),
            right: 24 * scale,
            child: NotificationBellButton(scale: scale),
          ),

          Positioned(
            right: -35 * scale,
            top: topSafe + (68 * scale),
            child: Icon(
              Icons.extension,
              size: 108 * scale,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final _ServiceFilter selectedFilter;
  final ValueChanged<_ServiceFilter> onFilterSelected;

  const _CategoryRow({
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);
    final double gap = 6 * scale;

    return Row(
      children: [
        Expanded(
          child: _CategoryCard(
            title: 'Todos',
            icon: Icons.grid_view_rounded,
            iconColor: const Color(0xff0021D3),
            selected: selectedFilter == _ServiceFilter.todos,
            onTap: () => onFilterSelected(_ServiceFilter.todos),
          ),
        ),

        SizedBox(width: gap),

        Expanded(
          child: _CategoryCard(
            title: 'Saúde',
            icon: Icons.person_outline,
            iconColor: const Color(0xff01AF17),
            selected: selectedFilter == _ServiceFilter.terapias,
            onTap: () => onFilterSelected(_ServiceFilter.terapias),
          ),
        ),

        SizedBox(width: gap),

        Expanded(
          child: _CategoryCard(
            title: 'Apoio familiar',
            icon: Icons.groups_2_outlined,
            iconColor: const Color(0xffFFB500),
            selected: selectedFilter == _ServiceFilter.apoioFamiliar,
            onTap: () => onFilterSelected(_ServiceFilter.apoioFamiliar),
          ),
        ),

        SizedBox(width: gap),

        Expanded(
          child: _CategoryCard(
            title: 'Atividades',
            icon: Icons.school_outlined,
            iconColor: const Color(0xff6B36F8),
            selected: selectedFilter == _ServiceFilter.atividades,
            onTap: () => onFilterSelected(_ServiceFilter.atividades),
          ),
        ),

        SizedBox(width: gap),

        Expanded(
          child: _CategoryCard(
            title: 'Inclusão',
            icon: Icons.volunteer_activism_outlined,
            iconColor: const Color(0xffFF2001),
            selected: selectedFilter == _ServiceFilter.inclusao,
            onTap: () => onFilterSelected(_ServiceFilter.inclusao),
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final bool selected;
  final VoidCallback? onTap;

  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54 * scale,
        decoration: BoxDecoration(
          color: const Color(0xffFDFDFD),
          borderRadius: BorderRadius.circular(7 * scale),
          border: Border.all(
            color: const Color(0xffF8F9FB),
            width: selected ? 3 * scale : 2 * scale,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.025),
              blurRadius: 4 * scale,
              offset: Offset(0, 2 * scale),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: selected ? 19 * scale : 18 * scale,
            ),

            SizedBox(height: 5 * scale),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2 * scale),
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected
                      ? const Color(0xff5B6DD8)
                      : const Color(0xff676B74),
                  fontSize: 8.08 * scale,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServicesList extends StatelessWidget {
  final Future<List<Servico>> servicesFuture;
  final _ServiceFilter selectedFilter;

  const _ServicesList({
    required this.servicesFuture,
    required this.selectedFilter,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    return FutureBuilder<List<Servico>>(
      future: servicesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _ServicesMessage(
            child: CircularProgressIndicator(color: ServicesPage.primaryBlue),
          );
        }

        if (snapshot.hasError) {
          return _ServicesMessage(
            child: Text(
              _errorMessage(snapshot.error),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xff676B74),
                fontSize: 10 * scale,
                fontWeight: FontWeight.w500,
                height: 1.25,
              ),
            ),
          );
        }

        final services = _filterServices(snapshot.data ?? <Servico>[]);

        if (services.isEmpty) {
          return _ServicesMessage(
            child: Text(
              'Nenhum serviço disponível no momento.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xff676B74),
                fontSize: 10 * scale,
                fontWeight: FontWeight.w500,
                height: 1.25,
              ),
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: services.length,
          separatorBuilder: (context, index) => SizedBox(height: 10 * scale),
          itemBuilder: (context, index) {
            final service = services[index];
            final style = _ServiceVisualStyle.fromServico(service);

            return _ServiceCard(
              title: service.titulo,
              description: service.descricao ?? '',
              footer: service.footer,
              icon: style.icon,
              iconColor: style.iconColor,
              iconBackground: style.iconBackground,
              onTap: () => showServiceBookingSheet(context, service: service),
            );
          },
        );
      },
    );
  }

  String _errorMessage(Object? error) {
    if (error is ServicosRepositoryException) {
      return error.message;
    }

    return 'Não foi possível carregar os serviços no momento.';
  }

  List<Servico> _filterServices(List<Servico> services) {
    final allowedCategories = _allowedCategoryIds(selectedFilter);

    if (allowedCategories == null) {
      return services;
    }

    return services
        .where((service) => allowedCategories.contains(service.idCategoria))
        .toList();
  }

  Set<int>? _allowedCategoryIds(_ServiceFilter filter) {
    switch (filter) {
      case _ServiceFilter.todos:
        return null;
      case _ServiceFilter.terapias:
        return {1};
      case _ServiceFilter.apoioFamiliar:
        return {2, 3};
      case _ServiceFilter.atividades:
        return {4, 6};
      case _ServiceFilter.inclusao:
        return {5};
    }
  }
}

class _ServicesMessage extends StatelessWidget {
  final Widget child;

  const _ServicesMessage({required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: child,
      ),
    );
  }
}

class _ServiceVisualStyle {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;

  const _ServiceVisualStyle({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
  });

  factory _ServiceVisualStyle.fromServico(Servico service) {
    switch (service.idCategoria) {
      case 1:
        return const _ServiceVisualStyle(
          icon: Icons.health_and_safety_outlined,
          iconColor: Color(0xff00A425),
          iconBackground: Color(0xffE6FBEA),
        );
      case 2:
        return const _ServiceVisualStyle(
          icon: Icons.balance_outlined,
          iconColor: Color(0xff001FE4),
          iconBackground: Color(0xffE7EEFE),
        );
      case 3:
        return const _ServiceVisualStyle(
          icon: Icons.spa_outlined,
          iconColor: Color(0xffE0479E),
          iconBackground: Color(0xffFCEAF4),
        );
      case 4:
        return const _ServiceVisualStyle(
          icon: Icons.self_improvement_outlined,
          iconColor: Color(0xff6B36F8),
          iconBackground: Color(0xffF0EBFF),
        );
      case 5:
        return const _ServiceVisualStyle(
          icon: Icons.menu_book_outlined,
          iconColor: Color(0xffFFB000),
          iconBackground: Color(0xffFFF5DF),
        );
      case 6:
        return const _ServiceVisualStyle(
          icon: Icons.directions_run_outlined,
          iconColor: Color(0xffFF2001),
          iconBackground: Color(0xffFDEAE9),
        );
      default:
        return const _ServiceVisualStyle(
          icon: Icons.handshake_outlined,
          iconColor: Color(0xff0021D3),
          iconBackground: Color(0xffE7EEFE),
        );
    }
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final String footer;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final VoidCallback? onTap;

  const _ServiceCard({
    required this.title,
    required this.description,
    required this.footer,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 82 * scale,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xffFDFEFD),
          borderRadius: BorderRadius.circular(2 * scale),
          border: Border.all(
            color: const Color(0xffF4F5F8),
            width: 0.8 * scale,
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 16 * scale),

            Container(
              width: 61 * scale,
              height: 63 * scale,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(4 * scale),
              ),
              child: Icon(icon, color: iconColor, size: 30 * scale),
            ),

            SizedBox(width: 14 * scale),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8 * scale),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xff4F545F),
                        fontSize: 11.31 * scale,
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),

                    SizedBox(height: 6 * scale),

                    Expanded(
                      child: Text(
                        description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: const Color(0xff8C8F97),
                          fontSize: 8.08 * scale,
                          fontWeight: FontWeight.w400,
                          height: 1.28,
                        ),
                      ),
                    ),

                    SizedBox(height: 4 * scale),

                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          color: const Color(0xff063DF2),
                          size: 10 * scale,
                        ),

                        SizedBox(width: 5 * scale),

                        Flexible(
                          child: Text(
                            footer,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xff6E83DF),
                              fontSize: 7.27 * scale,
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(right: 16 * scale),
              child: Icon(
                Icons.chevron_right,
                color: const Color(0xff70747D),
                size: 18 * scale,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox();

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    return Container(
      height: 56 * scale,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffFDFEFD),
        borderRadius: BorderRadius.circular(6 * scale),
      ),
      child: Row(
        children: [
          SizedBox(width: 17 * scale),

          Container(
            width: 21 * scale,
            height: 21 * scale,
            decoration: const BoxDecoration(
              color: Color(0xff0034C2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.info, color: Colors.white, size: 14 * scale),
          ),

          SizedBox(width: 11 * scale),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Atendimento humanizado e inclusivo',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xff576BD5),
                    fontSize: 9.69 * scale,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),

                SizedBox(height: 6 * scale),

                Text(
                  'Cada pessoa é única. Aqui, o respeito e o amor transformam vidas.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xff868C96),
                    fontSize: 7.27 * scale,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
