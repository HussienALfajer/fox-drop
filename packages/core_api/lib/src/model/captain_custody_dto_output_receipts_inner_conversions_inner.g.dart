// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_custody_dto_output_receipts_inner_conversions_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainCustodyDtoOutputReceiptsInnerConversionsInner
    extends CaptainCustodyDtoOutputReceiptsInnerConversionsInner {
  @override
  final String from;
  @override
  final String amount;
  @override
  final String to;
  @override
  final String converted;

  factory _$CaptainCustodyDtoOutputReceiptsInnerConversionsInner([
    void Function(CaptainCustodyDtoOutputReceiptsInnerConversionsInnerBuilder)?
    updates,
  ]) =>
      (CaptainCustodyDtoOutputReceiptsInnerConversionsInnerBuilder()
            ..update(updates))
          ._build();

  _$CaptainCustodyDtoOutputReceiptsInnerConversionsInner._({
    required this.from,
    required this.amount,
    required this.to,
    required this.converted,
  }) : super._();
  @override
  CaptainCustodyDtoOutputReceiptsInnerConversionsInner rebuild(
    void Function(CaptainCustodyDtoOutputReceiptsInnerConversionsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainCustodyDtoOutputReceiptsInnerConversionsInnerBuilder toBuilder() =>
      CaptainCustodyDtoOutputReceiptsInnerConversionsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainCustodyDtoOutputReceiptsInnerConversionsInner &&
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
            r'CaptainCustodyDtoOutputReceiptsInnerConversionsInner',
          )
          ..add('from', from)
          ..add('amount', amount)
          ..add('to', to)
          ..add('converted', converted))
        .toString();
  }
}

class CaptainCustodyDtoOutputReceiptsInnerConversionsInnerBuilder
    implements
        Builder<
          CaptainCustodyDtoOutputReceiptsInnerConversionsInner,
          CaptainCustodyDtoOutputReceiptsInnerConversionsInnerBuilder
        > {
  _$CaptainCustodyDtoOutputReceiptsInnerConversionsInner? _$v;

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

  CaptainCustodyDtoOutputReceiptsInnerConversionsInnerBuilder() {
    CaptainCustodyDtoOutputReceiptsInnerConversionsInner._defaults(this);
  }

  CaptainCustodyDtoOutputReceiptsInnerConversionsInnerBuilder get _$this {
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
  void replace(CaptainCustodyDtoOutputReceiptsInnerConversionsInner other) {
    _$v = other as _$CaptainCustodyDtoOutputReceiptsInnerConversionsInner;
  }

  @override
  void update(
    void Function(CaptainCustodyDtoOutputReceiptsInnerConversionsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainCustodyDtoOutputReceiptsInnerConversionsInner build() => _build();

  _$CaptainCustodyDtoOutputReceiptsInnerConversionsInner _build() {
    final _$result =
        _$v ??
        _$CaptainCustodyDtoOutputReceiptsInnerConversionsInner._(
          from: BuiltValueNullFieldError.checkNotNull(
            from,
            r'CaptainCustodyDtoOutputReceiptsInnerConversionsInner',
            'from',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainCustodyDtoOutputReceiptsInnerConversionsInner',
            'amount',
          ),
          to: BuiltValueNullFieldError.checkNotNull(
            to,
            r'CaptainCustodyDtoOutputReceiptsInnerConversionsInner',
            'to',
          ),
          converted: BuiltValueNullFieldError.checkNotNull(
            converted,
            r'CaptainCustodyDtoOutputReceiptsInnerConversionsInner',
            'converted',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
