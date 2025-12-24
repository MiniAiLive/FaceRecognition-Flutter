import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
//   const AboutPage({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;

    return Scaffold(
      backgroundColor: const Color(0xFFD0BCFF),
      appBar: AppBar(
        title: const Text("About"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Logo
            Image.asset(
              "assets/logo_name.png",
              width: 300,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 50),

            // Description
            const Text(
              "MiniAiLive is a provider of Touchless Biometrics Authentication, "
              "ID verification solutions. We offer strong security solutions with "
              "cutting-edge technologies for facial recognition, liveness detection, "
              "and ID document recognition. We also ensure that these solutions "
              "seamlessly integrate with our clients’ existing systems.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF020000), fontSize: 16, height: 1.4),
              
            ),

            const SizedBox(height: 30),

            _buildLinkTile(
              icon: Icons.language,
              title: "Website",
              onTap: () => _launchUrl("https://www.miniai.live/"),
            ),

            _buildLinkTile(
              icon: Icons.video_library,
              title: "YouTube",
              onTap: () =>
                  _launchUrl("https://www.youtube.com/channel/UCU3D895D0XiF4TGy02GhN_Q"),
            ),

            _buildLinkTile(
              icon: Icons.code,
              title: "GitHub",
              onTap: () => _launchUrl("https://github.com/MiniAiLive"),
            ),

            _buildLinkTile(
              icon: Icons.email,
              title: "Email",
              onTap: () => _launchUrl("mailto:info@miniai.live"),
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            // Copyright (clickable)
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("© $currentYear MiniAiLive")),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.copyright),
                  const SizedBox(width: 8),
                  Text(
                    "$currentYear MiniAiLive",
                    style: const TextStyle(color: Color(0xFF020000), fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
