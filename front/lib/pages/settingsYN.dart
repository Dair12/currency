import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: SettingsHeaderScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class SettingsHeaderScreen extends StatelessWidget {
  const SettingsHeaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isTablet = constraints.maxWidth > 600;
          final double horizontalPadding = isTablet ? 64 : 16;
          final double headerHeight = isTablet ? 180 : 140;
          final double titleFontSize = isTablet ? 26 : 22;

          return Column(
            children: [
              // Шапка с волной
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: headerHeight,
                  width: double.infinity,
                  color: Colors.blueAccent,
                  child: SafeArea(
                    child: Stack(
                      children: [
                        Positioned(
                          left: 16,
                          top: 16,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () {},
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              "Настройки",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Список настроек
              Expanded(
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding, vertical: 12),
                    child: ListView(
                      children: const [
                        SettingsItem(
                          icon: Icons.language,
                          title: "Язык",
                        ),
                        SettingsItem(
                          icon: Icons.notifications,
                          title: "Уведомления",
                        ),
                        SettingsItem(
                          icon: Icons.lock_outline,
                          title: "Пароль",
                        ),
                        SettingsItem(
                          icon: Icons.color_lens_outlined,
                          title: "Тема",
                        ),
                        SettingsItem(
                          icon: Icons.security,
                          title: "Конфиденциальность",
                        ),
                        SettingsItem(
                          icon: Icons.help_outline,
                          title: "Помощь",
                        ),
                        SettingsItem(
                          icon: Icons.logout,
                          title: "Выйти",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Виджет одного пункта настройки
class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black87, fontSize: 16),
      ),
      trailing:
          const Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 16),
      onTap: () {
        // Действие при нажатии
      },
    );
  }
}

// Волна
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 10);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 35,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
