// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_item_report_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum
_$adminOrderDtoOutputOrderItemReportItemsInnerUntilEnum_tomorrow =
    const AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum._('tomorrow');
const AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum
_$adminOrderDtoOutputOrderItemReportItemsInnerUntilEnum_turnedBackOn =
    const AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum._(
      'turnedBackOn',
    );

AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum
_$adminOrderDtoOutputOrderItemReportItemsInnerUntilEnumValueOf(String name) {
  switch (name) {
    case 'tomorrow':
      return _$adminOrderDtoOutputOrderItemReportItemsInnerUntilEnum_tomorrow;
    case 'turnedBackOn':
      return _$adminOrderDtoOutputOrderItemReportItemsInnerUntilEnum_turnedBackOn;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum>
_$adminOrderDtoOutputOrderItemReportItemsInnerUntilEnumValues =
    BuiltSet<AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum>(
      const <AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum>[
        _$adminOrderDtoOutputOrderItemReportItemsInnerUntilEnum_tomorrow,
        _$adminOrderDtoOutputOrderItemReportItemsInnerUntilEnum_turnedBackOn,
      ],
    );

Serializer<AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum>
_$adminOrderDtoOutputOrderItemReportItemsInnerUntilEnumSerializer =
    _$AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnumSerializer();

class _$AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnumSerializer
    implements
        PrimitiveSerializer<
          AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'tomorrow': 'tomorrow',
    'turnedBackOn': 'turned_back_on',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'tomorrow': 'tomorrow',
    'turned_back_on': 'turnedBackOn',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum,
  ];
  @override
  final String wireName =
      'AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderDtoOutputOrderItemReportItemsInner
    extends AdminOrderDtoOutputOrderItemReportItemsInner {
  @override
  final String itemId;
  @override
  final String name;
  @override
  final AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum until;

  factory _$AdminOrderDtoOutputOrderItemReportItemsInner([
    void Function(AdminOrderDtoOutputOrderItemReportItemsInnerBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderItemReportItemsInnerBuilder()..update(updates))
      ._build();

  _$AdminOrderDtoOutputOrderItemReportItemsInner._({
    required this.itemId,
    required this.name,
    required this.until,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderItemReportItemsInner rebuild(
    void Function(AdminOrderDtoOutputOrderItemReportItemsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderItemReportItemsInnerBuilder toBuilder() =>
      AdminOrderDtoOutputOrderItemReportItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderItemReportItemsInner &&
        itemId == other.itemId &&
        name == other.name &&
        until == other.until;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, itemId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, until.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderItemReportItemsInner',
          )
          ..add('itemId', itemId)
          ..add('name', name)
          ..add('until', until))
        .toString();
  }
}

class AdminOrderDtoOutputOrderItemReportItemsInnerBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderItemReportItemsInner,
          AdminOrderDtoOutputOrderItemReportItemsInnerBuilder
        > {
  _$AdminOrderDtoOutputOrderItemReportItemsInner? _$v;

  String? _itemId;
  String? get itemId => _$this._itemId;
  set itemId(String? itemId) => _$this._itemId = itemId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum? _until;
  AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum? get until =>
      _$this._until;
  set until(AdminOrderDtoOutputOrderItemReportItemsInnerUntilEnum? until) =>
      _$this._until = until;

  AdminOrderDtoOutputOrderItemReportItemsInnerBuilder() {
    AdminOrderDtoOutputOrderItemReportItemsInner._defaults(this);
  }

  AdminOrderDtoOutputOrderItemReportItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _itemId = $v.itemId;
      _name = $v.name;
      _until = $v.until;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderItemReportItemsInner other) {
    _$v = other as _$AdminOrderDtoOutputOrderItemReportItemsInner;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderItemReportItemsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderItemReportItemsInner build() => _build();

  _$AdminOrderDtoOutputOrderItemReportItemsInner _build() {
    final _$result =
        _$v ??
        _$AdminOrderDtoOutputOrderItemReportItemsInner._(
          itemId: BuiltValueNullFieldError.checkNotNull(
            itemId,
            r'AdminOrderDtoOutputOrderItemReportItemsInner',
            'itemId',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminOrderDtoOutputOrderItemReportItemsInner',
            'name',
          ),
          until: BuiltValueNullFieldError.checkNotNull(
            until,
            r'AdminOrderDtoOutputOrderItemReportItemsInner',
            'until',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
