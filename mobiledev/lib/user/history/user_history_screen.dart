import 'package:flutter/material.dart';
import '../../providers/app_settings_provider.dart';
import 'package:provider/provider.dart';

class UserHistoryScreen extends StatelessWidget {
  const UserHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text(settings.t('orders'))),
      body: Center(child: Text(settings.t('orders'))),
    );
  }
}
