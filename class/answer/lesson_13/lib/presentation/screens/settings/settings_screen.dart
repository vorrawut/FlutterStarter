import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubits/settings/settings_cubit.dart';
import '../../../core/models/weather_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocBuilder<SettingsCubit, WeatherSettings>(
        builder: (context, settings) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildUnitsSection(context, settings),
              const SizedBox(height: 24),
              _buildBehaviorSection(context, settings),
              const SizedBox(height: 24),
              _buildAppearanceSection(context, settings),
              const SizedBox(height: 24),
              _buildActionsSection(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUnitsSection(BuildContext context, WeatherSettings settings) {
    return _buildSection(
      context,
      'Units',
      Icons.straighten,
      [
        _buildDropdownTile(
          context,
          'Temperature',
          settings.temperatureUnit.name.toUpperCase(),
          TemperatureUnit.values.map((unit) => DropdownMenuItem(
            value: unit,
            child: Text(unit.name.toUpperCase()),
          )).toList(),
          (TemperatureUnit? value) {
            if (value != null) {
              context.read<SettingsCubit>().updateTemperatureUnit(value);
            }
          },
          settings.temperatureUnit,
        ),
        _buildDropdownTile(
          context,
          'Wind Speed',
          _getWindSpeedDisplayName(settings.windSpeedUnit),
          WindSpeedUnit.values.map((unit) => DropdownMenuItem(
            value: unit,
            child: Text(_getWindSpeedDisplayName(unit)),
          )).toList(),
          (WindSpeedUnit? value) {
            if (value != null) {
              context.read<SettingsCubit>().updateWindSpeedUnit(value);
            }
          },
          settings.windSpeedUnit,
        ),
        _buildDropdownTile(
          context,
          'Pressure',
          _getPressureDisplayName(settings.pressureUnit),
          PressureUnit.values.map((unit) => DropdownMenuItem(
            value: unit,
            child: Text(_getPressureDisplayName(unit)),
          )).toList(),
          (PressureUnit? value) {
            if (value != null) {
              context.read<SettingsCubit>().updatePressureUnit(value);
            }
          },
          settings.pressureUnit,
        ),
      ],
    );
  }

  Widget _buildBehaviorSection(BuildContext context, WeatherSettings settings) {
    return _buildSection(
      context,
      'Behavior',
      Icons.settings,
      [
        SwitchListTile(
          title: const Text('Auto Refresh'),
          subtitle: const Text('Automatically refresh weather data'),
          value: settings.autoRefresh,
          onChanged: (_) => context.read<SettingsCubit>().toggleAutoRefresh(),
        ),
        if (settings.autoRefresh)
          _buildSliderTile(
            context,
            'Refresh Interval',
            '${settings.refreshIntervalMinutes} minutes',
            settings.refreshIntervalMinutes.toDouble(),
            5,
            120,
            5,
            (double value) {
              context.read<SettingsCubit>().updateRefreshInterval(value.round());
            },
          ),
        SwitchListTile(
          title: const Text('Show Notifications'),
          subtitle: const Text('Receive weather alerts and updates'),
          value: settings.showNotifications,
          onChanged: (_) => context.read<SettingsCubit>().toggleNotifications(),
        ),
        SwitchListTile(
          title: const Text('Use Current Location'),
          subtitle: const Text('Automatically detect your location'),
          value: settings.useCurrentLocation,
          onChanged: (_) => context.read<SettingsCubit>().toggleCurrentLocation(),
        ),
      ],
    );
  }

  Widget _buildAppearanceSection(BuildContext context, WeatherSettings settings) {
    return _buildSection(
      context,
      'Appearance',
      Icons.palette,
      [
        SwitchListTile(
          title: const Text('Dark Mode'),
          subtitle: const Text('Use dark theme'),
          value: settings.useDarkMode,
          onChanged: (_) => context.read<SettingsCubit>().toggleDarkMode(),
        ),
      ],
    );
  }

  Widget _buildActionsSection(BuildContext context) {
    return _buildSection(
      context,
      'Actions',
      Icons.build,
      [
        ListTile(
          leading: const Icon(Icons.restore),
          title: const Text('Reset to Defaults'),
          subtitle: const Text('Restore all settings to default values'),
          onTap: () => _showResetDialog(context),
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDropdownTile<T>(
    BuildContext context,
    String title,
    String currentValue,
    List<DropdownMenuItem<T>> items,
    Function(T?) onChanged,
    T value,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(currentValue),
      trailing: DropdownButton<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        underline: const SizedBox(),
      ),
    );
  }

  Widget _buildSliderTile(
    BuildContext context,
    String title,
    String currentValue,
    double value,
    double min,
    double max,
    double divisions,
    Function(double) onChanged,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(currentValue),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: ((max - min) / divisions).round(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text(
          'This will reset all settings to their default values. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<SettingsCubit>().resetToDefaults();
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings reset to defaults'),
                ),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  String _getWindSpeedDisplayName(WindSpeedUnit unit) {
    switch (unit) {
      case WindSpeedUnit.metersPerSecond:
        return 'Meters/Second';
      case WindSpeedUnit.milesPerHour:
        return 'Miles/Hour';
      case WindSpeedUnit.kilometersPerHour:
        return 'Kilometers/Hour';
    }
  }

  String _getPressureDisplayName(PressureUnit unit) {
    switch (unit) {
      case PressureUnit.hpa:
        return 'hPa';
      case PressureUnit.inHg:
        return 'inHg';
      case PressureUnit.mmHg:
        return 'mmHg';
    }
  }
}