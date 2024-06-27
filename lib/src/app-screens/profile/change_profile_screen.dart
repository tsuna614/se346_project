// import 'package:dio/dio.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import 'package:provider/provider.dart';

// final dio = Dio();
// final _firebase = FirebaseAuth.instance;

// class ChangeProfileScreen extends StatefulWidget {
//   const ChangeProfileScreen({
//     super.key,
//     required this.name,
//     required this.email,
//     required this.avatarUrl,
//   });

//   final String name;
//   final String email;
//   final String avatarUrl;

//   @override
//   State<ChangeProfileScreen> createState() => _ChangeProfileScreenState();
// }

// class _ChangeProfileScreenState extends State<ChangeProfileScreen> {
//   final _nameTextField = TextEditingController();
//   final _emailTextField = TextEditingController();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _nameTextField.text = widget.name;
//     _emailTextField.text = widget.email;
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     _nameTextField.dispose();
//     _emailTextField.dispose();
//   }

//   void onCancelPressed() {
//     setState(() {
//       _nameTextField.text = widget.name;
//       _emailTextField.text = widget.email;
//     });
//   }

//   bool checkForTextFieldChanges() {
//     if (_firstNameTextField.text != widget.firstName ||
//         _lastNameTextField.text != widget.lastName ||
//         _ageTextField.text != widget.age.toString() ||
//         _emailTextField.text != widget.emailAddress ||
//         image.isNotEmpty) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   void putUserData() async {
//     // call put api to change user data

//     context.read<UserProvider>().setUserFirstName(_firstNameTextField.text);
//     context.read<UserProvider>().setUserLastName(_lastNameTextField.text);
//     context.read<UserProvider>().setUserAge(int.parse(_ageTextField.text));
//     context.read<UserProvider>().setUserEmail(_emailTextField.text);
//     context
//         .read<UserProvider>()
//         .setProfileImage(image.isEmpty ? widget.userImage : image);

//     await dio.put(
//       '${global.atozApi}/user/editUserById/${_firebase.currentUser!.uid}',
//       data: {
//         "firstName": _firstNameTextField.text,
//         "lastName": _lastNameTextField.text,
//         "age": _ageTextField.text,
//         "email": _emailTextField.text,
//         "profileImage": image.isEmpty ? widget.userImage : image,
//       },
//     );

//     // if (image != null) {
//     //   await dio.post(
//     //       '${global.atozApi}/user/uploadImage/${_firebase.currentUser!.uid}', // upload image
//     //       data: FormData.fromMap({
//     //         "image": await MultipartFile.fromFile(image!.path,
//     //             filename: image!.path.split('/').last),
//     //       }));
//     // }
//   }

//   /////////////////////////////////////////
//   ////////////// Image picker /////////////

//   String image = '';
//   // final ImagePicker picker = ImagePicker();
//   // //we can upload image from camera or from gallery based on parameter
//   // Future getImage(ImageSource media) async {
//   //   var img = await picker.pickImage(source: media);

//   //   setState(() {
//   //     image = img;
//   //   });
//   // }

//   Future<void> myAlert(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.width;

//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Padding(
//           padding: EdgeInsets.symmetric(
//               horizontal: 20, vertical: screenHeight * 0.4),
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               color: Colors.white,
//             ),
//             padding: EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 GridView.count(
//                   physics: NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   crossAxisCount: 3,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                   children: [
//                     buildAnimalAvatar(context, 'cat'),
//                     buildAnimalAvatar(context, 'chicken'),
//                     buildAnimalAvatar(context, 'cow'),
//                     buildAnimalAvatar(context, 'elephant'),
//                     buildAnimalAvatar(context, 'lion'),
//                     buildAnimalAvatar(context, 'panda'),
//                     buildAnimalAvatar(context, 'penguin'),
//                     buildAnimalAvatar(context, 'rabbit'),
//                     buildAnimalAvatar(context, 'technoblade'),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: () => Navigator.pop(context),
//                   style: ButtonStyle(
//                     backgroundColor:
//                         MaterialStateProperty.all<Color>(Colors.transparent),
//                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                       RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(18.0),
//                         side: BorderSide(color: Colors.black),
//                       ),
//                     ),
//                     elevation: MaterialStateProperty.all(0),
//                   ),
//                   child: Text(
//                     'CANCEL',
//                     style: TextStyle(
//                       color: Colors.black,
//                       letterSpacing: 5,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   /////////////////////////////////////////
//   /////////////////////////////////////////

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   elevation: 0,
//       //   backgroundColor: Colors.transparent,
//       //   iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
//       // ),
//       resizeToAvoidBottomInset: true,
//       body: Stack(
//         children: [
//           ClipPath(
//             clipper: CustomClipPathBlue(),
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topRight,
//                   end: Alignment.bottomLeft,
//                   colors: [
//                     Colors.blue.shade900,
//                     Colors.lightBlue.shade400,
//                   ],
//                 ),
//                 // color: Colors.blue,
//               ),
//               child: Center(
//                 child: Text('Clip path'),
//               ),
//             ),
//           ),
//           SafeArea(
//             child: Column(
//               children: [
//                 // THIS IS THE TOP PART OF THE SCREEN
//                 Stack(
//                   children: [
//                     Align(
//                       alignment: Alignment(-0.9, 0),
//                       child: IconButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         icon: Icon(
//                           Icons.arrow_back_ios,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     Column(
//                       children: const [
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Align(
//                           alignment: Alignment(0, 0),
//                           child: Text(
//                             'Edit profile',
//                             style: TextStyle(
//                                 fontSize: 30,
//                                 fontWeight: FontWeight.bold,
//                                 letterSpacing: 4,
//                                 color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 // THE IMAGE / PROFILE PICTURE
//                 SizedBox(
//                   height: 100,
//                 ),
//                 buildAvatar(context),
//                 // THIS IS THE TEXT FORM FIELDS IN THE MIDDLE
//                 SizedBox(height: 20),
//                 buildTextFormField(context),
//                 // THIS IS THE 2 BUTTONS ON THE BOTTOM OF THE SCREEN
//                 buildBottomSaveButton(context),
//                 // SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildAnimalAvatar(BuildContext context, String animalName) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           image = animalName;
//         });
//         Navigator.pop(context);
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           image: DecorationImage(
//             image: AssetImage('assets/images/avatar/$animalName.jpeg'),
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildTextFormField(BuildContext context) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       'First name',
//                       style: TextStyle(color: Theme.of(context).primaryColor),
//                     )),
//                 TextFormField(
//                   onChanged: (e) {
//                     setState(() {});
//                   },
//                   controller: _firstNameTextField,
//                   keyboardType: TextInputType.name,
//                   autocorrect: false,
//                   textCapitalization: TextCapitalization.none,
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Please enter your first name';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 30),
//                 Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       'Last name',
//                       style: TextStyle(color: Theme.of(context).primaryColor),
//                     )),
//                 TextFormField(
//                   onChanged: (e) {
//                     setState(() {});
//                   },
//                   controller: _lastNameTextField,
//                   keyboardType: TextInputType.name,
//                   autocorrect: false,
//                   textCapitalization: TextCapitalization.none,
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Please enter your last name';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 30),
//                 Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       'Age',
//                       style: TextStyle(color: Theme.of(context).primaryColor),
//                     )),
//                 TextFormField(
//                   onChanged: (e) {
//                     setState(() {});
//                   },
//                   controller: _ageTextField,
//                   keyboardType: TextInputType.number,
//                   autocorrect: false,
//                   textCapitalization: TextCapitalization.none,
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Please enter your age';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 30),
//                 Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       'Email address',
//                       style: TextStyle(color: Theme.of(context).primaryColor),
//                     )),
//                 TextFormField(
//                   onChanged: (e) {
//                     setState(() {});
//                   },
//                   controller: _emailTextField,
//                   keyboardType: TextInputType.emailAddress,
//                   autocorrect: false,
//                   textCapitalization: TextCapitalization.none,
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Please enter your email address';
//                     }
//                     return null;
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildAvatar(BuildContext context) {
//     return Stack(
//       children: [
//         Center(
//           child: Container(
//             height: 110,
//             width: 110,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(100),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.4),
//                   offset: Offset(0, 0),
//                   blurRadius: 20,
//                 )
//               ],
//             ),
//           ),
//         ),
//         Center(
//           child: Padding(
//             padding: const EdgeInsets.only(top: 5),
//             child: SizedBox(
//               height: 100,
//               width: 100,
//               child: Stack(
//                 clipBehavior: Clip.none,
//                 fit: StackFit.expand,
//                 children: [
//                   CircleAvatar(
//                     // if image is null (user hasn't upload image when editing profile), then use the userImage from profile_screen
//                     // if image is not null (user has upload image when editing profile), then use the image from image picker
//                     backgroundImage: image.isEmpty
//                         ? widget.userImage.isEmpty
//                             ? Image.asset('assets/images/profile.jpg').image
//                             : Image.asset(
//                                     'assets/images/avatar/${widget.userImage}.jpeg')
//                                 .image
//                         : Image.asset('assets/images/avatar/$image.jpeg').image,
//                   ),
//                   Positioned(
//                       bottom: -10,
//                       right: -40,
//                       child: SizedBox(
//                         height: 40,
//                         child: RawMaterialButton(
//                           onPressed: () {
//                             // _dialogBuilder(context);
//                             myAlert(context);
//                           },
//                           elevation: 2.0,
//                           fillColor: Color(0xFFF5F6F9),
//                           // padding: EdgeInsets.all(15.0),
//                           shape: CircleBorder(),
//                           child: Icon(
//                             Icons.image,
//                             color: Colors.grey,
//                             size: 25,
//                           ),
//                         ),
//                       )),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget buildBottomSaveButton(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.only(left: 16.0, right: 8.0),
//             child: ElevatedButton(
//               onPressed: () => showDialog<String>(
//                 context: context,
//                 builder: (BuildContext context) => AlertDialog(
//                   title: const Text('Revert all changes?'),
//                   actions: <Widget>[
//                     TextButton(
//                       onPressed: () => Navigator.pop(context, 'Cancel'),
//                       child: const Text('Cancel'),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         onCancelPressed();
//                         Navigator.of(context).pop();
//                       },
//                       child: const Text('OK'),
//                     ),
//                   ],
//                 ),
//               ),
//               style: ButtonStyle(
//                 backgroundColor:
//                     MaterialStateProperty.all<Color>(Colors.transparent),
//                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                   RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(18.0),
//                     side: BorderSide(color: Colors.black),
//                   ),
//                 ),
//                 elevation: MaterialStateProperty.all(0),
//               ),
//               child: Text(
//                 'CANCEL',
//                 style: TextStyle(
//                   color: Colors.black,
//                   letterSpacing: 5,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.only(right: 16.0, left: 8.0),
//             child: ElevatedButton(
//               onPressed: !checkForTextFieldChanges()
//                   ? null
//                   : () {
//                       putUserData();
//                       Navigator.pop(context);
//                     },
//               style: ButtonStyle(
//                 // minimumSize: MaterialStatePropertyAll(Size.fromHeight(20)),
//                 backgroundColor: !checkForTextFieldChanges()
//                     ? MaterialStateProperty.all<Color>(Colors.grey.shade300)
//                     : MaterialStateProperty.all<Color>(Colors.blue),
//                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                   RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(18.0),
//                     side: BorderSide(
//                         color: !checkForTextFieldChanges()
//                             ? Colors.grey.shade300
//                             : Colors.blue),
//                   ),
//                 ),
//               ),
//               child: Text(
//                 'SAVE',
//                 style: TextStyle(
//                     letterSpacing: 5,
//                     color: !checkForTextFieldChanges()
//                         ? Colors.grey
//                         : Colors.white),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class CustomClipPathBlue extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     double w = size.width;
//     double h = size.height;

//     final path = Path();

//     path.moveTo(0, -100);
//     path.lineTo(0, h * 0.22);
//     path.lineTo(w * 0.5, h * 0.3);
//     path.lineTo(w, h * 0.15);
//     path.lineTo(w, 0);
//     path.close();

//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     return false;
//   }
// }
