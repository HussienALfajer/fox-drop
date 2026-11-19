// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_profile_dto_output_on_time.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainProfileDtoOutputOnTime
    extends AdminCaptainProfileDtoOutputOnTime {
  @override
  final int onTime;
  @override
  final int counted;

  factory _$AdminCaptainProfileDtoOutputOnTime([
    void Function(AdminCaptainProfileDtoOutputOnTimeBuilder)? updates,
  ]) => (AdminCaptainProfileDtoOutputOnTimeBuilder()..update(updates))._build();

  _$AdminCaptainProfileDtoOutputOnTime._({
    required this.onTime,
    required this.counted,
  }) : super._();
  @override
  AdminCaptainProfileDtoOutputOnTime rebuild(
    void Function(AdminCaptainProfileDtoOutputOnTimeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainProfileDtoOutputOnTimeBuilder toBuilder() =>
      AdminCaptainProfileDtoOutputOnTimeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainProfileDtoOutputOnTime &&
        onTime == other.onTime &&
        counted == other.counted;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, onTime.hashCode);
    _$hash = $jc(_$hash, counted.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCaptainProfileDtoOutputOnTime')
          ..add('onTime', onTime)
          ..add('counted', counted))
        .toString();
  }
}

class AdminCaptainProfileDtoOutputOnTimeBuilder
    implements
        Builder<
          AdminCaptainProfileDtoOutputOnTime,
          AdminCaptainProfileDtoOutputOnTimeBuilder
        > {
  _$AdminCaptainProfileDtoOutputOnTime? _$v;

  int? _onTime;
  int? get onTime => _$this._onTime;
  set onTime(int? onTime) => _$this._onTime = onTime;

  int? _counted;
  int? get counted => _$this._counted;
  set counted(int? counted) => _$this._counted = counted;

  AdminCaptainProfileDtoOutputOnTimeBuilder() {
    AdminCaptainProfileDtoOutputOnTime._defaults(this);
  }

  AdminCaptainProfileDtoOutputOnTimeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _onTime = $v.onTime;
      _counted = $v.counted;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainProfileDtoOutputOnTime other) {
    _$v = other as _$AdminCaptainProfileDtoOutputOnTime;
  }

  @override
  void update(
    void Function(AdminCaptainProfileDtoOutputOnTimeBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainProfileDtoOutputOnTime build() => _build();

  _$AdminCaptainProfileDtoOutputOnTime _build() {
    final _$result =
        _$v ??
        _$AdminCaptainProfileDtoOutputOnTime._(
          onTime: BuiltValueNullFieldError.checkNotNull(
            onTime,
            r'AdminCaptainProfileDtoOutputOnTime',
            'onTime',
          ),
          counted: BuiltValueNullFieldError.checkNotNull(
            counted,
            r'AdminCaptainProfileDtoOutputOnTime',
            'counted',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
