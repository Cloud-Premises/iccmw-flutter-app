// lib/pages/business_detail_page.dart
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class BusinessDetailPage extends StatefulWidget {
  final String imageUrl;
  final String businessName;
  final String businessDescription;
  final String jsonUrl; // JSON URL to fetch additional data
  final int businessId; // Business ID to find specific data

  const BusinessDetailPage({
    Key? key,
    required this.imageUrl,
    required this.businessName,
    required this.businessDescription,
    required this.jsonUrl,
    required this.businessId,
  }) : super(key: key);

  @override
  State<BusinessDetailPage> createState() => _BusinessDetailPageState();
}

class _BusinessDetailPageState extends State<BusinessDetailPage> {
  Map<String, dynamic>? businessData;
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    fetchBusinessData(widget.jsonUrl);
  }

  Future<void> fetchBusinessData(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final subcategories = data['subcategories'] as Map<String, dynamic>?;
        if (subcategories == null) {
          print('Subcategories is null');
          return;
        }

        final businessList = subcategories['data'] as List<dynamic>?;
        if (businessList == null) {
          print('Business list is null');
          return;
        }

        // Find the service by ID
        final selectedService = businessList.firstWhere(
          (service) => service['id'] == widget.businessId,
          orElse: () => null,
        );

        if (selectedService != null) {
          setState(() {
            businessData = selectedService;
            _initializeFormControllers();
          });
        }
      } else {
        print('Failed to load service data');
      }
    } catch (e) {
      print('Error fetching service data: $e');
    }
  }

  void _initializeFormControllers() {
    if (businessData == null) return;

    final dataSections = businessData!['data'] as List<dynamic>;
    for (var section in dataSections) {
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

  Future<void> _refreshData() async {
    setState(() {
      fetchBusinessData(widget.jsonUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.businessName,
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
      body: businessData == null
          ? Center(
              child: kIsWeb
                  ? CircularProgressIndicator()
                  : (Platform.isAndroid
                      ? CircularProgressIndicator()
                      : CupertinoActivityIndicator()),
            )
          : Column(
              children: [
                Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 250,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 250,
                      color: Colors.grey,
                      child: const Icon(Icons.broken_image, size: 50),
                    );
                  },
                ),

                // Dynamic Form Section
                RefreshIndicator(
                  onRefresh: _refreshData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildBusinessDetails(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  List<Widget> _buildBusinessDetails() {
    List<Widget> widgets = [];

    // Display title and description if available
    if (businessData!['title'] != null && businessData!['title'].isNotEmpty) {
      widgets.add(Text(
        businessData!['title'],
        style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
      ));
      widgets.add(const SizedBox(height: 8));
    }

    if (businessData!['description'] != null &&
        businessData!['description'].isNotEmpty) {
      widgets.add(Text(
        businessData!['description'],
        style: const TextStyle(fontSize: 16),
      ));
      widgets.add(const SizedBox(height: 16));
    }

    // Display data sections if available
    final data = businessData!['data'] as List<dynamic>;
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
            border: TableBorder.all(color: commonComponentColor),
            children: [
              // Table Header
              TableRow(
                decoration: BoxDecoration(color: commonComponentColor),
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

      // Links

      if (section['links'] != null && section['links'].isNotEmpty) {
        // widgets.add(const Text(
        //   'Links',
        //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        // ));
        // widgets.add(const SizedBox(height: 8));

        // Check if links is a List of maps with 'title' and 'link' keys
        if (section['links'] is List<dynamic>) {
          widgets.add(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: section['links'].map<Widget>((linkItem) {
                // Ensure the item has both 'title' and 'link' keys
                if (linkItem is Map<String, dynamic> &&
                    linkItem.containsKey('title') &&
                    linkItem.containsKey('link')) {
                  return LinkWidget(
                    text: linkItem['title'],
                    url: linkItem['link'],
                  );
                } else {
                  return const SizedBox.shrink(); // Skip invalid items
                }
              }).toList(),
            ),
          );
        } else if (section['links'] is Map<String, dynamic>) {
          // If a single link map is provided
          var linkItem = section['links'];
          if (linkItem.containsKey('title') && linkItem.containsKey('link')) {
            widgets.add(LinkWidget(
              text: linkItem['title'],
              url: linkItem['link'],
            ));
          }
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
  final String text;
  const LinkWidget({super.key, required this.url, required this.text});

  @override
  Widget build(BuildContext context) {
    void openDonation(BuildContext context, String url) async {
      final Uri uri = Uri.parse(url);

      // Check if the URL can be launched
      if (await canLaunchUrl(uri)) {
        // Launch the URL in an external application
        await launchUrl(
          uri,
          mode: LaunchMode
              .externalApplication, // Ensure it opens in an external browser
        );
      } else {
        // Handle the error if the URL cannot be launched
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch the URL')),
        );
      }
    }

    return GestureDetector(
        onTap: () async {
          openDonation(context, url);

          // For now, just print the URL
          // print('Link tapped: $url');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              url,
              style: const TextStyle(
                color: Colors.blue,
              ),
            ),
            SizedBox(
              height: 4,
            )
          ],
        ));
  }
}
