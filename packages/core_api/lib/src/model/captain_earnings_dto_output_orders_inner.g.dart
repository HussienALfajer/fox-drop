// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_earnings_dto_output_orders_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainEarningsDtoOutputOrdersInner
    extends CaptainEarningsDtoOutputOrdersInner {
  @override
  final String? orderNumber;
  @override
  final DateTime at;
  @override
  final CaptainEarningsDtoOutputOrdersInnerParts? parts;
  @override
  final String total;

  factory _$CaptainEarningsDtoOutputOrdersInner([
    void Function(CaptainEarningsDtoOutputOrdersInnerBuilder)? updates,
  ]) =>
      (CaptainEarningsDtoOutputOrdersInnerBuilder()..update(updates))._build();

  _$CaptainEarningsDtoOutputOrdersInner._({
    this.orderNumber,
    required this.at,
    this.parts,
    required this.total,
  }) : super._();
  @override
  CaptainEarningsDtoOutputOrdersInner rebuild(
    void Function(CaptainEarningsDtoOutputOrdersInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainEarningsDtoOutputOrdersInnerBuilder toBuilder() =>
      CaptainEarningsDtoOutputOrdersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainEarningsDtoOutputOrdersInner &&
        orderNumber == other.orderNumber &&
        at == other.at &&
        parts == other.parts &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderNumber.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, parts.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainEarningsDtoOutputOrdersInner')
          ..add('orderNumber', orderNumber)
          ..add('at', at)
          ..add('parts', parts)
          ..add('total', total))
        .toString();
  }
}

class CaptainEarningsDtoOutputOrdersInnerBuilder
    implements
        Builder<
          CaptainEarningsDtoOutputOrdersInner,
          CaptainEarningsDtoOutputOrdersInnerBuilder
        > {
  _$CaptainEarningsDtoOutputOrdersInner? _$v;

  String? _orderNumber;
  String? get orderNumber => _$this._orderNumber;
  set orderNumber(String? orderNumber) => _$this._orderNumber = orderNumber;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  CaptainEarningsDtoOutputOrdersInnerPartsBuilder? _parts;
  CaptainEarningsDtoOutputOrdersInnerPartsBuilder get parts =>
      _$this._parts ??= CaptainEarningsDtoOutputOrdersInnerPartsBuilder();
  set parts(CaptainEarningsDtoOutputOrdersInnerPartsBuilder? parts) =>
      _$this._parts = parts;

  String? _total;
  String? get total => _$this._total;
  set total(String? total) => _$this._total = total;

  CaptainEarningsDtoOutputOrdersInnerBuilder() {
    CaptainEarningsDtoOutputOrdersInner._defaults(this);
  }

  CaptainEarningsDtoOutputOrdersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderNumber = $v.orderNumber;
      _at = $v.at;
      _parts = $v.parts?.toBuilder();
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainEarningsDtoOutputOrdersInner other) {
    _$v = other as _$CaptainEarningsDtoOutputOrdersInner;
  }

  @override
  void update(
    void Function(CaptainEarningsDtoOutputOrdersInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainEarningsDtoOutputOrdersInner build() => _build();

  _$CaptainEarningsDtoOutputOrdersInner _build() {
    _$CaptainEarningsDtoOutputOrdersInner _$result;
    try {
      _$result =
          _$v ??
          _$CaptainEarningsDtoOutputOrdersInner._(
            orderNumber: orderNumber,
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'CaptainEarningsDtoOutputOrdersInner',
              'at',
            ),
            parts: _parts?.build(),
            total: BuiltValueNullFieldError.checkNotNull(
              total,
              r'CaptainEarningsDtoOutputOrdersInner',
              'total',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'parts';
        _parts?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainEarningsDtoOutputOrdersInner',
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
