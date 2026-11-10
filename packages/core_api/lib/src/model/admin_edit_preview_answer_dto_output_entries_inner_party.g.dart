// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_edit_preview_answer_dto_output_entries_inner_party.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum
_$adminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum_merchant =
    const AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum._(
      'merchant',
    );
const AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum
_$adminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum_captain =
    const AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum._('captain');
const AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum
_$adminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum_platform =
    const AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum._(
      'platform',
    );

AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum
_$adminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnumValueOf(String name) {
  switch (name) {
    case 'merchant':
      return _$adminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum_merchant;
    case 'captain':
      return _$adminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum_captain;
    case 'platform':
      return _$adminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum_platform;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum>
_$adminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnumValues =
    BuiltSet<AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum>(
      const <AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum>[
        _$adminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum_merchant,
        _$adminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum_captain,
        _$adminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum_platform,
      ],
    );

Serializer<AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum>
_$adminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnumSerializer =
    _$AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnumSerializer();

class _$AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnumSerializer
    implements
        PrimitiveSerializer<
          AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'merchant': 'merchant',
    'captain': 'captain',
    'platform': 'platform',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'merchant': 'merchant',
    'captain': 'captain',
    'platform': 'platform',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum,
  ];
  @override
  final String wireName =
      'AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminEditPreviewAnswerDtoOutputEntriesInnerParty
    extends AdminEditPreviewAnswerDtoOutputEntriesInnerParty {
  @override
  final AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum kind;
  @override
  final String? id;
  @override
  final String? name;

  factory _$AdminEditPreviewAnswerDtoOutputEntriesInnerParty([
    void Function(AdminEditPreviewAnswerDtoOutputEntriesInnerPartyBuilder)?
    updates,
  ]) =>
      (AdminEditPreviewAnswerDtoOutputEntriesInnerPartyBuilder()
            ..update(updates))
          ._build();

  _$AdminEditPreviewAnswerDtoOutputEntriesInnerParty._({
    required this.kind,
    this.id,
    this.name,
  }) : super._();
  @override
  AdminEditPreviewAnswerDtoOutputEntriesInnerParty rebuild(
    void Function(AdminEditPreviewAnswerDtoOutputEntriesInnerPartyBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminEditPreviewAnswerDtoOutputEntriesInnerPartyBuilder toBuilder() =>
      AdminEditPreviewAnswerDtoOutputEntriesInnerPartyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminEditPreviewAnswerDtoOutputEntriesInnerParty &&
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
            r'AdminEditPreviewAnswerDtoOutputEntriesInnerParty',
          )
          ..add('kind', kind)
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class AdminEditPreviewAnswerDtoOutputEntriesInnerPartyBuilder
    implements
        Builder<
          AdminEditPreviewAnswerDtoOutputEntriesInnerParty,
          AdminEditPreviewAnswerDtoOutputEntriesInnerPartyBuilder
        > {
  _$AdminEditPreviewAnswerDtoOutputEntriesInnerParty? _$v;

  AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum? _kind;
  AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum? get kind =>
      _$this._kind;
  set kind(AdminEditPreviewAnswerDtoOutputEntriesInnerPartyKindEnum? kind) =>
      _$this._kind = kind;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminEditPreviewAnswerDtoOutputEntriesInnerPartyBuilder() {
    AdminEditPreviewAnswerDtoOutputEntriesInnerParty._defaults(this);
  }

  AdminEditPreviewAnswerDtoOutputEntriesInnerPartyBuilder get _$this {
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
  void replace(AdminEditPreviewAnswerDtoOutputEntriesInnerParty other) {
    _$v = other as _$AdminEditPreviewAnswerDtoOutputEntriesInnerParty;
  }

  @override
  void update(
    void Function(AdminEditPreviewAnswerDtoOutputEntriesInnerPartyBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminEditPreviewAnswerDtoOutputEntriesInnerParty build() => _build();

  _$AdminEditPreviewAnswerDtoOutputEntriesInnerParty _build() {
    final _$result =
        _$v ??
        _$AdminEditPreviewAnswerDtoOutputEntriesInnerParty._(
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'AdminEditPreviewAnswerDtoOutputEntriesInnerParty',
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
