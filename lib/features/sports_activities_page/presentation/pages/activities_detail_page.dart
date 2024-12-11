import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class ActivitiesDetailPage extends StatefulWidget {
  final int sportsId;
  const ActivitiesDetailPage({super.key, required this.sportsId});

  @override
  State<ActivitiesDetailPage> createState() => ActivitiesDetailPageState();
}

class ActivitiesDetailPageState extends State<ActivitiesDetailPage> {
  Map<String, dynamic>? sportsData;
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    fetchsportsData();
  }

  Future<void> fetchsportsData() async {
    final url =
        'https://raw.githubusercontent.com/Cloud-Premises/iccmw-app/refs/heads/main/data/assets/json/sporstActivitiesPage/sportsActivities.json';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final sports = data['sportsActivities'] as List<dynamic>;

        // Find the sports by ID
        final selectedSports = sports.firstWhere(
          (sports) => sports['id'] == widget.sportsId,
          orElse: () => null,
        );

        if (selectedSports != null) {
          setState(() {
            sportsData = selectedSports;
            _initializeFormControllers();
          });
        }
      } else {
        print('Failed to load sports data');
      }
    } catch (e) {
      print('Error fetching sports data: $e');
    }
  }

  void _initializeFormControllers() {
    if (sportsData == null) return;

    final data = sportsData!['data'] as List<dynamic>;
    for (var section in data) {
      if (section['form'] != null && section['form']['feilds'] != null) {
        final fields = section['form']['feilds'] as List<dynamic>;
        for (var field in fields) {
          _controllers[field['title']] = TextEditingController();
        }
      }
    }
  }

  Future<void> _submitForm(String submitUrl) async {
    if (_formKey.currentState?.validate() ?? false) {
      final formData = {};
      _controllers.forEach((key, controller) {
        formData[key] = controller.text;
      });

      try {
        final response = await http.post(
          Uri.parse(submitUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(formData),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Form submitted successfully!')),
          );
          _formKey.currentState?.reset();
          _controllers.forEach((key, controller) {
            controller.clear();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to submit form.')),
          );
        }
      } catch (e) {
        print('Error submitting form: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error submitting form.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: AppBar(
        title: Text(
          sportsData != null ? sportsData!['title'] ?? '' : 'Sports Detail',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        // backgroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: appBarColor,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: sportsData == null
          ? Center(
              child: kIsWeb
                  ? CircularProgressIndicator()
                  : (Platform.isAndroid
                      ? CircularProgressIndicator()
                      : CupertinoActivityIndicator()),
            )
          : RefreshIndicator(
              onRefresh: fetchsportsData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildSportsDetails(),
                  ),
                ),
              ),
            ),
    );
  }

  List<Widget> _buildSportsDetails() {
    List<Widget> widgets = [];

    // Display title and description if available
    if (sportsData!['title'] != null && sportsData!['title'].isNotEmpty) {
      widgets.add(Text(
        sportsData!['title'],
        style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
      ));
      widgets.add(const SizedBox(height: 8));
    }

    if (sportsData!['description'] != null &&
        sportsData!['description'].isNotEmpty) {
      widgets.add(Text(
        sportsData!['description'],
        style: const TextStyle(fontSize: 16),
      ));
      widgets.add(const SizedBox(height: 16));
    }

    // Display data sections if available
    final data = sportsData!['data'] as List<dynamic>;
    for (var section in data) {
      // Heading
      if (section['heading'] != null && section['heading'].isNotEmpty) {
        widgets.add(Text(
          section['heading'],
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ));
        widgets.add(const SizedBox(height: 8));
      }

      // Description (fixed typo)
      if (section['desciption:'] != null && section['desciption:'].isNotEmpty) {
        for (var description in section['desciption:']) {
          if (description.isNotEmpty) {
            widgets.add(Text(
              description,
              style: const TextStyle(fontSize: 16),
            ));
            widgets.add(const SizedBox(height: 8));
          }
        }
      }

      // List
      if (section['list'] != null && section['list'].isNotEmpty) {
        widgets.add(Column(
          children: section['list']
              .map<Widget>((item) => Row(
                    children: [
                      const SizedBox(height: 24),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ))
              .toList(),
        ));
        widgets.add(const SizedBox(height: 12));
      }

      // Table
      if (section['table'] != null &&
          section['table'] is Map<String, dynamic> &&
          section['table']['data'] != null) {
        final tableData = section['table']['data'];
        if (tableData is List<dynamic> && tableData.isNotEmpty) {
          widgets.add(Text(
            section['table']['title'] ?? 'Information',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ));
          widgets.add(const SizedBox(height: 8));

          widgets.add(Table(
            border: TableBorder.all(color: Colors.green),
            children: [
              // Table Header
              const TableRow(
                decoration: BoxDecoration(color: Colors.green),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Name',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Phone',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Email',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
              // Table Rows
              ...tableData.map<TableRow>((row) {
                // Ensure each row is a map
                if (row is Map<String, dynamic>) {
                  String name = row['name'] ?? '';
                  String phone = row['phone'] ?? '';
                  String email = row['email'] ?? '';

                  return TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(name),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(phone),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(email),
                    ),
                  ]);
                } else {
                  // Return empty cells if row is not a map
                  return const TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(''),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(''),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(''),
                    ),
                  ]);
                }
              }).toList(),
            ],
          ));
          widgets.add(const SizedBox(height: 16));
        }
      }

      // Images
      if (section['images'] != null &&
          section['images'] is List<dynamic> &&
          section['images'].isNotEmpty) {
        widgets.add(const Text(
          'Images',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ));
        widgets.add(const SizedBox(height: 8));

        widgets.add(GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: section['images'].length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemBuilder: (context, index) {
            String imageUrl = section['images'][index];
            return Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image);
              },
            );
          },
        ));
        widgets.add(const SizedBox(height: 16));
      }

      // Single Image
      if (section['image'] != null && section['image'].isNotEmpty) {
        widgets.add(const Text(
          'Image',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ));
        widgets.add(const SizedBox(height: 8));

        widgets.add(Image.network(
          section['image'],
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image);
          },
        ));
        widgets.add(const SizedBox(height: 16));
      }

      // Link
      if (section['link'] != null && section['link'].isNotEmpty) {
        widgets.add(const Text(
          'Link',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ));
        widgets.add(const SizedBox(height: 8));

        widgets.add(LinkWidget(url: section['link']));
        widgets.add(const SizedBox(height: 16));
      }

      // Links (Multiple)
      if (section['links'] != null && section['links'].isNotEmpty) {
        widgets.add(const Text(
          'Links',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ));
        widgets.add(const SizedBox(height: 8));

        if (section['links'] is List<dynamic>) {
          widgets.add(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: section['links']
                .map<Widget>((link) => LinkWidget(url: link))
                .toList(),
          ));
        } else if (section['links'] is String) {
          widgets.add(LinkWidget(url: section['links']));
        }
        widgets.add(const SizedBox(height: 16));
      }

      // Form (fixed typo: 'feilds' remains as is based on JSON)
      if (section['form'] != null &&
          section['form']['feilds'] != null &&
          (section['form']['feilds'] as List<dynamic>).isNotEmpty) {
        final formWidget = _buildForm(section['form']);
        if (formWidget != null) {
          widgets.add(formWidget);
          widgets.add(const SizedBox(height: 16));
        }
      }
    }

    return widgets;
  }

  Widget? _buildForm(Map<String, dynamic> form) {
    final fields = form['feilds'] as List<dynamic>;
    final submitUrl = form['submit'];

    // Return null if no fields are available
    if (fields.isEmpty) {
      return null;
    }

    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                form['title'] != null && form['title'].isNotEmpty
                    ? form['title']
                    : 'Form',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...fields.map<Widget>((field) {
                final fieldName = field['title'];
                final isRequired = field['required'] ?? false;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _controllers[fieldName],
                    decoration: InputDecoration(
                      labelText: fieldName,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (isRequired &&
                          (value == null || value.trim().isEmpty)) {
                        return '$fieldName is required';
                      }
                      return null;
                    },
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (submitUrl != null && submitUrl.isNotEmpty) {
                    _submitForm(submitUrl);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Submit URL is not provided.')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LinkWidget extends StatelessWidget {
  final String url;
  const LinkWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Handle link tap, e.g., using url_launcher package
        // Uncomment the lines below after adding url_launcher to pubspec.yaml
        /*
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch $url')),
          );
        }
        */
        // For now, just print the URL
        print('Link tapped: $url');
      },
      child: Text(
        url,
        style: const TextStyle(
            color: Colors.blue, decoration: TextDecoration.underline),
      ),
    );
  }
}
