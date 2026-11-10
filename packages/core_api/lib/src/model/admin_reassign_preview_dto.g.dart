// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_reassign_preview_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminReassignPreviewDtoCashEnum
_$adminReassignPreviewDtoCashEnum_returned =
    const AdminReassignPreviewDtoCashEnum._('returned');
const AdminReassignPreviewDtoCashEnum
_$adminReassignPreviewDtoCashEnum_notReturned =
    const AdminReassignPreviewDtoCashEnum._('notReturned');
const AdminReassignPreviewDtoCashEnum
_$adminReassignPreviewDtoCashEnum_notPaid =
    const AdminReassignPreviewDtoCashEnum._('notPaid');

AdminReassignPreviewDtoCashEnum _$adminReassignPreviewDtoCashEnumValueOf(
  String name,
) {
  switch (name) {
    case 'returned':
      return _$adminReassignPreviewDtoCashEnum_returned;
    case 'notReturned':
      return _$adminReassignPreviewDtoCashEnum_notReturned;
    case 'notPaid':
      return _$adminReassignPreviewDtoCashEnum_notPaid;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminReassignPreviewDtoCashEnum>
_$adminReassignPreviewDtoCashEnumValues =
    BuiltSet<AdminReassignPreviewDtoCashEnum>(
      const <AdminReassignPreviewDtoCashEnum>[
        _$adminReassignPreviewDtoCashEnum_returned,
        _$adminReassignPreviewDtoCashEnum_notReturned,
        _$adminReassignPreviewDtoCashEnum_notPaid,
      ],
    );

Serializer<AdminReassignPreviewDtoCashEnum>
_$adminReassignPreviewDtoCashEnumSerializer =
    _$AdminReassignPreviewDtoCashEnumSerializer();

class _$AdminReassignPreviewDtoCashEnumSerializer
    implements PrimitiveSerializer<AdminReassignPreviewDtoCashEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'returned': 'returned',
    'notReturned': 'not_returned',
    'notPaid': 'not_paid',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'returned': 'returned',
    'not_returned': 'notReturned',
    'not_paid': 'notPaid',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminReassignPreviewDtoCashEnum];
  @override
  final String wireName = 'AdminReassignPreviewDtoCashEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminReassignPreviewDtoCashEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminReassignPreviewDtoCashEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminReassignPreviewDtoCashEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminReassignPreviewDto extends AdminReassignPreviewDto {
  @override
  final AdminReassignPreviewDtoCashEnum? cash;

  factory _$AdminReassignPreviewDto([
    void Function(AdminReassignPreviewDtoBuilder)? updates,
  ]) => (AdminReassignPreviewDtoBuilder()..update(updates))._build();

  _$AdminReassignPreviewDto._({this.cash}) : super._();
  @override
  AdminReassignPreviewDto rebuild(
    void Function(AdminReassignPreviewDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminReassignPreviewDtoBuilder toBuilder() =>
      AdminReassignPreviewDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminReassignPreviewDto && cash == other.cash;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cash.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminReassignPreviewDto',
    )..add('cash', cash)).toString();
  }
}

class AdminReassignPreviewDtoBuilder
    implements
        Builder<AdminReassignPreviewDto, AdminReassignPreviewDtoBuilder> {
  _$AdminReassignPreviewDto? _$v;

  AdminReassignPreviewDtoCashEnum? _cash;
  AdminReassignPreviewDtoCashEnum? get cash => _$this._cash;
  set cash(AdminReassignPreviewDtoCashEnum? cash) => _$this._cash = cash;

  AdminReassignPreviewDtoBuilder() {
    AdminReassignPreviewDto._defaults(this);
  }

  AdminReassignPreviewDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cash = $v.cash;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminReassignPreviewDto other) {
    _$v = other as _$AdminReassignPreviewDto;
  }

  @override
  void update(void Function(AdminReassignPreviewDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminReassignPreviewDto build() => _build();

  _$AdminReassignPreviewDto _build() {
    final _$result = _$v ?? _$AdminReassignPreviewDto._(cash: cash);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
