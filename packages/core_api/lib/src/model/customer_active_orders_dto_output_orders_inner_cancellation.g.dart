// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner_cancellation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerActiveOrdersDtoOutputOrdersInnerCancellation
    extends CustomerActiveOrdersDtoOutputOrdersInnerCancellation {
  @override
  final DateTime at;
  @override
  final String reason;
  @override
  final String text;

  factory _$CustomerActiveOrdersDtoOutputOrdersInnerCancellation([
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerCancellationBuilder)?
    updates,
  ]) =>
      (CustomerActiveOrdersDtoOutputOrdersInnerCancellationBuilder()
            ..update(updates))
          ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerCancellation._({
    required this.at,
    required this.reason,
    required this.text,
  }) : super._();
  @override
  CustomerActiveOrdersDtoOutputOrdersInnerCancellation rebuild(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerCancellationBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerCancellationBuilder toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerCancellationBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerActiveOrdersDtoOutputOrdersInnerCancellation &&
        at == other.at &&
        reason == other.reason &&
        text == other.text;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerActiveOrdersDtoOutputOrdersInnerCancellation',
          )
          ..add('at', at)
          ..add('reason', reason)
          ..add('text', text))
        .toString();
  }
}

class CustomerActiveOrdersDtoOutputOrdersInnerCancellationBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInnerCancellation,
          CustomerActiveOrdersDtoOutputOrdersInnerCancellationBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInnerCancellation? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  CustomerActiveOrdersDtoOutputOrdersInnerCancellationBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInnerCancellation._defaults(this);
  }

  CustomerActiveOrdersDtoOutputOrdersInnerCancellationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _reason = $v.reason;
      _text = $v.text;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerActiveOrdersDtoOutputOrdersInnerCancellation other) {
    _$v = other as _$CustomerActiveOrdersDtoOutputOrdersInnerCancellation;
  }

  @override
  void update(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerCancellationBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerCancellation build() => _build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerCancellation _build() {
    final _$result =
        _$v ??
        _$CustomerActiveOrdersDtoOutputOrdersInnerCancellation._(
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'CustomerActiveOrdersDtoOutputOrdersInnerCancellation',
            'at',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'CustomerActiveOrdersDtoOutputOrdersInnerCancellation',
            'reason',
          ),
          text: BuiltValueNullFieldError.checkNotNull(
            text,
            r'CustomerActiveOrdersDtoOutputOrdersInnerCancellation',
            'text',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
