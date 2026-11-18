// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_order_route_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerOrderRouteDtoOutput extends CustomerOrderRouteDtoOutput {
  @override
  final CustomerOrderRouteDtoOutputCaptain? captain;
  @override
  final AdminCustomerDtoOutputAddressesInnerLocation destination;
  @override
  final CaptainOrderRouteDtoOutputRoute? route;

  factory _$CustomerOrderRouteDtoOutput([
    void Function(CustomerOrderRouteDtoOutputBuilder)? updates,
  ]) => (CustomerOrderRouteDtoOutputBuilder()..update(updates))._build();

  _$CustomerOrderRouteDtoOutput._({
    this.captain,
    required this.destination,
    this.route,
  }) : super._();
  @override
  CustomerOrderRouteDtoOutput rebuild(
    void Function(CustomerOrderRouteDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerOrderRouteDtoOutputBuilder toBuilder() =>
      CustomerOrderRouteDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerOrderRouteDtoOutput &&
        captain == other.captain &&
        destination == other.destination &&
        route == other.route;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, captain.hashCode);
    _$hash = $jc(_$hash, destination.hashCode);
    _$hash = $jc(_$hash, route.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerOrderRouteDtoOutput')
          ..add('captain', captain)
          ..add('destination', destination)
          ..add('route', route))
        .toString();
  }
}

class CustomerOrderRouteDtoOutputBuilder
    implements
        Builder<
          CustomerOrderRouteDtoOutput,
          CustomerOrderRouteDtoOutputBuilder
        > {
  _$CustomerOrderRouteDtoOutput? _$v;

  CustomerOrderRouteDtoOutputCaptainBuilder? _captain;
  CustomerOrderRouteDtoOutputCaptainBuilder get captain =>
      _$this._captain ??= CustomerOrderRouteDtoOutputCaptainBuilder();
  set captain(CustomerOrderRouteDtoOutputCaptainBuilder? captain) =>
      _$this._captain = captain;

  AdminCustomerDtoOutputAddressesInnerLocationBuilder? _destination;
  AdminCustomerDtoOutputAddressesInnerLocationBuilder get destination =>
      _$this._destination ??=
          AdminCustomerDtoOutputAddressesInnerLocationBuilder();
  set destination(
    AdminCustomerDtoOutputAddressesInnerLocationBuilder? destination,
  ) => _$this._destination = destination;

  CaptainOrderRouteDtoOutputRouteBuilder? _route;
  CaptainOrderRouteDtoOutputRouteBuilder get route =>
      _$this._route ??= CaptainOrderRouteDtoOutputRouteBuilder();
  set route(CaptainOrderRouteDtoOutputRouteBuilder? route) =>
      _$this._route = route;

  CustomerOrderRouteDtoOutputBuilder() {
    CustomerOrderRouteDtoOutput._defaults(this);
  }

  CustomerOrderRouteDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _captain = $v.captain?.toBuilder();
      _destination = $v.destination.toBuilder();
      _route = $v.route?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerOrderRouteDtoOutput other) {
    _$v = other as _$CustomerOrderRouteDtoOutput;
  }

  @override
  void update(void Function(CustomerOrderRouteDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerOrderRouteDtoOutput build() => _build();

  _$CustomerOrderRouteDtoOutput _build() {
    _$CustomerOrderRouteDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CustomerOrderRouteDtoOutput._(
            captain: _captain?.build(),
            destination: destination.build(),
            route: _route?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'captain';
        _captain?.build();
        _$failedField = 'destination';
        destination.build();
        _$failedField = 'route';
        _route?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerOrderRouteDtoOutput',
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
