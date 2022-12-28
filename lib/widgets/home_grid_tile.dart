import 'package:flutter/material.dart';

class HomeGridTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final String route;
  const HomeGridTile({
    required this.label,
    required this.icon,
    required this.route,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed(route);
      },
      child: GridTile(
        footer: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        child: Icon(icon, size: 80),
      ),
    );
  }
}
