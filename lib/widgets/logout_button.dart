import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    super.key,
    this.compact = false,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return IconButton(
        onPressed: () {
          // ログアウト処理
          FirebaseAuth.instance.signOut();
        },
        icon: const Icon(Icons.exit_to_app),
        tooltip: 'ログアウト',
      );
    }
    return OutlinedButton.icon(
      onPressed: () {
        // ログアウト処理
        FirebaseAuth.instance.signOut();
      },
      icon: const Icon(Icons.exit_to_app, size: 18),
      label: const Text('ログアウト'),
      style: OutlinedButton.styleFrom(
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
