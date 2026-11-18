// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_draft_operations_dto_periods_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDraftOperationsDtoPeriodsInner
    extends AdminDraftOperationsDtoPeriodsInner {
  @override
  final int weekday;
  @override
  final int opensAt;
  @override
  final int closesAt;

  factory _$AdminDraftOperationsDtoPeriodsInner([
    void Function(AdminDraftOperationsDtoPeriodsInnerBuilder)? updates,
  ]) =>
      (AdminDraftOperationsDtoPeriodsInnerBuilder()..update(updates))._build();

  _$AdminDraftOperationsDtoPeriodsInner._({
    required this.weekday,
    required this.opensAt,
    required this.closesAt,
  }) : super._();
  @override
  AdminDraftOperationsDtoPeriodsInner rebuild(
    void Function(AdminDraftOperationsDtoPeriodsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDraftOperationsDtoPeriodsInnerBuilder toBuilder() =>
      AdminDraftOperationsDtoPeriodsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDraftOperationsDtoPeriodsInner &&
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
    return (newBuiltValueToStringHelper(r'AdminDraftOperationsDtoPeriodsInner')
          ..add('weekday', weekday)
          ..add('opensAt', opensAt)
          ..add('closesAt', closesAt))
        .toString();
  }
}

class AdminDraftOperationsDtoPeriodsInnerBuilder
    implements
        Builder<
          AdminDraftOperationsDtoPeriodsInner,
          AdminDraftOperationsDtoPeriodsInnerBuilder
        > {
  _$AdminDraftOperationsDtoPeriodsInner? _$v;

  int? _weekday;
  int? get weekday => _$this._weekday;
  set weekday(int? weekday) => _$this._weekday = weekday;

  int? _opensAt;
  int? get opensAt => _$this._opensAt;
  set opensAt(int? opensAt) => _$this._opensAt = opensAt;

  int? _closesAt;
  int? get closesAt => _$this._closesAt;
  set closesAt(int? closesAt) => _$this._closesAt = closesAt;

  AdminDraftOperationsDtoPeriodsInnerBuilder() {
    AdminDraftOperationsDtoPeriodsInner._defaults(this);
  }

  AdminDraftOperationsDtoPeriodsInnerBuilder get _$this {
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
  void replace(AdminDraftOperationsDtoPeriodsInner other) {
    _$v = other as _$AdminDraftOperationsDtoPeriodsInner;
  }

  @override
  void update(
    void Function(AdminDraftOperationsDtoPeriodsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDraftOperationsDtoPeriodsInner build() => _build();

  _$AdminDraftOperationsDtoPeriodsInner _build() {
    final _$result =
        _$v ??
        _$AdminDraftOperationsDtoPeriodsInner._(
          weekday: BuiltValueNullFieldError.checkNotNull(
            weekday,
            r'AdminDraftOperationsDtoPeriodsInner',
            'weekday',
          ),
          opensAt: BuiltValueNullFieldError.checkNotNull(
            opensAt,
            r'AdminDraftOperationsDtoPeriodsInner',
            'opensAt',
          ),
          closesAt: BuiltValueNullFieldError.checkNotNull(
            closesAt,
            r'AdminDraftOperationsDtoPeriodsInner',
            'closesAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
