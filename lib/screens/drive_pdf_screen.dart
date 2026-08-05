import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

// ─── Drive Source Model ────────────────────────────────────────────────────────
class DriveSource {
  final String id;
  final String name;
  final String nameEn;
  final String fileId;

  const DriveSource({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.fileId,
  });

  factory DriveSource.fromJson(Map<String, dynamic> json) => DriveSource(
        id: json['id'] as String,
        name: json['name'] as String,
        nameEn: json['name_en'] as String,
        fileId: json['file_id'] as String,
      );

  String get downloadUrl =>
      'https://drive.usercontent.google.com/download?id=$fileId&export=download&confirm=t';

  String get cacheFileName => '$id.pdf';
}

// ─── Drive Sources Service ─────────────────────────────────────────────────────
class DriveSourcesService {
  static final DriveSourcesService _instance = DriveSourcesService._internal();
  factory DriveSourcesService() => _instance;
  DriveSourcesService._internal();

  List<DriveSource> _vedas = [];
  List<DriveSource> _puranas = [];

  List<DriveSource> get vedas => _vedas;
  List<DriveSource> get puranas => _puranas;

  Future<void> load() async {
    if (_vedas.isNotEmpty) return;
    try {
      final str =
          await rootBundle.loadString('assets/data/drive_sources.json');
      final json = jsonDecode(str) as Map<String, dynamic>;
      _vedas = (json['vedas'] as List)
          .map((e) => DriveSource.fromJson(e))
          .toList();
      _puranas = (json['puranas'] as List)
          .map((e) => DriveSource.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint('Error loading drive_sources.json: $e');
    }
  }
}

// ─── PDF Download & Cache Manager ─────────────────────────────────────────────
class PdfCacheManager {
  static Future<File?> getCachedOrDownload(
    DriveSource source, {
    required Function(double) onProgress,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${dir.path}/dharma_pdfs');
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }

    final file = File('${cacheDir.path}/${source.cacheFileName}');

    if (await file.exists()) {
      final len = await file.length();
      if (len > 100000) {
        onProgress(1.0);
        return file;
      }
    }

    final client = HttpClient();
    client.autoUncompress = true;

    try {
      final urls = [
        'https://drive.usercontent.google.com/download?id=${source.fileId}&export=download&confirm=t',
        'https://drive.google.com/uc?export=download&id=${source.fileId}&confirm=t',
        'https://drive.google.com/uc?export=download&id=${source.fileId}',
      ];

      HttpClientResponse? response;

      for (final urlStr in urls) {
        try {
          final request = await client.getUrl(Uri.parse(urlStr));
          request.headers.set('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36');
          request.headers.set('Accept', '*/*');
          final res = await request.close();

          if (res.statusCode == 200) {
            response = res;
            break;
          } else if (res.statusCode == 302 || res.statusCode == 303 || res.statusCode == 307) {
            final loc = res.headers.value(HttpHeaders.locationHeader);
            if (loc != null && loc.isNotEmpty) {
              final req2 = await client.getUrl(Uri.parse(loc));
              req2.headers.set('User-Agent', 'Mozilla/5.0');
              final res2 = await req2.close();
              if (res2.statusCode == 200) {
                response = res2;
                break;
              }
            }
          }
        } catch (e) {
          debugPrint('Drive attempt failed for $urlStr: $e');
        }
      }

      if (response == null || response.statusCode != 200) {
        debugPrint('All Drive download attempts failed for ${source.name}');
        return null;
      }

      final contentLength = response.contentLength;
      int received = 0;

      final sink = file.openWrite();
      await for (final chunk in response) {
        sink.add(chunk);
        received += chunk.length;
        if (contentLength > 0) {
          onProgress((received / contentLength).clamp(0.0, 0.99));
        } else {
          onProgress((received / (45 * 1024 * 1024)).clamp(0.0, 0.99));
        }
      }
      await sink.close();

      if (await file.exists()) {
        final len = await file.length();
        if (len > 100000) {
          onProgress(1.0);
          return file;
        } else {
          await file.delete();
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Download error for ${source.name}: $e');
      if (await file.exists()) {
        await file.delete();
      }
      return null;
    } finally {
      client.close();
    }
  }

  static bool isCached(DriveSource source, String docsPath) {
    final file = File('$docsPath/dharma_pdfs/${source.cacheFileName}');
    return file.existsSync() && file.lengthSync() > 100000;
  }

  static Future<void> clearCache(DriveSource source) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/dharma_pdfs/${source.cacheFileName}');
    if (await file.exists()) {
      await file.delete();
    }
  }
}

// ─── Drive PDF Reader Screen ───────────────────────────────────────────────────
class DrivePdfScreen extends StatefulWidget {
  final DriveSource source;

  const DrivePdfScreen({super.key, required this.source});

  @override
  State<DrivePdfScreen> createState() => _DrivePdfScreenState();
}

class _DrivePdfScreenState extends State<DrivePdfScreen> {
  String? _pdfPath;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  double _downloadProgress = 0;
  int _currentPage = 0;
  int _totalPages = 0;
  PDFViewController? _pdfController;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _downloadProgress = 0;
    });

    final file = await PdfCacheManager.getCachedOrDownload(
      widget.source,
      onProgress: (progress) {
        if (mounted) {
          setState(() => _downloadProgress = progress);
        }
      },
    );

    if (!mounted) return;

    if (file != null) {
      setState(() {
        _pdfPath = file.path;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage =
            'Download failed. Check internet connection and try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.amber,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.source.name,
              style: const TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (_totalPages > 0)
              Text(
                'Page $_currentPage of $_totalPages',
                style: TextStyle(
                  color: Colors.amber.withValues(alpha: 0.7),
                  fontSize: 11,
                ),
              ),
          ],
        ),
        actions: [
          if (!_isLoading && !_hasError)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, color: Colors.amber),
              tooltip: 'Clear cache & re-download',
              onPressed: () async {
                await PdfCacheManager.clearCache(widget.source);
                _loadPdf();
              },
            ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: (!_isLoading && !_hasError && _totalPages > 0)
          ? _buildPageNavBar()
          : null,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.amber.withValues(alpha: 0.3), width: 2),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      value: _downloadProgress > 0 ? _downloadProgress : null,
                      color: Colors.amber,
                      strokeWidth: 3,
                    ),
                  ),
                  if (_downloadProgress > 0)
                    Text(
                      '${(_downloadProgress * 100).toInt()}%',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.source.name,
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _downloadProgress > 0
                  ? 'Downloading... ${(_downloadProgress * 100).toInt()}%'
                  : 'Checking cache...',
              style: TextStyle(
                color: Colors.amber.withValues(alpha: 0.7),
                fontSize: 13,
              ),
            ),
            if (_downloadProgress > 0) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: LinearProgressIndicator(
                  value: _downloadProgress,
                  color: Colors.amber,
                  backgroundColor: Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ],
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, color: Colors.amber, size: 64),
              const SizedBox(height: 24),
              Text(
                'Could not load ${widget.source.name}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.amber.withValues(alpha: 0.7),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: _loadPdf,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return PDFView(
      filePath: _pdfPath!,
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: true,
      pageFling: true,
      backgroundColor: Colors.black,
      onRender: (pages) {
        if (mounted) setState(() => _totalPages = pages ?? 0);
      },
      onViewCreated: (controller) {
        _pdfController = controller;
      },
      onPageChanged: (page, total) {
        if (mounted) {
          setState(() {
            _currentPage = (page ?? 0) + 1;
            _totalPages = total ?? 0;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _hasError = true;
            _errorMessage = error.toString();
          });
        }
      },
    );
  }

  Widget _buildPageNavBar() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.first_page, color: Colors.amber),
            onPressed: () => _pdfController?.setPage(0),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.amber),
            onPressed: _currentPage > 1
                ? () => _pdfController?.setPage(_currentPage - 2)
                : null,
          ),
          Text(
            '$_currentPage / $_totalPages',
            style: const TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.amber),
            onPressed: _currentPage < _totalPages
                ? () => _pdfController?.setPage(_currentPage)
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.last_page, color: Colors.amber),
            onPressed: () => _pdfController?.setPage(_totalPages - 1),
          ),
        ],
      ),
    );
  }
}

// ─── Drive Literature Library Screen ──────────────────────────────────────────
class DriveLibraryScreen extends StatefulWidget {
  const DriveLibraryScreen({super.key});

  @override
  State<DriveLibraryScreen> createState() => _DriveLibraryScreenState();
}

class _DriveLibraryScreenState extends State<DriveLibraryScreen>
    with SingleTickerProviderStateMixin {
  final _service = DriveSourcesService();
  late TabController _tabController;
  bool _isLoaded = false;
  String _docsPath = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _init();
  }

  Future<void> _init() async {
    await _service.load();
    final dir = await getApplicationDocumentsDirectory();
    if (mounted) {
      setState(() {
        _isLoaded = true;
        _docsPath = dir.path;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A0A00),
        title: const Text(
          'Sacred Literature',
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.amber.withValues(alpha: 0.54),
          indicatorColor: Colors.amber,
          tabs: const [
            Tab(text: 'वेद (Vedas)'),
            Tab(text: 'पुराण (Puranas)'),
          ],
        ),
      ),
      body: !_isLoaded
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildList(_service.vedas),
                _buildList(_service.puranas),
              ],
            ),
    );
  }

  Widget _buildList(List<DriveSource> sources) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: sources.length,
      itemBuilder: (context, index) {
        final source = sources[index];
        final isCached = PdfCacheManager.isCached(source, _docsPath);
        return _SourceCard(
          source: source,
          isCached: isCached,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DrivePdfScreen(source: source),
            ),
          ).then((_) => setState(() {})),
        );
      },
    );
  }
}

class _SourceCard extends StatelessWidget {
  final DriveSource source;
  final bool isCached;
  final VoidCallback onTap;

  const _SourceCard({
    required this.source,
    required this.isCached,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1A0A00),
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isCached
              ? Colors.amber.withValues(alpha: 0.5)
              : Colors.amber.withValues(alpha: 0.15),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.amber.withValues(alpha: 0.1),
            border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
          ),
          child: Icon(
            isCached ? Icons.check_circle_outline : Icons.picture_as_pdf,
            color: isCached ? Colors.greenAccent : Colors.amber,
            size: 22,
          ),
        ),
        title: Text(
          source.name,
          style: const TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          isCached ? '✓ Cached locally' : source.nameEn,
          style: TextStyle(
            color: isCached ? Colors.greenAccent.withValues(alpha: 0.8) : Colors.amber.withValues(alpha: 0.54),
            fontSize: 12,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.amber.withValues(alpha: 0.5),
        ),
        onTap: onTap,
      ),
    );
  }
}
