// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_orders_dto_output_orders_inner_edits_inner_changes_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum
_$merchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum_added =
    const MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum._(
      'added',
    );
const MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum
_$merchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum_removed =
    const MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum._(
      'removed',
    );
const MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum
_$merchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum_quantity =
    const MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum._(
      'quantity',
    );

MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum
_$merchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnumValueOf(
  String name,
) {
  switch (name) {
    case 'added':
      return _$merchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum_added;
    case 'removed':
      return _$merchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum_removed;
    case 'quantity':
      return _$merchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum_quantity;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum>
_$merchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnumValues =
    BuiltSet<
      MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum
    >(const <MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum>[
      _$merchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum_added,
      _$merchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum_removed,
      _$merchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum_quantity,
    ]);

Serializer<MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum>
_$merchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnumSerializer =
    _$MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnumSerializer();

class _$MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnumSerializer
    implements
        PrimitiveSerializer<
          MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'added': 'added',
    'removed': 'removed',
    'quantity': 'quantity',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'added': 'added',
    'removed': 'removed',
    'quantity': 'quantity',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum,
  ];
  @override
  final String wireName =
      'MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum.valueOf(
        _fromWire[serialized] ?? (serialized is String ? serialized : ''),
      );
}

class _$MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner
    extends MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner {
  @override
  final MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum kind;
  @override
  final String name;
  @override
  final BuiltList<String> options;
  @override
  final int quantity;
  @override
  final int? quantityBefore;

  factory _$MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner([
    void Function(
      MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerBuilder,
    )?
    updates,
  ]) =>
      (MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerBuilder()
            ..update(updates))
          ._build();

  _$MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner._({
    required this.kind,
    required this.name,
    required this.options,
    required this.quantity,
    this.quantityBefore,
  }) : super._();
  @override
  MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner rebuild(
    void Function(
      MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerBuilder toBuilder() =>
      MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner &&
        kind == other.kind &&
        name == other.name &&
        options == other.options &&
        quantity == other.quantity &&
        quantityBefore == other.quantityBefore;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, options.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, quantityBefore.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner',
          )
          ..add('kind', kind)
          ..add('name', name)
          ..add('options', options)
          ..add('quantity', quantity)
          ..add('quantityBefore', quantityBefore))
        .toString();
  }
}

class MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerBuilder
    implements
        Builder<
          MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner,
          MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerBuilder
        > {
  _$MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner? _$v;

  MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum? _kind;
  MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum? get kind =>
      _$this._kind;
  set kind(
    MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerKindEnum? kind,
  ) => _$this._kind = kind;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ListBuilder<String>? _options;
  ListBuilder<String> get options => _$this._options ??= ListBuilder<String>();
  set options(ListBuilder<String>? options) => _$this._options = options;

  int? _quantity;
  int? get quantity => _$this._quantity;
  set quantity(int? quantity) => _$this._quantity = quantity;

  int? _quantityBefore;
  int? get quantityBefore => _$this._quantityBefore;
  set quantityBefore(int? quantityBefore) =>
      _$this._quantityBefore = quantityBefore;

  MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerBuilder() {
    MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner._defaults(this);
  }

  MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _name = $v.name;
      _options = $v.options.toBuilder();
      _quantity = $v.quantity;
      _quantityBefore = $v.quantityBefore;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner other) {
    _$v = other as _$MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner;
  }

  @override
  void update(
    void Function(
      MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner build() => _build();

  _$MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner _build() {
    _$MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner _$result;
    try {
      _$result =
          _$v ??
          _$MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner._(
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner',
              'kind',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner',
              'name',
            ),
            options: options.build(),
            quantity: BuiltValueNullFieldError.checkNotNull(
              quantity,
              r'MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner',
              'quantity',
            ),
            quantityBefore: quantityBefore,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'options';
        options.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner',
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
