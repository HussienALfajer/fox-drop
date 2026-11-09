// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_offer_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainOfferDtoOutput extends CaptainOfferDtoOutput {
  @override
  final CaptainOfferDtoOutputOffer offer;

  factory _$CaptainOfferDtoOutput([
    void Function(CaptainOfferDtoOutputBuilder)? updates,
  ]) => (CaptainOfferDtoOutputBuilder()..update(updates))._build();

  _$CaptainOfferDtoOutput._({required this.offer}) : super._();
  @override
  CaptainOfferDtoOutput rebuild(
    void Function(CaptainOfferDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainOfferDtoOutputBuilder toBuilder() =>
      CaptainOfferDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainOfferDtoOutput && offer == other.offer;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, offer.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CaptainOfferDtoOutput',
    )..add('offer', offer)).toString();
  }
}

class CaptainOfferDtoOutputBuilder
    implements Builder<CaptainOfferDtoOutput, CaptainOfferDtoOutputBuilder> {
  _$CaptainOfferDtoOutput? _$v;

  CaptainOfferDtoOutputOfferBuilder? _offer;
  CaptainOfferDtoOutputOfferBuilder get offer =>
      _$this._offer ??= CaptainOfferDtoOutputOfferBuilder();
  set offer(CaptainOfferDtoOutputOfferBuilder? offer) => _$this._offer = offer;

  CaptainOfferDtoOutputBuilder() {
    CaptainOfferDtoOutput._defaults(this);
  }

  CaptainOfferDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _offer = $v.offer.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainOfferDtoOutput other) {
    _$v = other as _$CaptainOfferDtoOutput;
  }

  @override
  void update(void Function(CaptainOfferDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainOfferDtoOutput build() => _build();

  _$CaptainOfferDtoOutput _build() {
    _$CaptainOfferDtoOutput _$result;
    try {
      _$result = _$v ?? _$CaptainOfferDtoOutput._(offer: offer.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'offer';
        offer.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainOfferDtoOutput',
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
