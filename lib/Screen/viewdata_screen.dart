import 'package:flutter/material.dart';
import '../models/cctv_specification.dart';
import '../API/api_service.dart';

class ViewDataScreen extends StatefulWidget {
  @override
  State<ViewDataScreen> createState() => _ViewDataScreenState();
}

class _ViewDataScreenState extends State<ViewDataScreen> {
  late Future<List<CCTVSpecification>> futureCCTVSpecifications;
  final ApiService apiService = ApiService();

  final _formKey = GlobalKey<FormState>();
  bool isEdit = false;
  CCTVSpecification? editCCTV;

  String id = '';
  String name = '';
  String resolution = '';
  String lensType = '';
  String description = '';

  @override
  void initState() {
    super.initState();
    futureCCTVSpecifications = apiService.getCCTVSpecifications();
  }

  int getCCTVNumber(String name) {
    final regex = RegExp(r'\d+'); // Menemukan angka dalam string
    final match = regex.firstMatch(name);
    if (match != null) {
      return int.parse(match.group(0)!); // Mengembalikan angka sebagai int
    }
    return 0; // Jika tidak ada angka, kembalikan 0
  }

  Future<void> _refreshData() async {
    setState(() {
      futureCCTVSpecifications = apiService.getCCTVSpecifications();
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      CCTVSpecification newCCTV = CCTVSpecification(
        id: isEdit ? editCCTV!.id : '',
        name: name,
        resolution: resolution,
        lensType: lensType,
        description: description,
      );

      try {
        if (isEdit) {
          await apiService.updateCCTVSpecification(newCCTV);
        } else {
          await apiService.createCCTVSpecification(newCCTV);
        }
        setState(() {
          futureCCTVSpecifications = apiService.getCCTVSpecifications();
          isEdit = false;
          editCCTV = null;
        });
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save CCTV Specification')),
        );
      }
    }
  }

  void _editCCTV(CCTVSpecification cctv) {
    setState(() {
      isEdit = true;
      editCCTV = cctv;
      id = cctv.id;
      name = cctv.name;
      resolution = cctv.resolution;
      lensType = cctv.lensType;
      description = cctv.description;
    });
  }

  void _deleteCCTV(String id) async {
    try {
      await apiService.deleteCCTVSpecification(id);
      setState(() {
        futureCCTVSpecifications = apiService.getCCTVSpecifications();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete CCTV Specification')),
      );
    }
  }

  void _openFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              isEdit ? 'Edit CCTV Specification' : 'Create CCTV Specification'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    initialValue: name,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      name = value!;
                    },
                  ),
                  TextFormField(
                    initialValue: resolution,
                    decoration: InputDecoration(labelText: 'Resolution'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a resolution';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      resolution = value!;
                    },
                  ),
                  TextFormField(
                    initialValue: lensType,
                    decoration: InputDecoration(labelText: 'Lens Type'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a lens type';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      lensType = value!;
                    },
                  ),
                  TextFormField(
                    initialValue: description,
                    decoration: InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      description = value!;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isEdit = false;
                  editCCTV = null;
                });
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(isEdit ? 'Update' : 'Create'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: true,
              snap: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'View Data',
                  style: TextStyle(color: Colors.white),
                ),
                background: Image.asset(
                  'assets/images/appbar_background.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isEdit = false;
                      editCCTV = null;
                      id = '';
                      name = '';
                      resolution = '';
                      lensType = '';
                      description = '';
                    });
                    _openFormDialog(context);
                  },
                  child: Text('Add CCTV Specification'),
                ),
              ),
            ),
            FutureBuilder<List<CCTVSpecification>>(
              future: futureCCTVSpecifications,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: Center(child: Text('Error: ${snapshot.error}')),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(child: Text('No CCTV Specifications Found')),
                  );
                } else {
                  List<CCTVSpecification> cctvSpecifications = snapshot.data!;
                  cctvSpecifications.sort((a, b) => getCCTVNumber(a.name)
                      .compareTo(getCCTVNumber(
                          b.name))); // Mengurutkan berdasarkan nomor
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final cctv = cctvSpecifications[index];
                        return ListTile(
                          title: Text(
                            cctv.name,
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(
                            '\nResolusi: ${cctv.resolution}, \nTipe Lensa: ${cctv.lensType}, \nDescription: ${cctv.description}',
                            style: TextStyle(color: Colors.grey),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _editCCTV(cctv);
                                  _openFormDialog(context);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _deleteCCTV(cctv.id);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: cctvSpecifications.length,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
