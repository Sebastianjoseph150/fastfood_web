import 'package:flutter/material.dart';
import 'package:fastfoodweb/Screens/auth/admin_login.dart';
import 'package:fastfoodweb/Screens/menu_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fastfoodweb/provider/product_provider.dart';
import 'package:provider/provider.dart';

class ProductAddingPage extends StatefulWidget {
  @override
  _ProductAddingPageState createState() => _ProductAddingPageState();
}

class _ProductAddingPageState extends State<ProductAddingPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  final _restaurent = TextEditingController();

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

  bool _isImagePicked = false;

  void _saveProduct(ProductProvider productProvider) async {
    if (_formKey.currentState!.validate()) {
      print('Data is valid');

      _formKey.currentState!.save();
      if (!_isImagePicked) {
        await Provider.of<ProductProvider>(context, listen: false).pickImage();
        setState(() {
          _isImagePicked = true;
        });
      }
      final pickedImage =
          Provider.of<ProductProvider>(context, listen: false).pickedImage;

      if (pickedImage != null) {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String userID = user.uid;
          await Provider.of<ProductProvider>(context, listen: false)
              .addProductToFirestore(
            userID: userID,
            name: _name.text,
            price: _price.text,
            description: _description.text,
            category: _selectedCategory!,
            imageUrl: pickedImage,
            restaurent: _restaurent.text,
            quantity: 1,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Product added successfully.'),
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MenuScreen(),
            ),
          );
        } else {
          // If the user is not authenticated, navigate to the login page
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Center(
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
                        Provider.of<ProductProvider>(context, listen: false)
                            .pickImage();
                        setState(() {
                          _isImagePicked = true;
                        });
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
                                  Provider.of<ProductProvider>(context)
                                      .pickedImage!,
                                )
                              : Icon(Icons.add_a_photo,
                                  size: 40, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _name,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                        hintText: 'Enter product name',
                      ),
                      validator: (value) => _validateNotEmpty(value, 'Name'),
                    ),
                    SizedBox(height: 16),
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
                      decoration: InputDecoration(
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
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _price,
                      decoration: InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                        hintText: 'Enter product price',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => _validatePrice(value),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _restaurent,
                      decoration: InputDecoration(
                        labelText: 'Restaurant name',
                        border: OutlineInputBorder(),
                        hintText: 'Restaurant name',
                      ),
                      // validator: (value) => _validateNotEmpty(value, 'Name'),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _description,
                      decoration: InputDecoration(
                        hintText: 'Enter product description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _saveProduct(Provider.of<ProductProvider>(context,
                            listen: false));
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => MenuScreen(),
                        //   ),
                        // );
                      },
                      child: Text('Save Product'),
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
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:fastfoodweb/Screens/menu_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fastfoodweb/provider/product_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class ProductAddingPage extends StatefulWidget {
//   @override
//   State<ProductAddingPage> createState() => _ProductAddingPageState();
// }

// class _ProductAddingPageState extends State<ProductAddingPage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   final _name = TextEditingController();

//   final _description = TextEditingController();

//   final _price = TextEditingController();

//   final _restaurent = TextEditingController();

//   bool _isImagePicked = false;

//   late String pickedImagePath;

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

//   void _saveProduct() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();

//       XFile? pickedImage = await ImagePicker().pickImage(
//         source: ImageSource.gallery,
//       );

//       if (pickedImage != null) {
//         pickedImagePath = pickedImage.path;

//         User? user = FirebaseAuth.instance.currentUser;
//         if (user != null) {
//           String userID = user.uid;

//           // Retrieve the BuildContext using context from the State object
//           BuildContext context = this.context;

//           await Provider.of<ProductProvider>(context, listen: false)
//               .addProductToFirestore(
//             userID: userID,
//             name: _name.text,
//             price: _price.text,
//             description: _description.text,
//             category: _selectedCategory!,
//             imageUrl: base64Decode(pickedImagePath),
//             restaurent: _restaurent.text,
//             quantity: 1,
//           );

//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Product added successfully.'),
//               duration: Duration(seconds: 2),
//             ),
//           );

//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => MenuScreen(),
//             ),
//           );
//         } else {
//           // If the user is not authenticated, navigate to the login page
//         }
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
//                       onTap: () async {
//                         XFile? pickedImage = await ImagePicker().pickImage(
//                           source: ImageSource.gallery,
//                         );
//                         if (pickedImage != null) {
//                           pickedImagePath = pickedImage.path;
//                           _isImagePicked = true;
//                           setState(() {});
//                         }
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
//                               ? Image.file(
//                                   File(pickedImagePath),
//                                 )
//                               : Icon(Icons.add_a_photo,
//                                   size: 40, color: Colors.white),
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
//                         _saveProduct();
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
