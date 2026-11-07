// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_content_dto_output_reasons.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantContentDtoOutputReasons
    extends MerchantContentDtoOutputReasons {
  @override
  final BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  merchantRejection;
  @override
  final BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  merchantProblem;
  @override
  final BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  itemUnavailableNote;
  @override
  final BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  merchantTicketType;

  factory _$MerchantContentDtoOutputReasons([
    void Function(MerchantContentDtoOutputReasonsBuilder)? updates,
  ]) => (MerchantContentDtoOutputReasonsBuilder()..update(updates))._build();

  _$MerchantContentDtoOutputReasons._({
    required this.merchantRejection,
    required this.merchantProblem,
    required this.itemUnavailableNote,
    required this.merchantTicketType,
  }) : super._();
  @override
  MerchantContentDtoOutputReasons rebuild(
    void Function(MerchantContentDtoOutputReasonsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantContentDtoOutputReasonsBuilder toBuilder() =>
      MerchantContentDtoOutputReasonsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantContentDtoOutputReasons &&
        merchantRejection == other.merchantRejection &&
        merchantProblem == other.merchantProblem &&
        itemUnavailableNote == other.itemUnavailableNote &&
        merchantTicketType == other.merchantTicketType;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, merchantRejection.hashCode);
    _$hash = $jc(_$hash, merchantProblem.hashCode);
    _$hash = $jc(_$hash, itemUnavailableNote.hashCode);
    _$hash = $jc(_$hash, merchantTicketType.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantContentDtoOutputReasons')
          ..add('merchantRejection', merchantRejection)
          ..add('merchantProblem', merchantProblem)
          ..add('itemUnavailableNote', itemUnavailableNote)
          ..add('merchantTicketType', merchantTicketType))
        .toString();
  }
}

class MerchantContentDtoOutputReasonsBuilder
    implements
        Builder<
          MerchantContentDtoOutputReasons,
          MerchantContentDtoOutputReasonsBuilder
        > {
  _$MerchantContentDtoOutputReasons? _$v;

  ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>?
  _merchantRejection;
  ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  get merchantRejection => _$this._merchantRejection ??=
      ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>();
  set merchantRejection(
    ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>?
    merchantRejection,
  ) => _$this._merchantRejection = merchantRejection;

  ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>?
  _merchantProblem;
  ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  get merchantProblem => _$this._merchantProblem ??=
      ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>();
  set merchantProblem(
    ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>?
    merchantProblem,
  ) => _$this._merchantProblem = merchantProblem;

  ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>?
  _itemUnavailableNote;
  ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  get itemUnavailableNote => _$this._itemUnavailableNote ??=
      ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>();
  set itemUnavailableNote(
    ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>?
    itemUnavailableNote,
  ) => _$this._itemUnavailableNote = itemUnavailableNote;

  ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>?
  _merchantTicketType;
  ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  get merchantTicketType => _$this._merchantTicketType ??=
      ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>();
  set merchantTicketType(
    ListBuilder<MerchantContentDtoOutputReasonsMerchantRejectionInner>?
    merchantTicketType,
  ) => _$this._merchantTicketType = merchantTicketType;

  MerchantContentDtoOutputReasonsBuilder() {
    MerchantContentDtoOutputReasons._defaults(this);
  }

  MerchantContentDtoOutputReasonsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _merchantRejection = $v.merchantRejection.toBuilder();
      _merchantProblem = $v.merchantProblem.toBuilder();
      _itemUnavailableNote = $v.itemUnavailableNote.toBuilder();
      _merchantTicketType = $v.merchantTicketType.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantContentDtoOutputReasons other) {
    _$v = other as _$MerchantContentDtoOutputReasons;
  }

  @override
  void update(void Function(MerchantContentDtoOutputReasonsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantContentDtoOutputReasons build() => _build();

  _$MerchantContentDtoOutputReasons _build() {
    _$MerchantContentDtoOutputReasons _$result;
    try {
      _$result =
          _$v ??
          _$MerchantContentDtoOutputReasons._(
            merchantRejection: merchantRejection.build(),
            merchantProblem: merchantProblem.build(),
            itemUnavailableNote: itemUnavailableNote.build(),
            merchantTicketType: merchantTicketType.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'merchantRejection';
        merchantRejection.build();
        _$failedField = 'merchantProblem';
        merchantProblem.build();
        _$failedField = 'itemUnavailableNote';
        itemUnavailableNote.build();
        _$failedField = 'merchantTicketType';
        merchantTicketType.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantContentDtoOutputReasons',
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
