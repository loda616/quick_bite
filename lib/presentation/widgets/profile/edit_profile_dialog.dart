//import 'package:flutter/material.dart';
//  
//
// class EditProfileDialog extends StatefulWidget {
//   final String? initialName;
//   final String? initialEmail;
//   final String? initialPhone;
//   final String? initialAddress;
//   final Function(String, String, String, String) onSave;
//
//   const EditProfileDialog({
//     super.key,
//     this.initialName,
//     this.initialEmail,
//     this.initialPhone,
//     this.initialAddress,
//     required this.onSave,
//   });
//
//   @override
//   State<EditProfileDialog> createState() => _EditProfileDialogState();
// }
//
// class _EditProfileDialogState extends State<EditProfileDialog> {
//   late final TextEditingController _nameController;
//   late final TextEditingController _emailController;
//   late final TextEditingController _phoneController;
//   late final TextEditingController _addressController;
//
//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.initialName);
//     _emailController = TextEditingController(text: widget.initialEmail);
//     _phoneController = TextEditingController(text: widget.initialPhone);
//     _addressController = TextEditingController(text: widget.initialAddress);
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//   
//
//     return AlertDialog(
//       title: Text(    editProfile),
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(
//                 labelText:     fullName,
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(
//                 labelText:     email,
//               ),
//               keyboardType: TextInputType.emailAddress,
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _phoneController,
//               decoration: InputDecoration(
//                 labelText:     phone,
//               ),
//               keyboardType: TextInputType.phone,
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _addressController,
//               decoration: InputDecoration(
//                 labelText:     address,
//               ),
//               maxLines: 2,
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: Text(    cancel),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             widget.onSave(
//               _nameController.text,
//               _emailController.text,
//               _phoneController.text,
//               _addressController.text,
//             );
//             Navigator.pop(context);
//           },
//           child: Text(    save),
//         ),
//       ],
//     );
//   }
// }