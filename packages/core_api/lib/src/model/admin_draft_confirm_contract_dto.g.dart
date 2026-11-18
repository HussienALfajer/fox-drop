// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_draft_confirm_contract_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminDraftConfirmContractDtoParityPledgeEnum
_$adminDraftConfirmContractDtoParityPledgeEnum_true_ =
    const AdminDraftConfirmContractDtoParityPledgeEnum._('true_');

AdminDraftConfirmContractDtoParityPledgeEnum
_$adminDraftConfirmContractDtoParityPledgeEnumValueOf(String name) {
  switch (name) {
    case 'true_':
      return _$adminDraftConfirmContractDtoParityPledgeEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDraftConfirmContractDtoParityPledgeEnum>
_$adminDraftConfirmContractDtoParityPledgeEnumValues =
    BuiltSet<AdminDraftConfirmContractDtoParityPledgeEnum>(
      const <AdminDraftConfirmContractDtoParityPledgeEnum>[
        _$adminDraftConfirmContractDtoParityPledgeEnum_true_,
      ],
    );

Serializer<AdminDraftConfirmContractDtoParityPledgeEnum>
_$adminDraftConfirmContractDtoParityPledgeEnumSerializer =
    _$AdminDraftConfirmContractDtoParityPledgeEnumSerializer();

class _$AdminDraftConfirmContractDtoParityPledgeEnumSerializer
    implements
        PrimitiveSerializer<AdminDraftConfirmContractDtoParityPledgeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminDraftConfirmContractDtoParityPledgeEnum,
  ];
  @override
  final String wireName = 'AdminDraftConfirmContractDtoParityPledgeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminDraftConfirmContractDtoParityPledgeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminDraftConfirmContractDtoParityPledgeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminDraftConfirmContractDtoParityPledgeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminDraftConfirmContractDto extends AdminDraftConfirmContractDto {
  @override
  final AdminDraftConfirmContractDtoParityPledgeEnum parityPledge;

  factory _$AdminDraftConfirmContractDto([
    void Function(AdminDraftConfirmContractDtoBuilder)? updates,
  ]) => (AdminDraftConfirmContractDtoBuilder()..update(updates))._build();

  _$AdminDraftConfirmContractDto._({required this.parityPledge}) : super._();
  @override
  AdminDraftConfirmContractDto rebuild(
    void Function(AdminDraftConfirmContractDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDraftConfirmContractDtoBuilder toBuilder() =>
      AdminDraftConfirmContractDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDraftConfirmContractDto &&
        parityPledge == other.parityPledge;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, parityPledge.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminDraftConfirmContractDto',
    )..add('parityPledge', parityPledge)).toString();
  }
}

class AdminDraftConfirmContractDtoBuilder
    implements
        Builder<
          AdminDraftConfirmContractDto,
          AdminDraftConfirmContractDtoBuilder
        > {
  _$AdminDraftConfirmContractDto? _$v;

  AdminDraftConfirmContractDtoParityPledgeEnum? _parityPledge;
  AdminDraftConfirmContractDtoParityPledgeEnum? get parityPledge =>
      _$this._parityPledge;
  set parityPledge(
    AdminDraftConfirmContractDtoParityPledgeEnum? parityPledge,
  ) => _$this._parityPledge = parityPledge;

  AdminDraftConfirmContractDtoBuilder() {
    AdminDraftConfirmContractDto._defaults(this);
  }

  AdminDraftConfirmContractDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _parityPledge = $v.parityPledge;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDraftConfirmContractDto other) {
    _$v = other as _$AdminDraftConfirmContractDto;
  }

  @override
  void update(void Function(AdminDraftConfirmContractDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDraftConfirmContractDto build() => _build();

  _$AdminDraftConfirmContractDto _build() {
    final _$result =
        _$v ??
        _$AdminDraftConfirmContractDto._(
          parityPledge: BuiltValueNullFieldError.checkNotNull(
            parityPledge,
            r'AdminDraftConfirmContractDto',
            'parityPledge',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
