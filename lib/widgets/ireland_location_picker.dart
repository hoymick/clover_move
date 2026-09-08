import 'package:flutter/material.dart';

import '../models/ireland_locations.dart';
import '../theme/pack_icons.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import 'fields.dart';

/// Republic of Ireland county and town picker shared by profiles, routes,
/// businesses, meet points and filters.
class IrelandLocationField extends StatefulWidget {
  const IrelandLocationField({
    super.key,
    this.initialCounty = 'Dublin',
    this.initialTown = 'Dublin',
    this.allowAll = false,
    this.onChanged,
  });

  final String initialCounty;
  final String initialTown;
  final bool allowAll;
  final void Function(String county, String? town)? onChanged;

  @override
  State<IrelandLocationField> createState() => _IrelandLocationFieldState();
}

class _IrelandLocationFieldState extends State<IrelandLocationField> {
  late String _county = widget.initialCounty;
  late String? _town = widget.initialTown;

  String get _label {
    if (_county.isEmpty) return 'All 26 counties';
    if (_town == null || _town!.isEmpty) return 'County $_county';
    return '$_town · County $_county';
  }

  Future<void> _pick() async {
    final result = await showModalBottomSheet<(String, String?)>(
      context: context,
      isScrollControlled: true,
      backgroundColor: CloverColors.white,
      builder: (context) => SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.78,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 12, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Choose an Irish location',
                        style: AppText.subtitle.copyWith(fontSize: 18),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              if (widget.allowAll)
                ListTile(
                  leading: const Icon(Icons.public, color: CloverColors.green),
                  title: const Text('All 26 counties'),
                  onTap: () => Navigator.pop(context, ('', null)),
                ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  children: [
                    for (final county in IrelandLocations.counties)
                      ExpansionTile(
                        title: Text('County $county'),
                        children: [
                          for (final town
                              in IrelandLocations.countyTowns[county] ??
                                  const <String>[])
                            ListTile(
                              contentPadding: const EdgeInsets.only(
                                left: 34,
                                right: 20,
                              ),
                              title: Text(town),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () =>
                                  Navigator.pop(context, (county, town)),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (result == null) return;
    setState(() {
      _county = result.$1;
      _town = result.$2;
    });
    widget.onChanged?.call(_county, _town);
  }

  @override
  Widget build(BuildContext context) {
    return SelectField(value: _label, icon: PackIcons.pin, onTap: _pick);
  }
}
