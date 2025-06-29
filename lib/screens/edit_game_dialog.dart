// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../models/game.dart';

class EditGameDialog extends StatefulWidget {
  final Game? gameToEdit;

  const EditGameDialog({
    super.key,
    this.gameToEdit,
  });

  @override
  State<EditGameDialog> createState() => _EditGameDialogState();
}

class _EditGameDialogState extends State<EditGameDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _genreController = TextEditingController();
  final _developerController = TextEditingController();
  final _releaseYearController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _executablePathController = TextEditingController();
  final _folderPathController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.gameToEdit != null) {
      _nameController.text = widget.gameToEdit!.name;
      _genreController.text = widget.gameToEdit!.genre;
      _developerController.text = widget.gameToEdit!.developer;
      _releaseYearController.text = widget.gameToEdit!.releaseYear;
      _descriptionController.text = widget.gameToEdit!.description;
      _executablePathController.text = widget.gameToEdit!.exePath;
      _folderPathController.text = widget.gameToEdit!.folderPath;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _genreController.dispose();
    _developerController.dispose();
    _releaseYearController.dispose();
    _descriptionController.dispose();
    _executablePathController.dispose();
    _folderPathController.dispose();
    super.dispose();
  }

  Future<void> _pickExecutablePath() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['exe', 'app', 'deb', 'rpm'],
    );

    if (result != null && result.files.single.path != null) {
      _executablePathController.text = result.files.single.path!;
    }
  }

  Future<void> _pickGameFolder() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      _folderPathController.text = selectedDirectory;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 500,
        constraints: const BoxConstraints(maxHeight: 600),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1a1a2e),
              const Color(0xFF16213e),
              const Color(0xFF0f3460),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.withOpacity(0.3),
                      Colors.blue.withOpacity(0.2),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.gamepad,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Edit Game',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Form Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputField(
                          label: 'Name',
                          controller: _nameController,
                          icon: Icons.sports_esports,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter game name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        _buildInputField(
                          label: 'Genre',
                          controller: _genreController,
                          icon: Icons.category,
                        ),
                        const SizedBox(height: 16),
                        
                        _buildInputField(
                          label: 'Developer',
                          controller: _developerController,
                          icon: Icons.person,
                        ),
                        const SizedBox(height: 16),
                        
                        _buildInputField(
                          label: 'Release Year',
                          controller: _releaseYearController,
                          icon: Icons.calendar_today,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        
                        _buildInputField(
                          label: 'Description',
                          controller: _descriptionController,
                          icon: Icons.description,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        
                        _buildFilePickerField(
                          label: 'Executable Path',
                          controller: _executablePathController,
                          icon: Icons.play_arrow,
                          onTap: _pickExecutablePath,
                        ),
                        const SizedBox(height: 16),
                        
                        _buildFilePickerField(
                          label: 'Game Folder',
                          controller: _folderPathController,
                          icon: Icons.folder,
                          onTap: _pickGameFolder,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Action Buttons
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildActionButton(
                      label: 'Cancel',
                      onPressed: () => Navigator.of(context).pop(),
                      isPrimary: false,
                    ),
                    const SizedBox(width: 12),
                    _buildActionButton(
                      label: 'Save',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Handle save logic here
                          Navigator.of(context).pop({
                            'name': _nameController.text,
                            'genre': _genreController.text,
                            'developer': _developerController.text,
                            'releaseYear': _releaseYearController.text,
                            'description': _descriptionController.text,
                            'exePath': _executablePathController.text,
                            'folderPath': _folderPathController.text,
                          });
                        }
                      },
                      isPrimary: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: Colors.white54,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              hintText: 'Enter $label',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilePickerField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  readOnly: true,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      icon,
                      color: Colors.white54,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    hintText: 'Select $label',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(4),
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.withOpacity(0.8),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Browse',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary 
            ? Colors.blue.withOpacity(0.8)
            : Colors.white.withOpacity(0.1),
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// Usage example:
void showEditGameDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const EditGameDialog();
    },
  ).then((result) {
    if (result != null) {
      // Handle the result (game data)
      // ignore: avoid_print
      print('New game added: $result');
    }
  });
}