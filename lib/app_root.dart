import 'package:flutter/material.dart';

import 'core/enum/workspace.dart';
import 'core/model/user_session.dart';
import 'core/theme/os_colors.dart';
import 'features/launcher/screens/launcher_screen.dart';
import 'shared/data/mock_data.dart';
import 'shared/widgets/module_shell.dart';

class IpfOSApp extends StatelessWidget {
  const IpfOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IpfOS',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: OsColors.page,
        colorScheme: ColorScheme.fromSeed(
          seedColor: OsColors.blue,
          primary: OsColors.black,
          secondary: OsColors.blue,
          surface: Colors.white,
          onSurface: OsColors.ink,
        ),
        textTheme: const TextTheme(
          displaySmall: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            height: 1.08,
          ),
          headlineMedium: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            height: 1.12,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 1.25,
          ),
          bodyLarge: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            height: 1.45,
          ),
          bodyMedium: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            height: 1.35,
          ),
          labelLarge: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
          labelMedium: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
          labelSmall: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ).apply(bodyColor: OsColors.ink, displayColor: OsColors.ink),
      ),
      home: const IpfOSRoot(),
    );
  }
}

class IpfOSRoot extends StatefulWidget {
  const IpfOSRoot({super.key});

  @override
  State<IpfOSRoot> createState() => _IpfOSRootState();
}

class _IpfOSRootState extends State<IpfOSRoot> {
  static const UserSession _dashboardUser = UserSession(
    id: 'u-1',
    name: 'Erick M',
    email: 'erick@ipfsoftwares.com',
    role: 'Super Admin',
  );

  UserSession _user = _dashboardUser;
  Workspace _workspace = Workspace.launcher;
  int _moduleTab = 0;
  final List<Map<String, String>> _tickets = List.of(MockData.tickets);

  Future<void> _logout() async {
    if (mounted) {
      setState(() {
        _user = _dashboardUser;
        _workspace = Workspace.launcher;
        _moduleTab = 0;
      });
    }
  }

  void _openWorkspace(Workspace workspace) {
    setState(() {
      _workspace = workspace;
      _moduleTab = 0;
    });
  }

  void _setTab(int index) => setState(() => _moduleTab = index);

  void _createTicket(Map<String, String> ticket) {
    setState(() => _tickets.insert(0, ticket));
  }

  void _updateTicket(Map<String, String> ticket) {
    setState(() {
      final index = _tickets.indexWhere((item) => item['id'] == ticket['id']);
      if (index == -1) return;
      _tickets[index] = ticket;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
    Widget currentScreen;

    if (_workspace == Workspace.launcher) {
      currentScreen = LauncherScreen(
        user: user,
        onLogout: _logout,
        onOpenWorkspace: _openWorkspace,
      );
    } else {
      currentScreen = ModuleShell(
        user: user,
        workspace: _workspace,
        activeIndex: _moduleTab,
        tickets: _tickets,
        onBackToLauncher: () => _openWorkspace(Workspace.launcher),
        onLogout: _logout,
        onTabChanged: _setTab,
        onCreateTicket: _createTicket,
        onUpdateTicket: _updateTicket,
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: KeyedSubtree(
        key: ValueKey<String>('screen-${user.id}-${_workspace.name}'),
        child: currentScreen,
      ),
    );
  }
}
