// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_draft_period_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDraftPeriodOutput extends AdminDraftPeriodOutput {
  @override
  final int weekday;
  @override
  final int opensAt;
  @override
  final int closesAt;

  factory _$AdminDraftPeriodOutput([
    void Function(AdminDraftPeriodOutputBuilder)? updates,
  ]) => (AdminDraftPeriodOutputBuilder()..update(updates))._build();

  _$AdminDraftPeriodOutput._({
    required this.weekday,
    required this.opensAt,
    required this.closesAt,
  }) : super._();
  @override
  AdminDraftPeriodOutput rebuild(
    void Function(AdminDraftPeriodOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDraftPeriodOutputBuilder toBuilder() =>
      AdminDraftPeriodOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDraftPeriodOutput &&
        weekday == other.weekday &&
        opensAt == other.opensAt &&
        closesAt == other.closesAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, weekday.hashCode);
    _$hash = $jc(_$hash, opensAt.hashCode);
    _$hash = $jc(_$hash, closesAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDraftPeriodOutput')
          ..add('weekday', weekday)
          ..add('opensAt', opensAt)
          ..add('closesAt', closesAt))
        .toString();
  }
}

class AdminDraftPeriodOutputBuilder
    implements Builder<AdminDraftPeriodOutput, AdminDraftPeriodOutputBuilder> {
  _$AdminDraftPeriodOutput? _$v;

  int? _weekday;
  int? get weekday => _$this._weekday;
  set weekday(int? weekday) => _$this._weekday = weekday;

  int? _opensAt;
  int? get opensAt => _$this._opensAt;
  set opensAt(int? opensAt) => _$this._opensAt = opensAt;

  int? _closesAt;
  int? get closesAt => _$this._closesAt;
  set closesAt(int? closesAt) => _$this._closesAt = closesAt;

  AdminDraftPeriodOutputBuilder() {
    AdminDraftPeriodOutput._defaults(this);
  }

  AdminDraftPeriodOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _weekday = $v.weekday;
      _opensAt = $v.opensAt;
      _closesAt = $v.closesAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDraftPeriodOutput other) {
    _$v = other as _$AdminDraftPeriodOutput;
  }

  @override
  void update(void Function(AdminDraftPeriodOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDraftPeriodOutput build() => _build();

  _$AdminDraftPeriodOutput _build() {
    final _$result =
        _$v ??
        _$AdminDraftPeriodOutput._(
          weekday: BuiltValueNullFieldError.checkNotNull(
            weekday,
            r'AdminDraftPeriodOutput',
            'weekday',
          ),
          opensAt: BuiltValueNullFieldError.checkNotNull(
            opensAt,
            r'AdminDraftPeriodOutput',
            'opensAt',
          ),
          closesAt: BuiltValueNullFieldError.checkNotNull(
            closesAt,
            r'AdminDraftPeriodOutput',
            'closesAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
