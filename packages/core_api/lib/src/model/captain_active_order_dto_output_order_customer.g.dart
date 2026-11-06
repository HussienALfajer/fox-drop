// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_order_customer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainActiveOrderDtoOutputOrderCustomer
    extends CaptainActiveOrderDtoOutputOrderCustomer {
  @override
  final String? name;
  @override
  final String? phone;
  @override
  final CaptainActiveOrderDtoOutputOrderCustomerLocation location;
  @override
  final CaptainActiveOrderDtoOutputOrderCustomerAddress address;
  @override
  final String? payIn;
  @override
  final BuiltList<CaptainWentOfflineDtoOutputHandIn?> collectEquivalents;
  @override
  final DateTime promisedAt;
  @override
  final CaptainActiveOrderDtoOutputOrderCustomerArrival? arrival;

  factory _$CaptainActiveOrderDtoOutputOrderCustomer([
    void Function(CaptainActiveOrderDtoOutputOrderCustomerBuilder)? updates,
  ]) => (CaptainActiveOrderDtoOutputOrderCustomerBuilder()..update(updates))
      ._build();

  _$CaptainActiveOrderDtoOutputOrderCustomer._({
    this.name,
    this.phone,
    required this.location,
    required this.address,
    this.payIn,
    required this.collectEquivalents,
    required this.promisedAt,
    this.arrival,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputOrderCustomer rebuild(
    void Function(CaptainActiveOrderDtoOutputOrderCustomerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputOrderCustomerBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputOrderCustomerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputOrderCustomer &&
        name == other.name &&
        phone == other.phone &&
        location == other.location &&
        address == other.address &&
        payIn == other.payIn &&
        collectEquivalents == other.collectEquivalents &&
        promisedAt == other.promisedAt &&
        arrival == other.arrival;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, payIn.hashCode);
    _$hash = $jc(_$hash, collectEquivalents.hashCode);
    _$hash = $jc(_$hash, promisedAt.hashCode);
    _$hash = $jc(_$hash, arrival.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainActiveOrderDtoOutputOrderCustomer',
          )
          ..add('name', name)
          ..add('phone', phone)
          ..add('location', location)
          ..add('address', address)
          ..add('payIn', payIn)
          ..add('collectEquivalents', collectEquivalents)
          ..add('promisedAt', promisedAt)
          ..add('arrival', arrival))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputOrderCustomerBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputOrderCustomer,
          CaptainActiveOrderDtoOutputOrderCustomerBuilder
        > {
  _$CaptainActiveOrderDtoOutputOrderCustomer? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  CaptainActiveOrderDtoOutputOrderCustomerLocationBuilder? _location;
  CaptainActiveOrderDtoOutputOrderCustomerLocationBuilder get location =>
      _$this._location ??=
          CaptainActiveOrderDtoOutputOrderCustomerLocationBuilder();
  set location(
    CaptainActiveOrderDtoOutputOrderCustomerLocationBuilder? location,
  ) => _$this._location = location;

  CaptainActiveOrderDtoOutputOrderCustomerAddressBuilder? _address;
  CaptainActiveOrderDtoOutputOrderCustomerAddressBuilder get address =>
      _$this._address ??=
          CaptainActiveOrderDtoOutputOrderCustomerAddressBuilder();
  set address(
    CaptainActiveOrderDtoOutputOrderCustomerAddressBuilder? address,
  ) => _$this._address = address;

  String? _payIn;
  String? get payIn => _$this._payIn;
  set payIn(String? payIn) => _$this._payIn = payIn;

  ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? _collectEquivalents;
  ListBuilder<CaptainWentOfflineDtoOutputHandIn?> get collectEquivalents =>
      _$this._collectEquivalents ??=
          ListBuilder<CaptainWentOfflineDtoOutputHandIn?>();
  set collectEquivalents(
    ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? collectEquivalents,
  ) => _$this._collectEquivalents = collectEquivalents;

  DateTime? _promisedAt;
  DateTime? get promisedAt => _$this._promisedAt;
  set promisedAt(DateTime? promisedAt) => _$this._promisedAt = promisedAt;

  CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder? _arrival;
  CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder get arrival =>
      _$this._arrival ??=
          CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder();
  set arrival(
    CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder? arrival,
  ) => _$this._arrival = arrival;

  CaptainActiveOrderDtoOutputOrderCustomerBuilder() {
    CaptainActiveOrderDtoOutputOrderCustomer._defaults(this);
  }

  CaptainActiveOrderDtoOutputOrderCustomerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _phone = $v.phone;
      _location = $v.location.toBuilder();
      _address = $v.address.toBuilder();
      _payIn = $v.payIn;
      _collectEquivalents = $v.collectEquivalents.toBuilder();
      _promisedAt = $v.promisedAt;
      _arrival = $v.arrival?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputOrderCustomer other) {
    _$v = other as _$CaptainActiveOrderDtoOutputOrderCustomer;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputOrderCustomerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputOrderCustomer build() => _build();

  _$CaptainActiveOrderDtoOutputOrderCustomer _build() {
    _$CaptainActiveOrderDtoOutputOrderCustomer _$result;
    try {
      _$result =
          _$v ??
          _$CaptainActiveOrderDtoOutputOrderCustomer._(
            name: name,
            phone: phone,
            location: location.build(),
            address: address.build(),
            payIn: payIn,
            collectEquivalents: collectEquivalents.build(),
            promisedAt: BuiltValueNullFieldError.checkNotNull(
              promisedAt,
              r'CaptainActiveOrderDtoOutputOrderCustomer',
              'promisedAt',
            ),
            arrival: _arrival?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'location';
        location.build();
        _$failedField = 'address';
        address.build();

        _$failedField = 'collectEquivalents';
        collectEquivalents.build();

        _$failedField = 'arrival';
        _arrival?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainActiveOrderDtoOutputOrderCustomer',
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
