import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

///Class for Showing about page, with app name, package name,
///verion number and build number.
class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  late String _appName;
  late String _packageName;
  late String _version;
  late String _buildNumber;

  @override
  Widget build(BuildContext context) {
    PackageInfo.fromPlatform().then((PackageInfo pi) {
      _appName = pi.appName;
      _packageName = pi.packageName;
      _version = pi.version;
      _buildNumber = pi.buildNumber;
    });

    return Column(
      children: [
        Text(
          "App name: $_appName",
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
        const SizedBox(height: 24),
        Text(
          "Package name: $_packageName",
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
        const SizedBox(height: 24),
        Text(
          "Version: $_version",
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
        const SizedBox(height: 24),
        Text(
          "Build number: $_buildNumber",
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
      ],
    );
  }
}
