import 'package:flutter/material.dart';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';

// a widget to display a metadata of a song in a ListView
class AudioMetadataDisplay extends StatelessWidget {
  final AudioMetadata metadata;

  const AudioMetadataDisplay({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildMetadataSection('Basic Info', [
          _buildRow('Title', metadata.title ?? 'N/A'),
          _buildRow('Artist', metadata.artist ?? 'N/A'),
          _buildRow('Album', metadata.album ?? 'N/A'),
          _buildRow('Year', metadata.year?.year.toString() ?? 'N/A'),
          _buildRow('Language', metadata.language ?? 'N/A'),
        ]),
        const Divider(),
        _buildMetadataSection('Track Info', [
          _buildRow('Track Number', metadata.trackNumber?.toString() ?? 'N/A'),
          _buildRow('Total Tracks', metadata.trackTotal?.toString() ?? 'N/A'),
          _buildRow('Disc Number', metadata.discNumber?.toString() ?? 'N/A'),
          _buildRow('Total Discs', metadata.totalDisc?.toString() ?? 'N/A'),
        ]),
        const Divider(),
        _buildMetadataSection('Technical Details', [
          _buildRow('Duration', metadata.duration.toString().split('.').first),
          _buildRow('Bitrate', metadata.bitrate?.toString() ?? 'N/A'),
          _buildRow('Sample Rate', '${metadata.sampleRate} Hz'),
        ]),
        const Divider(),
        _buildMetadataSection('Additional Info', [
          _buildRow('Genres',
              metadata.genres.isNotEmpty ? metadata.genres.join(', ') : 'N/A'),
          _buildRow('Pictures', '${metadata.pictures.length} embedded'),
          _buildRow('Lyrics', metadata.lyrics ?? 'N/A'),
          _buildRow(
            'File Path',
            metadata.file.path,
          ),
        ]),
      ],
    );
  }

// a helper function to build a section of metadata (a header)
  Widget _buildMetadataSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

// a helper function to build a row of metadata info
  Widget _buildRow(String label, String value,
      {TextOverflow overflow = TextOverflow.clip}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text('$label:',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Text(
              value,
              overflow: overflow,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
