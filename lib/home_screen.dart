import 'package:flutter/material.dart';
import 'package:local_storage/database/database_helper.dart';
import 'package:local_storage/widgets/contact_card.dart';
import 'package:local_storage/widgets/contact_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  DatabaseHelper databaseHelper = DatabaseHelper();

  int? editingId;

  List<Map<String, dynamic>> contacts = [];

  bool showFavoritesOnly = false;

  @override
  void initState() {
    super.initState();
    readContacts();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> readContacts() async {
    List<Map<String, dynamic>> rows =
    await databaseHelper.readContacts(
      searchController.text.trim(),
      showFavoritesOnly,
    );

    if (!mounted) return;

    setState(() {
      contacts = rows;
    });
  }

  Future<void> addContact() async {
    await databaseHelper.addContact({
      'name': nameController.text.trim(),
      'phone': phoneController.text.trim(),
      'email': emailController.text.trim(),
      'address': addressController.text.trim(),
      'isFavorite': 0,
    });

    if (!mounted) return;

    clearBoxes();
    await readContacts();
    showMessage('Contact added successfully');
  }

  Future<void> updateContact() async {
    await databaseHelper.updateContact(editingId!, {
      'name': nameController.text.trim(),
      'phone': phoneController.text.trim(),
      'email': emailController.text.trim(),
      'address': addressController.text.trim(),
    });

    if (!mounted) return;

    clearBoxes();
    await readContacts();
    showMessage('Contact updated successfully');
  }

  Future<void> deleteContact(int id) async {
    await databaseHelper.deleteContact(id);

    if (!mounted) return;

    if (editingId == id) {
      clearBoxes();
    }

    await readContacts();
    showMessage('Contact deleted successfully');
  }

  Future<void> toggleFavorite(
      Map<String, dynamic> contact,
      ) async {
    int favoriteValue = contact['isFavorite'] == 1 ? 0 : 1;

    await databaseHelper.updateFavorite(
      contact['id'],
      favoriteValue,
    );

    await readContacts();
  }

  void startEditing(Map<String, dynamic> contact) {
    setState(() {
      editingId = contact['id'];
      nameController.text = contact['name'];
      phoneController.text = contact['phone'];
      emailController.text = contact['email'];
      addressController.text = contact['address'];
    });
  }

  void saveButtonPressed() {
    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty) {
      showMessage('Please fill all fields');
      return;
    }

    if (editingId == null) {
      addContact();
    } else {
      updateContact();
    }
  }

  void clearBoxes() {
    setState(() {
      editingId = null;
      nameController.clear();
      phoneController.clear();
      emailController.clear();
      addressController.clear();
    });
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Management'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: (value) {
                readContacts();
              },
              decoration: InputDecoration(
                hintText: 'Search contacts by name',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () {
                    searchController.clear();
                    readContacts();
                  },
                  icon: const Icon(Icons.close),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  showFavoritesOnly
                      ? 'Favorite Contacts'
                      : 'All Contacts',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      showFavoritesOnly = !showFavoritesOnly;
                    });

                    readContacts();
                  },
                  icon: Icon(
                    showFavoritesOnly
                        ? Icons.people
                        : Icons.favorite,
                  ),
                  label: Text(
                    showFavoritesOnly
                        ? 'Show All'
                        : 'Favorites Only',
                  ),
                ),
              ],
            ),

            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: ContactForm(
                  nameController: nameController,
                  phoneController: phoneController,
                  emailController: emailController,
                  addressController: addressController,
                  onSave: saveButtonPressed,
                  isEditing: editingId != null,
                  onCancel: clearBoxes,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  const Text(
                    'Saved Contacts',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  Text('${contacts.length} Contacts'),
                ],
              ),
            ),

            Expanded(
              flex: 4,
              child: contacts.isEmpty
                  ? const Center(
                child: Text('No contacts found'),
              )
                  : ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> contact = contacts[index];

                  return ContactCard(
                    contact: contact,
                    onEdit: () {
                      startEditing(contact);
                    },
                    onDelete: () {
                      deleteContact(contact['id']);
                    },
                    onFavorite: () {
                      toggleFavorite(contact);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}