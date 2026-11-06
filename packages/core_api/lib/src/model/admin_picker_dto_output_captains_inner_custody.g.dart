// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_picker_dto_output_captains_inner_custody.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPickerDtoOutputCaptainsInnerCustody
    extends AdminPickerDtoOutputCaptainsInnerCustody {
  @override
  final AdminPickerDtoOutputCaptainsInnerCustodyUsage usage;
  @override
  final AdminPickerDtoOutputCaptainsInnerCustodyLimit? limit;

  factory _$AdminPickerDtoOutputCaptainsInnerCustody([
    void Function(AdminPickerDtoOutputCaptainsInnerCustodyBuilder)? updates,
  ]) => (AdminPickerDtoOutputCaptainsInnerCustodyBuilder()..update(updates))
      ._build();

  _$AdminPickerDtoOutputCaptainsInnerCustody._({
    required this.usage,
    this.limit,
  }) : super._();
  @override
  AdminPickerDtoOutputCaptainsInnerCustody rebuild(
    void Function(AdminPickerDtoOutputCaptainsInnerCustodyBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPickerDtoOutputCaptainsInnerCustodyBuilder toBuilder() =>
      AdminPickerDtoOutputCaptainsInnerCustodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPickerDtoOutputCaptainsInnerCustody &&
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
            r'AdminPickerDtoOutputCaptainsInnerCustody',
          )
          ..add('usage', usage)
          ..add('limit', limit))
        .toString();
  }
}

class AdminPickerDtoOutputCaptainsInnerCustodyBuilder
    implements
        Builder<
          AdminPickerDtoOutputCaptainsInnerCustody,
          AdminPickerDtoOutputCaptainsInnerCustodyBuilder
        > {
  _$AdminPickerDtoOutputCaptainsInnerCustody? _$v;

  AdminPickerDtoOutputCaptainsInnerCustodyUsageBuilder? _usage;
  AdminPickerDtoOutputCaptainsInnerCustodyUsageBuilder get usage =>
      _$this._usage ??= AdminPickerDtoOutputCaptainsInnerCustodyUsageBuilder();
  set usage(AdminPickerDtoOutputCaptainsInnerCustodyUsageBuilder? usage) =>
      _$this._usage = usage;

  AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder? _limit;
  AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder get limit =>
      _$this._limit ??= AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder();
  set limit(AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder? limit) =>
      _$this._limit = limit;

  AdminPickerDtoOutputCaptainsInnerCustodyBuilder() {
    AdminPickerDtoOutputCaptainsInnerCustody._defaults(this);
  }

  AdminPickerDtoOutputCaptainsInnerCustodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _usage = $v.usage.toBuilder();
      _limit = $v.limit?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPickerDtoOutputCaptainsInnerCustody other) {
    _$v = other as _$AdminPickerDtoOutputCaptainsInnerCustody;
  }

  @override
  void update(
    void Function(AdminPickerDtoOutputCaptainsInnerCustodyBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminPickerDtoOutputCaptainsInnerCustody build() => _build();

  _$AdminPickerDtoOutputCaptainsInnerCustody _build() {
    _$AdminPickerDtoOutputCaptainsInnerCustody _$result;
    try {
      _$result =
          _$v ??
          _$AdminPickerDtoOutputCaptainsInnerCustody._(
            usage: usage.build(),
            limit: _limit?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'usage';
        usage.build();
        _$failedField = 'limit';
        _limit?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminPickerDtoOutputCaptainsInnerCustody',
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
