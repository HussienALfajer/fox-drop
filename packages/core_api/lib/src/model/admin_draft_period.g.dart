// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_draft_period.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDraftPeriod extends AdminDraftPeriod {
  @override
  final int weekday;
  @override
  final int opensAt;
  @override
  final int closesAt;

  factory _$AdminDraftPeriod([
    void Function(AdminDraftPeriodBuilder)? updates,
  ]) => (AdminDraftPeriodBuilder()..update(updates))._build();

  _$AdminDraftPeriod._({
    required this.weekday,
    required this.opensAt,
    required this.closesAt,
  }) : super._();
  @override
  AdminDraftPeriod rebuild(void Function(AdminDraftPeriodBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDraftPeriodBuilder toBuilder() =>
      AdminDraftPeriodBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDraftPeriod &&
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
    return (newBuiltValueToStringHelper(r'AdminDraftPeriod')
          ..add('weekday', weekday)
          ..add('opensAt', opensAt)
          ..add('closesAt', closesAt))
        .toString();
  }
}

class AdminDraftPeriodBuilder
    implements Builder<AdminDraftPeriod, AdminDraftPeriodBuilder> {
  _$AdminDraftPeriod? _$v;

  int? _weekday;
  int? get weekday => _$this._weekday;
  set weekday(int? weekday) => _$this._weekday = weekday;

  int? _opensAt;
  int? get opensAt => _$this._opensAt;
  set opensAt(int? opensAt) => _$this._opensAt = opensAt;

  int? _closesAt;
  int? get closesAt => _$this._closesAt;
  set closesAt(int? closesAt) => _$this._closesAt = closesAt;

  AdminDraftPeriodBuilder() {
    AdminDraftPeriod._defaults(this);
  }

  AdminDraftPeriodBuilder get _$this {
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
  void replace(AdminDraftPeriod other) {
    _$v = other as _$AdminDraftPeriod;
  }

  @override
  void update(void Function(AdminDraftPeriodBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDraftPeriod build() => _build();

  _$AdminDraftPeriod _build() {
    final _$result =
        _$v ??
        _$AdminDraftPeriod._(
          weekday: BuiltValueNullFieldError.checkNotNull(
            weekday,
            r'AdminDraftPeriod',
            'weekday',
          ),
          opensAt: BuiltValueNullFieldError.checkNotNull(
            opensAt,
            r'AdminDraftPeriod',
            'opensAt',
          ),
          closesAt: BuiltValueNullFieldError.checkNotNull(
            closesAt,
            r'AdminDraftPeriod',
            'closesAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
