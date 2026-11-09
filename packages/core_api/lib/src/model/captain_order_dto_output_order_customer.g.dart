// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_order_dto_output_order_customer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainOrderDtoOutputOrderCustomer
    extends CaptainOrderDtoOutputOrderCustomer {
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
  final BuiltList<CaptainAvailabilityDtoOutputCustodyLimit> collectEquivalents;
  @override
  final DateTime promisedAt;
  @override
  final CaptainActiveOrderDtoOutputOrderCustomerArrival? arrival;

  factory _$CaptainOrderDtoOutputOrderCustomer([
    void Function(CaptainOrderDtoOutputOrderCustomerBuilder)? updates,
  ]) => (CaptainOrderDtoOutputOrderCustomerBuilder()..update(updates))._build();

  _$CaptainOrderDtoOutputOrderCustomer._({
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
  CaptainOrderDtoOutputOrderCustomer rebuild(
    void Function(CaptainOrderDtoOutputOrderCustomerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainOrderDtoOutputOrderCustomerBuilder toBuilder() =>
      CaptainOrderDtoOutputOrderCustomerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainOrderDtoOutputOrderCustomer &&
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
    return (newBuiltValueToStringHelper(r'CaptainOrderDtoOutputOrderCustomer')
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

class CaptainOrderDtoOutputOrderCustomerBuilder
    implements
        Builder<
          CaptainOrderDtoOutputOrderCustomer,
          CaptainOrderDtoOutputOrderCustomerBuilder
        > {
  _$CaptainOrderDtoOutputOrderCustomer? _$v;

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

  ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>? _collectEquivalents;
  ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>
  get collectEquivalents => _$this._collectEquivalents ??=
      ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>();
  set collectEquivalents(
    ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>? collectEquivalents,
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

  CaptainOrderDtoOutputOrderCustomerBuilder() {
    CaptainOrderDtoOutputOrderCustomer._defaults(this);
  }

  CaptainOrderDtoOutputOrderCustomerBuilder get _$this {
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
  void replace(CaptainOrderDtoOutputOrderCustomer other) {
    _$v = other as _$CaptainOrderDtoOutputOrderCustomer;
  }

  @override
  void update(
    void Function(CaptainOrderDtoOutputOrderCustomerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainOrderDtoOutputOrderCustomer build() => _build();

  _$CaptainOrderDtoOutputOrderCustomer _build() {
    _$CaptainOrderDtoOutputOrderCustomer _$result;
    try {
      _$result =
          _$v ??
          _$CaptainOrderDtoOutputOrderCustomer._(
            name: name,
            phone: phone,
            location: location.build(),
            address: address.build(),
            payIn: payIn,
            collectEquivalents: collectEquivalents.build(),
            promisedAt: BuiltValueNullFieldError.checkNotNull(
              promisedAt,
              r'CaptainOrderDtoOutputOrderCustomer',
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
          r'CaptainOrderDtoOutputOrderCustomer',
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
