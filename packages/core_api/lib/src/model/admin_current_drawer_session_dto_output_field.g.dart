// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_current_drawer_session_dto_output_field.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCurrentDrawerSessionDtoOutputFieldKindEnum
_$adminCurrentDrawerSessionDtoOutputFieldKindEnum_office =
    const AdminCurrentDrawerSessionDtoOutputFieldKindEnum._('office');
const AdminCurrentDrawerSessionDtoOutputFieldKindEnum
_$adminCurrentDrawerSessionDtoOutputFieldKindEnum_field =
    const AdminCurrentDrawerSessionDtoOutputFieldKindEnum._('field');

AdminCurrentDrawerSessionDtoOutputFieldKindEnum
_$adminCurrentDrawerSessionDtoOutputFieldKindEnumValueOf(String name) {
  switch (name) {
    case 'office':
      return _$adminCurrentDrawerSessionDtoOutputFieldKindEnum_office;
    case 'field':
      return _$adminCurrentDrawerSessionDtoOutputFieldKindEnum_field;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCurrentDrawerSessionDtoOutputFieldKindEnum>
_$adminCurrentDrawerSessionDtoOutputFieldKindEnumValues =
    BuiltSet<AdminCurrentDrawerSessionDtoOutputFieldKindEnum>(
      const <AdminCurrentDrawerSessionDtoOutputFieldKindEnum>[
        _$adminCurrentDrawerSessionDtoOutputFieldKindEnum_office,
        _$adminCurrentDrawerSessionDtoOutputFieldKindEnum_field,
      ],
    );

Serializer<AdminCurrentDrawerSessionDtoOutputFieldKindEnum>
_$adminCurrentDrawerSessionDtoOutputFieldKindEnumSerializer =
    _$AdminCurrentDrawerSessionDtoOutputFieldKindEnumSerializer();

class _$AdminCurrentDrawerSessionDtoOutputFieldKindEnumSerializer
    implements
        PrimitiveSerializer<AdminCurrentDrawerSessionDtoOutputFieldKindEnum> {
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
    AdminCurrentDrawerSessionDtoOutputFieldKindEnum,
  ];
  @override
  final String wireName = 'AdminCurrentDrawerSessionDtoOutputFieldKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCurrentDrawerSessionDtoOutputFieldKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCurrentDrawerSessionDtoOutputFieldKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCurrentDrawerSessionDtoOutputFieldKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCurrentDrawerSessionDtoOutputField
    extends AdminCurrentDrawerSessionDtoOutputField {
  @override
  final String id;
  @override
  final String cityId;
  @override
  final String adminAccountId;
  @override
  final String? adminName;
  @override
  final AdminCurrentDrawerSessionDtoOutputFieldKindEnum kind;
  @override
  final DateTime openedAt;
  @override
  final DateTime? closedAt;
  @override
  final String? closeNote;
  @override
  final BuiltList<AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner>
  currencies;

  factory _$AdminCurrentDrawerSessionDtoOutputField([
    void Function(AdminCurrentDrawerSessionDtoOutputFieldBuilder)? updates,
  ]) => (AdminCurrentDrawerSessionDtoOutputFieldBuilder()..update(updates))
      ._build();

  _$AdminCurrentDrawerSessionDtoOutputField._({
    required this.id,
    required this.cityId,
    required this.adminAccountId,
    this.adminName,
    required this.kind,
    required this.openedAt,
    this.closedAt,
    this.closeNote,
    required this.currencies,
  }) : super._();
  @override
  AdminCurrentDrawerSessionDtoOutputField rebuild(
    void Function(AdminCurrentDrawerSessionDtoOutputFieldBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCurrentDrawerSessionDtoOutputFieldBuilder toBuilder() =>
      AdminCurrentDrawerSessionDtoOutputFieldBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCurrentDrawerSessionDtoOutputField &&
        id == other.id &&
        cityId == other.cityId &&
        adminAccountId == other.adminAccountId &&
        adminName == other.adminName &&
        kind == other.kind &&
        openedAt == other.openedAt &&
        closedAt == other.closedAt &&
        closeNote == other.closeNote &&
        currencies == other.currencies;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, adminAccountId.hashCode);
    _$hash = $jc(_$hash, adminName.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, openedAt.hashCode);
    _$hash = $jc(_$hash, closedAt.hashCode);
    _$hash = $jc(_$hash, closeNote.hashCode);
    _$hash = $jc(_$hash, currencies.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCurrentDrawerSessionDtoOutputField',
          )
          ..add('id', id)
          ..add('cityId', cityId)
          ..add('adminAccountId', adminAccountId)
          ..add('adminName', adminName)
          ..add('kind', kind)
          ..add('openedAt', openedAt)
          ..add('closedAt', closedAt)
          ..add('closeNote', closeNote)
          ..add('currencies', currencies))
        .toString();
  }
}

class AdminCurrentDrawerSessionDtoOutputFieldBuilder
    implements
        Builder<
          AdminCurrentDrawerSessionDtoOutputField,
          AdminCurrentDrawerSessionDtoOutputFieldBuilder
        > {
  _$AdminCurrentDrawerSessionDtoOutputField? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _adminAccountId;
  String? get adminAccountId => _$this._adminAccountId;
  set adminAccountId(String? adminAccountId) =>
      _$this._adminAccountId = adminAccountId;

  String? _adminName;
  String? get adminName => _$this._adminName;
  set adminName(String? adminName) => _$this._adminName = adminName;

  AdminCurrentDrawerSessionDtoOutputFieldKindEnum? _kind;
  AdminCurrentDrawerSessionDtoOutputFieldKindEnum? get kind => _$this._kind;
  set kind(AdminCurrentDrawerSessionDtoOutputFieldKindEnum? kind) =>
      _$this._kind = kind;

  DateTime? _openedAt;
  DateTime? get openedAt => _$this._openedAt;
  set openedAt(DateTime? openedAt) => _$this._openedAt = openedAt;

  DateTime? _closedAt;
  DateTime? get closedAt => _$this._closedAt;
  set closedAt(DateTime? closedAt) => _$this._closedAt = closedAt;

  String? _closeNote;
  String? get closeNote => _$this._closeNote;
  set closeNote(String? closeNote) => _$this._closeNote = closeNote;

  ListBuilder<AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner>?
  _currencies;
  ListBuilder<AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner>
  get currencies => _$this._currencies ??=
      ListBuilder<AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner>();
  set currencies(
    ListBuilder<AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner>?
    currencies,
  ) => _$this._currencies = currencies;

  AdminCurrentDrawerSessionDtoOutputFieldBuilder() {
    AdminCurrentDrawerSessionDtoOutputField._defaults(this);
  }

  AdminCurrentDrawerSessionDtoOutputFieldBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _cityId = $v.cityId;
      _adminAccountId = $v.adminAccountId;
      _adminName = $v.adminName;
      _kind = $v.kind;
      _openedAt = $v.openedAt;
      _closedAt = $v.closedAt;
      _closeNote = $v.closeNote;
      _currencies = $v.currencies.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCurrentDrawerSessionDtoOutputField other) {
    _$v = other as _$AdminCurrentDrawerSessionDtoOutputField;
  }

  @override
  void update(
    void Function(AdminCurrentDrawerSessionDtoOutputFieldBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCurrentDrawerSessionDtoOutputField build() => _build();

  _$AdminCurrentDrawerSessionDtoOutputField _build() {
    _$AdminCurrentDrawerSessionDtoOutputField _$result;
    try {
      _$result =
          _$v ??
          _$AdminCurrentDrawerSessionDtoOutputField._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminCurrentDrawerSessionDtoOutputField',
              'id',
            ),
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminCurrentDrawerSessionDtoOutputField',
              'cityId',
            ),
            adminAccountId: BuiltValueNullFieldError.checkNotNull(
              adminAccountId,
              r'AdminCurrentDrawerSessionDtoOutputField',
              'adminAccountId',
            ),
            adminName: adminName,
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'AdminCurrentDrawerSessionDtoOutputField',
              'kind',
            ),
            openedAt: BuiltValueNullFieldError.checkNotNull(
              openedAt,
              r'AdminCurrentDrawerSessionDtoOutputField',
              'openedAt',
            ),
            closedAt: closedAt,
            closeNote: closeNote,
            currencies: currencies.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'currencies';
        currencies.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCurrentDrawerSessionDtoOutputField',
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
