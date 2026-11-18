// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_order_route_dto_output_route.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainOrderRouteDtoOutputRouteMethodEnum
_$captainOrderRouteDtoOutputRouteMethodEnum_road =
    const CaptainOrderRouteDtoOutputRouteMethodEnum._('road');
const CaptainOrderRouteDtoOutputRouteMethodEnum
_$captainOrderRouteDtoOutputRouteMethodEnum_straightX1Period3 =
    const CaptainOrderRouteDtoOutputRouteMethodEnum._('straightX1Period3');

CaptainOrderRouteDtoOutputRouteMethodEnum
_$captainOrderRouteDtoOutputRouteMethodEnumValueOf(String name) {
  switch (name) {
    case 'road':
      return _$captainOrderRouteDtoOutputRouteMethodEnum_road;
    case 'straightX1Period3':
      return _$captainOrderRouteDtoOutputRouteMethodEnum_straightX1Period3;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainOrderRouteDtoOutputRouteMethodEnum>
_$captainOrderRouteDtoOutputRouteMethodEnumValues =
    BuiltSet<CaptainOrderRouteDtoOutputRouteMethodEnum>(
      const <CaptainOrderRouteDtoOutputRouteMethodEnum>[
        _$captainOrderRouteDtoOutputRouteMethodEnum_road,
        _$captainOrderRouteDtoOutputRouteMethodEnum_straightX1Period3,
      ],
    );

Serializer<CaptainOrderRouteDtoOutputRouteMethodEnum>
_$captainOrderRouteDtoOutputRouteMethodEnumSerializer =
    _$CaptainOrderRouteDtoOutputRouteMethodEnumSerializer();

class _$CaptainOrderRouteDtoOutputRouteMethodEnumSerializer
    implements PrimitiveSerializer<CaptainOrderRouteDtoOutputRouteMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'road': 'road',
    'straightX1Period3': 'straight_x1.3',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'road': 'road',
    'straight_x1.3': 'straightX1Period3',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainOrderRouteDtoOutputRouteMethodEnum,
  ];
  @override
  final String wireName = 'CaptainOrderRouteDtoOutputRouteMethodEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainOrderRouteDtoOutputRouteMethodEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainOrderRouteDtoOutputRouteMethodEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainOrderRouteDtoOutputRouteMethodEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainOrderRouteDtoOutputRoute
    extends CaptainOrderRouteDtoOutputRoute {
  @override
  final int metres;
  @override
  final int seconds;
  @override
  final CaptainOrderRouteDtoOutputRouteMethodEnum method;
  @override
  final BuiltList<AdminCustomerDtoOutputAddressesInnerLocation>? line;

  factory _$CaptainOrderRouteDtoOutputRoute([
    void Function(CaptainOrderRouteDtoOutputRouteBuilder)? updates,
  ]) => (CaptainOrderRouteDtoOutputRouteBuilder()..update(updates))._build();

  _$CaptainOrderRouteDtoOutputRoute._({
    required this.metres,
    required this.seconds,
    required this.method,
    this.line,
  }) : super._();
  @override
  CaptainOrderRouteDtoOutputRoute rebuild(
    void Function(CaptainOrderRouteDtoOutputRouteBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainOrderRouteDtoOutputRouteBuilder toBuilder() =>
      CaptainOrderRouteDtoOutputRouteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainOrderRouteDtoOutputRoute &&
        metres == other.metres &&
        seconds == other.seconds &&
        method == other.method &&
        line == other.line;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, metres.hashCode);
    _$hash = $jc(_$hash, seconds.hashCode);
    _$hash = $jc(_$hash, method.hashCode);
    _$hash = $jc(_$hash, line.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainOrderRouteDtoOutputRoute')
          ..add('metres', metres)
          ..add('seconds', seconds)
          ..add('method', method)
          ..add('line', line))
        .toString();
  }
}

class CaptainOrderRouteDtoOutputRouteBuilder
    implements
        Builder<
          CaptainOrderRouteDtoOutputRoute,
          CaptainOrderRouteDtoOutputRouteBuilder
        > {
  _$CaptainOrderRouteDtoOutputRoute? _$v;

  int? _metres;
  int? get metres => _$this._metres;
  set metres(int? metres) => _$this._metres = metres;

  int? _seconds;
  int? get seconds => _$this._seconds;
  set seconds(int? seconds) => _$this._seconds = seconds;

  CaptainOrderRouteDtoOutputRouteMethodEnum? _method;
  CaptainOrderRouteDtoOutputRouteMethodEnum? get method => _$this._method;
  set method(CaptainOrderRouteDtoOutputRouteMethodEnum? method) =>
      _$this._method = method;

  ListBuilder<AdminCustomerDtoOutputAddressesInnerLocation>? _line;
  ListBuilder<AdminCustomerDtoOutputAddressesInnerLocation> get line =>
      _$this._line ??=
          ListBuilder<AdminCustomerDtoOutputAddressesInnerLocation>();
  set line(ListBuilder<AdminCustomerDtoOutputAddressesInnerLocation>? line) =>
      _$this._line = line;

  CaptainOrderRouteDtoOutputRouteBuilder() {
    CaptainOrderRouteDtoOutputRoute._defaults(this);
  }

  CaptainOrderRouteDtoOutputRouteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _metres = $v.metres;
      _seconds = $v.seconds;
      _method = $v.method;
      _line = $v.line?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainOrderRouteDtoOutputRoute other) {
    _$v = other as _$CaptainOrderRouteDtoOutputRoute;
  }

  @override
  void update(void Function(CaptainOrderRouteDtoOutputRouteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainOrderRouteDtoOutputRoute build() => _build();

  _$CaptainOrderRouteDtoOutputRoute _build() {
    _$CaptainOrderRouteDtoOutputRoute _$result;
    try {
      _$result =
          _$v ??
          _$CaptainOrderRouteDtoOutputRoute._(
            metres: BuiltValueNullFieldError.checkNotNull(
              metres,
              r'CaptainOrderRouteDtoOutputRoute',
              'metres',
            ),
            seconds: BuiltValueNullFieldError.checkNotNull(
              seconds,
              r'CaptainOrderRouteDtoOutputRoute',
              'seconds',
            ),
            method: BuiltValueNullFieldError.checkNotNull(
              method,
              r'CaptainOrderRouteDtoOutputRoute',
              'method',
            ),
            line: _line?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'line';
        _line?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainOrderRouteDtoOutputRoute',
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
