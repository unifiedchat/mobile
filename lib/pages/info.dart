import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Info"),
        centerTitle: true,
        leading: IconButton(
          tooltip: "Go Back",
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(
        child: Text("Info"),
      ),
    );
  }
}
