import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'dart:io';
import '../AppManager/file_manager.dart';
import '../AppManager/camera_manager.dart';
import '../AppManager/image_gallery.dart';
import 'viewdata_screen.dart';
import 'package:mime/mime.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import '../API/api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<File> selectedImages = [];
  int _selectedIndex = 0;
  bool multiCapture = false;
  String? selectedCCTV;
  List<String> cctvOptions = [];
  final PageController _pageController = PageController();
  final ApiService apiService = ApiService();
  Future<void>? _cctvNamesFuture;

  @override
  void initState() {
    super.initState();
    _cctvNamesFuture = _fetchCCTVNames();
  }

  int getCCTVNumber(String name) {
    final regex = RegExp(r'\d+'); // Menemukan angka dalam string
    final match = regex.firstMatch(name);
    if (match != null) {
      return int.parse(match.group(0)!); // Mengembalikan angka sebagai int
    }
    return 0; // Jika tidak ada angka, kembalikan 0
  }

  Future<void> _fetchCCTVNames() async {
    try {
      List<String> names = await apiService.getCCTVNames();
      names.sort((a, b) => getCCTVNumber(a)
          .compareTo(getCCTVNumber(b))); // Mengurutkan berdasarkan nomor
      setState(() {
        cctvOptions = names;
      });
      print('CCTV names fetched: $names'); // Debug log
    } catch (e) {
      print('Error fetching CCTV names: $e'); // Debug log
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load CCTV names')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void addImage(File image) {
    final mimeType = lookupMimeType(image.path);
    if (mimeType != null && mimeType.startsWith('image/')) {
      setState(() {
        selectedImages.add(image);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Berkas yang Anda Pilih Tidak Berformat Gambar')),
      );
    }
  }

  void removeImage(File image) {
    setState(() {
      selectedImages.remove(image);
    });
  }

  void setMultiCapture(bool value) {
    setState(() {
      multiCapture = value;
    });
  }

  Future<void> uploadFiles() async {
    if (selectedImages.isNotEmpty) {
      var uri = Uri.parse(
          'https://api.imgbb.com/1/upload?key=cbbc892ae0abd87e70742549fa6533e6');
      for (var image in selectedImages) {
        var request = http.MultipartRequest('POST', uri);
        request.files
            .add(await http.MultipartFile.fromPath('image', image.path));
        var response = await request.send();
        if (response.statusCode == 200) {
          var responseData = await response.stream.bytesToString();
          var jsonResponse = json.decode(responseData);
          var imageUrl = jsonResponse['data']['url'];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Uploaded: $imageUrl')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Something went wrong!')),
          );
        }
      }

      // Clear selected images after upload
      setState(() {
        selectedImages.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No file selected!')),
      );
    }
  }

  Future<void> _refreshPage() async {
    await _fetchCCTVNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          FutureBuilder(
            future: _cctvNamesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error loading data'));
              } else {
                return RefreshIndicator(
                  onRefresh: _refreshPage,
                  child: _buildHomeScreen(),
                );
              }
            },
          ),
          Center(child: Text('Search Screen')),
          ViewDataScreen(),
          Center(child: Text('Settings Screen')),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: GNav(
            backgroundColor: Colors.blue,
            color: Colors.blue.shade900,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.blue.shade200.withOpacity(0.8),
            gap: 5,
            hoverColor: Colors.blue.shade100,
            padding: EdgeInsets.all(12),
            onTabChange: _onItemTapped,
            selectedIndex: _selectedIndex,
            tabs: const [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.search, text: 'Search'),
              GButton(icon: Icons.list_alt, text: 'View'),
              GButton(icon: Icons.settings, text: 'Settings'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeScreen() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.blue,
          expandedHeight: 400.0,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(left: 16, bottom: 16),
            title: Row(
              children: [
                Image.asset('assets/images/pjb-logo.png', height: 50),
              ],
            ),
            background: Image.asset(
              'assets/images/appbar_background.jpg',
              fit: BoxFit.cover,
            ),
            centerTitle: false,
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(top: 20.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pilih CCTV',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Monospace',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          DropdownButton<String>(
                            isExpanded: true,
                            value: selectedCCTV,
                            hint: Text('Select CCTV'),
                            items: cctvOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedCCTV = newValue;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    content(selectedImages), // Menampilkan slider gambar
                    SwitchListTile(
                      title: Row(
                        children: [
                          Text(
                            'Foto Grup',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Aktifkan untuk mengambil beberapa gambar secara berurutan',
                                  ),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.info_outline,
                              color: Colors.grey.shade700,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      value: multiCapture,
                      onChanged: setMultiCapture,
                      inactiveThumbColor: Colors.grey.shade800.withOpacity(0.9),
                      inactiveTrackColor: Colors.grey,
                      activeTrackColor: Colors.lightBlue,
                      activeColor: Colors.white,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FileManager(onImageSelected: addImage),
                        SizedBox(width: 10), // Jarak antara dua tombol
                        CameraManager(
                          multiCapture: multiCapture,
                          onImageCaptured: addImage,
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 40.0),
                      child: SlideAction(
                        borderRadius: 12,
                        elevation: 0,
                        text: 'Geser untuk Upload',
                        textStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        innerColor: Colors.white,
                        outerColor: Colors.blue[400],
                        onSubmit: () {
                          uploadFiles();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget content(List<File> images) {
    return Container(
      height: 300,
      child: images.isEmpty
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'No Images Selected',
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
              ),
            )
          : CarouselSlider(
              items: images.map((image) {
                return GestureDetector(
                  onTap: () => _showFullImage(image),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.file(
                            image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              images.remove(image);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 300,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
              ),
            ),
    );
  }

  void _showFullImage(File image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.file(image),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }
}
