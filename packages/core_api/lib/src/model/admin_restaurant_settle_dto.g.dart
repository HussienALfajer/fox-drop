// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_settle_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminRestaurantSettleDtoSessionEnum
_$adminRestaurantSettleDtoSessionEnum_office =
    const AdminRestaurantSettleDtoSessionEnum._('office');
const AdminRestaurantSettleDtoSessionEnum
_$adminRestaurantSettleDtoSessionEnum_field =
    const AdminRestaurantSettleDtoSessionEnum._('field');

AdminRestaurantSettleDtoSessionEnum
_$adminRestaurantSettleDtoSessionEnumValueOf(String name) {
  switch (name) {
    case 'office':
      return _$adminRestaurantSettleDtoSessionEnum_office;
    case 'field':
      return _$adminRestaurantSettleDtoSessionEnum_field;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRestaurantSettleDtoSessionEnum>
_$adminRestaurantSettleDtoSessionEnumValues =
    BuiltSet<AdminRestaurantSettleDtoSessionEnum>(
      const <AdminRestaurantSettleDtoSessionEnum>[
        _$adminRestaurantSettleDtoSessionEnum_office,
        _$adminRestaurantSettleDtoSessionEnum_field,
      ],
    );

Serializer<AdminRestaurantSettleDtoSessionEnum>
_$adminRestaurantSettleDtoSessionEnumSerializer =
    _$AdminRestaurantSettleDtoSessionEnumSerializer();

class _$AdminRestaurantSettleDtoSessionEnumSerializer
    implements PrimitiveSerializer<AdminRestaurantSettleDtoSessionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'office': 'office',
    'field': 'field',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'office': 'office',
    'field': 'field',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminRestaurantSettleDtoSessionEnum,
  ];
  @override
  final String wireName = 'AdminRestaurantSettleDtoSessionEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantSettleDtoSessionEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminRestaurantSettleDtoSessionEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminRestaurantSettleDtoSessionEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminRestaurantSettleDto extends AdminRestaurantSettleDto {
  @override
  final String restaurantId;
  @override
  final AdminRestaurantSettleDtoSessionEnum? session;
  @override
  final String? visitorId;
  @override
  final String due;
  @override
  final BuiltList<AdminRestaurantSettleDtoLinesInner> lines;

  factory _$AdminRestaurantSettleDto([
    void Function(AdminRestaurantSettleDtoBuilder)? updates,
  ]) => (AdminRestaurantSettleDtoBuilder()..update(updates))._build();

  _$AdminRestaurantSettleDto._({
    required this.restaurantId,
    this.session,
    this.visitorId,
    required this.due,
    required this.lines,
  }) : super._();
  @override
  AdminRestaurantSettleDto rebuild(
    void Function(AdminRestaurantSettleDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantSettleDtoBuilder toBuilder() =>
      AdminRestaurantSettleDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantSettleDto &&
        restaurantId == other.restaurantId &&
        session == other.session &&
        visitorId == other.visitorId &&
        due == other.due &&
        lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jc(_$hash, session.hashCode);
    _$hash = $jc(_$hash, visitorId.hashCode);
    _$hash = $jc(_$hash, due.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRestaurantSettleDto')
          ..add('restaurantId', restaurantId)
          ..add('session', session)
          ..add('visitorId', visitorId)
          ..add('due', due)
          ..add('lines', lines))
        .toString();
  }
}

class AdminRestaurantSettleDtoBuilder
    implements
        Builder<AdminRestaurantSettleDto, AdminRestaurantSettleDtoBuilder> {
  _$AdminRestaurantSettleDto? _$v;

  String? _restaurantId;
  String? get restaurantId => _$this._restaurantId;
  set restaurantId(String? restaurantId) => _$this._restaurantId = restaurantId;

  AdminRestaurantSettleDtoSessionEnum? _session;
  AdminRestaurantSettleDtoSessionEnum? get session => _$this._session;
  set session(AdminRestaurantSettleDtoSessionEnum? session) =>
      _$this._session = session;

  String? _visitorId;
  String? get visitorId => _$this._visitorId;
  set visitorId(String? visitorId) => _$this._visitorId = visitorId;

  String? _due;
  String? get due => _$this._due;
  set due(String? due) => _$this._due = due;

  ListBuilder<AdminRestaurantSettleDtoLinesInner>? _lines;
  ListBuilder<AdminRestaurantSettleDtoLinesInner> get lines =>
      _$this._lines ??= ListBuilder<AdminRestaurantSettleDtoLinesInner>();
  set lines(ListBuilder<AdminRestaurantSettleDtoLinesInner>? lines) =>
      _$this._lines = lines;

  AdminRestaurantSettleDtoBuilder() {
    AdminRestaurantSettleDto._defaults(this);
  }

  AdminRestaurantSettleDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _restaurantId = $v.restaurantId;
      _session = $v.session;
      _visitorId = $v.visitorId;
      _due = $v.due;
      _lines = $v.lines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantSettleDto other) {
    _$v = other as _$AdminRestaurantSettleDto;
  }

  @override
  void update(void Function(AdminRestaurantSettleDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantSettleDto build() => _build();

  _$AdminRestaurantSettleDto _build() {
    _$AdminRestaurantSettleDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantSettleDto._(
            restaurantId: BuiltValueNullFieldError.checkNotNull(
              restaurantId,
              r'AdminRestaurantSettleDto',
              'restaurantId',
            ),
            session: session,
            visitorId: visitorId,
            due: BuiltValueNullFieldError.checkNotNull(
              due,
              r'AdminRestaurantSettleDto',
              'due',
            ),
            lines: lines.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantSettleDto',
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
