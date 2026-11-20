// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_order_history_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainOrderHistoryDtoOutput extends CaptainOrderHistoryDtoOutput {
  @override
  final String payCurrency;
  @override
  final BuiltList<CaptainOrderHistoryDtoOutputOrdersInner> orders;
  @override
  final String? next;

  factory _$CaptainOrderHistoryDtoOutput([
    void Function(CaptainOrderHistoryDtoOutputBuilder)? updates,
  ]) => (CaptainOrderHistoryDtoOutputBuilder()..update(updates))._build();

  _$CaptainOrderHistoryDtoOutput._({
    required this.payCurrency,
    required this.orders,
    this.next,
  }) : super._();
  @override
  CaptainOrderHistoryDtoOutput rebuild(
    void Function(CaptainOrderHistoryDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainOrderHistoryDtoOutputBuilder toBuilder() =>
      CaptainOrderHistoryDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainOrderHistoryDtoOutput &&
        payCurrency == other.payCurrency &&
        orders == other.orders &&
        next == other.next;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, payCurrency.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, next.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainOrderHistoryDtoOutput')
          ..add('payCurrency', payCurrency)
          ..add('orders', orders)
          ..add('next', next))
        .toString();
  }
}

class CaptainOrderHistoryDtoOutputBuilder
    implements
        Builder<
          CaptainOrderHistoryDtoOutput,
          CaptainOrderHistoryDtoOutputBuilder
        > {
  _$CaptainOrderHistoryDtoOutput? _$v;

  String? _payCurrency;
  String? get payCurrency => _$this._payCurrency;
  set payCurrency(String? payCurrency) => _$this._payCurrency = payCurrency;

  ListBuilder<CaptainOrderHistoryDtoOutputOrdersInner>? _orders;
  ListBuilder<CaptainOrderHistoryDtoOutputOrdersInner> get orders =>
      _$this._orders ??= ListBuilder<CaptainOrderHistoryDtoOutputOrdersInner>();
  set orders(ListBuilder<CaptainOrderHistoryDtoOutputOrdersInner>? orders) =>
      _$this._orders = orders;

  String? _next;
  String? get next => _$this._next;
  set next(String? next) => _$this._next = next;

  CaptainOrderHistoryDtoOutputBuilder() {
    CaptainOrderHistoryDtoOutput._defaults(this);
  }

  CaptainOrderHistoryDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _payCurrency = $v.payCurrency;
      _orders = $v.orders.toBuilder();
      _next = $v.next;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainOrderHistoryDtoOutput other) {
    _$v = other as _$CaptainOrderHistoryDtoOutput;
  }

  @override
  void update(void Function(CaptainOrderHistoryDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainOrderHistoryDtoOutput build() => _build();

  _$CaptainOrderHistoryDtoOutput _build() {
    _$CaptainOrderHistoryDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CaptainOrderHistoryDtoOutput._(
            payCurrency: BuiltValueNullFieldError.checkNotNull(
              payCurrency,
              r'CaptainOrderHistoryDtoOutput',
              'payCurrency',
            ),
            orders: orders.build(),
            next: next,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'orders';
        orders.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainOrderHistoryDtoOutput',
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
