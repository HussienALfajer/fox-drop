// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_pickup_dispute_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantPickupDisputeDto extends MerchantPickupDisputeDto {
  @override
  final BuiltList<MerchantPickupDisputeDtoReceivedLinesInner> receivedLines;

  factory _$MerchantPickupDisputeDto([
    void Function(MerchantPickupDisputeDtoBuilder)? updates,
  ]) => (MerchantPickupDisputeDtoBuilder()..update(updates))._build();

  _$MerchantPickupDisputeDto._({required this.receivedLines}) : super._();
  @override
  MerchantPickupDisputeDto rebuild(
    void Function(MerchantPickupDisputeDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantPickupDisputeDtoBuilder toBuilder() =>
      MerchantPickupDisputeDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantPickupDisputeDto &&
        receivedLines == other.receivedLines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, receivedLines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MerchantPickupDisputeDto',
    )..add('receivedLines', receivedLines)).toString();
  }
}

class MerchantPickupDisputeDtoBuilder
    implements
        Builder<MerchantPickupDisputeDto, MerchantPickupDisputeDtoBuilder> {
  _$MerchantPickupDisputeDto? _$v;

  ListBuilder<MerchantPickupDisputeDtoReceivedLinesInner>? _receivedLines;
  ListBuilder<MerchantPickupDisputeDtoReceivedLinesInner> get receivedLines =>
      _$this._receivedLines ??=
          ListBuilder<MerchantPickupDisputeDtoReceivedLinesInner>();
  set receivedLines(
    ListBuilder<MerchantPickupDisputeDtoReceivedLinesInner>? receivedLines,
  ) => _$this._receivedLines = receivedLines;

  MerchantPickupDisputeDtoBuilder() {
    MerchantPickupDisputeDto._defaults(this);
  }

  MerchantPickupDisputeDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _receivedLines = $v.receivedLines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantPickupDisputeDto other) {
    _$v = other as _$MerchantPickupDisputeDto;
  }

  @override
  void update(void Function(MerchantPickupDisputeDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantPickupDisputeDto build() => _build();

  _$MerchantPickupDisputeDto _build() {
    _$MerchantPickupDisputeDto _$result;
    try {
      _$result =
          _$v ??
          _$MerchantPickupDisputeDto._(receivedLines: receivedLines.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'receivedLines';
        receivedLines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantPickupDisputeDto',
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
