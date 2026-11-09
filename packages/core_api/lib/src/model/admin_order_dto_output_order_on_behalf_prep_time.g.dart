// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_on_behalf_prep_time.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderOnBehalfPrepTime
    extends AdminOrderDtoOutputOrderOnBehalfPrepTime {
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

  factory _$AdminOrderDtoOutputOrderOnBehalfPrepTime([
    void Function(AdminOrderDtoOutputOrderOnBehalfPrepTimeBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderOnBehalfPrepTimeBuilder()..update(updates))
      ._build();

  _$AdminOrderDtoOutputOrderOnBehalfPrepTime._({
    required this.options,
    required this.stepMin,
    required this.floorMin,
    required this.ceilingMin,
    required this.defaultMin,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderOnBehalfPrepTime rebuild(
    void Function(AdminOrderDtoOutputOrderOnBehalfPrepTimeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderOnBehalfPrepTimeBuilder toBuilder() =>
      AdminOrderDtoOutputOrderOnBehalfPrepTimeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderOnBehalfPrepTime &&
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
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderOnBehalfPrepTime',
          )
          ..add('options', options)
          ..add('stepMin', stepMin)
          ..add('floorMin', floorMin)
          ..add('ceilingMin', ceilingMin)
          ..add('defaultMin', defaultMin))
        .toString();
  }
}

class AdminOrderDtoOutputOrderOnBehalfPrepTimeBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderOnBehalfPrepTime,
          AdminOrderDtoOutputOrderOnBehalfPrepTimeBuilder
        > {
  _$AdminOrderDtoOutputOrderOnBehalfPrepTime? _$v;

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

  AdminOrderDtoOutputOrderOnBehalfPrepTimeBuilder() {
    AdminOrderDtoOutputOrderOnBehalfPrepTime._defaults(this);
  }

  AdminOrderDtoOutputOrderOnBehalfPrepTimeBuilder get _$this {
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
  void replace(AdminOrderDtoOutputOrderOnBehalfPrepTime other) {
    _$v = other as _$AdminOrderDtoOutputOrderOnBehalfPrepTime;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderOnBehalfPrepTimeBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderOnBehalfPrepTime build() => _build();

  _$AdminOrderDtoOutputOrderOnBehalfPrepTime _build() {
    _$AdminOrderDtoOutputOrderOnBehalfPrepTime _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderDtoOutputOrderOnBehalfPrepTime._(
            options: options.build(),
            stepMin: BuiltValueNullFieldError.checkNotNull(
              stepMin,
              r'AdminOrderDtoOutputOrderOnBehalfPrepTime',
              'stepMin',
            ),
            floorMin: BuiltValueNullFieldError.checkNotNull(
              floorMin,
              r'AdminOrderDtoOutputOrderOnBehalfPrepTime',
              'floorMin',
            ),
            ceilingMin: BuiltValueNullFieldError.checkNotNull(
              ceilingMin,
              r'AdminOrderDtoOutputOrderOnBehalfPrepTime',
              'ceilingMin',
            ),
            defaultMin: BuiltValueNullFieldError.checkNotNull(
              defaultMin,
              r'AdminOrderDtoOutputOrderOnBehalfPrepTime',
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
          r'AdminOrderDtoOutputOrderOnBehalfPrepTime',
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
