// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_applications_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainApplicationsDtoOutput
    extends AdminCaptainApplicationsDtoOutput {
  @override
  final BuiltMap<String, int> counts;
  @override
  final BuiltList<AdminCaptainApplicationsDtoOutputApplicationsInner>
  applications;

  factory _$AdminCaptainApplicationsDtoOutput([
    void Function(AdminCaptainApplicationsDtoOutputBuilder)? updates,
  ]) => (AdminCaptainApplicationsDtoOutputBuilder()..update(updates))._build();

  _$AdminCaptainApplicationsDtoOutput._({
    required this.counts,
    required this.applications,
  }) : super._();
  @override
  AdminCaptainApplicationsDtoOutput rebuild(
    void Function(AdminCaptainApplicationsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainApplicationsDtoOutputBuilder toBuilder() =>
      AdminCaptainApplicationsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainApplicationsDtoOutput &&
        counts == other.counts &&
        applications == other.applications;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, counts.hashCode);
    _$hash = $jc(_$hash, applications.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCaptainApplicationsDtoOutput')
          ..add('counts', counts)
          ..add('applications', applications))
        .toString();
  }
}

class AdminCaptainApplicationsDtoOutputBuilder
    implements
        Builder<
          AdminCaptainApplicationsDtoOutput,
          AdminCaptainApplicationsDtoOutputBuilder
        > {
  _$AdminCaptainApplicationsDtoOutput? _$v;

  MapBuilder<String, int>? _counts;
  MapBuilder<String, int> get counts =>
      _$this._counts ??= MapBuilder<String, int>();
  set counts(MapBuilder<String, int>? counts) => _$this._counts = counts;

  ListBuilder<AdminCaptainApplicationsDtoOutputApplicationsInner>?
  _applications;
  ListBuilder<AdminCaptainApplicationsDtoOutputApplicationsInner>
  get applications => _$this._applications ??=
      ListBuilder<AdminCaptainApplicationsDtoOutputApplicationsInner>();
  set applications(
    ListBuilder<AdminCaptainApplicationsDtoOutputApplicationsInner>?
    applications,
  ) => _$this._applications = applications;

  AdminCaptainApplicationsDtoOutputBuilder() {
    AdminCaptainApplicationsDtoOutput._defaults(this);
  }

  AdminCaptainApplicationsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _counts = $v.counts.toBuilder();
      _applications = $v.applications.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainApplicationsDtoOutput other) {
    _$v = other as _$AdminCaptainApplicationsDtoOutput;
  }

  @override
  void update(
    void Function(AdminCaptainApplicationsDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainApplicationsDtoOutput build() => _build();

  _$AdminCaptainApplicationsDtoOutput _build() {
    _$AdminCaptainApplicationsDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminCaptainApplicationsDtoOutput._(
            counts: counts.build(),
            applications: applications.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'counts';
        counts.build();
        _$failedField = 'applications';
        applications.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCaptainApplicationsDtoOutput',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
