// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_block_customer_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminBlockCustomerDtoKindEnum _$adminBlockCustomerDtoKindEnum_until =
    const AdminBlockCustomerDtoKindEnum._('until');
const AdminBlockCustomerDtoKindEnum _$adminBlockCustomerDtoKindEnum_indefinite =
    const AdminBlockCustomerDtoKindEnum._('indefinite');
const AdminBlockCustomerDtoKindEnum _$adminBlockCustomerDtoKindEnum_dues =
    const AdminBlockCustomerDtoKindEnum._('dues');

AdminBlockCustomerDtoKindEnum _$adminBlockCustomerDtoKindEnumValueOf(
  String name,
) {
  switch (name) {
    case 'until':
      return _$adminBlockCustomerDtoKindEnum_until;
    case 'indefinite':
      return _$adminBlockCustomerDtoKindEnum_indefinite;
    case 'dues':
      return _$adminBlockCustomerDtoKindEnum_dues;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminBlockCustomerDtoKindEnum>
_$adminBlockCustomerDtoKindEnumValues = BuiltSet<AdminBlockCustomerDtoKindEnum>(
  const <AdminBlockCustomerDtoKindEnum>[
    _$adminBlockCustomerDtoKindEnum_until,
    _$adminBlockCustomerDtoKindEnum_indefinite,
    _$adminBlockCustomerDtoKindEnum_dues,
  ],
);

Serializer<AdminBlockCustomerDtoKindEnum>
_$adminBlockCustomerDtoKindEnumSerializer =
    _$AdminBlockCustomerDtoKindEnumSerializer();

class _$AdminBlockCustomerDtoKindEnumSerializer
    implements PrimitiveSerializer<AdminBlockCustomerDtoKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'until': 'until',
    'indefinite': 'indefinite',
    'dues': 'dues',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'until': 'until',
    'indefinite': 'indefinite',
    'dues': 'dues',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminBlockCustomerDtoKindEnum];
  @override
  final String wireName = 'AdminBlockCustomerDtoKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminBlockCustomerDtoKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminBlockCustomerDtoKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminBlockCustomerDtoKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminBlockCustomerDto extends AdminBlockCustomerDto {
  @override
  final String cityId;
  @override
  final AdminBlockCustomerDtoKindEnum kind;
  @override
  final DateTime? until;
  @override
  final String? amount;
  @override
  final String reason;
  @override
  final String note;

  factory _$AdminBlockCustomerDto([
    void Function(AdminBlockCustomerDtoBuilder)? updates,
  ]) => (AdminBlockCustomerDtoBuilder()..update(updates))._build();

  _$AdminBlockCustomerDto._({
    required this.cityId,
    required this.kind,
    this.until,
    this.amount,
    required this.reason,
    required this.note,
  }) : super._();
  @override
  AdminBlockCustomerDto rebuild(
    void Function(AdminBlockCustomerDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminBlockCustomerDtoBuilder toBuilder() =>
      AdminBlockCustomerDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminBlockCustomerDto &&
        cityId == other.cityId &&
        kind == other.kind &&
        until == other.until &&
        amount == other.amount &&
        reason == other.reason &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, until.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminBlockCustomerDto')
          ..add('cityId', cityId)
          ..add('kind', kind)
          ..add('until', until)
          ..add('amount', amount)
          ..add('reason', reason)
          ..add('note', note))
        .toString();
  }
}

class AdminBlockCustomerDtoBuilder
    implements Builder<AdminBlockCustomerDto, AdminBlockCustomerDtoBuilder> {
  _$AdminBlockCustomerDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  AdminBlockCustomerDtoKindEnum? _kind;
  AdminBlockCustomerDtoKindEnum? get kind => _$this._kind;
  set kind(AdminBlockCustomerDtoKindEnum? kind) => _$this._kind = kind;

  DateTime? _until;
  DateTime? get until => _$this._until;
  set until(DateTime? until) => _$this._until = until;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  AdminBlockCustomerDtoBuilder() {
    AdminBlockCustomerDto._defaults(this);
  }

  AdminBlockCustomerDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _kind = $v.kind;
      _until = $v.until;
      _amount = $v.amount;
      _reason = $v.reason;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminBlockCustomerDto other) {
    _$v = other as _$AdminBlockCustomerDto;
  }

  @override
  void update(void Function(AdminBlockCustomerDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminBlockCustomerDto build() => _build();

  _$AdminBlockCustomerDto _build() {
    final _$result =
        _$v ??
        _$AdminBlockCustomerDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminBlockCustomerDto',
            'cityId',
          ),
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'AdminBlockCustomerDto',
            'kind',
          ),
          until: until,
          amount: amount,
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminBlockCustomerDto',
            'reason',
          ),
          note: BuiltValueNullFieldError.checkNotNull(
            note,
            r'AdminBlockCustomerDto',
            'note',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
