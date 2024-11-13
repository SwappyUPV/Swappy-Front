import 'package:flutter/material.dart';

class QualitySelectorWidget extends StatelessWidget {
  final String? selectedQuality;
  final List<String> qualityOptions;
  final Function(String?) onQualityChanged;

  const QualitySelectorWidget({
    Key? key,
    required this.selectedQuality,
    required this.qualityOptions,
    required this.onQualityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Calidad*', style: Theme.of(context).textTheme.titleMedium),
        ...qualityOptions
            .map((quality) => RadioListTile<String>(
                  title: Text(quality),
                  value: quality,
                  groupValue: selectedQuality,
                  onChanged: onQualityChanged,
                ))
            .toList(),
      ],
    );
  }
}
