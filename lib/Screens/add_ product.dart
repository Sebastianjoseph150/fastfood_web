// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:fastfoodweb/Screens/menu_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fastfoodweb/provider/product_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:file_picker/file_picker.dart';

// class ProductAddingPage extends StatefulWidget {
//   @override
//   _ProductAddingPageState createState() => _ProductAddingPageState();
// }

// class _ProductAddingPageState extends State<ProductAddingPage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final _name = TextEditingController();
//   final _description = TextEditingController();
//   final _price = TextEditingController();
//   final _restaurent = TextEditingController();

//   Uint8List _pickedImage = Uint8List(0);
//   bool _isImagePicked = false;
//   String? _selectedCategory;

//   List<String> _categories = [
//     'veg items',
//     'non-veg items',
//     'bread items',
//     'main courses',
//     'starters',
//     'burger',
//     'pizza'
//   ];

//   String? _validateNotEmpty(String? value, String field) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter a $field';
//     }
//     return null;
//   }

//   String? _validatePrice(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter a valid price';
//     }
//     int? parsedPrice = int.tryParse(value);
//     if (parsedPrice == null || parsedPrice <= 0) {
//       return 'Please enter a valid price';
//     }
//     return null;
//   }

//   Future<void> _pickImage() async {
//     try {
//       FilePickerResult? pickedImage = await FilePicker.platform.pickFiles(
//         type: FileType.image,
//       );

//       if (pickedImage != null && pickedImage.files.isNotEmpty) {
//         final fileBytes = pickedImage.files.first.bytes;
//         if (fileBytes != null) {
//           setState(() {
//             _pickedImage = Uint8List.fromList(fileBytes);
//             _isImagePicked = true;
//           });
//         }
//       } else {
//         print('No image picked.');
//       }
//     } catch (e) {
//       print('Error picking image: $e');
//     }
//   }

//   void _saveProduct(ProductProvider productProvider) async {
//     if (_formKey.currentState!.validate()) {
//       print('Data is valid');

//       _formKey.currentState!.save();

//       // Ensure that the image is picked before proceeding
//       if (!_isImagePicked) {
//         await _pickImage();
//       }

//       if (_pickedImage.isNotEmpty) {
//         productProvider
//             .addProductToFirestore(
//           userID: FirebaseAuth.instance.currentUser!.uid,
//           name: _name.text,
//           price: _price.text,
//           description: _description.text,
//           category: _selectedCategory!,
//                     restaurant: _restaurent.text,

//           imageUrl: _pickedImage,
//           quantity: 1,
//         )
//             .then((value) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(value),
//               duration: Duration(seconds: 2),
//             ),
//           );
//         });

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => MenuScreen(),
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.orange,
//         title: Center(
//           child: Text(
//             'Add Product',
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Center(
//           child: Container(
//             height: double.infinity,
//             width: 500,
//             decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
//             child: Form(
//               key: _formKey,
//               child: Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         _pickImage();
//                         setState(() {
//                           _isImagePicked = true;
//                         });
//                       },
//                       child: Container(
//                         height: 150,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: Colors.grey,
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                         child: Center(
//                           child: _isImagePicked
//                               ? Image.memory(
//                                   _pickedImage,
//                                   fit: BoxFit.cover,
//                                 )
//                               : Icon(
//                                   Icons.add_a_photo,
//                                   size: 40,
//                                   color: Colors.white,
//                                 ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     TextFormField(
//                       controller: _name,
//                       decoration: InputDecoration(
//                         labelText: 'Name',
//                         border: OutlineInputBorder(),
//                         hintText: 'Enter product name',
//                       ),
//                       validator: (value) => _validateNotEmpty(value, 'Name'),
//                     ),
//                     SizedBox(height: 16),
//                     DropdownButtonFormField<String>(
//                       value: _selectedCategory,
//                       items: _categories.map((category) {
//                         return DropdownMenuItem<String>(
//                           value: category,
//                           child: Text(category),
//                         );
//                       }).toList(),
//                       onChanged: (newValue) {
//                         setState(() {
//                           _selectedCategory = newValue;
//                         });
//                       },
//                       decoration: InputDecoration(
//                         labelText: 'Category',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: (value) {
//                         if (_selectedCategory == null) {
//                           return 'Please select a category';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 16),
//                     TextFormField(
//                       controller: _price,
//                       decoration: InputDecoration(
//                         labelText: 'Price',
//                         border: OutlineInputBorder(),
//                         hintText: 'Enter product price',
//                       ),
//                       keyboardType: TextInputType.number,
//                       validator: (value) => _validatePrice(value),
//                     ),
//                     SizedBox(height: 16),
//                     TextFormField(
//                       controller: _restaurent,
//                       decoration: InputDecoration(
//                         labelText: 'Restaurant name',
//                         border: OutlineInputBorder(),
//                         hintText: 'Restaurant name',
//                       ),
//                       // validator: (value) => _validateNotEmpty(value, 'Name'),
//                     ),
//                     SizedBox(height: 16),
//                     TextFormField(
//                       controller: _description,
//                       decoration: InputDecoration(
//                         hintText: 'Enter product description',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: () {
//                         _saveProduct(Provider.of<ProductProvider>(context,
//                             listen: false));
//                         // Navigator.push(
//                         //   context,
//                         //   MaterialPageRoute(
//                         //     builder: (context) => MenuScreen(),
//                         //   ),
//                         // );
//                       },
//                       child: Text('Save Product'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fastfoodweb/Screens/menu_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fastfoodweb/provider/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

class ProductAddingPage extends StatefulWidget {
  @override
  _ProductAddingPageState createState() => _ProductAddingPageState();
}

class _ProductAddingPageState extends State<ProductAddingPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  final _restaurant = TextEditingController();

  Uint8List _pickedImage = Uint8List(0);
  bool _isImagePicked = false;
  String? _selectedCategory;

  List<String> _categories = [
    'veg items',
    'non-veg items',
    'bread items',
    'main courses',
    'starters',
    'burger',
    'pizza'
  ];

  String? _validateNotEmpty(String? value, String field) {
    if (value == null || value.isEmpty) {
      return 'Please enter a $field';
    }
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid price';
    }
    int? parsedPrice = int.tryParse(value);
    if (parsedPrice == null || parsedPrice <= 0) {
      return 'Please enter a valid price';
    }
    return null;
  }

  Future<void> _pickImage() async {
    try {
      FilePickerResult? pickedImage = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (pickedImage != null && pickedImage.files.isNotEmpty) {
        final fileBytes = pickedImage.files.first.bytes;
        if (fileBytes != null) {
          setState(() {
            _pickedImage = Uint8List.fromList(fileBytes);
            _isImagePicked = true;
          });
        }
      } else {
        print('No image picked.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _saveProduct(ProductProvider productProvider) async {
    if (_formKey.currentState!.validate()) {
      print('Data is valid');

      _formKey.currentState!.save();

      // Ensure that the image is picked before proceeding
      if (!_isImagePicked) {
        await _pickImage();
      }

      // Check if any required field is null
      if (_name.text.isNotEmpty &&
          _price.text.isNotEmpty &&
          _description.text.isNotEmpty &&
          _selectedCategory != null &&
          _restaurant.text.isNotEmpty &&
          _pickedImage.isNotEmpty) {
        productProvider
            .addProductToFirestore(
          userID: FirebaseAuth.instance.currentUser!.uid,
          name: _name.text,
          price: _price.text,
          description: _description.text,
          category: _selectedCategory!,
          restaurant: _restaurant.text,
          imageUrl: _pickedImage,
          quantity: 1,
        )
            .then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('success'),
              duration: const Duration(seconds: 2),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MenuScreen(),
            ),
          );
        }).catchError((error) {
          print('Error saving product: $error');
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all required fields.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Center(
          child: Text(
            'Add Product',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            height: double.infinity,
            width: 500,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _pickImage();
                      },
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: _isImagePicked
                              ? Image.memory(
                                  _pickedImage,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(
                                  Icons.add_a_photo,
                                  size: 40,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _name,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                        hintText: 'Enter product name',
                      ),
                      validator: (value) => _validateNotEmpty(value, 'Name'),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      items: _categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (_selectedCategory == null) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _price,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                        hintText: 'Enter product price',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => _validatePrice(value),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _restaurant,
                      decoration: const InputDecoration(
                        labelText: 'Restaurant name',
                        border: OutlineInputBorder(),
                        hintText: 'Restaurant name',
                      ),
                      // validator: (value) => _validateNotEmpty(value, 'Name'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _description,
                      decoration: const InputDecoration(
                        hintText: 'Enter product description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _saveProduct(Provider.of<ProductProvider>(context,
                            listen: false));
                      },
                      child: const Text('Save Product'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
