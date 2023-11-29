import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Uint8List? _pickedImage;
  final _firebaseStorage = FirebaseStorage.instance;
  final _restaurantNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> pickImage() async {
    FilePickerResult? pickedImage =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (pickedImage != null && pickedImage.files.isNotEmpty) {
      final fileBytes = pickedImage.files.first.bytes;
      if (fileBytes != null) {
        _pickedImage = Uint8List.fromList(fileBytes);
        setState(() {});
      }
    }
  }

  Future<String?> uploadImageToFirebaseStorage() async {
    if (_pickedImage != null) {
      Reference ref =
          _firebaseStorage.ref().child('restaurant_images').child('image.jpg');
      UploadTask uploadTask = ref.putData(_pickedImage!);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Container(
          width: 600,
          height: 550,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(4.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 3),
              ),
            ],
            color: Colors.white,
          ),
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                    ),
                    child: _pickedImage != null
                        ? ClipOval(
                            child: Image.memory(
                              _pickedImage!,
                              width: 150.0,
                              height: 150.0,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.add_a_photo,
                            size: 50,
                            color: Colors.grey,
                          ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _restaurantNameController,
                decoration: InputDecoration(
                  labelText: 'Restaurant Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final restaurantName = _restaurantNameController.text;
                  final description = _descriptionController.text;
                  String? imageUrl = await uploadImageToFirebaseStorage();
                  print('hii');
                  if (imageUrl != null) {
                    User? user = FirebaseAuth.instance.currentUser;
                    String userID = user!.uid;
                    print(userID);

                    DocumentReference userDocRef = FirebaseFirestore.instance
                        .collection('users')
                        .doc(userID);

                    // Check if the document already exists for the user
                    bool documentExists = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userID)
                        .collection('restaurants')
                        .get()
                        .then((QuerySnapshot querySnapshot) =>
                            querySnapshot.docs.isNotEmpty);

                    if (!documentExists) {
                      // Add a new document if one doesn't exist for the user
                      userDocRef.collection('restaurants').add({
                        'name': restaurantName,
                        'description': description,
                        'imageUrl': imageUrl,
                        // Add other fields as needed
                      }).then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Restaurant details saved!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }).catchError((error) {
                        print('Failed to save details: $error');
                        // Handle error scenario
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Restaurant details already exist for this user!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to upload image'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
