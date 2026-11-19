// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_performance_dto_output_acceptance_offers_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum
_$captainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum_accepted =
    const CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum._(
      'accepted',
    );
const CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum
_$captainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum_declined =
    const CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum._(
      'declined',
    );
const CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum
_$captainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum_expired =
    const CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum._(
      'expired',
    );

CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum
_$captainPerformanceDtoOutputAcceptanceOffersInnerResponseEnumValueOf(
  String name,
) {
  switch (name) {
    case 'accepted':
      return _$captainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum_accepted;
    case 'declined':
      return _$captainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum_declined;
    case 'expired':
      return _$captainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum_expired;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum>
_$captainPerformanceDtoOutputAcceptanceOffersInnerResponseEnumValues =
    BuiltSet<CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum>(
      const <CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum>[
        _$captainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum_accepted,
        _$captainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum_declined,
        _$captainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum_expired,
      ],
    );

Serializer<CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum>
_$captainPerformanceDtoOutputAcceptanceOffersInnerResponseEnumSerializer =
    _$CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnumSerializer();

class _$CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnumSerializer
    implements
        PrimitiveSerializer<
          CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'accepted': 'accepted',
    'declined': 'declined',
    'expired': 'expired',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'accepted': 'accepted',
    'declined': 'declined',
    'expired': 'expired',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum,
  ];
  @override
  final String wireName =
      'CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainPerformanceDtoOutputAcceptanceOffersInner
    extends CaptainPerformanceDtoOutputAcceptanceOffersInner {
  @override
  final DateTime offeredAt;
  @override
  final String? restaurantName;
  @override
  final CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum response;

  factory _$CaptainPerformanceDtoOutputAcceptanceOffersInner([
    void Function(CaptainPerformanceDtoOutputAcceptanceOffersInnerBuilder)?
    updates,
  ]) =>
      (CaptainPerformanceDtoOutputAcceptanceOffersInnerBuilder()
            ..update(updates))
          ._build();

  _$CaptainPerformanceDtoOutputAcceptanceOffersInner._({
    required this.offeredAt,
    this.restaurantName,
    required this.response,
  }) : super._();
  @override
  CaptainPerformanceDtoOutputAcceptanceOffersInner rebuild(
    void Function(CaptainPerformanceDtoOutputAcceptanceOffersInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainPerformanceDtoOutputAcceptanceOffersInnerBuilder toBuilder() =>
      CaptainPerformanceDtoOutputAcceptanceOffersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainPerformanceDtoOutputAcceptanceOffersInner &&
        offeredAt == other.offeredAt &&
        restaurantName == other.restaurantName &&
        response == other.response;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, offeredAt.hashCode);
    _$hash = $jc(_$hash, restaurantName.hashCode);
    _$hash = $jc(_$hash, response.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainPerformanceDtoOutputAcceptanceOffersInner',
          )
          ..add('offeredAt', offeredAt)
          ..add('restaurantName', restaurantName)
          ..add('response', response))
        .toString();
  }
}

class CaptainPerformanceDtoOutputAcceptanceOffersInnerBuilder
    implements
        Builder<
          CaptainPerformanceDtoOutputAcceptanceOffersInner,
          CaptainPerformanceDtoOutputAcceptanceOffersInnerBuilder
        > {
  _$CaptainPerformanceDtoOutputAcceptanceOffersInner? _$v;

  DateTime? _offeredAt;
  DateTime? get offeredAt => _$this._offeredAt;
  set offeredAt(DateTime? offeredAt) => _$this._offeredAt = offeredAt;

  String? _restaurantName;
  String? get restaurantName => _$this._restaurantName;
  set restaurantName(String? restaurantName) =>
      _$this._restaurantName = restaurantName;

  CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum? _response;
  CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum? get response =>
      _$this._response;
  set response(
    CaptainPerformanceDtoOutputAcceptanceOffersInnerResponseEnum? response,
  ) => _$this._response = response;

  CaptainPerformanceDtoOutputAcceptanceOffersInnerBuilder() {
    CaptainPerformanceDtoOutputAcceptanceOffersInner._defaults(this);
  }

  CaptainPerformanceDtoOutputAcceptanceOffersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _offeredAt = $v.offeredAt;
      _restaurantName = $v.restaurantName;
      _response = $v.response;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainPerformanceDtoOutputAcceptanceOffersInner other) {
    _$v = other as _$CaptainPerformanceDtoOutputAcceptanceOffersInner;
  }

  @override
  void update(
    void Function(CaptainPerformanceDtoOutputAcceptanceOffersInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainPerformanceDtoOutputAcceptanceOffersInner build() => _build();

  _$CaptainPerformanceDtoOutputAcceptanceOffersInner _build() {
    final _$result =
        _$v ??
        _$CaptainPerformanceDtoOutputAcceptanceOffersInner._(
          offeredAt: BuiltValueNullFieldError.checkNotNull(
            offeredAt,
            r'CaptainPerformanceDtoOutputAcceptanceOffersInner',
            'offeredAt',
          ),
          restaurantName: restaurantName,
          response: BuiltValueNullFieldError.checkNotNull(
            response,
            r'CaptainPerformanceDtoOutputAcceptanceOffersInner',
            'response',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
