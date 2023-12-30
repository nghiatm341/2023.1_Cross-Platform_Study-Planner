import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:frontend/ultils/networkImage.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {

  final storage = FirebaseStorage.instance.ref();

  XFile? image;
  XFile? pickedImage;
  String imagedUrl = "";
  UploadTask? uploadTask;

  bool uploaded = false;
  bool uploading = false;

  TextEditingController _textEditingController = TextEditingController();

  void getImage() async {
    final picker = ImagePicker();

    image = await picker.pickImage(source: ImageSource.gallery);
  
    debugPrint('Image: ${image?.path}');

    setState(() {
      pickedImage = image;
    });
  }

  void uploadImage() async {
    if (image == null) return;

    setState(() {
      uploading = true;
    });

    //image folder in cloud
    Reference cloudAvatarDirectory = storage.child("Avatar");

    // generate image file name
    String uniqueImageName = DateTime.now().millisecondsSinceEpoch.toString();

    //get file image extension (pne or jpg)
    String fileExtension = image!.path.split('.').last.toLowerCase(); 

    // image need uploaded reference
    Reference imageToUpload = cloudAvatarDirectory.child('$uniqueImageName.$fileExtension');

    try {
      // upload image using upload task

      setState(() {
         uploadTask = imageToUpload.putFile(File(image!.path));
      });

      final snapshot = await uploadTask!.whenComplete((){});

      imagedUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        imagedUrl = imagedUrl;
        uploaded = true;
      });
        
      debugPrint("Image url: ${imagedUrl}");

    } catch (error) {
      
    }
  }

  void clear(){
    setState(() {
      uploaded = false;
      uploading = false;
      imagedUrl = "";
      pickedImage = null;
      image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

          if(pickedImage != null)
            Container(
                height: 200,
                width: double.infinity,
                color: Colors.blue[100],
                child: Image.file(
                  File(pickedImage!.path),
                  fit: BoxFit.contain,
                ),
              ),
          
          const SizedBox(height: 12,),
      
          ElevatedButton(onPressed: getImage, child: Icon(Icons.image)),
          ElevatedButton(onPressed: uploadImage, child: Text("Upload")),

          Center(child: Text('${imagedUrl}'),),

          if(uploading)
            buildProgress(),

          const SizedBox(height: 12,),

          Visibility(
            visible: uploaded,
            child: Container(
              child: Column(children: [
                Text("Uploaded file:"),
                SimpleNetworkImage(imageUrl: imagedUrl,),
                 ElevatedButton(onPressed: clear, child: Text("Clear")),
              ]),
            ),
          )
    
        ]),
      ),
    );

    
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(stream: uploadTask?.snapshotEvents, builder: (context, snapshot){
    if(snapshot.hasData){
      final data = snapshot.data!;
      double progress = data.bytesTransferred / data.totalBytes;

      return SizedBox(
        height: 50,
        child: Stack(
          fit: StackFit.expand,
          children: [
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey,
              color: Colors.green,
            ),

            Center(
              child: Text('${(100 * progress).roundToDouble()}%', style: const TextStyle(color: Colors.white),),
            ),
            
          ],
        ),
      );
    }
    else{
      return const SizedBox(height: 50,);
    }
  });
}
