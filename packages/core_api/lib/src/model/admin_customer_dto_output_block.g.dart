// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_dto_output_block.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCustomerDtoOutputBlockKindEnum
_$adminCustomerDtoOutputBlockKindEnum_until =
    const AdminCustomerDtoOutputBlockKindEnum._('until');
const AdminCustomerDtoOutputBlockKindEnum
_$adminCustomerDtoOutputBlockKindEnum_indefinite =
    const AdminCustomerDtoOutputBlockKindEnum._('indefinite');
const AdminCustomerDtoOutputBlockKindEnum
_$adminCustomerDtoOutputBlockKindEnum_dues =
    const AdminCustomerDtoOutputBlockKindEnum._('dues');

AdminCustomerDtoOutputBlockKindEnum
_$adminCustomerDtoOutputBlockKindEnumValueOf(String name) {
  switch (name) {
    case 'until':
      return _$adminCustomerDtoOutputBlockKindEnum_until;
    case 'indefinite':
      return _$adminCustomerDtoOutputBlockKindEnum_indefinite;
    case 'dues':
      return _$adminCustomerDtoOutputBlockKindEnum_dues;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCustomerDtoOutputBlockKindEnum>
_$adminCustomerDtoOutputBlockKindEnumValues =
    BuiltSet<AdminCustomerDtoOutputBlockKindEnum>(
      const <AdminCustomerDtoOutputBlockKindEnum>[
        _$adminCustomerDtoOutputBlockKindEnum_until,
        _$adminCustomerDtoOutputBlockKindEnum_indefinite,
        _$adminCustomerDtoOutputBlockKindEnum_dues,
      ],
    );

Serializer<AdminCustomerDtoOutputBlockKindEnum>
_$adminCustomerDtoOutputBlockKindEnumSerializer =
    _$AdminCustomerDtoOutputBlockKindEnumSerializer();

class _$AdminCustomerDtoOutputBlockKindEnumSerializer
    implements PrimitiveSerializer<AdminCustomerDtoOutputBlockKindEnum> {
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
  final Iterable<Type> types = const <Type>[
    AdminCustomerDtoOutputBlockKindEnum,
  ];
  @override
  final String wireName = 'AdminCustomerDtoOutputBlockKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerDtoOutputBlockKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCustomerDtoOutputBlockKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCustomerDtoOutputBlockKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCustomerDtoOutputBlock extends AdminCustomerDtoOutputBlock {
  @override
  final String id;
  @override
  final AdminCustomerDtoOutputBlockKindEnum kind;
  @override
  final DateTime? until;
  @override
  final String reason;
  @override
  final String reasonLabel;
  @override
  final String customerText;
  @override
  final String note;
  @override
  final DateTime startedAt;

  factory _$AdminCustomerDtoOutputBlock([
    void Function(AdminCustomerDtoOutputBlockBuilder)? updates,
  ]) => (AdminCustomerDtoOutputBlockBuilder()..update(updates))._build();

  _$AdminCustomerDtoOutputBlock._({
    required this.id,
    required this.kind,
    this.until,
    required this.reason,
    required this.reasonLabel,
    required this.customerText,
    required this.note,
    required this.startedAt,
  }) : super._();
  @override
  AdminCustomerDtoOutputBlock rebuild(
    void Function(AdminCustomerDtoOutputBlockBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerDtoOutputBlockBuilder toBuilder() =>
      AdminCustomerDtoOutputBlockBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerDtoOutputBlock &&
        id == other.id &&
        kind == other.kind &&
        until == other.until &&
        reason == other.reason &&
        reasonLabel == other.reasonLabel &&
        customerText == other.customerText &&
        note == other.note &&
        startedAt == other.startedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, until.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, reasonLabel.hashCode);
    _$hash = $jc(_$hash, customerText.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, startedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCustomerDtoOutputBlock')
          ..add('id', id)
          ..add('kind', kind)
          ..add('until', until)
          ..add('reason', reason)
          ..add('reasonLabel', reasonLabel)
          ..add('customerText', customerText)
          ..add('note', note)
          ..add('startedAt', startedAt))
        .toString();
  }
}

class AdminCustomerDtoOutputBlockBuilder
    implements
        Builder<
          AdminCustomerDtoOutputBlock,
          AdminCustomerDtoOutputBlockBuilder
        > {
  _$AdminCustomerDtoOutputBlock? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  AdminCustomerDtoOutputBlockKindEnum? _kind;
  AdminCustomerDtoOutputBlockKindEnum? get kind => _$this._kind;
  set kind(AdminCustomerDtoOutputBlockKindEnum? kind) => _$this._kind = kind;

  DateTime? _until;
  DateTime? get until => _$this._until;
  set until(DateTime? until) => _$this._until = until;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _reasonLabel;
  String? get reasonLabel => _$this._reasonLabel;
  set reasonLabel(String? reasonLabel) => _$this._reasonLabel = reasonLabel;

  String? _customerText;
  String? get customerText => _$this._customerText;
  set customerText(String? customerText) => _$this._customerText = customerText;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(DateTime? startedAt) => _$this._startedAt = startedAt;

  AdminCustomerDtoOutputBlockBuilder() {
    AdminCustomerDtoOutputBlock._defaults(this);
  }

  AdminCustomerDtoOutputBlockBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _kind = $v.kind;
      _until = $v.until;
      _reason = $v.reason;
      _reasonLabel = $v.reasonLabel;
      _customerText = $v.customerText;
      _note = $v.note;
      _startedAt = $v.startedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerDtoOutputBlock other) {
    _$v = other as _$AdminCustomerDtoOutputBlock;
  }

  @override
  void update(void Function(AdminCustomerDtoOutputBlockBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerDtoOutputBlock build() => _build();

  _$AdminCustomerDtoOutputBlock _build() {
    final _$result =
        _$v ??
        _$AdminCustomerDtoOutputBlock._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminCustomerDtoOutputBlock',
            'id',
          ),
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'AdminCustomerDtoOutputBlock',
            'kind',
          ),
          until: until,
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminCustomerDtoOutputBlock',
            'reason',
          ),
          reasonLabel: BuiltValueNullFieldError.checkNotNull(
            reasonLabel,
            r'AdminCustomerDtoOutputBlock',
            'reasonLabel',
          ),
          customerText: BuiltValueNullFieldError.checkNotNull(
            customerText,
            r'AdminCustomerDtoOutputBlock',
            'customerText',
          ),
          note: BuiltValueNullFieldError.checkNotNull(
            note,
            r'AdminCustomerDtoOutputBlock',
            'note',
          ),
          startedAt: BuiltValueNullFieldError.checkNotNull(
            startedAt,
            r'AdminCustomerDtoOutputBlock',
            'startedAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
