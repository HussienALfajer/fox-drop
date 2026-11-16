// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_exchange_rates_dto_output_currencies_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum
_$adminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum_nearest =
    const AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum._(
      'nearest',
    );
const AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum
_$adminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum_up =
    const AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum._('up');
const AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum
_$adminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum_down =
    const AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum._('down');

AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum
_$adminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnumValueOf(
  String name,
) {
  switch (name) {
    case 'nearest':
      return _$adminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum_nearest;
    case 'up':
      return _$adminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum_up;
    case 'down':
      return _$adminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum_down;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum>
_$adminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnumValues =
    BuiltSet<AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum>(
      const <AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum>[
        _$adminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum_nearest,
        _$adminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum_up,
        _$adminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum_down,
      ],
    );

Serializer<AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum>
_$adminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnumSerializer =
    _$AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnumSerializer();

class _$AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnumSerializer
    implements
        PrimitiveSerializer<
          AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'nearest': 'nearest',
    'up': 'up',
    'down': 'down',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'nearest': 'nearest',
    'up': 'up',
    'down': 'down',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum,
  ];
  @override
  final String wireName =
      'AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminExchangeRatesDtoOutputCurrenciesInner
    extends AdminExchangeRatesDtoOutputCurrenciesInner {
  @override
  final String currency;
  @override
  final String nameAr;
  @override
  final String symbol;
  @override
  final int decimals;
  @override
  final int displayOrder;
  @override
  final bool enabled;
  @override
  final bool isBase;
  @override
  final AdminExchangeRatesDtoOutputCurrenciesInnerRate? rate;
  @override
  final bool stale;
  @override
  final String? roundingUnitMinor;
  @override
  final AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum roundingMode;

  factory _$AdminExchangeRatesDtoOutputCurrenciesInner([
    void Function(AdminExchangeRatesDtoOutputCurrenciesInnerBuilder)? updates,
  ]) => (AdminExchangeRatesDtoOutputCurrenciesInnerBuilder()..update(updates))
      ._build();

  _$AdminExchangeRatesDtoOutputCurrenciesInner._({
    required this.currency,
    required this.nameAr,
    required this.symbol,
    required this.decimals,
    required this.displayOrder,
    required this.enabled,
    required this.isBase,
    this.rate,
    required this.stale,
    this.roundingUnitMinor,
    required this.roundingMode,
  }) : super._();
  @override
  AdminExchangeRatesDtoOutputCurrenciesInner rebuild(
    void Function(AdminExchangeRatesDtoOutputCurrenciesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminExchangeRatesDtoOutputCurrenciesInnerBuilder toBuilder() =>
      AdminExchangeRatesDtoOutputCurrenciesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminExchangeRatesDtoOutputCurrenciesInner &&
        currency == other.currency &&
        nameAr == other.nameAr &&
        symbol == other.symbol &&
        decimals == other.decimals &&
        displayOrder == other.displayOrder &&
        enabled == other.enabled &&
        isBase == other.isBase &&
        rate == other.rate &&
        stale == other.stale &&
        roundingUnitMinor == other.roundingUnitMinor &&
        roundingMode == other.roundingMode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, nameAr.hashCode);
    _$hash = $jc(_$hash, symbol.hashCode);
    _$hash = $jc(_$hash, decimals.hashCode);
    _$hash = $jc(_$hash, displayOrder.hashCode);
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, isBase.hashCode);
    _$hash = $jc(_$hash, rate.hashCode);
    _$hash = $jc(_$hash, stale.hashCode);
    _$hash = $jc(_$hash, roundingUnitMinor.hashCode);
    _$hash = $jc(_$hash, roundingMode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminExchangeRatesDtoOutputCurrenciesInner',
          )
          ..add('currency', currency)
          ..add('nameAr', nameAr)
          ..add('symbol', symbol)
          ..add('decimals', decimals)
          ..add('displayOrder', displayOrder)
          ..add('enabled', enabled)
          ..add('isBase', isBase)
          ..add('rate', rate)
          ..add('stale', stale)
          ..add('roundingUnitMinor', roundingUnitMinor)
          ..add('roundingMode', roundingMode))
        .toString();
  }
}

class AdminExchangeRatesDtoOutputCurrenciesInnerBuilder
    implements
        Builder<
          AdminExchangeRatesDtoOutputCurrenciesInner,
          AdminExchangeRatesDtoOutputCurrenciesInnerBuilder
        > {
  _$AdminExchangeRatesDtoOutputCurrenciesInner? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _nameAr;
  String? get nameAr => _$this._nameAr;
  set nameAr(String? nameAr) => _$this._nameAr = nameAr;

  String? _symbol;
  String? get symbol => _$this._symbol;
  set symbol(String? symbol) => _$this._symbol = symbol;

  int? _decimals;
  int? get decimals => _$this._decimals;
  set decimals(int? decimals) => _$this._decimals = decimals;

  int? _displayOrder;
  int? get displayOrder => _$this._displayOrder;
  set displayOrder(int? displayOrder) => _$this._displayOrder = displayOrder;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  bool? _isBase;
  bool? get isBase => _$this._isBase;
  set isBase(bool? isBase) => _$this._isBase = isBase;

  AdminExchangeRatesDtoOutputCurrenciesInnerRateBuilder? _rate;
  AdminExchangeRatesDtoOutputCurrenciesInnerRateBuilder get rate =>
      _$this._rate ??= AdminExchangeRatesDtoOutputCurrenciesInnerRateBuilder();
  set rate(AdminExchangeRatesDtoOutputCurrenciesInnerRateBuilder? rate) =>
      _$this._rate = rate;

  bool? _stale;
  bool? get stale => _$this._stale;
  set stale(bool? stale) => _$this._stale = stale;

  String? _roundingUnitMinor;
  String? get roundingUnitMinor => _$this._roundingUnitMinor;
  set roundingUnitMinor(String? roundingUnitMinor) =>
      _$this._roundingUnitMinor = roundingUnitMinor;

  AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum? _roundingMode;
  AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum?
  get roundingMode => _$this._roundingMode;
  set roundingMode(
    AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum? roundingMode,
  ) => _$this._roundingMode = roundingMode;

  AdminExchangeRatesDtoOutputCurrenciesInnerBuilder() {
    AdminExchangeRatesDtoOutputCurrenciesInner._defaults(this);
  }

  AdminExchangeRatesDtoOutputCurrenciesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _nameAr = $v.nameAr;
      _symbol = $v.symbol;
      _decimals = $v.decimals;
      _displayOrder = $v.displayOrder;
      _enabled = $v.enabled;
      _isBase = $v.isBase;
      _rate = $v.rate?.toBuilder();
      _stale = $v.stale;
      _roundingUnitMinor = $v.roundingUnitMinor;
      _roundingMode = $v.roundingMode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminExchangeRatesDtoOutputCurrenciesInner other) {
    _$v = other as _$AdminExchangeRatesDtoOutputCurrenciesInner;
  }

  @override
  void update(
    void Function(AdminExchangeRatesDtoOutputCurrenciesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminExchangeRatesDtoOutputCurrenciesInner build() => _build();

  _$AdminExchangeRatesDtoOutputCurrenciesInner _build() {
    _$AdminExchangeRatesDtoOutputCurrenciesInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminExchangeRatesDtoOutputCurrenciesInner._(
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminExchangeRatesDtoOutputCurrenciesInner',
              'currency',
            ),
            nameAr: BuiltValueNullFieldError.checkNotNull(
              nameAr,
              r'AdminExchangeRatesDtoOutputCurrenciesInner',
              'nameAr',
            ),
            symbol: BuiltValueNullFieldError.checkNotNull(
              symbol,
              r'AdminExchangeRatesDtoOutputCurrenciesInner',
              'symbol',
            ),
            decimals: BuiltValueNullFieldError.checkNotNull(
              decimals,
              r'AdminExchangeRatesDtoOutputCurrenciesInner',
              'decimals',
            ),
            displayOrder: BuiltValueNullFieldError.checkNotNull(
              displayOrder,
              r'AdminExchangeRatesDtoOutputCurrenciesInner',
              'displayOrder',
            ),
            enabled: BuiltValueNullFieldError.checkNotNull(
              enabled,
              r'AdminExchangeRatesDtoOutputCurrenciesInner',
              'enabled',
            ),
            isBase: BuiltValueNullFieldError.checkNotNull(
              isBase,
              r'AdminExchangeRatesDtoOutputCurrenciesInner',
              'isBase',
            ),
            rate: _rate?.build(),
            stale: BuiltValueNullFieldError.checkNotNull(
              stale,
              r'AdminExchangeRatesDtoOutputCurrenciesInner',
              'stale',
            ),
            roundingUnitMinor: roundingUnitMinor,
            roundingMode: BuiltValueNullFieldError.checkNotNull(
              roundingMode,
              r'AdminExchangeRatesDtoOutputCurrenciesInner',
              'roundingMode',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rate';
        _rate?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminExchangeRatesDtoOutputCurrenciesInner',
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
