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
const AdminCustomerDtoOutputStatusEnum
_$adminCustomerDtoOutputStatusEnum_closed =
    const AdminCustomerDtoOutputStatusEnum._('closed');

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
    case 'closed':
      return _$adminCustomerDtoOutputStatusEnum_closed;
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
        _$adminCustomerDtoOutputStatusEnum_closed,
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
    'closed': 'closed',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'active': 'active',
    'blocked': 'blocked',
    'dues_unpaid': 'duesUnpaid',
    'review_stop': 'reviewStop',
    'closed': 'closed',
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
  final AdminCustomerDtoOutputClosed? closed;
  @override
  final BuiltList<AdminCustomerDtoOutputLinkedAccountsInner> linkedAccounts;
  @override
  final bool trusted;
  @override
  final int delivered;
  @override
  final int trustedAfter;
  @override
  final AdminCustomerDtoOutputTrustMark? trustMark;
  @override
  final AdminCustomerDtoOutputLateCancels lateCancels;
  @override
  final int fakeOrders;
  @override
  final AdminCustomerDtoOutputDues dues;
  @override
  final BuiltList<AdminCustomerDtoOutputBlocksInner> blocks;
  @override
  final BuiltList<AdminCustomerDtoOutputBlockReasonsInner> blockReasons;
  @override
  final bool testAccount;
  @override
  final AdminCustomerDtoOutputOrders orders;
  @override
  final BuiltList<AdminCustomerDtoOutputTicketsInner> tickets;
  @override
  final BuiltList<AdminCustomerDtoOutputRatingsInner> ratings;
  @override
  final BuiltList<AdminCustomerDtoOutputCodesInner> codes;
  @override
  final BuiltList<AdminCustomerDtoOutputAddressesInner> addresses;
  @override
  final BuiltList<AdminCustomerDtoOutputNotesInner> notes;
  @override
  final BuiltList<AdminCustomerDtoOutputDevicesInner> devices;
  @override
  final String? duesViaAccountId;

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
    this.closed,
    required this.linkedAccounts,
    required this.trusted,
    required this.delivered,
    required this.trustedAfter,
    this.trustMark,
    required this.lateCancels,
    required this.fakeOrders,
    required this.dues,
    required this.blocks,
    required this.blockReasons,
    required this.testAccount,
    required this.orders,
    required this.tickets,
    required this.ratings,
    required this.codes,
    required this.addresses,
    required this.notes,
    required this.devices,
    this.duesViaAccountId,
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
        closed == other.closed &&
        linkedAccounts == other.linkedAccounts &&
        trusted == other.trusted &&
        delivered == other.delivered &&
        trustedAfter == other.trustedAfter &&
        trustMark == other.trustMark &&
        lateCancels == other.lateCancels &&
        fakeOrders == other.fakeOrders &&
        dues == other.dues &&
        blocks == other.blocks &&
        blockReasons == other.blockReasons &&
        testAccount == other.testAccount &&
        orders == other.orders &&
        tickets == other.tickets &&
        ratings == other.ratings &&
        codes == other.codes &&
        addresses == other.addresses &&
        notes == other.notes &&
        devices == other.devices &&
        duesViaAccountId == other.duesViaAccountId;
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
    _$hash = $jc(_$hash, closed.hashCode);
    _$hash = $jc(_$hash, linkedAccounts.hashCode);
    _$hash = $jc(_$hash, trusted.hashCode);
    _$hash = $jc(_$hash, delivered.hashCode);
    _$hash = $jc(_$hash, trustedAfter.hashCode);
    _$hash = $jc(_$hash, trustMark.hashCode);
    _$hash = $jc(_$hash, lateCancels.hashCode);
    _$hash = $jc(_$hash, fakeOrders.hashCode);
    _$hash = $jc(_$hash, dues.hashCode);
    _$hash = $jc(_$hash, blocks.hashCode);
    _$hash = $jc(_$hash, blockReasons.hashCode);
    _$hash = $jc(_$hash, testAccount.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, tickets.hashCode);
    _$hash = $jc(_$hash, ratings.hashCode);
    _$hash = $jc(_$hash, codes.hashCode);
    _$hash = $jc(_$hash, addresses.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jc(_$hash, devices.hashCode);
    _$hash = $jc(_$hash, duesViaAccountId.hashCode);
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
          ..add('closed', closed)
          ..add('linkedAccounts', linkedAccounts)
          ..add('trusted', trusted)
          ..add('delivered', delivered)
          ..add('trustedAfter', trustedAfter)
          ..add('trustMark', trustMark)
          ..add('lateCancels', lateCancels)
          ..add('fakeOrders', fakeOrders)
          ..add('dues', dues)
          ..add('blocks', blocks)
          ..add('blockReasons', blockReasons)
          ..add('testAccount', testAccount)
          ..add('orders', orders)
          ..add('tickets', tickets)
          ..add('ratings', ratings)
          ..add('codes', codes)
          ..add('addresses', addresses)
          ..add('notes', notes)
          ..add('devices', devices)
          ..add('duesViaAccountId', duesViaAccountId))
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

  AdminCustomerDtoOutputClosedBuilder? _closed;
  AdminCustomerDtoOutputClosedBuilder get closed =>
      _$this._closed ??= AdminCustomerDtoOutputClosedBuilder();
  set closed(AdminCustomerDtoOutputClosedBuilder? closed) =>
      _$this._closed = closed;

  ListBuilder<AdminCustomerDtoOutputLinkedAccountsInner>? _linkedAccounts;
  ListBuilder<AdminCustomerDtoOutputLinkedAccountsInner> get linkedAccounts =>
      _$this._linkedAccounts ??=
          ListBuilder<AdminCustomerDtoOutputLinkedAccountsInner>();
  set linkedAccounts(
    ListBuilder<AdminCustomerDtoOutputLinkedAccountsInner>? linkedAccounts,
  ) => _$this._linkedAccounts = linkedAccounts;

  bool? _trusted;
  bool? get trusted => _$this._trusted;
  set trusted(bool? trusted) => _$this._trusted = trusted;

  int? _delivered;
  int? get delivered => _$this._delivered;
  set delivered(int? delivered) => _$this._delivered = delivered;

  int? _trustedAfter;
  int? get trustedAfter => _$this._trustedAfter;
  set trustedAfter(int? trustedAfter) => _$this._trustedAfter = trustedAfter;

  AdminCustomerDtoOutputTrustMarkBuilder? _trustMark;
  AdminCustomerDtoOutputTrustMarkBuilder get trustMark =>
      _$this._trustMark ??= AdminCustomerDtoOutputTrustMarkBuilder();
  set trustMark(AdminCustomerDtoOutputTrustMarkBuilder? trustMark) =>
      _$this._trustMark = trustMark;

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

  ListBuilder<AdminCustomerDtoOutputBlockReasonsInner>? _blockReasons;
  ListBuilder<AdminCustomerDtoOutputBlockReasonsInner> get blockReasons =>
      _$this._blockReasons ??=
          ListBuilder<AdminCustomerDtoOutputBlockReasonsInner>();
  set blockReasons(
    ListBuilder<AdminCustomerDtoOutputBlockReasonsInner>? blockReasons,
  ) => _$this._blockReasons = blockReasons;

  bool? _testAccount;
  bool? get testAccount => _$this._testAccount;
  set testAccount(bool? testAccount) => _$this._testAccount = testAccount;

  AdminCustomerDtoOutputOrdersBuilder? _orders;
  AdminCustomerDtoOutputOrdersBuilder get orders =>
      _$this._orders ??= AdminCustomerDtoOutputOrdersBuilder();
  set orders(AdminCustomerDtoOutputOrdersBuilder? orders) =>
      _$this._orders = orders;

  ListBuilder<AdminCustomerDtoOutputTicketsInner>? _tickets;
  ListBuilder<AdminCustomerDtoOutputTicketsInner> get tickets =>
      _$this._tickets ??= ListBuilder<AdminCustomerDtoOutputTicketsInner>();
  set tickets(ListBuilder<AdminCustomerDtoOutputTicketsInner>? tickets) =>
      _$this._tickets = tickets;

  ListBuilder<AdminCustomerDtoOutputRatingsInner>? _ratings;
  ListBuilder<AdminCustomerDtoOutputRatingsInner> get ratings =>
      _$this._ratings ??= ListBuilder<AdminCustomerDtoOutputRatingsInner>();
  set ratings(ListBuilder<AdminCustomerDtoOutputRatingsInner>? ratings) =>
      _$this._ratings = ratings;

  ListBuilder<AdminCustomerDtoOutputCodesInner>? _codes;
  ListBuilder<AdminCustomerDtoOutputCodesInner> get codes =>
      _$this._codes ??= ListBuilder<AdminCustomerDtoOutputCodesInner>();
  set codes(ListBuilder<AdminCustomerDtoOutputCodesInner>? codes) =>
      _$this._codes = codes;

  ListBuilder<AdminCustomerDtoOutputAddressesInner>? _addresses;
  ListBuilder<AdminCustomerDtoOutputAddressesInner> get addresses =>
      _$this._addresses ??= ListBuilder<AdminCustomerDtoOutputAddressesInner>();
  set addresses(ListBuilder<AdminCustomerDtoOutputAddressesInner>? addresses) =>
      _$this._addresses = addresses;

  ListBuilder<AdminCustomerDtoOutputNotesInner>? _notes;
  ListBuilder<AdminCustomerDtoOutputNotesInner> get notes =>
      _$this._notes ??= ListBuilder<AdminCustomerDtoOutputNotesInner>();
  set notes(ListBuilder<AdminCustomerDtoOutputNotesInner>? notes) =>
      _$this._notes = notes;

  ListBuilder<AdminCustomerDtoOutputDevicesInner>? _devices;
  ListBuilder<AdminCustomerDtoOutputDevicesInner> get devices =>
      _$this._devices ??= ListBuilder<AdminCustomerDtoOutputDevicesInner>();
  set devices(ListBuilder<AdminCustomerDtoOutputDevicesInner>? devices) =>
      _$this._devices = devices;

  String? _duesViaAccountId;
  String? get duesViaAccountId => _$this._duesViaAccountId;
  set duesViaAccountId(String? duesViaAccountId) =>
      _$this._duesViaAccountId = duesViaAccountId;

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
      _closed = $v.closed?.toBuilder();
      _linkedAccounts = $v.linkedAccounts.toBuilder();
      _trusted = $v.trusted;
      _delivered = $v.delivered;
      _trustedAfter = $v.trustedAfter;
      _trustMark = $v.trustMark?.toBuilder();
      _lateCancels = $v.lateCancels.toBuilder();
      _fakeOrders = $v.fakeOrders;
      _dues = $v.dues.toBuilder();
      _blocks = $v.blocks.toBuilder();
      _blockReasons = $v.blockReasons.toBuilder();
      _testAccount = $v.testAccount;
      _orders = $v.orders.toBuilder();
      _tickets = $v.tickets.toBuilder();
      _ratings = $v.ratings.toBuilder();
      _codes = $v.codes.toBuilder();
      _addresses = $v.addresses.toBuilder();
      _notes = $v.notes.toBuilder();
      _devices = $v.devices.toBuilder();
      _duesViaAccountId = $v.duesViaAccountId;
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
            closed: _closed?.build(),
            linkedAccounts: linkedAccounts.build(),
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
            trustMark: _trustMark?.build(),
            lateCancels: lateCancels.build(),
            fakeOrders: BuiltValueNullFieldError.checkNotNull(
              fakeOrders,
              r'AdminCustomerDtoOutput',
              'fakeOrders',
            ),
            dues: dues.build(),
            blocks: blocks.build(),
            blockReasons: blockReasons.build(),
            testAccount: BuiltValueNullFieldError.checkNotNull(
              testAccount,
              r'AdminCustomerDtoOutput',
              'testAccount',
            ),
            orders: orders.build(),
            tickets: tickets.build(),
            ratings: ratings.build(),
            codes: codes.build(),
            addresses: addresses.build(),
            notes: notes.build(),
            devices: devices.build(),
            duesViaAccountId: duesViaAccountId,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'block';
        _block?.build();
        _$failedField = 'reviewStop';
        _reviewStop?.build();
        _$failedField = 'closed';
        _closed?.build();
        _$failedField = 'linkedAccounts';
        linkedAccounts.build();

        _$failedField = 'trustMark';
        _trustMark?.build();
        _$failedField = 'lateCancels';
        lateCancels.build();

        _$failedField = 'dues';
        dues.build();
        _$failedField = 'blocks';
        blocks.build();
        _$failedField = 'blockReasons';
        blockReasons.build();

        _$failedField = 'orders';
        orders.build();
        _$failedField = 'tickets';
        tickets.build();
        _$failedField = 'ratings';
        ratings.build();
        _$failedField = 'codes';
        codes.build();
        _$failedField = 'addresses';
        addresses.build();
        _$failedField = 'notes';
        notes.build();
        _$failedField = 'devices';
        devices.build();
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
