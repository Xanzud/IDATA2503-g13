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
  String? _appName;
  String? _packageName;
  String? _version;
  String? _buildNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        elevation: 0,
        title: Text("About"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(50),
          child: FutureBuilder(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                PackageInfo pInfo = snapshot.data!;
                _appName = pInfo.appName;
                _packageName = pInfo.packageName;
                _version = pInfo.version;
                _buildNumber = pInfo.buildNumber;

                return Column(
                  children: [
                    Text(
                      "App name: $_appName",
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Package name: $_packageName",
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Version: $_version",
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Build number: $_buildNumber",
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: Text("No data to load"),
                );
              }
              return const Center(
                child: Text("No data to load"),
              );
            },
          ),
        ),
      ),
    );
  }
}
