// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_live_map_dto_output_captains_inner_custody.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminLiveMapDtoOutputCaptainsInnerCustody
    extends AdminLiveMapDtoOutputCaptainsInnerCustody {
  @override
  final AdminLiveMapDtoOutputCaptainsInnerCustodyUsage usage;
  @override
  final AdminLiveMapDtoOutputCaptainsInnerCustodyUsage limit;

  factory _$AdminLiveMapDtoOutputCaptainsInnerCustody([
    void Function(AdminLiveMapDtoOutputCaptainsInnerCustodyBuilder)? updates,
  ]) => (AdminLiveMapDtoOutputCaptainsInnerCustodyBuilder()..update(updates))
      ._build();

  _$AdminLiveMapDtoOutputCaptainsInnerCustody._({
    required this.usage,
    required this.limit,
  }) : super._();
  @override
  AdminLiveMapDtoOutputCaptainsInnerCustody rebuild(
    void Function(AdminLiveMapDtoOutputCaptainsInnerCustodyBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminLiveMapDtoOutputCaptainsInnerCustodyBuilder toBuilder() =>
      AdminLiveMapDtoOutputCaptainsInnerCustodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminLiveMapDtoOutputCaptainsInnerCustody &&
        usage == other.usage &&
        limit == other.limit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, usage.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminLiveMapDtoOutputCaptainsInnerCustody',
          )
          ..add('usage', usage)
          ..add('limit', limit))
        .toString();
  }
}

class AdminLiveMapDtoOutputCaptainsInnerCustodyBuilder
    implements
        Builder<
          AdminLiveMapDtoOutputCaptainsInnerCustody,
          AdminLiveMapDtoOutputCaptainsInnerCustodyBuilder
        > {
  _$AdminLiveMapDtoOutputCaptainsInnerCustody? _$v;

  AdminLiveMapDtoOutputCaptainsInnerCustodyUsageBuilder? _usage;
  AdminLiveMapDtoOutputCaptainsInnerCustodyUsageBuilder get usage =>
      _$this._usage ??= AdminLiveMapDtoOutputCaptainsInnerCustodyUsageBuilder();
  set usage(AdminLiveMapDtoOutputCaptainsInnerCustodyUsageBuilder? usage) =>
      _$this._usage = usage;

  AdminLiveMapDtoOutputCaptainsInnerCustodyUsageBuilder? _limit;
  AdminLiveMapDtoOutputCaptainsInnerCustodyUsageBuilder get limit =>
      _$this._limit ??= AdminLiveMapDtoOutputCaptainsInnerCustodyUsageBuilder();
  set limit(AdminLiveMapDtoOutputCaptainsInnerCustodyUsageBuilder? limit) =>
      _$this._limit = limit;

  AdminLiveMapDtoOutputCaptainsInnerCustodyBuilder() {
    AdminLiveMapDtoOutputCaptainsInnerCustody._defaults(this);
  }

  AdminLiveMapDtoOutputCaptainsInnerCustodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _usage = $v.usage.toBuilder();
      _limit = $v.limit.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminLiveMapDtoOutputCaptainsInnerCustody other) {
    _$v = other as _$AdminLiveMapDtoOutputCaptainsInnerCustody;
  }

  @override
  void update(
    void Function(AdminLiveMapDtoOutputCaptainsInnerCustodyBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminLiveMapDtoOutputCaptainsInnerCustody build() => _build();

  _$AdminLiveMapDtoOutputCaptainsInnerCustody _build() {
    _$AdminLiveMapDtoOutputCaptainsInnerCustody _$result;
    try {
      _$result =
          _$v ??
          _$AdminLiveMapDtoOutputCaptainsInnerCustody._(
            usage: usage.build(),
            limit: limit.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'usage';
        usage.build();
        _$failedField = 'limit';
        limit.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminLiveMapDtoOutputCaptainsInnerCustody',
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
