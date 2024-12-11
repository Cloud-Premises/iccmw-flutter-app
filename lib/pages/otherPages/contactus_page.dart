// import 'package:flutter/material.dart';

// import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';

// class ContactUsPage extends StatefulWidget {
//   const ContactUsPage({super.key});

//   @override
//   State<ContactUsPage> createState() => ContactUsPageState();
// }

// class ContactUsPageState extends State<ContactUsPage> {
//   final _formKey = GlobalKey<FormState>();
//   // ignore: unused_field
//   String? _name;
//   // ignore: unused_field
//   String? _mobileNumber;
//   // ignore: unused_field
//   String? _email;
//   // ignore: unused_field
//   String? _message;
//   // ignore: unused_field
//   String? _subject;
//   // ignore: unused_field
//   String? _category;
//   // String _contactNumber = '+1 347-471-8869';
//   // String _contactEmail = 'icc4mw@gmail.com';

//   @override
//   void initState() {
//     super.initState();
//     // _fetchContactDetails();
//   }

//   // Future<void> _fetchContactDetails() async {
//   //   const url =
//   //       'https://raw.githubusercontent.com/Cloud-Premises/iccmw-app/refs/heads/main/data/assets/json/contactPage/contact.json';

//   //   try {
//   //     final response = await http.get(Uri.parse(url));

//   //     if (response.statusCode == 200) {
//   //       final data = json.decode(response.body);
//   //       setState(() {
//   //         _contactNumber = data['contact']['phone'] ?? 'Not available';
//   //         _contactEmail = data['contact']['email'] ?? 'Not available';
//   //       });
//   //     } else {
//   //       throw Exception('Failed to load contact details');
//   //     }
//   //   } catch (e) {
//   //     setState(() {
//   //       _contactNumber = 'Failed to fetch';
//   //       _contactEmail = 'Failed to fetch';
//   //     });
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bodyBackgroundColor,
//       appBar: AppBar(
//         // backgroundColor: Theme.of(context).colorScheme.primary,
//         backgroundColor: appBarColor,
//         title: Row(
//           children: [
//             Image(
//               image: AssetImage('assets/images/icons/mail.png'),
//               width: 24.0,
//               height: 24.0,
//             ),
//             SizedBox(width: 10.0),
//             Text(
//               "Contact Us",
//               style: TextStyle(
//                 color: appBarTextColor,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           icon: Icon(
//             Icons.arrow_back_ios,
//             color: appBarIconColor,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Contact Form',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Card(
//               color: Colors.white,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Form(
//                   key: _formKey,
//                   child: Container(
//                     width: double.infinity,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Icon(Icons.person),
//                             SizedBox(
//                               width: 18,
//                             ),
//                             Expanded(
//                               child: TextFormField(
//                                 decoration: const InputDecoration(
//                                   labelText: 'Name',
//                                 ),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter your name';
//                                   }
//                                   return null;
//                                 },
//                                 onSaved: (value) => _name = value,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 12),
//                         Row(
//                           children: [
//                             Icon(Icons.mail_outline),
//                             SizedBox(
//                               width: 18,
//                             ),
//                             Expanded(
//                               child: TextFormField(
//                                 decoration: const InputDecoration(
//                                   labelText: 'Email',
//                                 ),
//                                 keyboardType: TextInputType.emailAddress,
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter your email';
//                                   } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
//                                       .hasMatch(value)) {
//                                     return 'Please enter a valid email address';
//                                   }
//                                   return null;
//                                 },
//                                 onSaved: (value) => _email = value,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 12),
//                         Row(
//                           children: [
//                             Icon(Icons.call),
//                             SizedBox(
//                               width: 18,
//                             ),
//                             Expanded(
//                               child: TextFormField(
//                                 decoration: const InputDecoration(
//                                   labelText: 'Mobile Number',
//                                 ),
//                                 keyboardType: TextInputType.phone,
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter your mobile number';
//                                   }
//                                   return null;
//                                 },
//                                 onSaved: (value) => _mobileNumber = value,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 12),
//                         Row(
//                           children: [
//                             Icon(Icons.format_align_left_sharp),
//                             SizedBox(
//                               width: 18,
//                             ),
//                             Expanded(
//                               child: TextFormField(
//                                 decoration: const InputDecoration(
//                                   labelText: 'Subject',
//                                 ),
//                                 keyboardType: TextInputType.text,
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please select your subject';
//                                   }
//                                   return null;
//                                 },
//                                 onSaved: (value) => _subject = value,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 12),
//                         Row(
//                           children: [
//                             Icon(Icons.format_align_justify_sharp),
//                             SizedBox(
//                               width: 18,
//                             ),
//                             Expanded(
//                               child: TextFormField(
//                                 decoration: const InputDecoration(
//                                   labelText: 'Message',
//                                 ),
//                                 maxLines: 4,
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter your message';
//                                   }
//                                   return null;
//                                 },
//                                 onSaved: (value) => _message = value,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             ElevatedButton(
//                               onPressed: () {
//                                 if (_formKey.currentState!.validate()) {
//                                   _formKey.currentState!.save();
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                         content:
//                                             Text('Successfully submitted')),
//                                   );
//                                   _formKey.currentState!.reset();
//                                 }
//                               },
//                               child: const Text('Submit'),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'Contact Details',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       'Mobile Number: ',
//                       style: TextStyle(
//                         fontSize: 18,
//                       ),
//                     ),
//                     SizedBox(width: 12),
//                     Text(
//                       '+1 347-471-8869',
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Text(
//                       'E-mail Address: ',
//                       style: TextStyle(
//                         fontSize: 18,
//                       ),
//                     ),
//                     SizedBox(width: 12),
//                     Text(
//                       'icc4mw@gmail.com',
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:iccmw/features/app_theme/utils/app_theme_data.dart'; // Ensure this path is correct
// // If you plan to use url_launcher for future enhancements, you can import it here

// class ContactUsPage extends StatefulWidget {
//   const ContactUsPage({super.key});

//   @override
//   State<ContactUsPage> createState() => ContactUsPageState();
// }

// class ContactUsPageState extends State<ContactUsPage> {
//   final _formKey = GlobalKey<FormState>();
//   String? _name;
//   String? _email;
//   String? _mobileNumber;
//   String? _subject;
//   String? _message;

//   Future<void> _sendEmail() async {
//     const serviceId = 'iccmw_app'; // Replace with your EmailJS service ID
//     const templateId =
//         'iccmw_app_template'; // Replace with your EmailJS template ID
//     const userId = 'a2tMVtbzIJqJ-XL4y'; // Replace with your EmailJS user ID

//     final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'service_id': serviceId,
//         'template_id': templateId,
//         'user_id': userId,
//         'template_params': {
//           'name': _name,
//           'email': _email,
//           'mobile_number': _mobileNumber,
//           'subject': _subject,
//           'message': _message,
//         },
//       }),
//     );

//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Email sent successfully!')),
//       );
//       _formKey.currentState?.reset();
//     } else {
//       print('Error: ${response.body}');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to send email: ${response.body}')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bodyBackgroundColor, // From your app_theme_data.dart
//       appBar: AppBar(
//         backgroundColor: appBarColor, // From your app_theme_data.dart
//         title: Row(
//           children: [
//             Image.asset(
//               'assets/images/icons/mail.png',
//               width: 24.0,
//               height: 24.0,
//             ),
//             const SizedBox(width: 10.0),
//             Text(
//               "Contact Us",
//               style: TextStyle(
//                 color: appBarTextColor, // From your app_theme_data.dart
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           icon: Icon(
//             Icons.arrow_back_ios,
//             color: appBarIconColor, // From your app_theme_data.dart
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Contact Form',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Card(
//               color: Colors.white,
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       // Name Field
//                       Row(
//                         children: [
//                           const Icon(Icons.person, color: commonComponentColor),
//                           const SizedBox(width: 18),
//                           Expanded(
//                             child: TextFormField(
//                               decoration: const InputDecoration(
//                                 labelText: 'Name',
//                                 border: OutlineInputBorder(),
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your name';
//                                 }
//                                 return null;
//                               },
//                               onSaved: (value) => _name = value,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),

//                       // Email Field
//                       Row(
//                         children: [
//                           const Icon(Icons.mail_outline, color: commonComponentColor),
//                           const SizedBox(width: 18),
//                           Expanded(
//                             child: TextFormField(
//                               decoration: const InputDecoration(
//                                 labelText: 'Email',
//                                 border: OutlineInputBorder(),
//                               ),
//                               keyboardType: TextInputType.emailAddress,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your email';
//                                 } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
//                                     .hasMatch(value)) {
//                                   return 'Please enter a valid email address';
//                                 }
//                                 return null;
//                               },
//                               onSaved: (value) => _email = value,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),

//                       // Mobile Number Field
//                       Row(
//                         children: [
//                           const Icon(Icons.call, color: commonComponentColor),
//                           const SizedBox(width: 18),
//                           Expanded(
//                             child: TextFormField(
//                               decoration: const InputDecoration(
//                                 labelText: 'Mobile Number',
//                                 border: OutlineInputBorder(),
//                               ),
//                               keyboardType: TextInputType.phone,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your mobile number';
//                                 }
//                                 return null;
//                               },
//                               onSaved: (value) => _mobileNumber = value,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),

//                       // Subject Field
//                       Row(
//                         children: [
//                           const Icon(Icons.subject, color: commonComponentColor),
//                           const SizedBox(width: 18),
//                           Expanded(
//                             child: TextFormField(
//                               decoration: const InputDecoration(
//                                 labelText: 'Subject',
//                                 border: OutlineInputBorder(),
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter the subject';
//                                 }
//                                 return null;
//                               },
//                               onSaved: (value) => _subject = value,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),

//                       // Message Field
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Icon(Icons.message, color: commonComponentColor),
//                           const SizedBox(width: 18),
//                           Expanded(
//                             child: TextFormField(
//                               decoration: const InputDecoration(
//                                 labelText: 'Message',
//                                 border: OutlineInputBorder(),
//                               ),
//                               maxLines: 4,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your message';
//                                 }
//                                 return null;
//                               },
//                               onSaved: (value) => _message = value,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),

//                       // Submit Button
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () {
//                               if (_formKey.currentState?.validate() ?? false) {
//                                 _formKey.currentState?.save();
//                                 _sendEmail();
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 24, vertical: 12),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8.0),
//                               ),
//                               backgroundColor: Theme.of(context).primaryColor,
//                             ),
//                             child: const Text(
//                               'Submit',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Contact Details Section
//             const Text(
//               'Contact Details',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     const Icon(Icons.phone, color: Colors.blue),
//                     const SizedBox(width: 12),
//                     const Text(
//                       'Mobile Number: ',
//                       style: TextStyle(
//                         fontSize: 18,
//                       ),
//                     ),
//                   ],
//                 ),
//                 // const SizedBox(width: 12),
//                 Row(
//                   children: [
//                     Text(
//                       '+1 347-471-8869',
//                       style: TextStyle(
//                         color: Colors.red[700],
//                         fontSize: 18,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 14),
//                 Row(
//                   children: [
//                     const Icon(Icons.email, color: Colors.blue),
//                     const SizedBox(width: 12),
//                     const Text(
//                       'E-mail Address: ',
//                       style: TextStyle(
//                         fontSize: 18,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Text(
//                       'icc4mw@gmail.com',
//                       style: TextStyle(
//                         color: Colors.red[700],
//                         fontSize: 18,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 32),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:iccmw/features/app_theme/utils/app_theme_data.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  String? _mobileNumber;
  String? _subject;
  String? _message;

  Future<void> _sendEmail() async {
    final email = Email(
      body: 'Name: $_name\nEmail: $_email\nMobile: $_mobileNumber\n'
          'Subject: $_subject\nMessage: $_message',
      subject: _subject ?? 'Contact Us Form Submission',
      recipients: ['icc4mw@gmail.com'],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email draft opened successfully!')),
      );
      _formKey.currentState?.reset();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send email: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: appBarColor,
        title: Row(
          children: [
            Image(
              image: AssetImage('assets/images/icons/mail.png'),
              width: 24.0,
              height: 24.0,
            ),
            SizedBox(width: 10.0),
            Text(
              "Contact Us",
              style: TextStyle(
                color: appBarTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: appBarIconColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Contact Details',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Card(
                color: Colors.white,
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Name Field
                        Row(
                          children: [
                            Icon(Icons.person, color: commonComponentColor),
                            const SizedBox(width: 18),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                                onSaved: (value) => _name = value,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Email Field
                        Row(
                          children: [
                            Icon(Icons.mail_outline,
                                color: commonComponentColor),
                            const SizedBox(width: 18),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                      .hasMatch(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                                onSaved: (value) => _email = value,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Mobile Number Field
                        Row(
                          children: [
                            Icon(Icons.call, color: commonComponentColor),
                            const SizedBox(width: 18),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Mobile Number',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your mobile number';
                                  }
                                  return null;
                                },
                                onSaved: (value) => _mobileNumber = value,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Subject Field
                        Row(
                          children: [
                            Icon(Icons.subject, color: commonComponentColor),
                            const SizedBox(width: 18),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Subject',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the subject';
                                  }
                                  return null;
                                },
                                onSaved: (value) => _subject = value,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Message Field
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.message, color: commonComponentColor),
                            const SizedBox(width: 18),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Message',
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 4,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your message';
                                  }
                                  return null;
                                },
                                onSaved: (value) => _message = value,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Submit Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  _formKey.currentState?.save();
                                  _sendEmail();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                backgroundColor: primaryButtonBackgroundColor,
                              ),
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Poppins",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Contact Details Section
              const Text(
                'Contact Details',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.phone, color: commonComponentColor),
                      SizedBox(width: 12),
                      Text(
                        'Mobile Number:',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Text(
                    ' +1 347-471-8869',
                    style: TextStyle(fontSize: 18, color: headingColorLight),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.email, color: commonComponentColor),
                      SizedBox(width: 12),
                      Text(
                        'Email Address: ',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'icc4mw@gmail.com',
                    style: TextStyle(fontSize: 18, color: headingColorLight),
                  ),
                ],
              ),
              SizedBox(
                height: 32,
              ),
            ],
          )),
    );
  }
}
