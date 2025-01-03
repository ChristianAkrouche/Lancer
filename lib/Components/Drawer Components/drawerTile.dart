import 'package:flutter/material.dart';

class drawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function()? onTap;
  const drawerTile({super.key, required this.title, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return  ListTile(
      title: Text(title,style: TextStyle(color: Colors.grey[700],fontSize: 16),),
      leading: Icon(icon, color: Colors.grey[700]),
      onTap: onTap,
    );
  }
}

