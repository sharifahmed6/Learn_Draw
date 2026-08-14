import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:dropdown_search/dropdown_search.dart';

class CountryItem {
  final String name;
  final String emoji;

  CountryItem({required this.name, required this.emoji});

  @override
  String toString() => '$emoji  $name';

  @override
  bool operator ==(Object other) => identical(this, other) || other is CountryItem && other.name == name;

  @override
  int get hashCode => name.hashCode;
}

class CountryPickerWidget extends StatefulWidget {
  final String? initialCountry;
  final ValueChanged<String> onCountryChanged;

  const CountryPickerWidget({
    super.key,
    this.initialCountry,
    required this.onCountryChanged,
  });

  @override
  State<CountryPickerWidget> createState() => _CountryPickerWidgetState();
}

class _CountryPickerWidgetState extends State<CountryPickerWidget> {
  List<CountryItem> _countries = [];
  CountryItem? _selectedCountry;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final jsonString = await rootBundle.loadString('packages/country_state_city_picker/lib/assets/country.json');
      List<dynamic> allData = jsonDecode(jsonString);
      
      final countries = allData.map((e) => CountryItem(
        name: e['name'].toString(),
        emoji: e['emoji']?.toString() ?? '🌍',
      )).toList();

      CountryItem? initial;
      if (widget.initialCountry != null && widget.initialCountry!.isNotEmpty) {
        try {
          initial = countries.firstWhere((c) => c.name == widget.initialCountry);
        } catch (_) {}
      }

      setState(() {
        _countries = countries;
        _selectedCountry = initial;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading country data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return DropdownSearch<CountryItem>(
      items: (filter, props) => _countries,
      selectedItem: _selectedCountry,
      compareFn: (item, selectedItem) => item.name == selectedItem.name,
      itemAsString: (CountryItem item) => item.toString(),
      onSelected: (value) {
        if (value != null) {
          setState(() {
            _selectedCountry = value;
          });
          widget.onCountryChanged(value.name);
        }
      },
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          labelText: 'Country *',
          prefixIcon: const Icon(Icons.public),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      popupProps: PopupProps.menu(
        showSearchBox: true,
        menuProps: const MenuProps(
          backgroundColor: Color(0xFFFFF9C4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          elevation: 4,
        ),
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: "Search Country...",
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
