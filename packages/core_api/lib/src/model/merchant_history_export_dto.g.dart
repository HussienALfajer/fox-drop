// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_history_export_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantHistoryExportDtoStatusEnum
_$merchantHistoryExportDtoStatusEnum_placed =
    const MerchantHistoryExportDtoStatusEnum._('placed');
const MerchantHistoryExportDtoStatusEnum
_$merchantHistoryExportDtoStatusEnum_accepted =
    const MerchantHistoryExportDtoStatusEnum._('accepted');
const MerchantHistoryExportDtoStatusEnum
_$merchantHistoryExportDtoStatusEnum_ready =
    const MerchantHistoryExportDtoStatusEnum._('ready');
const MerchantHistoryExportDtoStatusEnum
_$merchantHistoryExportDtoStatusEnum_pickedUp =
    const MerchantHistoryExportDtoStatusEnum._('pickedUp');
const MerchantHistoryExportDtoStatusEnum
_$merchantHistoryExportDtoStatusEnum_arrived =
    const MerchantHistoryExportDtoStatusEnum._('arrived');
const MerchantHistoryExportDtoStatusEnum
_$merchantHistoryExportDtoStatusEnum_delivered =
    const MerchantHistoryExportDtoStatusEnum._('delivered');
const MerchantHistoryExportDtoStatusEnum
_$merchantHistoryExportDtoStatusEnum_rejected =
    const MerchantHistoryExportDtoStatusEnum._('rejected');
const MerchantHistoryExportDtoStatusEnum
_$merchantHistoryExportDtoStatusEnum_cancelled =
    const MerchantHistoryExportDtoStatusEnum._('cancelled');
const MerchantHistoryExportDtoStatusEnum
_$merchantHistoryExportDtoStatusEnum_failed =
    const MerchantHistoryExportDtoStatusEnum._('failed');

MerchantHistoryExportDtoStatusEnum _$merchantHistoryExportDtoStatusEnumValueOf(
  String name,
) {
  switch (name) {
    case 'placed':
      return _$merchantHistoryExportDtoStatusEnum_placed;
    case 'accepted':
      return _$merchantHistoryExportDtoStatusEnum_accepted;
    case 'ready':
      return _$merchantHistoryExportDtoStatusEnum_ready;
    case 'pickedUp':
      return _$merchantHistoryExportDtoStatusEnum_pickedUp;
    case 'arrived':
      return _$merchantHistoryExportDtoStatusEnum_arrived;
    case 'delivered':
      return _$merchantHistoryExportDtoStatusEnum_delivered;
    case 'rejected':
      return _$merchantHistoryExportDtoStatusEnum_rejected;
    case 'cancelled':
      return _$merchantHistoryExportDtoStatusEnum_cancelled;
    case 'failed':
      return _$merchantHistoryExportDtoStatusEnum_failed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantHistoryExportDtoStatusEnum>
_$merchantHistoryExportDtoStatusEnumValues =
    BuiltSet<MerchantHistoryExportDtoStatusEnum>(
      const <MerchantHistoryExportDtoStatusEnum>[
        _$merchantHistoryExportDtoStatusEnum_placed,
        _$merchantHistoryExportDtoStatusEnum_accepted,
        _$merchantHistoryExportDtoStatusEnum_ready,
        _$merchantHistoryExportDtoStatusEnum_pickedUp,
        _$merchantHistoryExportDtoStatusEnum_arrived,
        _$merchantHistoryExportDtoStatusEnum_delivered,
        _$merchantHistoryExportDtoStatusEnum_rejected,
        _$merchantHistoryExportDtoStatusEnum_cancelled,
        _$merchantHistoryExportDtoStatusEnum_failed,
      ],
    );

Serializer<MerchantHistoryExportDtoStatusEnum>
_$merchantHistoryExportDtoStatusEnumSerializer =
    _$MerchantHistoryExportDtoStatusEnumSerializer();

class _$MerchantHistoryExportDtoStatusEnumSerializer
    implements PrimitiveSerializer<MerchantHistoryExportDtoStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'placed': 'placed',
    'accepted': 'accepted',
    'ready': 'ready',
    'pickedUp': 'picked_up',
    'arrived': 'arrived',
    'delivered': 'delivered',
    'rejected': 'rejected',
    'cancelled': 'cancelled',
    'failed': 'failed',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'placed': 'placed',
    'accepted': 'accepted',
    'ready': 'ready',
    'picked_up': 'pickedUp',
    'arrived': 'arrived',
    'delivered': 'delivered',
    'rejected': 'rejected',
    'cancelled': 'cancelled',
    'failed': 'failed',
  };

  @override
  final Iterable<Type> types = const <Type>[MerchantHistoryExportDtoStatusEnum];
  @override
  final String wireName = 'MerchantHistoryExportDtoStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantHistoryExportDtoStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantHistoryExportDtoStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantHistoryExportDtoStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantHistoryExportDto extends MerchantHistoryExportDto {
  @override
  final String from;
  @override
  final String to;
  @override
  final MerchantHistoryExportDtoStatusEnum? status;
  @override
  final String? number;

  factory _$MerchantHistoryExportDto([
    void Function(MerchantHistoryExportDtoBuilder)? updates,
  ]) => (MerchantHistoryExportDtoBuilder()..update(updates))._build();

  _$MerchantHistoryExportDto._({
    required this.from,
    required this.to,
    this.status,
    this.number,
  }) : super._();
  @override
  MerchantHistoryExportDto rebuild(
    void Function(MerchantHistoryExportDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantHistoryExportDtoBuilder toBuilder() =>
      MerchantHistoryExportDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantHistoryExportDto &&
        from == other.from &&
        to == other.to &&
        status == other.status &&
        number == other.number;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantHistoryExportDto')
          ..add('from', from)
          ..add('to', to)
          ..add('status', status)
          ..add('number', number))
        .toString();
  }
}

class MerchantHistoryExportDtoBuilder
    implements
        Builder<MerchantHistoryExportDto, MerchantHistoryExportDtoBuilder> {
  _$MerchantHistoryExportDto? _$v;

  String? _from;
  String? get from => _$this._from;
  set from(String? from) => _$this._from = from;

  String? _to;
  String? get to => _$this._to;
  set to(String? to) => _$this._to = to;

  MerchantHistoryExportDtoStatusEnum? _status;
  MerchantHistoryExportDtoStatusEnum? get status => _$this._status;
  set status(MerchantHistoryExportDtoStatusEnum? status) =>
      _$this._status = status;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  MerchantHistoryExportDtoBuilder() {
    MerchantHistoryExportDto._defaults(this);
  }

  MerchantHistoryExportDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _from = $v.from;
      _to = $v.to;
      _status = $v.status;
      _number = $v.number;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantHistoryExportDto other) {
    _$v = other as _$MerchantHistoryExportDto;
  }

  @override
  void update(void Function(MerchantHistoryExportDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantHistoryExportDto build() => _build();

  _$MerchantHistoryExportDto _build() {
    final _$result =
        _$v ??
        _$MerchantHistoryExportDto._(
          from: BuiltValueNullFieldError.checkNotNull(
            from,
            r'MerchantHistoryExportDto',
            'from',
          ),
          to: BuiltValueNullFieldError.checkNotNull(
            to,
            r'MerchantHistoryExportDto',
            'to',
          ),
          status: status,
          number: number,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
