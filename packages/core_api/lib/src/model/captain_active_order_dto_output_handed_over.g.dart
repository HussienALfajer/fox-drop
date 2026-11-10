// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_handed_over.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainActiveOrderDtoOutputHandedOver
    extends CaptainActiveOrderDtoOutputHandedOver {
  @override
  final String orderId;
  @override
  final String number;
  @override
  final String toCaptainName;
  @override
  final DateTime at;

  factory _$CaptainActiveOrderDtoOutputHandedOver([
    void Function(CaptainActiveOrderDtoOutputHandedOverBuilder)? updates,
  ]) => (CaptainActiveOrderDtoOutputHandedOverBuilder()..update(updates))
      ._build();

  _$CaptainActiveOrderDtoOutputHandedOver._({
    required this.orderId,
    required this.number,
    required this.toCaptainName,
    required this.at,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputHandedOver rebuild(
    void Function(CaptainActiveOrderDtoOutputHandedOverBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputHandedOverBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputHandedOverBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputHandedOver &&
        orderId == other.orderId &&
        number == other.number &&
        toCaptainName == other.toCaptainName &&
        at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, toCaptainName.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainActiveOrderDtoOutputHandedOver',
          )
          ..add('orderId', orderId)
          ..add('number', number)
          ..add('toCaptainName', toCaptainName)
          ..add('at', at))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputHandedOverBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputHandedOver,
          CaptainActiveOrderDtoOutputHandedOverBuilder
        > {
  _$CaptainActiveOrderDtoOutputHandedOver? _$v;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  String? _toCaptainName;
  String? get toCaptainName => _$this._toCaptainName;
  set toCaptainName(String? toCaptainName) =>
      _$this._toCaptainName = toCaptainName;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  CaptainActiveOrderDtoOutputHandedOverBuilder() {
    CaptainActiveOrderDtoOutputHandedOver._defaults(this);
  }

  CaptainActiveOrderDtoOutputHandedOverBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderId = $v.orderId;
      _number = $v.number;
      _toCaptainName = $v.toCaptainName;
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputHandedOver other) {
    _$v = other as _$CaptainActiveOrderDtoOutputHandedOver;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputHandedOverBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputHandedOver build() => _build();

  _$CaptainActiveOrderDtoOutputHandedOver _build() {
    final _$result =
        _$v ??
        _$CaptainActiveOrderDtoOutputHandedOver._(
          orderId: BuiltValueNullFieldError.checkNotNull(
            orderId,
            r'CaptainActiveOrderDtoOutputHandedOver',
            'orderId',
          ),
          number: BuiltValueNullFieldError.checkNotNull(
            number,
            r'CaptainActiveOrderDtoOutputHandedOver',
            'number',
          ),
          toCaptainName: BuiltValueNullFieldError.checkNotNull(
            toCaptainName,
            r'CaptainActiveOrderDtoOutputHandedOver',
            'toCaptainName',
          ),
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'CaptainActiveOrderDtoOutputHandedOver',
            'at',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
