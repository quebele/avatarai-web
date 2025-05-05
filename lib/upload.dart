
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'premium_service.dart';
import 'storage_service.dart';
import 'package:http/http.dart' as http;

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {

  int dailyLimit = 3;
  int generatedToday = 0;

  Future<void> _checkLimitAndGenerate() async {
    await _premium.checkPurchase();
    _premium.isPremium = _premium.isPremium || await StorageService.getPremium();
    if (!_premium.isPremium) {
      await _resetIfNewDay();
      generatedToday = await StorageService.getAvatarCount();
      if (generatedToday >= dailyLimit) {
        _showUpgradeDialog();
        return;
      }
    }
    _generateAvatar();
    if (!_premium.isPremium) {
      generatedToday++;
      await StorageService.setAvatarCount(generatedToday);
    }
  }

  Future<void> _resetIfNewDay() async {
    String today = DateTime.now().toIso8601String().substring(0, 10);
    String? last = await StorageService.getLastResetDate();
    if (last != today) {
      await StorageService.setLastResetDate(today);
      await StorageService.setAvatarCount(0);
    }
  }

  final PremiumService _premium = PremiumService();
  File? _image;
  bool _loading = false;
  String? _avatarUrl;

  final picker = ImagePicker();
  final List<String> styles = ['anime', 'cyberpunk', 'cartoon'];
  String selectedStyle = 'anime';

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _avatarUrl = null;
      });
    }
  }

  Future<void> _generateAvatar() async {
    await _premium.checkPurchase();
    if (!_premium.isPremium) {
      _showUpgradeDialog();
      return;
    }
    if (_image == null) return;

    setState(() {
      _loading = true;
    });

    final url = Uri.parse('https://api-inference.huggingface.co/models/stabilityai/stable-diffusion-2');
    final bytes = await _image!.readAsBytes();

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer YOUR_HUGGINGFACE_API_KEY',
        'Content-Type': 'application/octet-stream',
      },
      body: bytes,
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      setState(() {
        _avatarUrl = result['generated_image_url'] ?? null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fehler bei der Avatar-Erstellung')),
      );
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Avatar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _image != null
                ? Image.file(_image!, height: 150)
                : const Placeholder(fallbackHeight: 150),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedStyle,
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedStyle = value);
                }
              },
              items: styles.map((s) {
                return DropdownMenuItem(value: s, child: Text(s));
              }).toList(),
            ),
            ElevatedButton(onPressed: _pickImage, child: const Text('Upload Image')),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loading ? null : _checkLimitAndGenerate,
              child: _loading ? const CircularProgressIndicator() : const Text('Generate Avatar'),
            ),
            const SizedBox(height: 20),
            if (_avatarUrl != null) Image.network(_avatarUrl!),
          ],
        ),
      ),
    );
  }
}
