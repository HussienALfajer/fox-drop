// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_dto_output_blocks_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCustomerDtoOutputBlocksInnerKindEnum
_$adminCustomerDtoOutputBlocksInnerKindEnum_until =
    const AdminCustomerDtoOutputBlocksInnerKindEnum._('until');
const AdminCustomerDtoOutputBlocksInnerKindEnum
_$adminCustomerDtoOutputBlocksInnerKindEnum_indefinite =
    const AdminCustomerDtoOutputBlocksInnerKindEnum._('indefinite');
const AdminCustomerDtoOutputBlocksInnerKindEnum
_$adminCustomerDtoOutputBlocksInnerKindEnum_dues =
    const AdminCustomerDtoOutputBlocksInnerKindEnum._('dues');

AdminCustomerDtoOutputBlocksInnerKindEnum
_$adminCustomerDtoOutputBlocksInnerKindEnumValueOf(String name) {
  switch (name) {
    case 'until':
      return _$adminCustomerDtoOutputBlocksInnerKindEnum_until;
    case 'indefinite':
      return _$adminCustomerDtoOutputBlocksInnerKindEnum_indefinite;
    case 'dues':
      return _$adminCustomerDtoOutputBlocksInnerKindEnum_dues;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCustomerDtoOutputBlocksInnerKindEnum>
_$adminCustomerDtoOutputBlocksInnerKindEnumValues =
    BuiltSet<AdminCustomerDtoOutputBlocksInnerKindEnum>(
      const <AdminCustomerDtoOutputBlocksInnerKindEnum>[
        _$adminCustomerDtoOutputBlocksInnerKindEnum_until,
        _$adminCustomerDtoOutputBlocksInnerKindEnum_indefinite,
        _$adminCustomerDtoOutputBlocksInnerKindEnum_dues,
      ],
    );

Serializer<AdminCustomerDtoOutputBlocksInnerKindEnum>
_$adminCustomerDtoOutputBlocksInnerKindEnumSerializer =
    _$AdminCustomerDtoOutputBlocksInnerKindEnumSerializer();

class _$AdminCustomerDtoOutputBlocksInnerKindEnumSerializer
    implements PrimitiveSerializer<AdminCustomerDtoOutputBlocksInnerKindEnum> {
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
    AdminCustomerDtoOutputBlocksInnerKindEnum,
  ];
  @override
  final String wireName = 'AdminCustomerDtoOutputBlocksInnerKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerDtoOutputBlocksInnerKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCustomerDtoOutputBlocksInnerKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCustomerDtoOutputBlocksInnerKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCustomerDtoOutputBlocksInner
    extends AdminCustomerDtoOutputBlocksInner {
  @override
  final String id;
  @override
  final AdminCustomerDtoOutputBlocksInnerKindEnum kind;
  @override
  final String reason;
  @override
  final String reasonLabel;
  @override
  final String note;
  @override
  final DateTime? until;
  @override
  final String? duesAmount;
  @override
  final String? duesCurrency;
  @override
  final DateTime startedAt;
  @override
  final String? startedByName;
  @override
  final DateTime? endedAt;
  @override
  final String? endedByName;
  @override
  final String? endNote;
  @override
  final bool inForce;

  factory _$AdminCustomerDtoOutputBlocksInner([
    void Function(AdminCustomerDtoOutputBlocksInnerBuilder)? updates,
  ]) => (AdminCustomerDtoOutputBlocksInnerBuilder()..update(updates))._build();

  _$AdminCustomerDtoOutputBlocksInner._({
    required this.id,
    required this.kind,
    required this.reason,
    required this.reasonLabel,
    required this.note,
    this.until,
    this.duesAmount,
    this.duesCurrency,
    required this.startedAt,
    this.startedByName,
    this.endedAt,
    this.endedByName,
    this.endNote,
    required this.inForce,
  }) : super._();
  @override
  AdminCustomerDtoOutputBlocksInner rebuild(
    void Function(AdminCustomerDtoOutputBlocksInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerDtoOutputBlocksInnerBuilder toBuilder() =>
      AdminCustomerDtoOutputBlocksInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerDtoOutputBlocksInner &&
        id == other.id &&
        kind == other.kind &&
        reason == other.reason &&
        reasonLabel == other.reasonLabel &&
        note == other.note &&
        until == other.until &&
        duesAmount == other.duesAmount &&
        duesCurrency == other.duesCurrency &&
        startedAt == other.startedAt &&
        startedByName == other.startedByName &&
        endedAt == other.endedAt &&
        endedByName == other.endedByName &&
        endNote == other.endNote &&
        inForce == other.inForce;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, reasonLabel.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, until.hashCode);
    _$hash = $jc(_$hash, duesAmount.hashCode);
    _$hash = $jc(_$hash, duesCurrency.hashCode);
    _$hash = $jc(_$hash, startedAt.hashCode);
    _$hash = $jc(_$hash, startedByName.hashCode);
    _$hash = $jc(_$hash, endedAt.hashCode);
    _$hash = $jc(_$hash, endedByName.hashCode);
    _$hash = $jc(_$hash, endNote.hashCode);
    _$hash = $jc(_$hash, inForce.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCustomerDtoOutputBlocksInner')
          ..add('id', id)
          ..add('kind', kind)
          ..add('reason', reason)
          ..add('reasonLabel', reasonLabel)
          ..add('note', note)
          ..add('until', until)
          ..add('duesAmount', duesAmount)
          ..add('duesCurrency', duesCurrency)
          ..add('startedAt', startedAt)
          ..add('startedByName', startedByName)
          ..add('endedAt', endedAt)
          ..add('endedByName', endedByName)
          ..add('endNote', endNote)
          ..add('inForce', inForce))
        .toString();
  }
}

class AdminCustomerDtoOutputBlocksInnerBuilder
    implements
        Builder<
          AdminCustomerDtoOutputBlocksInner,
          AdminCustomerDtoOutputBlocksInnerBuilder
        > {
  _$AdminCustomerDtoOutputBlocksInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  AdminCustomerDtoOutputBlocksInnerKindEnum? _kind;
  AdminCustomerDtoOutputBlocksInnerKindEnum? get kind => _$this._kind;
  set kind(AdminCustomerDtoOutputBlocksInnerKindEnum? kind) =>
      _$this._kind = kind;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _reasonLabel;
  String? get reasonLabel => _$this._reasonLabel;
  set reasonLabel(String? reasonLabel) => _$this._reasonLabel = reasonLabel;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  DateTime? _until;
  DateTime? get until => _$this._until;
  set until(DateTime? until) => _$this._until = until;

  String? _duesAmount;
  String? get duesAmount => _$this._duesAmount;
  set duesAmount(String? duesAmount) => _$this._duesAmount = duesAmount;

  String? _duesCurrency;
  String? get duesCurrency => _$this._duesCurrency;
  set duesCurrency(String? duesCurrency) => _$this._duesCurrency = duesCurrency;

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(DateTime? startedAt) => _$this._startedAt = startedAt;

  String? _startedByName;
  String? get startedByName => _$this._startedByName;
  set startedByName(String? startedByName) =>
      _$this._startedByName = startedByName;

  DateTime? _endedAt;
  DateTime? get endedAt => _$this._endedAt;
  set endedAt(DateTime? endedAt) => _$this._endedAt = endedAt;

  String? _endedByName;
  String? get endedByName => _$this._endedByName;
  set endedByName(String? endedByName) => _$this._endedByName = endedByName;

  String? _endNote;
  String? get endNote => _$this._endNote;
  set endNote(String? endNote) => _$this._endNote = endNote;

  bool? _inForce;
  bool? get inForce => _$this._inForce;
  set inForce(bool? inForce) => _$this._inForce = inForce;

  AdminCustomerDtoOutputBlocksInnerBuilder() {
    AdminCustomerDtoOutputBlocksInner._defaults(this);
  }

  AdminCustomerDtoOutputBlocksInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _kind = $v.kind;
      _reason = $v.reason;
      _reasonLabel = $v.reasonLabel;
      _note = $v.note;
      _until = $v.until;
      _duesAmount = $v.duesAmount;
      _duesCurrency = $v.duesCurrency;
      _startedAt = $v.startedAt;
      _startedByName = $v.startedByName;
      _endedAt = $v.endedAt;
      _endedByName = $v.endedByName;
      _endNote = $v.endNote;
      _inForce = $v.inForce;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerDtoOutputBlocksInner other) {
    _$v = other as _$AdminCustomerDtoOutputBlocksInner;
  }

  @override
  void update(
    void Function(AdminCustomerDtoOutputBlocksInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerDtoOutputBlocksInner build() => _build();

  _$AdminCustomerDtoOutputBlocksInner _build() {
    final _$result =
        _$v ??
        _$AdminCustomerDtoOutputBlocksInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminCustomerDtoOutputBlocksInner',
            'id',
          ),
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'AdminCustomerDtoOutputBlocksInner',
            'kind',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminCustomerDtoOutputBlocksInner',
            'reason',
          ),
          reasonLabel: BuiltValueNullFieldError.checkNotNull(
            reasonLabel,
            r'AdminCustomerDtoOutputBlocksInner',
            'reasonLabel',
          ),
          note: BuiltValueNullFieldError.checkNotNull(
            note,
            r'AdminCustomerDtoOutputBlocksInner',
            'note',
          ),
          until: until,
          duesAmount: duesAmount,
          duesCurrency: duesCurrency,
          startedAt: BuiltValueNullFieldError.checkNotNull(
            startedAt,
            r'AdminCustomerDtoOutputBlocksInner',
            'startedAt',
          ),
          startedByName: startedByName,
          endedAt: endedAt,
          endedByName: endedByName,
          endNote: endNote,
          inForce: BuiltValueNullFieldError.checkNotNull(
            inForce,
            r'AdminCustomerDtoOutputBlocksInner',
            'inForce',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
