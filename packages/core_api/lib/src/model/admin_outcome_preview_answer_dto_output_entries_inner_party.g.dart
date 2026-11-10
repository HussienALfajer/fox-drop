// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_outcome_preview_answer_dto_output_entries_inner_party.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum
_$adminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum_merchant =
    const AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum._(
      'merchant',
    );
const AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum
_$adminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum_captain =
    const AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum._(
      'captain',
    );
const AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum
_$adminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum_customer =
    const AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum._(
      'customer',
    );
const AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum
_$adminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum_platform =
    const AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum._(
      'platform',
    );

AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum
_$adminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnumValueOf(
  String name,
) {
  switch (name) {
    case 'merchant':
      return _$adminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum_merchant;
    case 'captain':
      return _$adminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum_captain;
    case 'customer':
      return _$adminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum_customer;
    case 'platform':
      return _$adminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum_platform;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum>
_$adminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnumValues =
    BuiltSet<AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum>(
      const <AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum>[
        _$adminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum_merchant,
        _$adminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum_captain,
        _$adminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum_customer,
        _$adminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum_platform,
      ],
    );

Serializer<AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum>
_$adminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnumSerializer =
    _$AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnumSerializer();

class _$AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnumSerializer
    implements
        PrimitiveSerializer<
          AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'merchant': 'merchant',
    'captain': 'captain',
    'customer': 'customer',
    'platform': 'platform',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'merchant': 'merchant',
    'captain': 'captain',
    'customer': 'customer',
    'platform': 'platform',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum,
  ];
  @override
  final String wireName =
      'AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty
    extends AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty {
  @override
  final AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum kind;
  @override
  final String? id;
  @override
  final String? name;

  factory _$AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty([
    void Function(AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyBuilder)?
    updates,
  ]) =>
      (AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyBuilder()
            ..update(updates))
          ._build();

  _$AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty._({
    required this.kind,
    this.id,
    this.name,
  }) : super._();
  @override
  AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty rebuild(
    void Function(AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyBuilder toBuilder() =>
      AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty &&
        kind == other.kind &&
        id == other.id &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty',
          )
          ..add('kind', kind)
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyBuilder
    implements
        Builder<
          AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty,
          AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyBuilder
        > {
  _$AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty? _$v;

  AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum? _kind;
  AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum? get kind =>
      _$this._kind;
  set kind(AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyKindEnum? kind) =>
      _$this._kind = kind;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyBuilder() {
    AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty._defaults(this);
  }

  AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty other) {
    _$v = other as _$AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty;
  }

  @override
  void update(
    void Function(AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty build() => _build();

  _$AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty _build() {
    final _$result =
        _$v ??
        _$AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty._(
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty',
            'kind',
          ),
          id: id,
          name: name,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
