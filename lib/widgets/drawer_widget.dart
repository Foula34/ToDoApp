import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
// Suggested code may be subject to a license. Learn more: ~LicenseLog:4162919713.
          children: [
            SizedBox(
              width: double.infinity,
              child: DrawerHeader(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.inversePrimary),
                  child: const Center(child: Text('Task Menu'))),
            ),
            Expanded(
              child: ListTile(
                leading: const Icon(Icons.brightness_1),
                title: Text('theme'.toUpperCase()),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
           const Divider(),
            Expanded(
              child: ListTile(
                leading: const Icon(Icons.notification_add),
                title: Text('Notification'.toUpperCase()),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListTile(
                leading: const Icon(Icons.filter_list),
                title: Text('Filter List'.toUpperCase()),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListTile(
                leading: const Icon(Icons.calendar_month),
                title: Text('Calendar'.toUpperCase()),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const Divider(),
             Expanded(
              child: ListTile(
                leading: const Icon(Icons.settings),
                title: Text('Settings'.toUpperCase()),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ]),
    );
  }
}
