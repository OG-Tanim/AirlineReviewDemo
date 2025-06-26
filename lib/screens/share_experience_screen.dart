import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:searchable_textfeild/dropdown_menu_items.dart';
import 'package:searchable_textfeild/searchable_textfeild.dart';
import 'package:image_picker/image_picker.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:airlineapp/widgets/custom_drawer.dart';
import 'package:airlineapp/models/airport.dart';
import 'package:airlineapp/data/mock_airports.dart';
import 'package:airlineapp/screens/feed_screen.dart';
import 'package:airlineapp/models/comment_model.dart';

class ShareExperienceScreen extends StatefulWidget {
  const ShareExperienceScreen({Key? key}) : super(key: key);

  @override
  State<ShareExperienceScreen> createState() => _ShareExperienceScreenState();
}

class _ShareExperienceScreenState extends State<ShareExperienceScreen> {
  // Controllers
  final departureController = TextEditingController();
  final arrivalController = TextEditingController();
  final airlineController = TextEditingController();
  final classController = TextEditingController();
  final dateController = TextEditingController();
  final messageController = TextEditingController();

  // Image picker
  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];

  // Airport data: now immediately available
  final List<Airport> _airports = mockAirports;

  // Rating
  int rating = 0;

  // Dropdown source lists
  final List<String> airlinesList = [
    'Emirates',
    'Qatar Airways',
    'Singapore Airlines',
    'Biman Bangladesh',
    'Air Asia',
  ];
  final List<String> classesList = ['Economy', 'Business', 'First-Class'];

  // Selected values
  String? selectedDepartureAirport;
  String? selectedArrivalAirport;
  String? selectedClassType;

  @override
  void initState() {
    super.initState();
    // mirror sign_up.dart’s clear‐icon logic
    departureController.addListener(() => setState(() {}));
    arrivalController.addListener(() => setState(() {}));
    classController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    departureController.dispose();
    arrivalController.dispose();
    airlineController.dispose();
    classController.dispose();
    dateController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Future<void> _pickMonthYear() async {
    final now = DateTime.now();
    final picked = await showMonthPicker(
      context: context,
      firstDate: DateTime(now.year - 1, 1),
      lastDate: DateTime(now.year + 1, 12),
      initialDate: now,
    );
    if (picked != null) {
      dateController.text =
          '${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  Future<void> _pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage(
      imageQuality: 80,
      maxWidth: 800,
    );
    if (images != null && images.isNotEmpty) {
      setState(() => _images = images);
    }
  }

  InputDecoration _decoration({required String hint, Widget? suffix}) =>
      InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        suffixIcon: suffix,
      );

  Widget _airportDropdown(TextEditingController ctl, String hint) {
    return SearchableTextField(
      key: ValueKey('$hint-${_airports.length}'),
      controller: ctl,
      isDropdown: true,
      items: _airports
          .map(
            (a) =>
                DropdownMenuItems(lable: a.displayName, value: a.displayName),
          )
          .toList(),
      onChanged: (value, label) {
        setState(() {
          if (ctl == departureController) {
            selectedDepartureAirport = value;
          } else if (ctl == arrivalController)
            // ignore: curly_braces_in_flow_control_structures
            selectedArrivalAirport = value;
        });
      },
      textFeildDecorator: _decoration(
        hint: hint,
        suffix: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (ctl.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear),
                  iconSize: 18,
                  onPressed: () => setState(() {
                    ctl.clear();
                    if (ctl == departureController) {
                      selectedDepartureAirport = null;
                    } else if (ctl == arrivalController)
                      // ignore: curly_braces_in_flow_control_structures
                      selectedArrivalAirport = null;
                  }),
                ),
              const Icon(Icons.keyboard_arrow_down),
            ],
          ),
        ),
      ),
      enabled: true,
    );
  }

  Widget _simpleDropdown(
    TextEditingController ctl,
    String hint,
    List<String> items,
  ) {
    return SearchableTextField(
      controller: ctl,
      isDropdown: true,
      items: items.map((s) => DropdownMenuItems(lable: s, value: s)).toList(),
      onChanged: (value, label) {
        setState(() {
          if (ctl == classController) selectedClassType = value;
        });
      },
      textFeildDecorator: _decoration(
        hint: hint,
        suffix: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (ctl.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear),
                  iconSize: 18,
                  onPressed: () => setState(() {
                    ctl.clear();
                    if (ctl == classController) selectedClassType = null;
                  }),
                ),
              const Icon(Icons.keyboard_arrow_down),
            ],
          ),
        ),
      ),
      enabled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: const CustomDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Share',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Image picker
              DottedBorder(
                color: Colors.grey.shade400,
                strokeWidth: 2,
                dashPattern: [6, 3],
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: _pickImages,
                    child: _images.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo,
                                  size: 40,
                                  color: Colors.blueGrey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Tap to add photos',
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: _images.length,
                            itemBuilder: (c, i) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(_images[i].path),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              _airportDropdown(departureController, 'Departure Airport'),
              const SizedBox(height: 16),
              _airportDropdown(arrivalController, 'Arrival Airport'),
              const SizedBox(height: 16),

              _simpleDropdown(airlineController, 'Airline', airlinesList),
              const SizedBox(height: 16),
              _simpleDropdown(classController, 'Class', classesList),
              const SizedBox(height: 16),

              TextField(
                controller: messageController,
                minLines: 6,
                maxLines: null,
                decoration: _decoration(hint: 'Write your message'),
              ),

              const SizedBox(height: 24),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: dateController,
                      readOnly: true,
                      onTap: _pickMonthYear,
                      decoration: _decoration(
                        hint: 'Travel Date',
                        suffix: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: const Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  const Text(
                    'Rating',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  ...List.generate(
                    5,
                    (i) => IconButton(
                      icon: Icon(i < rating ? Icons.star : Icons.star_border),
                      color: Colors.amber,
                      iconSize: 20,
                      onPressed: () => setState(() => rating = i + 1),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {
                    final now = DateTime.now();
                    const monthNames = [
                      'Jan',
                      'Feb',
                      'Mar',
                      'Apr',
                      'May',
                      'Jun',
                      'Jul',
                      'Aug',
                      'Sep',
                      'Oct',
                      'Nov',
                      'Dec',
                    ];
                    final timeAgo = '${monthNames[now.month - 1]} ${now.day}';

                    // 1. Find the Airport object by displayName
                    final depAirport = _airports.firstWhere(
                      (a) => a.displayName == selectedDepartureAirport,
                      orElse: () => Airport(name: '', iata: ''),
                    );
                    final arrAirport = _airports.firstWhere(
                      (a) => a.displayName == selectedArrivalAirport,
                      orElse: () => Airport(name: '', iata: ''),
                    );

                    // 2. Pull out just the IATA codes
                    final depCode = depAirport.iata;
                    final arrCode = arrAirport.iata;

                    // 3. Build the post using only IATA codes
                    final newPost = PostModel(
                      avatarUrl: 'assets/avatar.png',
                      userName: 'User',
                      timeAgo: timeAgo,
                      rating: rating.toDouble(),
                      departureCode: depCode,
                      arrivalCode: arrCode,
                      airline: airlineController.text,
                      travelClass: selectedClassType ?? '',
                      travelDate: dateController.text,
                      reviewText: messageController.text,
                      imageUrls: _images.map((img) => img.path).toList(),
                      likeCount: 0,
                      commentCount: 0,
                      initialComments: <Comment>[],
                    );
                    FeedScreen.addPost(newPost);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 20,
                    ),
                  ),
                  child: const Text(
                    'Share Now',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
