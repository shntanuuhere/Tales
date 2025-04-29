import 'dart:io';
import 'package:intl/intl.dart';

void main() async {
  final reportTemplate = await File('test/test_report_template.md').readAsString();

  // Get current date
  final now = DateTime.now();
  final dateFormat = DateFormat('yyyy-MM-dd');
  final formattedDate = dateFormat.format(now);

  // Get app version from pubspec.yaml
  final pubspecFile = await File('pubspec.yaml').readAsString();
  final versionRegex = RegExp(r'version:\s*(\d+\.\d+\.\d+\+\d+)');
  final versionMatch = versionRegex.firstMatch(pubspecFile);
  final version = versionMatch != null ? versionMatch.group(1) : 'Unknown';

  // Replace placeholders in template
  var report = reportTemplate
      .replaceAll('[DATE]', formattedDate)
      .replaceAll('[VERSION]', version!)
      .replaceAll('[TESTER NAME]', 'Automated Test Runner')
      .replaceAll('[DEVICE MODEL, OS VERSION]', 'Multiple devices');

  // Create report file
  final reportFile = File('test/reports/test_report_${formattedDate.replaceAll('-', '')}.md');

  // Create directory if it doesn't exist
  if (!await Directory('test/reports').exists()) {
    await Directory('test/reports').create(recursive: true);
  }

  // Write report to file
  await reportFile.writeAsString(report);

  // Use stderr for logging in test scripts
  stderr.writeln('Test report template generated at ${reportFile.path}');
  stderr.writeln('Please fill in the test results manually.');
}
