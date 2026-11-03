import 'package:flutter/material.dart';

class ContactForm extends StatelessWidget {
  const ContactForm({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.addressController,
    required this.onSave,
    required this.isEditing,
    required this.onCancel,
  });

  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController addressController;

  final VoidCallback onSave;
  final VoidCallback onCancel;
  final bool isEditing;

  Widget buildInputField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            buildInputField(
              controller: nameController,
              label: 'Name',
            ),

            buildInputField(
              controller: phoneController,
              label: 'Phone Number',
              keyboardType: TextInputType.phone,
            ),

            buildInputField(
              controller: emailController,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),

            buildInputField(
              controller: addressController,
              label: 'Address',
            ),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onSave,
                    child: Text(
                      isEditing ? 'UPDATE CONTACT' : 'ADD CONTACT',
                    ),
                  ),
                ),

                if (isEditing) ...[
                  const SizedBox(width: 8),

                  OutlinedButton(
                    onPressed: onCancel,
                    child: const Text('CANCEL'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}