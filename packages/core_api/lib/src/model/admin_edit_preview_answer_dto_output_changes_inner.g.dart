// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_edit_preview_answer_dto_output_changes_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum
_$adminEditPreviewAnswerDtoOutputChangesInnerKindEnum_added =
    const AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum._('added');
const AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum
_$adminEditPreviewAnswerDtoOutputChangesInnerKindEnum_removed =
    const AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum._('removed');
const AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum
_$adminEditPreviewAnswerDtoOutputChangesInnerKindEnum_quantity =
    const AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum._('quantity');

AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum
_$adminEditPreviewAnswerDtoOutputChangesInnerKindEnumValueOf(String name) {
  switch (name) {
    case 'added':
      return _$adminEditPreviewAnswerDtoOutputChangesInnerKindEnum_added;
    case 'removed':
      return _$adminEditPreviewAnswerDtoOutputChangesInnerKindEnum_removed;
    case 'quantity':
      return _$adminEditPreviewAnswerDtoOutputChangesInnerKindEnum_quantity;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum>
_$adminEditPreviewAnswerDtoOutputChangesInnerKindEnumValues =
    BuiltSet<AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum>(
      const <AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum>[
        _$adminEditPreviewAnswerDtoOutputChangesInnerKindEnum_added,
        _$adminEditPreviewAnswerDtoOutputChangesInnerKindEnum_removed,
        _$adminEditPreviewAnswerDtoOutputChangesInnerKindEnum_quantity,
      ],
    );

Serializer<AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum>
_$adminEditPreviewAnswerDtoOutputChangesInnerKindEnumSerializer =
    _$AdminEditPreviewAnswerDtoOutputChangesInnerKindEnumSerializer();

class _$AdminEditPreviewAnswerDtoOutputChangesInnerKindEnumSerializer
    implements
        PrimitiveSerializer<
          AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum
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
    AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum,
  ];
  @override
  final String wireName = 'AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminEditPreviewAnswerDtoOutputChangesInner
    extends AdminEditPreviewAnswerDtoOutputChangesInner {
  @override
  final AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum kind;
  @override
  final String name;
  @override
  final BuiltList<String> options;
  @override
  final int quantity;
  @override
  final int? quantityBefore;

  factory _$AdminEditPreviewAnswerDtoOutputChangesInner([
    void Function(AdminEditPreviewAnswerDtoOutputChangesInnerBuilder)? updates,
  ]) => (AdminEditPreviewAnswerDtoOutputChangesInnerBuilder()..update(updates))
      ._build();

  _$AdminEditPreviewAnswerDtoOutputChangesInner._({
    required this.kind,
    required this.name,
    required this.options,
    required this.quantity,
    this.quantityBefore,
  }) : super._();
  @override
  AdminEditPreviewAnswerDtoOutputChangesInner rebuild(
    void Function(AdminEditPreviewAnswerDtoOutputChangesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminEditPreviewAnswerDtoOutputChangesInnerBuilder toBuilder() =>
      AdminEditPreviewAnswerDtoOutputChangesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminEditPreviewAnswerDtoOutputChangesInner &&
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
            r'AdminEditPreviewAnswerDtoOutputChangesInner',
          )
          ..add('kind', kind)
          ..add('name', name)
          ..add('options', options)
          ..add('quantity', quantity)
          ..add('quantityBefore', quantityBefore))
        .toString();
  }
}

class AdminEditPreviewAnswerDtoOutputChangesInnerBuilder
    implements
        Builder<
          AdminEditPreviewAnswerDtoOutputChangesInner,
          AdminEditPreviewAnswerDtoOutputChangesInnerBuilder
        > {
  _$AdminEditPreviewAnswerDtoOutputChangesInner? _$v;

  AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum? _kind;
  AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum? get kind => _$this._kind;
  set kind(AdminEditPreviewAnswerDtoOutputChangesInnerKindEnum? kind) =>
      _$this._kind = kind;

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

  AdminEditPreviewAnswerDtoOutputChangesInnerBuilder() {
    AdminEditPreviewAnswerDtoOutputChangesInner._defaults(this);
  }

  AdminEditPreviewAnswerDtoOutputChangesInnerBuilder get _$this {
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
  void replace(AdminEditPreviewAnswerDtoOutputChangesInner other) {
    _$v = other as _$AdminEditPreviewAnswerDtoOutputChangesInner;
  }

  @override
  void update(
    void Function(AdminEditPreviewAnswerDtoOutputChangesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminEditPreviewAnswerDtoOutputChangesInner build() => _build();

  _$AdminEditPreviewAnswerDtoOutputChangesInner _build() {
    _$AdminEditPreviewAnswerDtoOutputChangesInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminEditPreviewAnswerDtoOutputChangesInner._(
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'AdminEditPreviewAnswerDtoOutputChangesInner',
              'kind',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminEditPreviewAnswerDtoOutputChangesInner',
              'name',
            ),
            options: options.build(),
            quantity: BuiltValueNullFieldError.checkNotNull(
              quantity,
              r'AdminEditPreviewAnswerDtoOutputChangesInner',
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
          r'AdminEditPreviewAnswerDtoOutputChangesInner',
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
