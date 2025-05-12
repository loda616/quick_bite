//import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
//     final l10n = AppLocalizations.of(context)!;
//
//     return AlertDialog(
//       title: Text(l10n.editProfile),
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(
//                 labelText: l10n.fullName,
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(
//                 labelText: l10n.email,
//               ),
//               keyboardType: TextInputType.emailAddress,
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _phoneController,
//               decoration: InputDecoration(
//                 labelText: l10n.phone,
//               ),
//               keyboardType: TextInputType.phone,
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _addressController,
//               decoration: InputDecoration(
//                 labelText: l10n.address,
//               ),
//               maxLines: 2,
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: Text(l10n.cancel),
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
//           child: Text(l10n.save),
//         ),
//       ],
//     );
//   }
// }