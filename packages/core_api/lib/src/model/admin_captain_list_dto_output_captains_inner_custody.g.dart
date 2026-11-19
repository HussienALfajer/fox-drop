// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_list_dto_output_captains_inner_custody.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainListDtoOutputCaptainsInnerCustody
    extends AdminCaptainListDtoOutputCaptainsInnerCustody {
  @override
  final AdminCaptainListDtoOutputCaptainsInnerCustodyUsage usage;
  @override
  final AdminCaptainListDtoOutputCaptainsInnerCustodyLimit limit;
  @override
  final AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue? closedDue;

  factory _$AdminCaptainListDtoOutputCaptainsInnerCustody([
    void Function(AdminCaptainListDtoOutputCaptainsInnerCustodyBuilder)?
    updates,
  ]) =>
      (AdminCaptainListDtoOutputCaptainsInnerCustodyBuilder()..update(updates))
          ._build();

  _$AdminCaptainListDtoOutputCaptainsInnerCustody._({
    required this.usage,
    required this.limit,
    this.closedDue,
  }) : super._();
  @override
  AdminCaptainListDtoOutputCaptainsInnerCustody rebuild(
    void Function(AdminCaptainListDtoOutputCaptainsInnerCustodyBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainListDtoOutputCaptainsInnerCustodyBuilder toBuilder() =>
      AdminCaptainListDtoOutputCaptainsInnerCustodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainListDtoOutputCaptainsInnerCustody &&
        usage == other.usage &&
        limit == other.limit &&
        closedDue == other.closedDue;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, usage.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jc(_$hash, closedDue.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCaptainListDtoOutputCaptainsInnerCustody',
          )
          ..add('usage', usage)
          ..add('limit', limit)
          ..add('closedDue', closedDue))
        .toString();
  }
}

class AdminCaptainListDtoOutputCaptainsInnerCustodyBuilder
    implements
        Builder<
          AdminCaptainListDtoOutputCaptainsInnerCustody,
          AdminCaptainListDtoOutputCaptainsInnerCustodyBuilder
        > {
  _$AdminCaptainListDtoOutputCaptainsInnerCustody? _$v;

  AdminCaptainListDtoOutputCaptainsInnerCustodyUsageBuilder? _usage;
  AdminCaptainListDtoOutputCaptainsInnerCustodyUsageBuilder get usage =>
      _$this._usage ??=
          AdminCaptainListDtoOutputCaptainsInnerCustodyUsageBuilder();
  set usage(AdminCaptainListDtoOutputCaptainsInnerCustodyUsageBuilder? usage) =>
      _$this._usage = usage;

  AdminCaptainListDtoOutputCaptainsInnerCustodyLimitBuilder? _limit;
  AdminCaptainListDtoOutputCaptainsInnerCustodyLimitBuilder get limit =>
      _$this._limit ??=
          AdminCaptainListDtoOutputCaptainsInnerCustodyLimitBuilder();
  set limit(AdminCaptainListDtoOutputCaptainsInnerCustodyLimitBuilder? limit) =>
      _$this._limit = limit;

  AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder? _closedDue;
  AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder get closedDue =>
      _$this._closedDue ??=
          AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder();
  set closedDue(
    AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDueBuilder? closedDue,
  ) => _$this._closedDue = closedDue;

  AdminCaptainListDtoOutputCaptainsInnerCustodyBuilder() {
    AdminCaptainListDtoOutputCaptainsInnerCustody._defaults(this);
  }

  AdminCaptainListDtoOutputCaptainsInnerCustodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _usage = $v.usage.toBuilder();
      _limit = $v.limit.toBuilder();
      _closedDue = $v.closedDue?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainListDtoOutputCaptainsInnerCustody other) {
    _$v = other as _$AdminCaptainListDtoOutputCaptainsInnerCustody;
  }

  @override
  void update(
    void Function(AdminCaptainListDtoOutputCaptainsInnerCustodyBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainListDtoOutputCaptainsInnerCustody build() => _build();

  _$AdminCaptainListDtoOutputCaptainsInnerCustody _build() {
    _$AdminCaptainListDtoOutputCaptainsInnerCustody _$result;
    try {
      _$result =
          _$v ??
          _$AdminCaptainListDtoOutputCaptainsInnerCustody._(
            usage: usage.build(),
            limit: limit.build(),
            closedDue: _closedDue?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'usage';
        usage.build();
        _$failedField = 'limit';
        limit.build();
        _$failedField = 'closedDue';
        _closedDue?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCaptainListDtoOutputCaptainsInnerCustody',
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
