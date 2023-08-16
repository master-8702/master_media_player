import 'package:flutter/material.dart';

import 'package:mastermediaplayer/components/neumorphic_container.dart';
import 'package:mastermediaplayer/features/file_explorer/presentation/file_explorer_controller.dart';

class FileSearchTextField extends StatelessWidget {
  /// This custom widget will be used as a search bar (search text field) for all 
  /// file explorers.

  const FileSearchTextField({
    super.key,
    required this.controller,
  });

  final FileExplorerController controller;

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      padding: 10,
      child: TextField(
        autofocus: false,
        controller: controller.textEditingController,
        decoration: const InputDecoration(
          hintText: 'Search Current Folder',
          border: InputBorder.none,
          suffixIcon: Icon(Icons.search),
        ),
        onChanged: (query) {
          controller.searchFileAndDirectory(
              directory: controller.currentDir.value, query: query);
        },
      ),
    );
  }
}
