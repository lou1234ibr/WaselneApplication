import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  final Function(String) onSubmit;
  const SearchBox({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(12),
      child: TextField(
        keyboardType: TextInputType.phone,
        controller: _searchController,
        onSubmitted: (value) {
          if (value.trim().isEmpty) return;
          widget.onSubmit(value.trim());
        },
        decoration: InputDecoration(
          hintText: 'Search by mobile number',
          filled: true,
          fillColor: Colors.grey[100],
          labelText: 'Search with Mobile',
          labelStyle: const TextStyle(color: Colors.green),
          prefixIcon: const Icon(Icons.search, color: Colors.green),
          suffixIcon: IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.green),
            onPressed: () {
              final value = _searchController.text.trim();
              if (value.isEmpty) return;
              widget.onSubmit(value);
            },
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.green.shade600, width: 1.5),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
