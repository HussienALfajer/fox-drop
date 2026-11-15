// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_settlement_dto_output_receipts_inner_conversions_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSettlementDtoOutputReceiptsInnerConversionsInner
    extends AdminSettlementDtoOutputReceiptsInnerConversionsInner {
  @override
  final String from;
  @override
  final String amount;
  @override
  final String to;
  @override
  final String converted;

  factory _$AdminSettlementDtoOutputReceiptsInnerConversionsInner([
    void Function(AdminSettlementDtoOutputReceiptsInnerConversionsInnerBuilder)?
    updates,
  ]) =>
      (AdminSettlementDtoOutputReceiptsInnerConversionsInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminSettlementDtoOutputReceiptsInnerConversionsInner._({
    required this.from,
    required this.amount,
    required this.to,
    required this.converted,
  }) : super._();
  @override
  AdminSettlementDtoOutputReceiptsInnerConversionsInner rebuild(
    void Function(AdminSettlementDtoOutputReceiptsInnerConversionsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSettlementDtoOutputReceiptsInnerConversionsInnerBuilder toBuilder() =>
      AdminSettlementDtoOutputReceiptsInnerConversionsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSettlementDtoOutputReceiptsInnerConversionsInner &&
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
            r'AdminSettlementDtoOutputReceiptsInnerConversionsInner',
          )
          ..add('from', from)
          ..add('amount', amount)
          ..add('to', to)
          ..add('converted', converted))
        .toString();
  }
}

class AdminSettlementDtoOutputReceiptsInnerConversionsInnerBuilder
    implements
        Builder<
          AdminSettlementDtoOutputReceiptsInnerConversionsInner,
          AdminSettlementDtoOutputReceiptsInnerConversionsInnerBuilder
        > {
  _$AdminSettlementDtoOutputReceiptsInnerConversionsInner? _$v;

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

  AdminSettlementDtoOutputReceiptsInnerConversionsInnerBuilder() {
    AdminSettlementDtoOutputReceiptsInnerConversionsInner._defaults(this);
  }

  AdminSettlementDtoOutputReceiptsInnerConversionsInnerBuilder get _$this {
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
  void replace(AdminSettlementDtoOutputReceiptsInnerConversionsInner other) {
    _$v = other as _$AdminSettlementDtoOutputReceiptsInnerConversionsInner;
  }

  @override
  void update(
    void Function(AdminSettlementDtoOutputReceiptsInnerConversionsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminSettlementDtoOutputReceiptsInnerConversionsInner build() => _build();

  _$AdminSettlementDtoOutputReceiptsInnerConversionsInner _build() {
    final _$result =
        _$v ??
        _$AdminSettlementDtoOutputReceiptsInnerConversionsInner._(
          from: BuiltValueNullFieldError.checkNotNull(
            from,
            r'AdminSettlementDtoOutputReceiptsInnerConversionsInner',
            'from',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminSettlementDtoOutputReceiptsInnerConversionsInner',
            'amount',
          ),
          to: BuiltValueNullFieldError.checkNotNull(
            to,
            r'AdminSettlementDtoOutputReceiptsInnerConversionsInner',
            'to',
          ),
          converted: BuiltValueNullFieldError.checkNotNull(
            converted,
            r'AdminSettlementDtoOutputReceiptsInnerConversionsInner',
            'converted',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
