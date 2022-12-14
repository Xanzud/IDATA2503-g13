import "dart:io";

import "package:flutter/material.dart";

/// Custom widget class for the profile page
class ProfileWidget extends StatefulWidget {
  final String imagePath;
  final VoidCallback onClicked;

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    required this.onClicked,
  }) : super(key: key);
}

class _ProfileWidgetState extends State<ProfileWidget> {
  String? _imagePath;
  VoidCallback? _onClicked;

  @override
  void initState() {
    super.initState();
    _imagePath = widget.imagePath;
    _onClicked = widget.onClicked;
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
        child: Stack(children: [
      buildImage(),
    ]));
  }

  /// Handles building of round profile image.
  Widget buildImage() {
    //final image = AssetImage(imagePath);
    final image = NetworkImage(_imagePath!);

    return ClipOval(
        child: Material(
            color: Colors.transparent,
            child: Ink.image(
                image: image,
                fit: BoxFit.cover,
                width: 128,
                height: 128,
                child: InkWell(onTap: _onClicked))));
  }

  /// Helper method for buildImage(), builds edit icon
  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: const Icon(
            Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  /// Helper method for buildImage(), builds surrounding circle.
  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
          child: Container(
        color: color,
        padding: EdgeInsets.all(all),
        child: child,
      ));
}
