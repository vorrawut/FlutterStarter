import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';

void main() {
  runApp(const DevelopmentEnvironmentMasterApp());
}

class DevelopmentEnvironmentMasterApp extends StatelessWidget {
  const DevelopmentEnvironmentMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Development Environment Master',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'RobotoMono',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'RobotoMono',
      ),
      home: const DevelopmentEnvironmentScreen(),
    );
  }
}

class DevelopmentEnvironmentScreen extends StatefulWidget {
  const DevelopmentEnvironmentScreen({super.key});

  @override
  State<DevelopmentEnvironmentScreen> createState() =>
      _DevelopmentEnvironmentScreenState();
}

class _DevelopmentEnvironmentScreenState
    extends State<DevelopmentEnvironmentScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic> deviceInfo = {};
  Map<String, dynamic> appInfo = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadSystemInfo();
  }

  Future<void> _loadSystemInfo() async {
    try {
      final deviceInfoPlugin = DeviceInfoPlugin();
      final packageInfo = await PackageInfo.fromPlatform();

      Map<String, dynamic> deviceData = {};

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        deviceData = {
          'platform': 'Android',
          'version': androidInfo.version.release,
          'model': androidInfo.model,
          'manufacturer': androidInfo.manufacturer,
          'sdk': androidInfo.version.sdkInt.toString(),
          'brand': androidInfo.brand,
          'device': androidInfo.device,
        };
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        deviceData = {
          'platform': 'iOS',
          'version': iosInfo.systemVersion,
          'model': iosInfo.model,
          'name': iosInfo.name,
          'systemName': iosInfo.systemName,
        };
      } else if (Platform.isMacOS) {
        final macOsInfo = await deviceInfoPlugin.macOsInfo;
        deviceData = {
          'platform': 'macOS',
          'version': macOsInfo.osRelease,
          'model': macOsInfo.model,
          'computerName': macOsInfo.computerName,
          'hostName': macOsInfo.hostName,
        };
      } else if (Platform.isWindows) {
        final windowsInfo = await deviceInfoPlugin.windowsInfo;
        deviceData = {
          'platform': 'Windows',
          'version': windowsInfo.displayVersion,
          'computerName': windowsInfo.computerName,
          'numberOfCores': windowsInfo.numberOfCores.toString(),
        };
      } else if (Platform.isLinux) {
        final linuxInfo = await deviceInfoPlugin.linuxInfo;
        deviceData = {
          'platform': 'Linux',
          'name': linuxInfo.name,
          'version': linuxInfo.version,
          'id': linuxInfo.id,
        };
      } else {
        // Web or other platforms
        deviceData = {
          'platform': 'Web/Other',
          'userAgent': 'Web Platform',
        };
      }

      setState(() {
        deviceInfo = deviceData;
        appInfo = {
          'appName': packageInfo.appName,
          'packageName': packageInfo.packageName,
          'version': packageInfo.version,
          'buildNumber': packageInfo.buildNumber,
        };
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        deviceInfo = {'error': 'Failed to load device info: $e'};
        appInfo = {'error': 'Failed to load app info'};
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Development Environment Master'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.computer), text: 'Environment'),
            Tab(icon: Icon(Icons.build), text: 'Tools'),
            Tab(icon: Icon(Icons.speed), text: 'Performance'),
            Tab(icon: Icon(Icons.check_circle), text: 'Verification'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEnvironmentTab(),
          _buildToolsTab(),
          _buildPerformanceTab(),
          _buildVerificationTab(),
        ],
      ),
    );
  }

  Widget _buildEnvironmentTab() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            'System Information',
            deviceInfo,
            Icons.computer,
            Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Application Information',
            appInfo,
            Icons.app_registration,
            Colors.green,
          ),
          const SizedBox(height: 16),
          _buildDevelopmentMetricsCard(),
        ],
      ),
    );
  }

  Widget _buildToolsTab() {
    final tools = [
      {
        'name': 'Hot Reload',
        'description': 'Instant code changes without losing app state',
        'status': 'Active',
        'icon': Icons.flash_on,
        'color': Colors.orange,
      },
      {
        'name': 'Flutter DevTools',
        'description': 'Comprehensive debugging and profiling suite',
        'status': 'Available',
        'icon': Icons.developer_mode,
        'color': Colors.purple,
      },
      {
        'name': 'Widget Inspector',
        'description': 'Visual widget tree exploration and debugging',
        'status': 'Enabled',
        'icon': Icons.search,
        'color': Colors.blue,
      },
      {
        'name': 'Performance Profiler',
        'description': 'Frame rendering and performance analysis',
        'status': 'Ready',
        'icon': Icons.speed,
        'color': Colors.red,
      },
      {
        'name': 'Memory Monitor',
        'description': 'Memory usage tracking and leak detection',
        'status': 'Active',
        'icon': Icons.memory,
        'color': Colors.teal,
      },
      {
        'name': 'Network Inspector',
        'description': 'HTTP request monitoring and analysis',
        'status': 'Available',
        'icon': Icons.network_check,
        'color': Colors.green,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: (tool['color'] as Color).withOpacity(0.1),
              child: Icon(
                tool['icon'] as IconData,
                color: tool['color'] as Color,
              ),
            ),
            title: Text(
              tool['name'] as String,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(tool['description'] as String),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                tool['status'] as String,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () => _showToolDetails(tool),
          ),
        );
      },
    );
  }

  Widget _buildPerformanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildPerformanceMetricCard(
            'Hot Reload Speed',
            '< 500ms',
            'Excellent',
            Icons.flash_on,
            Colors.green,
            0.95,
          ),
          _buildPerformanceMetricCard(
            'Build Time',
            '~15s',
            'Good',
            Icons.build,
            Colors.orange,
            0.75,
          ),
          _buildPerformanceMetricCard(
            'Code Completion',
            '< 100ms',
            'Excellent',
            Icons.code,
            Colors.green,
            0.90,
          ),
          _buildPerformanceMetricCard(
            'Error Detection',
            'Real-time',
            'Excellent',
            Icons.bug_report,
            Colors.green,
            1.0,
          ),
          const SizedBox(height: 16),
          _buildOptimizationTipsCard(),
        ],
      ),
    );
  }

  Widget _buildVerificationTab() {
    final checks = [
      {
        'title': 'Flutter Doctor',
        'description': 'All Flutter dependencies verified',
        'status': true,
        'action': 'Run flutter doctor',
      },
      {
        'title': 'Platform Tools',
        'description': 'Android SDK and platform tools configured',
        'status': true,
        'action': 'Verify platform setup',
      },
      {
        'title': 'IDE Configuration',
        'description': 'Development environment optimized',
        'status': true,
        'action': 'Check IDE settings',
      },
      {
        'title': 'Hot Reload',
        'description': 'Instant code reload functionality',
        'status': true,
        'action': 'Test hot reload',
      },
      {
        'title': 'Multi-Platform',
        'description': 'Can deploy to multiple platforms',
        'status': true,
        'action': 'Test platform builds',
      },
      {
        'title': 'Code Quality',
        'description': 'Linting and formatting configured',
        'status': true,
        'action': 'Run analysis',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: checks.length,
      itemBuilder: (context, index) {
        final check = checks[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(
              check['status'] as bool
                  ? Icons.check_circle
                  : Icons.error_outline,
              color: check['status'] as bool ? Colors.green : Colors.red,
              size: 32,
            ),
            title: Text(
              check['title'] as String,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(check['description'] as String),
            trailing: TextButton(
              onPressed: () => _runVerificationAction(check['action'] as String),
              child: const Text('Verify'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(
    String title,
    Map<String, dynamic> info,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...info.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        '${entry.key}:',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value.toString(),
                        style: const TextStyle(fontFamily: 'RobotoMono'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDevelopmentMetricsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics, color: Colors.purple, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Development Metrics',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildMetricRow('Flutter Version', 'Latest Stable'),
            _buildMetricRow('Dart Version', '3.0+'),
            _buildMetricRow('Platform Support', 'Multi-Platform'),
            _buildMetricRow('Hot Reload', 'Enabled'),
            _buildMetricRow('DevTools', 'Available'),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoMono',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetricCard(
    String title,
    String value,
    String status,
    IconData icon,
    Color color,
    double progress,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        value,
                        style: const TextStyle(
                          fontFamily: 'RobotoMono',
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptimizationTipsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb, color: Colors.amber, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Optimization Tips',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTipItem('Use const constructors for better performance'),
            _buildTipItem('Enable format on save for consistent code style'),
            _buildTipItem('Run flutter analyze regularly for code quality'),
            _buildTipItem('Use keyboard shortcuts for faster development'),
            _buildTipItem('Keep dependencies updated for latest features'),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.arrow_right, color: Colors.blue, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(tip),
          ),
        ],
      ),
    );
  }

  void _showToolDetails(Map<String, dynamic> tool) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              tool['icon'] as IconData,
              color: tool['color'] as Color,
            ),
            const SizedBox(width: 8),
            Text(tool['name'] as String),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tool['description'] as String),
            const SizedBox(height: 16),
            Text(
              'Status: ${tool['status']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _runVerificationAction(String action) {
    // Copy action to clipboard for user to run
    Clipboard.setData(ClipboardData(text: action));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied "$action" to clipboard'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

