import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.contact,
    required this.onEdit,
    required this.onDelete,
    required this.onFavorite,
  });

  final Map<String, dynamic> contact;

  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade100,
          child: Text('${contact['id']}'),
        ),

        title: Text(
          contact['name'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(
          'ID: ${contact['id']}\n'
              'Phone: ${contact['phone']}\n'
              'Email: ${contact['email']}\n'
              'Address: ${contact['address']}',
        ),

        onTap: onEdit,

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onFavorite,
              icon: Icon(
                contact['isFavorite'] == 1
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.red,
              ),
            ),

            IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}