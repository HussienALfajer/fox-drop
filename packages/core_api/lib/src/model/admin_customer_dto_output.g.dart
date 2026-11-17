// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCustomerDtoOutputGenderEnum _$adminCustomerDtoOutputGenderEnum_male =
    const AdminCustomerDtoOutputGenderEnum._('male');
const AdminCustomerDtoOutputGenderEnum
_$adminCustomerDtoOutputGenderEnum_female =
    const AdminCustomerDtoOutputGenderEnum._('female');

AdminCustomerDtoOutputGenderEnum _$adminCustomerDtoOutputGenderEnumValueOf(
  String name,
) {
  switch (name) {
    case 'male':
      return _$adminCustomerDtoOutputGenderEnum_male;
    case 'female':
      return _$adminCustomerDtoOutputGenderEnum_female;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCustomerDtoOutputGenderEnum>
_$adminCustomerDtoOutputGenderEnumValues =
    BuiltSet<AdminCustomerDtoOutputGenderEnum>(
      const <AdminCustomerDtoOutputGenderEnum>[
        _$adminCustomerDtoOutputGenderEnum_male,
        _$adminCustomerDtoOutputGenderEnum_female,
      ],
    );

const AdminCustomerDtoOutputStatusEnum
_$adminCustomerDtoOutputStatusEnum_active =
    const AdminCustomerDtoOutputStatusEnum._('active');
const AdminCustomerDtoOutputStatusEnum
_$adminCustomerDtoOutputStatusEnum_blocked =
    const AdminCustomerDtoOutputStatusEnum._('blocked');
const AdminCustomerDtoOutputStatusEnum
_$adminCustomerDtoOutputStatusEnum_duesUnpaid =
    const AdminCustomerDtoOutputStatusEnum._('duesUnpaid');
const AdminCustomerDtoOutputStatusEnum
_$adminCustomerDtoOutputStatusEnum_reviewStop =
    const AdminCustomerDtoOutputStatusEnum._('reviewStop');

AdminCustomerDtoOutputStatusEnum _$adminCustomerDtoOutputStatusEnumValueOf(
  String name,
) {
  switch (name) {
    case 'active':
      return _$adminCustomerDtoOutputStatusEnum_active;
    case 'blocked':
      return _$adminCustomerDtoOutputStatusEnum_blocked;
    case 'duesUnpaid':
      return _$adminCustomerDtoOutputStatusEnum_duesUnpaid;
    case 'reviewStop':
      return _$adminCustomerDtoOutputStatusEnum_reviewStop;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCustomerDtoOutputStatusEnum>
_$adminCustomerDtoOutputStatusEnumValues =
    BuiltSet<AdminCustomerDtoOutputStatusEnum>(
      const <AdminCustomerDtoOutputStatusEnum>[
        _$adminCustomerDtoOutputStatusEnum_active,
        _$adminCustomerDtoOutputStatusEnum_blocked,
        _$adminCustomerDtoOutputStatusEnum_duesUnpaid,
        _$adminCustomerDtoOutputStatusEnum_reviewStop,
      ],
    );

Serializer<AdminCustomerDtoOutputGenderEnum>
_$adminCustomerDtoOutputGenderEnumSerializer =
    _$AdminCustomerDtoOutputGenderEnumSerializer();
Serializer<AdminCustomerDtoOutputStatusEnum>
_$adminCustomerDtoOutputStatusEnumSerializer =
    _$AdminCustomerDtoOutputStatusEnumSerializer();

class _$AdminCustomerDtoOutputGenderEnumSerializer
    implements PrimitiveSerializer<AdminCustomerDtoOutputGenderEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'male': 'male',
    'female': 'female',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'male': 'male',
    'female': 'female',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminCustomerDtoOutputGenderEnum];
  @override
  final String wireName = 'AdminCustomerDtoOutputGenderEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerDtoOutputGenderEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCustomerDtoOutputGenderEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCustomerDtoOutputGenderEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCustomerDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<AdminCustomerDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'active': 'active',
    'blocked': 'blocked',
    'duesUnpaid': 'dues_unpaid',
    'reviewStop': 'review_stop',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'active': 'active',
    'blocked': 'blocked',
    'dues_unpaid': 'duesUnpaid',
    'review_stop': 'reviewStop',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminCustomerDtoOutputStatusEnum];
  @override
  final String wireName = 'AdminCustomerDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCustomerDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCustomerDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCustomerDtoOutput extends AdminCustomerDtoOutput {
  @override
  final String id;
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final AdminCustomerDtoOutputGenderEnum? gender;
  @override
  final Date? birthday;
  @override
  final String? maskedPhone;
  @override
  final AdminCustomerDtoOutputStatusEnum status;
  @override
  final AdminCustomerDtoOutputBlock? block;
  @override
  final AdminCustomerDtoOutputReviewStop? reviewStop;
  @override
  final bool trusted;
  @override
  final int delivered;
  @override
  final int trustedAfter;
  @override
  final AdminCustomerDtoOutputLateCancels lateCancels;
  @override
  final int fakeOrders;
  @override
  final AdminCustomerDtoOutputDues dues;
  @override
  final BuiltList<AdminCustomerDtoOutputBlocksInner> blocks;

  factory _$AdminCustomerDtoOutput([
    void Function(AdminCustomerDtoOutputBuilder)? updates,
  ]) => (AdminCustomerDtoOutputBuilder()..update(updates))._build();

  _$AdminCustomerDtoOutput._({
    required this.id,
    this.firstName,
    this.lastName,
    this.gender,
    this.birthday,
    this.maskedPhone,
    required this.status,
    this.block,
    this.reviewStop,
    required this.trusted,
    required this.delivered,
    required this.trustedAfter,
    required this.lateCancels,
    required this.fakeOrders,
    required this.dues,
    required this.blocks,
  }) : super._();
  @override
  AdminCustomerDtoOutput rebuild(
    void Function(AdminCustomerDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerDtoOutputBuilder toBuilder() =>
      AdminCustomerDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerDtoOutput &&
        id == other.id &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        gender == other.gender &&
        birthday == other.birthday &&
        maskedPhone == other.maskedPhone &&
        status == other.status &&
        block == other.block &&
        reviewStop == other.reviewStop &&
        trusted == other.trusted &&
        delivered == other.delivered &&
        trustedAfter == other.trustedAfter &&
        lateCancels == other.lateCancels &&
        fakeOrders == other.fakeOrders &&
        dues == other.dues &&
        blocks == other.blocks;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, gender.hashCode);
    _$hash = $jc(_$hash, birthday.hashCode);
    _$hash = $jc(_$hash, maskedPhone.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, block.hashCode);
    _$hash = $jc(_$hash, reviewStop.hashCode);
    _$hash = $jc(_$hash, trusted.hashCode);
    _$hash = $jc(_$hash, delivered.hashCode);
    _$hash = $jc(_$hash, trustedAfter.hashCode);
    _$hash = $jc(_$hash, lateCancels.hashCode);
    _$hash = $jc(_$hash, fakeOrders.hashCode);
    _$hash = $jc(_$hash, dues.hashCode);
    _$hash = $jc(_$hash, blocks.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCustomerDtoOutput')
          ..add('id', id)
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('gender', gender)
          ..add('birthday', birthday)
          ..add('maskedPhone', maskedPhone)
          ..add('status', status)
          ..add('block', block)
          ..add('reviewStop', reviewStop)
          ..add('trusted', trusted)
          ..add('delivered', delivered)
          ..add('trustedAfter', trustedAfter)
          ..add('lateCancels', lateCancels)
          ..add('fakeOrders', fakeOrders)
          ..add('dues', dues)
          ..add('blocks', blocks))
        .toString();
  }
}

class AdminCustomerDtoOutputBuilder
    implements Builder<AdminCustomerDtoOutput, AdminCustomerDtoOutputBuilder> {
  _$AdminCustomerDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _firstName;
  String? get firstName => _$this._firstName;
  set firstName(String? firstName) => _$this._firstName = firstName;

  String? _lastName;
  String? get lastName => _$this._lastName;
  set lastName(String? lastName) => _$this._lastName = lastName;

  AdminCustomerDtoOutputGenderEnum? _gender;
  AdminCustomerDtoOutputGenderEnum? get gender => _$this._gender;
  set gender(AdminCustomerDtoOutputGenderEnum? gender) =>
      _$this._gender = gender;

  Date? _birthday;
  Date? get birthday => _$this._birthday;
  set birthday(Date? birthday) => _$this._birthday = birthday;

  String? _maskedPhone;
  String? get maskedPhone => _$this._maskedPhone;
  set maskedPhone(String? maskedPhone) => _$this._maskedPhone = maskedPhone;

  AdminCustomerDtoOutputStatusEnum? _status;
  AdminCustomerDtoOutputStatusEnum? get status => _$this._status;
  set status(AdminCustomerDtoOutputStatusEnum? status) =>
      _$this._status = status;

  AdminCustomerDtoOutputBlockBuilder? _block;
  AdminCustomerDtoOutputBlockBuilder get block =>
      _$this._block ??= AdminCustomerDtoOutputBlockBuilder();
  set block(AdminCustomerDtoOutputBlockBuilder? block) => _$this._block = block;

  AdminCustomerDtoOutputReviewStopBuilder? _reviewStop;
  AdminCustomerDtoOutputReviewStopBuilder get reviewStop =>
      _$this._reviewStop ??= AdminCustomerDtoOutputReviewStopBuilder();
  set reviewStop(AdminCustomerDtoOutputReviewStopBuilder? reviewStop) =>
      _$this._reviewStop = reviewStop;

  bool? _trusted;
  bool? get trusted => _$this._trusted;
  set trusted(bool? trusted) => _$this._trusted = trusted;

  int? _delivered;
  int? get delivered => _$this._delivered;
  set delivered(int? delivered) => _$this._delivered = delivered;

  int? _trustedAfter;
  int? get trustedAfter => _$this._trustedAfter;
  set trustedAfter(int? trustedAfter) => _$this._trustedAfter = trustedAfter;

  AdminCustomerDtoOutputLateCancelsBuilder? _lateCancels;
  AdminCustomerDtoOutputLateCancelsBuilder get lateCancels =>
      _$this._lateCancels ??= AdminCustomerDtoOutputLateCancelsBuilder();
  set lateCancels(AdminCustomerDtoOutputLateCancelsBuilder? lateCancels) =>
      _$this._lateCancels = lateCancels;

  int? _fakeOrders;
  int? get fakeOrders => _$this._fakeOrders;
  set fakeOrders(int? fakeOrders) => _$this._fakeOrders = fakeOrders;

  AdminCustomerDtoOutputDuesBuilder? _dues;
  AdminCustomerDtoOutputDuesBuilder get dues =>
      _$this._dues ??= AdminCustomerDtoOutputDuesBuilder();
  set dues(AdminCustomerDtoOutputDuesBuilder? dues) => _$this._dues = dues;

  ListBuilder<AdminCustomerDtoOutputBlocksInner>? _blocks;
  ListBuilder<AdminCustomerDtoOutputBlocksInner> get blocks =>
      _$this._blocks ??= ListBuilder<AdminCustomerDtoOutputBlocksInner>();
  set blocks(ListBuilder<AdminCustomerDtoOutputBlocksInner>? blocks) =>
      _$this._blocks = blocks;

  AdminCustomerDtoOutputBuilder() {
    AdminCustomerDtoOutput._defaults(this);
  }

  AdminCustomerDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _gender = $v.gender;
      _birthday = $v.birthday;
      _maskedPhone = $v.maskedPhone;
      _status = $v.status;
      _block = $v.block?.toBuilder();
      _reviewStop = $v.reviewStop?.toBuilder();
      _trusted = $v.trusted;
      _delivered = $v.delivered;
      _trustedAfter = $v.trustedAfter;
      _lateCancels = $v.lateCancels.toBuilder();
      _fakeOrders = $v.fakeOrders;
      _dues = $v.dues.toBuilder();
      _blocks = $v.blocks.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerDtoOutput other) {
    _$v = other as _$AdminCustomerDtoOutput;
  }

  @override
  void update(void Function(AdminCustomerDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerDtoOutput build() => _build();

  _$AdminCustomerDtoOutput _build() {
    _$AdminCustomerDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminCustomerDtoOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminCustomerDtoOutput',
              'id',
            ),
            firstName: firstName,
            lastName: lastName,
            gender: gender,
            birthday: birthday,
            maskedPhone: maskedPhone,
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'AdminCustomerDtoOutput',
              'status',
            ),
            block: _block?.build(),
            reviewStop: _reviewStop?.build(),
            trusted: BuiltValueNullFieldError.checkNotNull(
              trusted,
              r'AdminCustomerDtoOutput',
              'trusted',
            ),
            delivered: BuiltValueNullFieldError.checkNotNull(
              delivered,
              r'AdminCustomerDtoOutput',
              'delivered',
            ),
            trustedAfter: BuiltValueNullFieldError.checkNotNull(
              trustedAfter,
              r'AdminCustomerDtoOutput',
              'trustedAfter',
            ),
            lateCancels: lateCancels.build(),
            fakeOrders: BuiltValueNullFieldError.checkNotNull(
              fakeOrders,
              r'AdminCustomerDtoOutput',
              'fakeOrders',
            ),
            dues: dues.build(),
            blocks: blocks.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'block';
        _block?.build();
        _$failedField = 'reviewStop';
        _reviewStop?.build();

        _$failedField = 'lateCancels';
        lateCancels.build();

        _$failedField = 'dues';
        dues.build();
        _$failedField = 'blocks';
        blocks.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCustomerDtoOutput',
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
