import 'package:flutter/material.dart';

enum AdminTab { painel, perfil }

class AdminBottomNav extends StatelessWidget {
  final AdminTab currentTab;
  final VoidCallback onPainelTap;
  final VoidCallback onPerfilTap;

  const AdminBottomNav({
    super.key,
    required this.currentTab,
    required this.onPainelTap,
    required this.onPerfilTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPainel = currentTab == AdminTab.painel;
    final isPerfil = currentTab == AdminTab.perfil;

    return Material(
      color: Colors.white,
      child: Container(
        height: 65,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFDFE3EB), width: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NavItem(
              icon: Icons.settings,
              label: 'Painel',
              active: isPainel,
              onTap: onPainelTap,
            ),
            _NavItem(
              icon: Icons.person_outline,
              label: 'Perfil',
              active: isPerfil,
              onTap: onPerfilTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.active ? Colors.blue : Colors.grey;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: _hover ? Colors.blue.withOpacity(0.06) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: color),
              const SizedBox(height: 2),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
