// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_reject_dto_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminRejectDtoItemsInnerUntilEnum
_$adminRejectDtoItemsInnerUntilEnum_tomorrow =
    const AdminRejectDtoItemsInnerUntilEnum._('tomorrow');
const AdminRejectDtoItemsInnerUntilEnum
_$adminRejectDtoItemsInnerUntilEnum_turnedBackOn =
    const AdminRejectDtoItemsInnerUntilEnum._('turnedBackOn');

AdminRejectDtoItemsInnerUntilEnum _$adminRejectDtoItemsInnerUntilEnumValueOf(
  String name,
) {
  switch (name) {
    case 'tomorrow':
      return _$adminRejectDtoItemsInnerUntilEnum_tomorrow;
    case 'turnedBackOn':
      return _$adminRejectDtoItemsInnerUntilEnum_turnedBackOn;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRejectDtoItemsInnerUntilEnum>
_$adminRejectDtoItemsInnerUntilEnumValues =
    BuiltSet<AdminRejectDtoItemsInnerUntilEnum>(
      const <AdminRejectDtoItemsInnerUntilEnum>[
        _$adminRejectDtoItemsInnerUntilEnum_tomorrow,
        _$adminRejectDtoItemsInnerUntilEnum_turnedBackOn,
      ],
    );

Serializer<AdminRejectDtoItemsInnerUntilEnum>
_$adminRejectDtoItemsInnerUntilEnumSerializer =
    _$AdminRejectDtoItemsInnerUntilEnumSerializer();

class _$AdminRejectDtoItemsInnerUntilEnumSerializer
    implements PrimitiveSerializer<AdminRejectDtoItemsInnerUntilEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'tomorrow': 'tomorrow',
    'turnedBackOn': 'turned_back_on',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'tomorrow': 'tomorrow',
    'turned_back_on': 'turnedBackOn',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminRejectDtoItemsInnerUntilEnum];
  @override
  final String wireName = 'AdminRejectDtoItemsInnerUntilEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminRejectDtoItemsInnerUntilEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminRejectDtoItemsInnerUntilEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminRejectDtoItemsInnerUntilEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminRejectDtoItemsInner extends AdminRejectDtoItemsInner {
  @override
  final String itemId;
  @override
  final AdminRejectDtoItemsInnerUntilEnum until;

  factory _$AdminRejectDtoItemsInner([
    void Function(AdminRejectDtoItemsInnerBuilder)? updates,
  ]) => (AdminRejectDtoItemsInnerBuilder()..update(updates))._build();

  _$AdminRejectDtoItemsInner._({required this.itemId, required this.until})
    : super._();
  @override
  AdminRejectDtoItemsInner rebuild(
    void Function(AdminRejectDtoItemsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRejectDtoItemsInnerBuilder toBuilder() =>
      AdminRejectDtoItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRejectDtoItemsInner &&
        itemId == other.itemId &&
        until == other.until;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, itemId.hashCode);
    _$hash = $jc(_$hash, until.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRejectDtoItemsInner')
          ..add('itemId', itemId)
          ..add('until', until))
        .toString();
  }
}

class AdminRejectDtoItemsInnerBuilder
    implements
        Builder<AdminRejectDtoItemsInner, AdminRejectDtoItemsInnerBuilder> {
  _$AdminRejectDtoItemsInner? _$v;

  String? _itemId;
  String? get itemId => _$this._itemId;
  set itemId(String? itemId) => _$this._itemId = itemId;

  AdminRejectDtoItemsInnerUntilEnum? _until;
  AdminRejectDtoItemsInnerUntilEnum? get until => _$this._until;
  set until(AdminRejectDtoItemsInnerUntilEnum? until) => _$this._until = until;

  AdminRejectDtoItemsInnerBuilder() {
    AdminRejectDtoItemsInner._defaults(this);
  }

  AdminRejectDtoItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _itemId = $v.itemId;
      _until = $v.until;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRejectDtoItemsInner other) {
    _$v = other as _$AdminRejectDtoItemsInner;
  }

  @override
  void update(void Function(AdminRejectDtoItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRejectDtoItemsInner build() => _build();

  _$AdminRejectDtoItemsInner _build() {
    final _$result =
        _$v ??
        _$AdminRejectDtoItemsInner._(
          itemId: BuiltValueNullFieldError.checkNotNull(
            itemId,
            r'AdminRejectDtoItemsInner',
            'itemId',
          ),
          until: BuiltValueNullFieldError.checkNotNull(
            until,
            r'AdminRejectDtoItemsInner',
            'until',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
