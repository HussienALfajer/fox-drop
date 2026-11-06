// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_orders_dto_output_prep_time.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantOrdersDtoOutputPrepTime
    extends MerchantOrdersDtoOutputPrepTime {
  @override
  final BuiltList<int> options;
  @override
  final int stepMin;
  @override
  final int floorMin;
  @override
  final int ceilingMin;
  @override
  final int defaultMin;

  factory _$MerchantOrdersDtoOutputPrepTime([
    void Function(MerchantOrdersDtoOutputPrepTimeBuilder)? updates,
  ]) => (MerchantOrdersDtoOutputPrepTimeBuilder()..update(updates))._build();

  _$MerchantOrdersDtoOutputPrepTime._({
    required this.options,
    required this.stepMin,
    required this.floorMin,
    required this.ceilingMin,
    required this.defaultMin,
  }) : super._();
  @override
  MerchantOrdersDtoOutputPrepTime rebuild(
    void Function(MerchantOrdersDtoOutputPrepTimeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrdersDtoOutputPrepTimeBuilder toBuilder() =>
      MerchantOrdersDtoOutputPrepTimeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrdersDtoOutputPrepTime &&
        options == other.options &&
        stepMin == other.stepMin &&
        floorMin == other.floorMin &&
        ceilingMin == other.ceilingMin &&
        defaultMin == other.defaultMin;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, options.hashCode);
    _$hash = $jc(_$hash, stepMin.hashCode);
    _$hash = $jc(_$hash, floorMin.hashCode);
    _$hash = $jc(_$hash, ceilingMin.hashCode);
    _$hash = $jc(_$hash, defaultMin.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantOrdersDtoOutputPrepTime')
          ..add('options', options)
          ..add('stepMin', stepMin)
          ..add('floorMin', floorMin)
          ..add('ceilingMin', ceilingMin)
          ..add('defaultMin', defaultMin))
        .toString();
  }
}

class MerchantOrdersDtoOutputPrepTimeBuilder
    implements
        Builder<
          MerchantOrdersDtoOutputPrepTime,
          MerchantOrdersDtoOutputPrepTimeBuilder
        > {
  _$MerchantOrdersDtoOutputPrepTime? _$v;

  ListBuilder<int>? _options;
  ListBuilder<int> get options => _$this._options ??= ListBuilder<int>();
  set options(ListBuilder<int>? options) => _$this._options = options;

  int? _stepMin;
  int? get stepMin => _$this._stepMin;
  set stepMin(int? stepMin) => _$this._stepMin = stepMin;

  int? _floorMin;
  int? get floorMin => _$this._floorMin;
  set floorMin(int? floorMin) => _$this._floorMin = floorMin;

  int? _ceilingMin;
  int? get ceilingMin => _$this._ceilingMin;
  set ceilingMin(int? ceilingMin) => _$this._ceilingMin = ceilingMin;

  int? _defaultMin;
  int? get defaultMin => _$this._defaultMin;
  set defaultMin(int? defaultMin) => _$this._defaultMin = defaultMin;

  MerchantOrdersDtoOutputPrepTimeBuilder() {
    MerchantOrdersDtoOutputPrepTime._defaults(this);
  }

  MerchantOrdersDtoOutputPrepTimeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _options = $v.options.toBuilder();
      _stepMin = $v.stepMin;
      _floorMin = $v.floorMin;
      _ceilingMin = $v.ceilingMin;
      _defaultMin = $v.defaultMin;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOrdersDtoOutputPrepTime other) {
    _$v = other as _$MerchantOrdersDtoOutputPrepTime;
  }

  @override
  void update(void Function(MerchantOrdersDtoOutputPrepTimeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrdersDtoOutputPrepTime build() => _build();

  _$MerchantOrdersDtoOutputPrepTime _build() {
    _$MerchantOrdersDtoOutputPrepTime _$result;
    try {
      _$result =
          _$v ??
          _$MerchantOrdersDtoOutputPrepTime._(
            options: options.build(),
            stepMin: BuiltValueNullFieldError.checkNotNull(
              stepMin,
              r'MerchantOrdersDtoOutputPrepTime',
              'stepMin',
            ),
            floorMin: BuiltValueNullFieldError.checkNotNull(
              floorMin,
              r'MerchantOrdersDtoOutputPrepTime',
              'floorMin',
            ),
            ceilingMin: BuiltValueNullFieldError.checkNotNull(
              ceilingMin,
              r'MerchantOrdersDtoOutputPrepTime',
              'ceilingMin',
            ),
            defaultMin: BuiltValueNullFieldError.checkNotNull(
              defaultMin,
              r'MerchantOrdersDtoOutputPrepTime',
              'defaultMin',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'options';
        options.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantOrdersDtoOutputPrepTime',
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
