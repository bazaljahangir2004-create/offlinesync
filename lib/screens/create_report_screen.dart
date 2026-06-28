import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../models/app_database.dart';
import '../providers/reports_provider.dart';
import '../providers/sync_provider.dart';
import '../services/location_service.dart';

class CreateReportScreen extends ConsumerStatefulWidget {
  const CreateReportScreen({super.key, this.existingReport});

  /// When provided, the screen opens in edit mode, pre-filled with
  /// this report's data, and saves update it instead of creating new.
  final InspectionReport? existingReport;

  @override
  ConsumerState<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends ConsumerState<CreateReportScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;

  late List<String> _imagePaths;
  double? _latitude;
  double? _longitude;

  bool _isFetchingLocation = false;
  bool _isSaving = false;

  final _locationService = LocationService();
  final _imagePicker = ImagePicker();

  bool get _isEditing => widget.existingReport != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingReport;
    _titleController = TextEditingController(text: existing?.title ?? '');
    _notesController = TextEditingController(text: existing?.notes ?? '');
    _imagePaths = existing != null
        ? ReportsRepository.decodeImagePaths(existing.localImagePaths)
        : [];
    _latitude = existing?.latitude;
    _longitude = existing?.longitude;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _captureLocation() async {
    setState(() => _isFetchingLocation = true);
    final position = await _locationService.getCurrentLocation();
    setState(() {
      _isFetchingLocation = false;
      if (position != null) {
        _latitude = position.latitude;
        _longitude = position.longitude;
      }
    });

    if (!mounted) return;
    if (position == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not get location. Check permissions or GPS signal.',
          ),
        ),
      );
    }
  }

  void _removeLocation() {
    setState(() {
      _latitude = null;
      _longitude = null;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_imagePaths.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 3 photos per report')),
      );
      return;
    }

    final XFile? picked = await _imagePicker.pickImage(
      source: source,
      maxWidth: 1600,
      imageQuality: 80,
    );

    if (picked != null) {
      setState(() => _imagePaths.add(picked.path));
    }
  }

  void _removeImage(int index) {
    setState(() => _imagePaths.removeAt(index));
  }

  Future<void> _saveReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final repository = ref.read(reportsRepositoryProvider);

      if (_isEditing) {
        await repository.updateReportContent(
          uuid: widget.existingReport!.uuid,
          title: _titleController.text.trim(),
          notes: _notesController.text.trim(),
          localImagePaths: _imagePaths,
          latitude: _latitude,
          longitude: _longitude,
        );
      } else {
        await repository.createReport(
          title: _titleController.text.trim(),
          notes: _notesController.text.trim(),
          localImagePaths: _imagePaths,
          latitude: _latitude,
          longitude: _longitude,
        );
      }

      // Try to sync immediately - covers the common case where the
      // device is already online when the report is created or
      // edited. Fire-and-forget: don't block the UI on this.
      ref.read(syncServiceProvider).syncAllPending();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? 'Report updated' : 'Report saved')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save report: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take photo'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Report' : 'New Site Inspection'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'e.g. Warehouse B - North Wall',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Describe what you observed...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 24),

            // Photos section
            Text('Photos', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._imagePaths.asMap().entries.map((entry) {
                  final index = entry.key;
                  final path = entry.value;
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(path),
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: -6,
                        right: -6,
                        child: IconButton(
                          icon: const Icon(Icons.cancel,
                              color: Colors.red, size: 20),
                          onPressed: () => _removeImage(index),
                        ),
                      ),
                    ],
                  );
                }),
                if (_imagePaths.length < 3)
                  InkWell(
                    onTap: _showImageSourcePicker,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.add_a_photo_outlined,
                          color: Colors.grey.shade600),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // Location section
            Text('Location', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            if (_latitude != null && _longitude != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.green.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${_latitude!.toStringAsFixed(5)}, ${_longitude!.toStringAsFixed(5)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    TextButton(
                      onPressed: _captureLocation,
                      child: const Text('Update'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: _removeLocation,
                    ),
                  ],
                ),
              )
            else
              OutlinedButton.icon(
                onPressed: _isFetchingLocation ? null : _captureLocation,
                icon: _isFetchingLocation
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location),
                label: Text(_isFetchingLocation
                    ? 'Getting location...'
                    : 'Capture current location'),
              ),

            const SizedBox(height: 32),
            FilledButton(
              onPressed: _isSaving ? null : _saveReport,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(_isEditing ? 'Save Changes' : 'Save Report'),
            ),
            const SizedBox(height: 8),
            Text(
              'Saved locally - will sync automatically when you\'re back online.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
