import 'package:flutter/material.dart';
import '../../providers/app_settings_provider.dart';
import 'package:provider/provider.dart';

class UserUpcomingScreen extends StatelessWidget {
  const UserUpcomingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text(settings.t('upcoming'))),
      body: Center(child: Text(settings.t('upcoming'))),
    );
  }
}
