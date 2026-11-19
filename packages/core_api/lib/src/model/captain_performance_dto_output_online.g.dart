// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_performance_dto_output_online.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainPerformanceDtoOutputOnline
    extends CaptainPerformanceDtoOutputOnline {
  @override
  final int todayMinutes;
  @override
  final int weekMinutes;

  factory _$CaptainPerformanceDtoOutputOnline([
    void Function(CaptainPerformanceDtoOutputOnlineBuilder)? updates,
  ]) => (CaptainPerformanceDtoOutputOnlineBuilder()..update(updates))._build();

  _$CaptainPerformanceDtoOutputOnline._({
    required this.todayMinutes,
    required this.weekMinutes,
  }) : super._();
  @override
  CaptainPerformanceDtoOutputOnline rebuild(
    void Function(CaptainPerformanceDtoOutputOnlineBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainPerformanceDtoOutputOnlineBuilder toBuilder() =>
      CaptainPerformanceDtoOutputOnlineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainPerformanceDtoOutputOnline &&
        todayMinutes == other.todayMinutes &&
        weekMinutes == other.weekMinutes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, todayMinutes.hashCode);
    _$hash = $jc(_$hash, weekMinutes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainPerformanceDtoOutputOnline')
          ..add('todayMinutes', todayMinutes)
          ..add('weekMinutes', weekMinutes))
        .toString();
  }
}

class CaptainPerformanceDtoOutputOnlineBuilder
    implements
        Builder<
          CaptainPerformanceDtoOutputOnline,
          CaptainPerformanceDtoOutputOnlineBuilder
        > {
  _$CaptainPerformanceDtoOutputOnline? _$v;

  int? _todayMinutes;
  int? get todayMinutes => _$this._todayMinutes;
  set todayMinutes(int? todayMinutes) => _$this._todayMinutes = todayMinutes;

  int? _weekMinutes;
  int? get weekMinutes => _$this._weekMinutes;
  set weekMinutes(int? weekMinutes) => _$this._weekMinutes = weekMinutes;

  CaptainPerformanceDtoOutputOnlineBuilder() {
    CaptainPerformanceDtoOutputOnline._defaults(this);
  }

  CaptainPerformanceDtoOutputOnlineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _todayMinutes = $v.todayMinutes;
      _weekMinutes = $v.weekMinutes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainPerformanceDtoOutputOnline other) {
    _$v = other as _$CaptainPerformanceDtoOutputOnline;
  }

  @override
  void update(
    void Function(CaptainPerformanceDtoOutputOnlineBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainPerformanceDtoOutputOnline build() => _build();

  _$CaptainPerformanceDtoOutputOnline _build() {
    final _$result =
        _$v ??
        _$CaptainPerformanceDtoOutputOnline._(
          todayMinutes: BuiltValueNullFieldError.checkNotNull(
            todayMinutes,
            r'CaptainPerformanceDtoOutputOnline',
            'todayMinutes',
          ),
          weekMinutes: BuiltValueNullFieldError.checkNotNull(
            weekMinutes,
            r'CaptainPerformanceDtoOutputOnline',
            'weekMinutes',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
