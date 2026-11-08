// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_resend_notification_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminResendNotificationDtoToEnum
_$adminResendNotificationDtoToEnum_customer =
    const AdminResendNotificationDtoToEnum._('customer');
const AdminResendNotificationDtoToEnum
_$adminResendNotificationDtoToEnum_merchant =
    const AdminResendNotificationDtoToEnum._('merchant');
const AdminResendNotificationDtoToEnum
_$adminResendNotificationDtoToEnum_captain =
    const AdminResendNotificationDtoToEnum._('captain');

AdminResendNotificationDtoToEnum _$adminResendNotificationDtoToEnumValueOf(
  String name,
) {
  switch (name) {
    case 'customer':
      return _$adminResendNotificationDtoToEnum_customer;
    case 'merchant':
      return _$adminResendNotificationDtoToEnum_merchant;
    case 'captain':
      return _$adminResendNotificationDtoToEnum_captain;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminResendNotificationDtoToEnum>
_$adminResendNotificationDtoToEnumValues =
    BuiltSet<AdminResendNotificationDtoToEnum>(
      const <AdminResendNotificationDtoToEnum>[
        _$adminResendNotificationDtoToEnum_customer,
        _$adminResendNotificationDtoToEnum_merchant,
        _$adminResendNotificationDtoToEnum_captain,
      ],
    );

Serializer<AdminResendNotificationDtoToEnum>
_$adminResendNotificationDtoToEnumSerializer =
    _$AdminResendNotificationDtoToEnumSerializer();

class _$AdminResendNotificationDtoToEnumSerializer
    implements PrimitiveSerializer<AdminResendNotificationDtoToEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'customer': 'customer',
    'merchant': 'merchant',
    'captain': 'captain',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'customer': 'customer',
    'merchant': 'merchant',
    'captain': 'captain',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminResendNotificationDtoToEnum];
  @override
  final String wireName = 'AdminResendNotificationDtoToEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminResendNotificationDtoToEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminResendNotificationDtoToEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminResendNotificationDtoToEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminResendNotificationDto extends AdminResendNotificationDto {
  @override
  final AdminResendNotificationDtoToEnum to;

  factory _$AdminResendNotificationDto([
    void Function(AdminResendNotificationDtoBuilder)? updates,
  ]) => (AdminResendNotificationDtoBuilder()..update(updates))._build();

  _$AdminResendNotificationDto._({required this.to}) : super._();
  @override
  AdminResendNotificationDto rebuild(
    void Function(AdminResendNotificationDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminResendNotificationDtoBuilder toBuilder() =>
      AdminResendNotificationDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminResendNotificationDto && to == other.to;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminResendNotificationDto',
    )..add('to', to)).toString();
  }
}

class AdminResendNotificationDtoBuilder
    implements
        Builder<AdminResendNotificationDto, AdminResendNotificationDtoBuilder> {
  _$AdminResendNotificationDto? _$v;

  AdminResendNotificationDtoToEnum? _to;
  AdminResendNotificationDtoToEnum? get to => _$this._to;
  set to(AdminResendNotificationDtoToEnum? to) => _$this._to = to;

  AdminResendNotificationDtoBuilder() {
    AdminResendNotificationDto._defaults(this);
  }

  AdminResendNotificationDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _to = $v.to;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminResendNotificationDto other) {
    _$v = other as _$AdminResendNotificationDto;
  }

  @override
  void update(void Function(AdminResendNotificationDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminResendNotificationDto build() => _build();

  _$AdminResendNotificationDto _build() {
    final _$result =
        _$v ??
        _$AdminResendNotificationDto._(
          to: BuiltValueNullFieldError.checkNotNull(
            to,
            r'AdminResendNotificationDto',
            'to',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
