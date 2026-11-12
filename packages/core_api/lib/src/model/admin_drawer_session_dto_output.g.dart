// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_drawer_session_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminDrawerSessionDtoOutputKindEnum
_$adminDrawerSessionDtoOutputKindEnum_office =
    const AdminDrawerSessionDtoOutputKindEnum._('office');

AdminDrawerSessionDtoOutputKindEnum
_$adminDrawerSessionDtoOutputKindEnumValueOf(String name) {
  switch (name) {
    case 'office':
      return _$adminDrawerSessionDtoOutputKindEnum_office;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDrawerSessionDtoOutputKindEnum>
_$adminDrawerSessionDtoOutputKindEnumValues =
    BuiltSet<AdminDrawerSessionDtoOutputKindEnum>(
      const <AdminDrawerSessionDtoOutputKindEnum>[
        _$adminDrawerSessionDtoOutputKindEnum_office,
      ],
    );

Serializer<AdminDrawerSessionDtoOutputKindEnum>
_$adminDrawerSessionDtoOutputKindEnumSerializer =
    _$AdminDrawerSessionDtoOutputKindEnumSerializer();

class _$AdminDrawerSessionDtoOutputKindEnumSerializer
    implements PrimitiveSerializer<AdminDrawerSessionDtoOutputKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'office': 'office',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'office': 'office',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminDrawerSessionDtoOutputKindEnum,
  ];
  @override
  final String wireName = 'AdminDrawerSessionDtoOutputKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminDrawerSessionDtoOutputKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminDrawerSessionDtoOutputKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminDrawerSessionDtoOutputKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminDrawerSessionDtoOutput extends AdminDrawerSessionDtoOutput {
  @override
  final String id;
  @override
  final String cityId;
  @override
  final String adminAccountId;
  @override
  final String? adminName;
  @override
  final AdminDrawerSessionDtoOutputKindEnum kind;
  @override
  final DateTime openedAt;
  @override
  final DateTime? closedAt;
  @override
  final String? closeNote;
  @override
  final BuiltList<AdminCurrentDrawerSessionDtoOutputSessionCurrenciesInner>
  currencies;

  factory _$AdminDrawerSessionDtoOutput([
    void Function(AdminDrawerSessionDtoOutputBuilder)? updates,
  ]) => (AdminDrawerSessionDtoOutputBuilder()..update(updates))._build();

  _$AdminDrawerSessionDtoOutput._({
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
  AdminDrawerSessionDtoOutput rebuild(
    void Function(AdminDrawerSessionDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDrawerSessionDtoOutputBuilder toBuilder() =>
      AdminDrawerSessionDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDrawerSessionDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'AdminDrawerSessionDtoOutput')
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

class AdminDrawerSessionDtoOutputBuilder
    implements
        Builder<
          AdminDrawerSessionDtoOutput,
          AdminDrawerSessionDtoOutputBuilder
        > {
  _$AdminDrawerSessionDtoOutput? _$v;

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

  AdminDrawerSessionDtoOutputKindEnum? _kind;
  AdminDrawerSessionDtoOutputKindEnum? get kind => _$this._kind;
  set kind(AdminDrawerSessionDtoOutputKindEnum? kind) => _$this._kind = kind;

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

  AdminDrawerSessionDtoOutputBuilder() {
    AdminDrawerSessionDtoOutput._defaults(this);
  }

  AdminDrawerSessionDtoOutputBuilder get _$this {
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
  void replace(AdminDrawerSessionDtoOutput other) {
    _$v = other as _$AdminDrawerSessionDtoOutput;
  }

  @override
  void update(void Function(AdminDrawerSessionDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDrawerSessionDtoOutput build() => _build();

  _$AdminDrawerSessionDtoOutput _build() {
    _$AdminDrawerSessionDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminDrawerSessionDtoOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminDrawerSessionDtoOutput',
              'id',
            ),
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminDrawerSessionDtoOutput',
              'cityId',
            ),
            adminAccountId: BuiltValueNullFieldError.checkNotNull(
              adminAccountId,
              r'AdminDrawerSessionDtoOutput',
              'adminAccountId',
            ),
            adminName: adminName,
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'AdminDrawerSessionDtoOutput',
              'kind',
            ),
            openedAt: BuiltValueNullFieldError.checkNotNull(
              openedAt,
              r'AdminDrawerSessionDtoOutput',
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
          r'AdminDrawerSessionDtoOutput',
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
