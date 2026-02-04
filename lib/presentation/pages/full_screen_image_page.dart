import 'package:flutter/material.dart';

class FullScreenImagePage extends StatelessWidget {
  final ImageProvider imageProvider;
  final String heroTag; 

  const FullScreenImagePage({
    super.key,
    required this.imageProvider,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, 
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4.0,  
          child: Hero(
            tag: heroTag, 
            child: Image(
              image: imageProvider,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}