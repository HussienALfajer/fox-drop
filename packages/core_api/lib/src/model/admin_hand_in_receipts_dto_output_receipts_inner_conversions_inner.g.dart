// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_hand_in_receipts_dto_output_receipts_inner_conversions_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner
    extends AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner {
  @override
  final String from;
  @override
  final String amount;
  @override
  final String to;
  @override
  final String converted;

  factory _$AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner([
    void Function(
      AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInnerBuilder,
    )?
    updates,
  ]) =>
      (AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner._({
    required this.from,
    required this.amount,
    required this.to,
    required this.converted,
  }) : super._();
  @override
  AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner rebuild(
    void Function(
      AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInnerBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInnerBuilder
  toBuilder() =>
      AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner &&
        from == other.from &&
        amount == other.amount &&
        to == other.to &&
        converted == other.converted;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, converted.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner',
          )
          ..add('from', from)
          ..add('amount', amount)
          ..add('to', to)
          ..add('converted', converted))
        .toString();
  }
}

class AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInnerBuilder
    implements
        Builder<
          AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner,
          AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInnerBuilder
        > {
  _$AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner? _$v;

  String? _from;
  String? get from => _$this._from;
  set from(String? from) => _$this._from = from;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _to;
  String? get to => _$this._to;
  set to(String? to) => _$this._to = to;

  String? _converted;
  String? get converted => _$this._converted;
  set converted(String? converted) => _$this._converted = converted;

  AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInnerBuilder() {
    AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner._defaults(this);
  }

  AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _from = $v.from;
      _amount = $v.amount;
      _to = $v.to;
      _converted = $v.converted;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
    AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner other,
  ) {
    _$v = other as _$AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner;
  }

  @override
  void update(
    void Function(
      AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner build() => _build();

  _$AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner _build() {
    final _$result =
        _$v ??
        _$AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner._(
          from: BuiltValueNullFieldError.checkNotNull(
            from,
            r'AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner',
            'from',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner',
            'amount',
          ),
          to: BuiltValueNullFieldError.checkNotNull(
            to,
            r'AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner',
            'to',
          ),
          converted: BuiltValueNullFieldError.checkNotNull(
            converted,
            r'AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner',
            'converted',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
