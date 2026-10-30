import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSS3344 Lab 02',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const Lab02CompleteScreen(),
    );
  }
}

class Lab02CompleteScreen extends StatefulWidget {
  const Lab02CompleteScreen({super.key});

  @override
  State<Lab02CompleteScreen> createState() => _Lab02CompleteScreenState();
}

class _Lab02CompleteScreenState extends State<Lab02CompleteScreen> {
  DateTime _selectedDate = DateTime(2026, 10, 28);
  String _selectedRole = 'Slytherin';
  final List<String> _roles = ['Gryffindor', 'Slytherin', 'Ravenclaw', 'Hufflepuff'];

  // 1. Material Date Picker
  Future<void> _selectMaterialDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  // 2. Cupertino Date Picker (Modal Sheet)
  void _showCupertinoDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext ctx) => Container(
        height: 260,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: const Text('Done'),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _selectedDate,
                onDateTimeChanged: (DateTime newDate) {
                  setState(() => _selectedDate = newDate);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 4. Cupertino Wheel Picker (Modal Sheet)
  void _showCupertinoRolePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext ctx) => Container(
        height: 240,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: const Text('Done'),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 36,
                scrollController: FixedExtentScrollController(
                  initialItem: _roles.indexOf(_selectedRole),
                ),
                onSelectedItemChanged: (int index) {
                  setState(() => _selectedRole = _roles[index]);
                },
                children: _roles.map((role) => Center(child: Text(role))).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('CSS3344 Mobile App Dev - Lab 02'),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade100,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildPortraitView()
              : _buildLandscapeView();
        },
      ),
    );
  }

  // Portrait Mode (Vertical Stack)
  Widget _buildPortraitView() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const StudentDetailsSection(),
        const SizedBox(height: 16),
        const TitleSection(
          name: 'Aurora Borealis & Arctic Cabin',
          location: 'Thingvellir, Iceland',
          starCount: 50,
        ),
        const SizedBox(height: 16),
        const LocationImageSection(imagePath: 'assets/iceland.jpeg'),
        const SizedBox(height: 16),
        _buildPickersCard(),
      ],
    );
  }

  // Landscape Mode (Side-by-Side Distribution)
  Widget _buildLandscapeView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: StudentDetailsSection(),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const TitleSection(
                name: 'Aurora Borealis & Arctic Cabin',
                location: 'Thingvellir, Iceland',
                starCount: 50,
              ),
              const SizedBox(height: 12),
              const LocationImageSection(imagePath: 'assets/iceland.jpeg'),
              const SizedBox(height: 16),
              _buildPickersCard(),
            ],
          ),
        ),
      ],
    );
  }

  // Interactive Pickers Card (Exercise 2.2)
  Widget _buildPickersCard() {
    final String formattedDate =
        "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";

    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Interactive Pickers (Lab 2.2)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text('Selected Date: $formattedDate', style: const TextStyle(fontSize: 12)),
            Text('Selected House: $_selectedRole', style: const TextStyle(fontSize: 12)),
            const Divider(height: 20),
            OutlinedButton.icon(
              onPressed: () => _selectMaterialDate(context),
              icon: const Icon(Icons.calendar_month, size: 18),
              label: const Text('Material Date Picker'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _showCupertinoDatePicker(context),
              icon: const Icon(CupertinoIcons.calendar, size: 18),
              label: const Text('Cupertino Date Picker (Modal Sheet)'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Material Dropdown: ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedRole,
                  items: _roles.map((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() => _selectedRole = newValue);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _showCupertinoRolePicker(context),
              icon: const Icon(CupertinoIcons.circle_grid_hex, size: 18),
              label: const Text('Cupertino House Wheel Picker'),
            ),
          ],
        ),
      ),
    );
  }
}

// Sub-Widget 1: Student Details Section
class StudentDetailsSection extends StatelessWidget {
  const StudentDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircleAvatar(
              radius: 48,
              backgroundImage: AssetImage('assets/profile.jpeg'),
            ),
            SizedBox(height: 14),
            Text(
              'NURUL FARHANA TIE BINTI MOHAMAD HAZMI TIE',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Student ID: BCS24090006',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Divider(height: 24, thickness: 1),
            Text(
              'Personal Life Goal / Quote:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4),
            Text(
              '"To travel around the world."',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Sub-Widget 2: TitleSection
class TitleSection extends StatelessWidget {
  final String name;
  final String location;
  final int starCount;

  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.starCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Location Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        location,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.star, color: Colors.indigo.shade300, size: 18),
                const SizedBox(width: 4),
                Text(
                  '$starCount',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Sub-Widget 3: Image Section
class LocationImageSection extends StatelessWidget {
  final String imagePath;
  const LocationImageSection({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.asset(
        imagePath,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}