import 'dart:io';

void main() {
  final file = File('coverage/lcov.info');
  if (!file.existsSync()) {
    print('Coverage file not found');
    exit(1);
  }

  final lines = file.readAsLinesSync();
  int totalLines = 0;
  int coveredLines = 0;
  String currentFile = '';
  Map<String, Map<String, int>> fileCoverage = {};

  for (final line in lines) {
    if (line.startsWith('SF:')) {
      currentFile = line.substring(3);
      fileCoverage[currentFile] = {'total': 0, 'covered': 0};
    } else if (line.startsWith('LF:')) {
      final linesInFile = int.parse(line.substring(3));
      totalLines += linesInFile;
      if (fileCoverage.containsKey(currentFile)) {
        fileCoverage[currentFile]!['total'] = linesInFile;
      }
    } else if (line.startsWith('LH:')) {
      final coveredInFile = int.parse(line.substring(3));
      coveredLines += coveredInFile;
      if (fileCoverage.containsKey(currentFile)) {
        fileCoverage[currentFile]!['covered'] = coveredInFile;
      }
    }
  }

  final coverage = totalLines > 0 ? (coveredLines / totalLines * 100) : 0.0;
  
  print('Code Coverage Report');
  print('===================');
  print('Total Lines: $totalLines');
  print('Covered Lines: $coveredLines');
  print('Coverage: ${coverage.toStringAsFixed(2)}%');
  
  // Coverage by file
  print('\nCoverage by File:');
  print('-----------------');
  fileCoverage.forEach((file, stats) {
    final fileCoveragePercent = stats['total']! > 0 
        ? (stats['covered']! / stats['total']! * 100) 
        : 0.0;
    final status = fileCoveragePercent >= 80 ? '✅' 
        : fileCoveragePercent >= 60 ? '⚠️' 
        : '❌';
    print('$status ${file.split('/').last}: ${fileCoveragePercent.toStringAsFixed(1)}% (${stats['covered']}/${stats['total']})');
  });
  
  // Create coverage badge
  final coverageColor = coverage >= 80 ? 'green' : coverage >= 60 ? 'yellow' : 'red';
  final badgeUrl = 'https://img.shields.io/badge/coverage-${coverage.toStringAsFixed(1)}%25-$coverageColor';
  print('\nCoverage Badge URL: $badgeUrl');
  
  // GitHub Actions output
  if (Platform.environment.containsKey('GITHUB_ACTIONS')) {
    print('::set-output name=coverage::${coverage.toStringAsFixed(2)}');
    print('::set-output name=coverage_color::$coverageColor');
  }
  
  // Exit with error if coverage is too low
  if (coverage < 20) {
    print('\n⚠️  Warning: Coverage is below 20%');
    exit(1);
  }
}
