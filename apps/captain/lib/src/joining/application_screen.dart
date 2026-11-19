import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../api.dart';
import '../auth.dart';
import '../support/report_photo.dart';
import '../work/order_view.dart' show navigationTo;
import 'application.dart';
import 'texts.dart';

/// CA §5.1–5.4 (slices 2.34a–b): the applicant's screen, the form while a
/// draft (or a new application after a rejection, K11), the status page
/// once sent. Unstyled until the design (the design stop): plain Material
/// widgets showing [applicationProvider].
class ApplicationScreen extends ConsumerStatefulWidget {
  const ApplicationScreen({super.key});

  @override
  ConsumerState<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends ConsumerState<ApplicationScreen> {
  /// «تقديم طلب جديد» was tapped: the form shows until step 1 starts the
  /// new draft on the server.
  bool _reapplying = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final application = ref.watch(applicationProvider);
    // CA §5.4 «مفعّل» (slice 2.35a): the account is a captain's now; the
    // session's read moves the app home.
    ref.listen(applicationProvider, (previous, next) {
      if (next.value?.stage == ApplicationStage.active) {
        ref.invalidate(captainSessionProvider);
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.captainApplicationTitle),
        actions: [
          TextButton(
            key: const Key('application-sign-out'),
            onPressed: () => ref.read(captainAuth.session.notifier).signOut(),
            child: Text(l10n.signOut),
          ),
        ],
      ),
      body: switch (application) {
        AsyncData(:final value) =>
          value == null || value.stage == ApplicationStage.draft
              ? ApplicationForm(application: value)
              : _reapplying && value.stage == ApplicationStage.rejected
              ? ApplicationForm(application: null, previous: value)
              : _Status(
                  application: value,
                  onReapply: () => setState(() => _reapplying = true),
                ),
        AsyncError() => Center(
          child: TextButton(
            onPressed: () => ref.invalidate(applicationProvider),
            child: Text(l10n.captainRetry),
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

/// A calendar day `YYYY-MM-DD` as `dd/mm/yyyy`.
String dayText(AppLocalizations l10n, String day) =>
    l10n.formatDate(DateTime.parse('${day}T12:00:00Z'));

String _day(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

/// CA §5.4: the stage, what to do, each document's status (a requested or
/// rejected one uploaded again here) and the history.
class _Status extends ConsumerWidget {
  const _Status({required this.application, required this.onReapply});

  final Application application;
  final VoidCallback onReapply;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final interview = application.interview;
    final now = ref.watch(serverClockProvider).now();
    return ListView(
      padding: const EdgeInsetsDirectional.all(16),
      children: [
        Text(
          stageText(l10n, application),
          key: const Key('application-stage'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        for (final request in application.requests)
          Text(requestText(l10n, request)),
        if (application.stage == ApplicationStage.interview &&
            interview != null)
          TextButton(
            key: const Key('application-interview-map'),
            onPressed: () => ref.read(captainAuth.launch)(
              navigationTo(interview.latitude, interview.longitude),
            ),
            child: Text(l10n.captainOfficeMap),
          ),
        if (canReapply(application, now))
          FilledButton(
            key: const Key('application-reapply'),
            onPressed: onReapply,
            child: Text(l10n.captainApplicationReapply),
          ),
        const SizedBox(height: 16),
        for (final kind in statusDocuments(application))
          ListTile(
            key: Key('application-document-${kind.wire}'),
            title: Text(documentText(l10n, kind)),
            subtitle: Text(
              documentStatusText(l10n, application.document(kind)),
            ),
            trailing: canUploadAgain(application, kind)
                ? TextButton(
                    onPressed: () => showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => DocumentSheet(kind: kind),
                    ),
                    child: Text(l10n.captainDocumentUploadAgain),
                  )
                : null,
          ),
        if (application.history.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            l10n.captainApplicationHistory,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          for (final change in application.history)
            Text(historyText(l10n, change)),
        ],
      ],
    );
  }
}

/// CA §5.2: the five steps, each saved on the server before the next.
class ApplicationForm extends ConsumerStatefulWidget {
  const ApplicationForm({super.key, required this.application, this.previous});

  final Application? application;

  /// The rejected application a new one follows (K11): step 1 starts from
  /// its name, date of birth and neighbourhood.
  final Application? previous;

  @override
  ConsumerState<ApplicationForm> createState() => _ApplicationFormState();
}

class _ApplicationFormState extends ConsumerState<ApplicationForm> {
  late int _step = firstOpenStep(widget.application);

  bool _reachable(int step) =>
      step == personalStep || widget.application != null;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final application = widget.application;
    void next() => setState(() => _step = (_step + 1).clamp(0, reviewStep));
    return Stepper(
      currentStep: _step,
      onStepTapped: (step) {
        if (_reachable(step)) setState(() => _step = step);
      },
      controlsBuilder: (context, details) => const SizedBox.shrink(),
      steps: [
        Step(
          title: Text(l10n.captainApplicationStepPersonal),
          isActive: _step == personalStep,
          content: _PersonalStep(
            application: application ?? widget.previous,
            onSaved: next,
          ),
        ),
        Step(
          title: Text(l10n.captainApplicationStepVehicle),
          isActive: _step == vehicleStep,
          content: application == null
              ? const SizedBox.shrink()
              : _VehicleStep(application: application, onSaved: next),
        ),
        Step(
          title: Text(l10n.captainApplicationStepDocuments),
          isActive: _step == documentsStep,
          content: application == null
              ? const SizedBox.shrink()
              : _DocumentsStep(application: application, onDone: next),
        ),
        Step(
          title: Text(l10n.captainApplicationStepTerms),
          isActive: _step == termsStep,
          content: application == null
              ? const SizedBox.shrink()
              : _TermsStep(application: application, onDone: next),
        ),
        Step(
          title: Text(l10n.captainApplicationStepReview),
          isActive: _step == reviewStep,
          content: application == null
              ? const SizedBox.shrink()
              : _ReviewStep(application: application),
        ),
      ],
    );
  }
}

/// A step's save: busy while it runs, the refusal's sentence after.
mixin _Saving<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  bool busy = false;
  ApplicationRefusal? refusal;

  ApplicationController get controller =>
      ref.read(applicationProvider.notifier);

  Future<bool> run(Future<void> Function() save) async {
    setState(() {
      busy = true;
      refusal = null;
    });
    try {
      await save();
      if (mounted) setState(() => busy = false);
      return true;
    } on ApplicationRefusal catch (error) {
      if (mounted) {
        setState(() {
          busy = false;
          refusal = error;
        });
      }
      return false;
    }
  }

  Widget refusalLine(AppLocalizations l10n) => refusal == null
      ? const SizedBox.shrink()
      : Text(
          refusalText(l10n, refusal!),
          key: const Key('application-refusal'),
        );
}

class _PersonalStep extends ConsumerStatefulWidget {
  const _PersonalStep({required this.application, required this.onSaved});

  final Application? application;
  final VoidCallback onSaved;

  @override
  ConsumerState<_PersonalStep> createState() => _PersonalStepState();
}

class _PersonalStepState extends ConsumerState<_PersonalStep>
    with _Saving<_PersonalStep> {
  late final _name = TextEditingController(text: widget.application?.fullName);
  late String? _birthDate = widget.application?.birthDate;
  late String? _zoneId = widget.application?.zoneId;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zones = ref.watch(applicationZonesProvider).value ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          key: const Key('application-name'),
          controller: _name,
          decoration: InputDecoration(
            labelText: l10n.captainApplicationFullName,
          ),
        ),
        ListTile(
          key: const Key('application-birth-date'),
          title: Text(l10n.captainApplicationBirthDate),
          subtitle: Text(
            _birthDate == null
                ? l10n.captainApplicationChooseDate
                : dayText(l10n, _birthDate!),
          ),
          onTap: () async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime(now.year - 20),
              firstDate: DateTime(now.year - 80),
              lastDate: now,
            );
            if (picked != null) setState(() => _birthDate = _day(picked));
          },
        ),
        DropdownButton<String>(
          key: const Key('application-zone'),
          isExpanded: true,
          hint: Text(l10n.captainApplicationNeighbourhood),
          value: zones.any((zone) => zone.id == _zoneId) ? _zoneId : null,
          items: [
            for (final zone in zones)
              DropdownMenuItem(value: zone.id, child: Text(zone.name)),
          ],
          onChanged: (id) => setState(() => _zoneId = id),
        ),
        refusalLine(l10n),
        FilledButton(
          key: const Key('application-save-personal'),
          onPressed: busy || _birthDate == null || _zoneId == null
              ? null
              : () async {
                  final saved = await run(
                    () => controller.savePersonal(
                      fullName: _name.text,
                      birthDate: _birthDate!,
                      zoneId: _zoneId!,
                    ),
                  );
                  if (saved) widget.onSaved();
                },
          child: Text(l10n.captainApplicationSaveAndContinue),
        ),
      ],
    );
  }
}

class _VehicleStep extends ConsumerStatefulWidget {
  const _VehicleStep({required this.application, required this.onSaved});

  final Application application;
  final VoidCallback onSaved;

  @override
  ConsumerState<_VehicleStep> createState() => _VehicleStepState();
}

class _VehicleStepState extends ConsumerState<_VehicleStep>
    with _Saving<_VehicleStep> {
  late Vehicle? _vehicle = widget.application.vehicle;
  late final _plate = TextEditingController(text: widget.application.plate);

  @override
  void dispose() {
    _plate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final vehicle = _vehicle;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RadioGroup<Vehicle>(
          groupValue: vehicle,
          onChanged: (chosen) => setState(() => _vehicle = chosen),
          child: Column(
            children: [
              for (final each in Vehicle.values)
                RadioListTile<Vehicle>(
                  key: Key('application-vehicle-${each.name}'),
                  value: each,
                  title: Text(vehicleText(l10n, each)),
                ),
            ],
          ),
        ),
        if (vehicle != null && isMotor(vehicle)) ...[
          Text(l10n.captainApplicationLicensedOnly),
          TextField(
            key: const Key('application-plate'),
            controller: _plate,
            decoration: InputDecoration(
              labelText: l10n.captainApplicationPlate,
            ),
          ),
        ],
        refusalLine(l10n),
        FilledButton(
          key: const Key('application-save-vehicle'),
          onPressed: busy || vehicle == null
              ? null
              : () async {
                  final saved = await run(
                    () => controller.saveVehicle(vehicle, _plate.text),
                  );
                  if (saved) widget.onSaved();
                },
          child: Text(l10n.captainApplicationSaveAndContinue),
        ),
      ],
    );
  }
}

class _DocumentsStep extends StatelessWidget {
  const _DocumentsStep({required this.application, required this.onDone});

  final Application application;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final waiting = application.missing.any((each) => each is MissingDocument);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final kind in formDocuments(application.vehicle))
          ListTile(
            key: Key('application-document-${kind.wire}'),
            title: Text(
              isRequired(kind)
                  ? documentText(l10n, kind)
                  : '${documentText(l10n, kind)} (${l10n.captainDocumentOptional})',
            ),
            subtitle: Text(
              documentStatusText(l10n, application.document(kind)),
            ),
            trailing: TextButton(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (context) => DocumentSheet(kind: kind),
              ),
              child: Text(
                application.document(kind) == null
                    ? l10n.captainDocumentUpload
                    : l10n.captainDocumentUploadAgain,
              ),
            ),
          ),
        FilledButton(
          key: const Key('application-documents-next'),
          onPressed: waiting ? null : onDone,
          child: Text(l10n.captainApplicationSaveAndContinue),
        ),
      ],
    );
  }
}

/// One document's photos (CA §5.3): each checked for blur and darkness
/// before it joins, the ID's two sides and number, the criminal record's
/// issue date; «حفظ المستند» uploads and saves them.
/// Saves a document's checked photos; throws an [ApplicationRefusal].
typedef DocumentSave =
    Future<void> Function(
      DocumentKind kind,
      List<DocumentPhoto> photos, {
      String? number,
      String? issueDate,
    });

class DocumentSheet extends ConsumerStatefulWidget {
  const DocumentSheet({super.key, required this.kind, this.save});

  final DocumentKind kind;

  /// The application's by default; a captain's «رفع نسخة جديدة» (CA §12.2,
  /// slice 2.35a) gives its own.
  final DocumentSave? save;

  @override
  ConsumerState<DocumentSheet> createState() => _DocumentSheetState();
}

class _DocumentSheetState extends ConsumerState<DocumentSheet>
    with _Saving<DocumentSheet> {
  final List<DocumentPhoto> _photos = [];
  final _number = TextEditingController();
  String? _issueDate;

  DocumentKind get _kind => widget.kind;

  @override
  void dispose() {
    _number.dispose();
    super.dispose();
  }

  Future<void> _pick(PhotoSource source) async {
    final picked = await ref.read(photoPickerProvider)(source);
    if (picked == null) {
      setState(
        () => refusal = const ApplicationRefusal(ApplicationRefusal.unreadable),
      );
      return;
    }
    await run(() async {
      final checked = await controller.check(picked);
      _photos.add(checked);
    });
  }

  String _pageLabel(AppLocalizations l10n, int index) =>
      _kind == DocumentKind.nationalId
      ? (index == 0 ? l10n.captainDocumentIdFront : l10n.captainDocumentIdBack)
      : l10n.captainDocumentPage('${index + 1}');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final camera = _kind.frontCamera
        ? PhotoSource.frontCamera
        : PhotoSource.camera;
    final full = _photos.length >= _kind.maxFiles;
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: 16,
        end: 16,
        top: 16,
        bottom: 16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          Text(
            documentText(l10n, _kind),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (_kind == DocumentKind.personalPhoto)
            Text(l10n.captainDocumentPhotoHint),
          for (var i = 0; i < _photos.length; i++)
            ListTile(
              leading: Image.memory(
                _photos[i].photo.bytes,
                width: 48,
                errorBuilder: (context, error, stack) =>
                    const SizedBox(width: 48),
              ),
              title: Text(_pageLabel(l10n, i)),
            ),
          if (!full) ...[
            if (_photos.isNotEmpty || _kind == DocumentKind.nationalId)
              Text(_pageLabel(l10n, _photos.length)),
            OutlinedButton(
              key: const Key('document-camera'),
              onPressed: busy || !cameraAvailable ? null : () => _pick(camera),
              child: Text(l10n.captainDocumentTakePhoto),
            ),
            if (_kind.fromFile || !cameraAvailable)
              OutlinedButton(
                key: const Key('document-file'),
                onPressed: busy ? null : () => _pick(PhotoSource.gallery),
                child: Text(l10n.captainDocumentPickFile),
              ),
          ],
          if (_kind == DocumentKind.nationalId)
            TextField(
              key: const Key('document-number'),
              controller: _number,
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
              decoration: InputDecoration(
                labelText: l10n.captainDocumentIdNumber,
              ),
            ),
          if (_kind == DocumentKind.criminalRecord)
            ListTile(
              key: const Key('document-issue-date'),
              title: Text(l10n.captainDocumentIssueDate),
              subtitle: Text(
                _issueDate == null
                    ? l10n.captainApplicationChooseDate
                    : dayText(l10n, _issueDate!),
              ),
              onTap: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: now,
                  firstDate: DateTime(now.year - 2),
                  lastDate: now,
                );
                if (picked != null) setState(() => _issueDate = _day(picked));
              },
            ),
          refusalLine(l10n),
          FilledButton(
            key: const Key('document-save'),
            onPressed: busy || _photos.isEmpty
                ? null
                : () async {
                    final saved = await run(
                      () => (widget.save ?? controller.saveDocument)(
                        _kind,
                        _photos,
                        number: _kind == DocumentKind.nationalId
                            ? _number.text
                            : null,
                        issueDate: _issueDate,
                      ),
                    );
                    if (saved && context.mounted) Navigator.of(context).pop();
                  },
            child: Text(l10n.captainDocumentSave),
          ),
        ],
      ),
    );
  }
}

/// Step 4 (CA §5.2): the captain terms, accepted on `/terms` with the
/// account the applicant keeps as a captain, and the work rules.
class _TermsStep extends ConsumerWidget {
  const _TermsStep({required this.application, required this.onDone});

  final Application application;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextButton(
          onPressed: () => context.push('/work-rules'),
          child: Text(l10n.captainWorkRules),
        ),
        if (application.termsAccepted)
          Text(l10n.captainApplicationTermsAccepted)
        else
          OutlinedButton(
            key: const Key('application-terms'),
            onPressed: () async {
              await context.push('/terms');
              await ref.read(applicationProvider.notifier).reload();
            },
            child: Text(l10n.captainApplicationTermsRead),
          ),
        FilledButton(
          key: const Key('application-terms-next'),
          onPressed: application.termsAccepted ? onDone : null,
          child: Text(l10n.captainApplicationSaveAndContinue),
        ),
      ],
    );
  }
}

/// Step 5: the summary, then «إرسال الطلب».
class _ReviewStep extends ConsumerStatefulWidget {
  const _ReviewStep({required this.application});

  final Application application;

  @override
  ConsumerState<_ReviewStep> createState() => _ReviewStepState();
}

class _ReviewStepState extends ConsumerState<_ReviewStep>
    with _Saving<_ReviewStep> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final application = widget.application;
    final zones = ref.watch(applicationZonesProvider).value ?? const [];
    final zone = zones.where((each) => each.id == application.zoneId);
    final vehicle = application.vehicle;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(application.fullName),
        Text(
          '${l10n.captainApplicationBirthDate}: '
          '${dayText(l10n, application.birthDate)}',
        ),
        if (zone.isNotEmpty)
          Text('${l10n.captainApplicationNeighbourhood}: ${zone.first.name}'),
        if (vehicle != null)
          Text(
            application.plate == null
                ? vehicleText(l10n, vehicle)
                : '${vehicleText(l10n, vehicle)} · ${application.plate}',
          ),
        for (final document in application.documents)
          Text(
            '${documentText(l10n, document.kind)}: '
            '${documentStatusText(l10n, document)}',
          ),
        if (application.missing.isNotEmpty) ...[
          Text(l10n.captainApplicationMissingTitle),
          for (final missing in application.missing)
            Text('• ${missingText(l10n, missing)}'),
        ],
        refusalLine(l10n),
        FilledButton(
          key: const Key('application-submit'),
          onPressed: busy || application.missing.isNotEmpty
              ? null
              : () => run(controller.submit),
          child: Text(l10n.captainApplicationSubmit),
        ),
      ],
    );
  }
}
