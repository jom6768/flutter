import 'package:flutter/material.dart';

// ================= Model =================
class AppBarMenuItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool destructive;

  const AppBarMenuItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.destructive = false,
  });
}

// ================= Widget =================
class AppBarMenu extends StatelessWidget {
  final List<AppBarMenuItem> items;

  const AppBarMenu({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      tooltip: 'เมนู',
      icon: const Icon(Icons.more_vert),
      onSelected: (index) {
        items[index].onTap();
      },
      itemBuilder: (context) {
        return List.generate(items.length, (index) {
          final item = items[index];
          final color = item.destructive ? Colors.red : Colors.black87;

          return PopupMenuItem<int>(
            value: index,
            padding: EdgeInsets.zero,
            child: _MenuItem(
              icon: item.icon,
              text: item.label,
              color: color,
            ),
          );
        });
      },
    );
  }
}

// ================= Internal UI =================
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _MenuItem({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        hoverColor: Colors.grey.withOpacity(0.12),
        splashColor: Colors.grey.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 12),
              Text(
                text,
                style: TextStyle(
                  fontSize: 14,
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






/* ตัวอย่างการใช้งาน

// Confirm Logout
Future<void> _confirmLogout() async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('ออกจากระบบ'),
      content: const Text('คุณต้องการออกจากระบบใช่หรือไม่'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('ยกเลิก'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: const Text('ออกจากระบบ'),
        ),
      ],
    ),
  );

  if (confirm != true || !mounted) return;

  // TODO: clear session / token ถ้ามี

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => const TaxFormScreen()),
    (route) => false,
  );
}



// App Bar


        appBar: AppBar(
        title: const Text('คำนวณภาษีเงินได้'),
        actions: [
          AppBarMenu(
            items: [
              AppBarMenuItem(
                label: 'ดูประวัติ',
                icon: Icons.history,
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TaxHistoryScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
              AppBarMenuItem(
                label: 'ออกจากระบบ',
                icon: Icons.logout,
                destructive: true,
                onTap: () {
                  _confirmLogout();
                },
              ),
            ],
          ),
        ],
      ),
 */