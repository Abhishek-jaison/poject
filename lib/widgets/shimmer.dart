import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!, // Base color of the placeholder
      highlightColor: Colors.grey[100]!, // Highlight color for the shimmer
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300], // Placeholder color
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Center(
            child: Icon(
              Icons.camera_alt,
              size: 50,
              color: const Color.fromARGB(
                255,
                177,
                29,
                29,
              ), // Camera icon color
            ),
          ),
        ],
      ),
    );
  }
}
