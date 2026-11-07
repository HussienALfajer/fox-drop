// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_content_dto_output_reasons.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerContentDtoOutputReasons
    extends CustomerContentDtoOutputReasons {
  @override
  final BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  customerCancel;
  @override
  final BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  customerProblem;
  @override
  final BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  orderNote;
  @override
  final BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  restaurantRatingLow;
  @override
  final BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  restaurantRatingMid;
  @override
  final BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  restaurantRatingHigh;
  @override
  final BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  captainRatingLow;
  @override
  final BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  captainRatingMid;
  @override
  final BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  captainRatingHigh;

  factory _$CustomerContentDtoOutputReasons([
    void Function(CustomerContentDtoOutputReasonsBuilder)? updates,
  ]) => (CustomerContentDtoOutputReasonsBuilder()..update(updates))._build();

  _$CustomerContentDtoOutputReasons._({
    required this.customerCancel,
    required this.customerProblem,
    required this.orderNote,
    required this.restaurantRatingLow,
    required this.restaurantRatingMid,
    required this.restaurantRatingHigh,
    required this.captainRatingLow,
    required this.captainRatingMid,
    required this.captainRatingHigh,
  }) : super._();
  @override
  CustomerContentDtoOutputReasons rebuild(
    void Function(CustomerContentDtoOutputReasonsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerContentDtoOutputReasonsBuilder toBuilder() =>
      CustomerContentDtoOutputReasonsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerContentDtoOutputReasons &&
        customerCancel == other.customerCancel &&
        customerProblem == other.customerProblem &&
        orderNote == other.orderNote &&
        restaurantRatingLow == other.restaurantRatingLow &&
        restaurantRatingMid == other.restaurantRatingMid &&
        restaurantRatingHigh == other.restaurantRatingHigh &&
        captainRatingLow == other.captainRatingLow &&
        captainRatingMid == other.captainRatingMid &&
        captainRatingHigh == other.captainRatingHigh;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, customerCancel.hashCode);
    _$hash = $jc(_$hash, customerProblem.hashCode);
    _$hash = $jc(_$hash, orderNote.hashCode);
    _$hash = $jc(_$hash, restaurantRatingLow.hashCode);
    _$hash = $jc(_$hash, restaurantRatingMid.hashCode);
    _$hash = $jc(_$hash, restaurantRatingHigh.hashCode);
    _$hash = $jc(_$hash, captainRatingLow.hashCode);
    _$hash = $jc(_$hash, captainRatingMid.hashCode);
    _$hash = $jc(_$hash, captainRatingHigh.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerContentDtoOutputReasons')
          ..add('customerCancel', customerCancel)
          ..add('customerProblem', customerProblem)
          ..add('orderNote', orderNote)
          ..add('restaurantRatingLow', restaurantRatingLow)
          ..add('restaurantRatingMid', restaurantRatingMid)
          ..add('restaurantRatingHigh', restaurantRatingHigh)
          ..add('captainRatingLow', captainRatingLow)
          ..add('captainRatingMid', captainRatingMid)
          ..add('captainRatingHigh', captainRatingHigh))
        .toString();
  }
}

class CustomerContentDtoOutputReasonsBuilder
    implements
        Builder<
          CustomerContentDtoOutputReasons,
          CustomerContentDtoOutputReasonsBuilder
        > {
  _$CustomerContentDtoOutputReasons? _$v;

  ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>?
  _customerCancel;
  ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  get customerCancel => _$this._customerCancel ??=
      ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>();
  set customerCancel(
    ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>?
    customerCancel,
  ) => _$this._customerCancel = customerCancel;

  ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>?
  _customerProblem;
  ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  get customerProblem => _$this._customerProblem ??=
      ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>();
  set customerProblem(
    ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>?
    customerProblem,
  ) => _$this._customerProblem = customerProblem;

  ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>?
  _orderNote;
  ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  get orderNote => _$this._orderNote ??=
      ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>();
  set orderNote(
    ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>?
    orderNote,
  ) => _$this._orderNote = orderNote;

  ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>?
  _restaurantRatingLow;
  ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  get restaurantRatingLow => _$this._restaurantRatingLow ??=
      ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>();
  set restaurantRatingLow(
    ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>?
    restaurantRatingLow,
  ) => _$this._restaurantRatingLow = restaurantRatingLow;

  ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>?
  _restaurantRatingMid;
  ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  get restaurantRatingMid => _$this._restaurantRatingMid ??=
      ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>();
  set restaurantRatingMid(
    ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>?
    restaurantRatingMid,
  ) => _$this._restaurantRatingMid = restaurantRatingMid;

  ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>?
  _restaurantRatingHigh;
  ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  get restaurantRatingHigh => _$this._restaurantRatingHigh ??=
      ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>();
  set restaurantRatingHigh(
    ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>?
    restaurantRatingHigh,
  ) => _$this._restaurantRatingHigh = restaurantRatingHigh;

  ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>?
  _captainRatingLow;
  ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  get captainRatingLow => _$this._captainRatingLow ??=
      ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>();
  set captainRatingLow(
    ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>?
    captainRatingLow,
  ) => _$this._captainRatingLow = captainRatingLow;

  ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>?
  _captainRatingMid;
  ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  get captainRatingMid => _$this._captainRatingMid ??=
      ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>();
  set captainRatingMid(
    ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>?
    captainRatingMid,
  ) => _$this._captainRatingMid = captainRatingMid;

  ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>?
  _captainRatingHigh;
  ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  get captainRatingHigh => _$this._captainRatingHigh ??=
      ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>();
  set captainRatingHigh(
    ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>?
    captainRatingHigh,
  ) => _$this._captainRatingHigh = captainRatingHigh;

  CustomerContentDtoOutputReasonsBuilder() {
    CustomerContentDtoOutputReasons._defaults(this);
  }

  CustomerContentDtoOutputReasonsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _customerCancel = $v.customerCancel.toBuilder();
      _customerProblem = $v.customerProblem.toBuilder();
      _orderNote = $v.orderNote.toBuilder();
      _restaurantRatingLow = $v.restaurantRatingLow.toBuilder();
      _restaurantRatingMid = $v.restaurantRatingMid.toBuilder();
      _restaurantRatingHigh = $v.restaurantRatingHigh.toBuilder();
      _captainRatingLow = $v.captainRatingLow.toBuilder();
      _captainRatingMid = $v.captainRatingMid.toBuilder();
      _captainRatingHigh = $v.captainRatingHigh.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerContentDtoOutputReasons other) {
    _$v = other as _$CustomerContentDtoOutputReasons;
  }

  @override
  void update(void Function(CustomerContentDtoOutputReasonsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerContentDtoOutputReasons build() => _build();

  _$CustomerContentDtoOutputReasons _build() {
    _$CustomerContentDtoOutputReasons _$result;
    try {
      _$result =
          _$v ??
          _$CustomerContentDtoOutputReasons._(
            customerCancel: customerCancel.build(),
            customerProblem: customerProblem.build(),
            orderNote: orderNote.build(),
            restaurantRatingLow: restaurantRatingLow.build(),
            restaurantRatingMid: restaurantRatingMid.build(),
            restaurantRatingHigh: restaurantRatingHigh.build(),
            captainRatingLow: captainRatingLow.build(),
            captainRatingMid: captainRatingMid.build(),
            captainRatingHigh: captainRatingHigh.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'customerCancel';
        customerCancel.build();
        _$failedField = 'customerProblem';
        customerProblem.build();
        _$failedField = 'orderNote';
        orderNote.build();
        _$failedField = 'restaurantRatingLow';
        restaurantRatingLow.build();
        _$failedField = 'restaurantRatingMid';
        restaurantRatingMid.build();
        _$failedField = 'restaurantRatingHigh';
        restaurantRatingHigh.build();
        _$failedField = 'captainRatingLow';
        captainRatingLow.build();
        _$failedField = 'captainRatingMid';
        captainRatingMid.build();
        _$failedField = 'captainRatingHigh';
        captainRatingHigh.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerContentDtoOutputReasons',
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
