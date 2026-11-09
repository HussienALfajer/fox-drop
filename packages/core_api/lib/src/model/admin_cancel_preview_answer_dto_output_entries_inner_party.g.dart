// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_cancel_preview_answer_dto_output_entries_inner_party.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum
_$adminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum_merchant =
    const AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum._(
      'merchant',
    );
const AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum
_$adminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum_captain =
    const AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum._(
      'captain',
    );
const AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum
_$adminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum_platform =
    const AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum._(
      'platform',
    );

AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum
_$adminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnumValueOf(
  String name,
) {
  switch (name) {
    case 'merchant':
      return _$adminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum_merchant;
    case 'captain':
      return _$adminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum_captain;
    case 'platform':
      return _$adminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum_platform;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum>
_$adminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnumValues =
    BuiltSet<AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum>(
      const <AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum>[
        _$adminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum_merchant,
        _$adminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum_captain,
        _$adminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum_platform,
      ],
    );

Serializer<AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum>
_$adminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnumSerializer =
    _$AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnumSerializer();

class _$AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnumSerializer
    implements
        PrimitiveSerializer<
          AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum
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
    AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum,
  ];
  @override
  final String wireName =
      'AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCancelPreviewAnswerDtoOutputEntriesInnerParty
    extends AdminCancelPreviewAnswerDtoOutputEntriesInnerParty {
  @override
  final AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum kind;
  @override
  final String? id;
  @override
  final String? name;

  factory _$AdminCancelPreviewAnswerDtoOutputEntriesInnerParty([
    void Function(AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyBuilder)?
    updates,
  ]) =>
      (AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyBuilder()
            ..update(updates))
          ._build();

  _$AdminCancelPreviewAnswerDtoOutputEntriesInnerParty._({
    required this.kind,
    this.id,
    this.name,
  }) : super._();
  @override
  AdminCancelPreviewAnswerDtoOutputEntriesInnerParty rebuild(
    void Function(AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyBuilder toBuilder() =>
      AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCancelPreviewAnswerDtoOutputEntriesInnerParty &&
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
            r'AdminCancelPreviewAnswerDtoOutputEntriesInnerParty',
          )
          ..add('kind', kind)
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyBuilder
    implements
        Builder<
          AdminCancelPreviewAnswerDtoOutputEntriesInnerParty,
          AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyBuilder
        > {
  _$AdminCancelPreviewAnswerDtoOutputEntriesInnerParty? _$v;

  AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum? _kind;
  AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum? get kind =>
      _$this._kind;
  set kind(AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyKindEnum? kind) =>
      _$this._kind = kind;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyBuilder() {
    AdminCancelPreviewAnswerDtoOutputEntriesInnerParty._defaults(this);
  }

  AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyBuilder get _$this {
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
  void replace(AdminCancelPreviewAnswerDtoOutputEntriesInnerParty other) {
    _$v = other as _$AdminCancelPreviewAnswerDtoOutputEntriesInnerParty;
  }

  @override
  void update(
    void Function(AdminCancelPreviewAnswerDtoOutputEntriesInnerPartyBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCancelPreviewAnswerDtoOutputEntriesInnerParty build() => _build();

  _$AdminCancelPreviewAnswerDtoOutputEntriesInnerParty _build() {
    final _$result =
        _$v ??
        _$AdminCancelPreviewAnswerDtoOutputEntriesInnerParty._(
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'AdminCancelPreviewAnswerDtoOutputEntriesInnerParty',
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
