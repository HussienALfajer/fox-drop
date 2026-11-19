// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_change_decided_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminChangeDecidedDtoOutputStatusEnum
_$adminChangeDecidedDtoOutputStatusEnum_approved =
    const AdminChangeDecidedDtoOutputStatusEnum._('approved');
const AdminChangeDecidedDtoOutputStatusEnum
_$adminChangeDecidedDtoOutputStatusEnum_rejected =
    const AdminChangeDecidedDtoOutputStatusEnum._('rejected');

AdminChangeDecidedDtoOutputStatusEnum
_$adminChangeDecidedDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'approved':
      return _$adminChangeDecidedDtoOutputStatusEnum_approved;
    case 'rejected':
      return _$adminChangeDecidedDtoOutputStatusEnum_rejected;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminChangeDecidedDtoOutputStatusEnum>
_$adminChangeDecidedDtoOutputStatusEnumValues =
    BuiltSet<AdminChangeDecidedDtoOutputStatusEnum>(
      const <AdminChangeDecidedDtoOutputStatusEnum>[
        _$adminChangeDecidedDtoOutputStatusEnum_approved,
        _$adminChangeDecidedDtoOutputStatusEnum_rejected,
      ],
    );

Serializer<AdminChangeDecidedDtoOutputStatusEnum>
_$adminChangeDecidedDtoOutputStatusEnumSerializer =
    _$AdminChangeDecidedDtoOutputStatusEnumSerializer();

class _$AdminChangeDecidedDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<AdminChangeDecidedDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'approved': 'approved',
    'rejected': 'rejected',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'approved': 'approved',
    'rejected': 'rejected',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminChangeDecidedDtoOutputStatusEnum,
  ];
  @override
  final String wireName = 'AdminChangeDecidedDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminChangeDecidedDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminChangeDecidedDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminChangeDecidedDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminChangeDecidedDtoOutput extends AdminChangeDecidedDtoOutput {
  @override
  final AdminChangeDecidedDtoOutputStatusEnum status;

  factory _$AdminChangeDecidedDtoOutput([
    void Function(AdminChangeDecidedDtoOutputBuilder)? updates,
  ]) => (AdminChangeDecidedDtoOutputBuilder()..update(updates))._build();

  _$AdminChangeDecidedDtoOutput._({required this.status}) : super._();
  @override
  AdminChangeDecidedDtoOutput rebuild(
    void Function(AdminChangeDecidedDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminChangeDecidedDtoOutputBuilder toBuilder() =>
      AdminChangeDecidedDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminChangeDecidedDtoOutput && status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminChangeDecidedDtoOutput',
    )..add('status', status)).toString();
  }
}

class AdminChangeDecidedDtoOutputBuilder
    implements
        Builder<
          AdminChangeDecidedDtoOutput,
          AdminChangeDecidedDtoOutputBuilder
        > {
  _$AdminChangeDecidedDtoOutput? _$v;

  AdminChangeDecidedDtoOutputStatusEnum? _status;
  AdminChangeDecidedDtoOutputStatusEnum? get status => _$this._status;
  set status(AdminChangeDecidedDtoOutputStatusEnum? status) =>
      _$this._status = status;

  AdminChangeDecidedDtoOutputBuilder() {
    AdminChangeDecidedDtoOutput._defaults(this);
  }

  AdminChangeDecidedDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminChangeDecidedDtoOutput other) {
    _$v = other as _$AdminChangeDecidedDtoOutput;
  }

  @override
  void update(void Function(AdminChangeDecidedDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminChangeDecidedDtoOutput build() => _build();

  _$AdminChangeDecidedDtoOutput _build() {
    final _$result =
        _$v ??
        _$AdminChangeDecidedDtoOutput._(
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'AdminChangeDecidedDtoOutput',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
