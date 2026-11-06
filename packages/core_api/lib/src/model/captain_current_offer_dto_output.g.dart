// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_current_offer_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainCurrentOfferDtoOutput extends CaptainCurrentOfferDtoOutput {
  @override
  final CaptainCurrentOfferDtoOutputOffer? offer;

  factory _$CaptainCurrentOfferDtoOutput([
    void Function(CaptainCurrentOfferDtoOutputBuilder)? updates,
  ]) => (CaptainCurrentOfferDtoOutputBuilder()..update(updates))._build();

  _$CaptainCurrentOfferDtoOutput._({this.offer}) : super._();
  @override
  CaptainCurrentOfferDtoOutput rebuild(
    void Function(CaptainCurrentOfferDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainCurrentOfferDtoOutputBuilder toBuilder() =>
      CaptainCurrentOfferDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainCurrentOfferDtoOutput && offer == other.offer;
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
      r'CaptainCurrentOfferDtoOutput',
    )..add('offer', offer)).toString();
  }
}

class CaptainCurrentOfferDtoOutputBuilder
    implements
        Builder<
          CaptainCurrentOfferDtoOutput,
          CaptainCurrentOfferDtoOutputBuilder
        > {
  _$CaptainCurrentOfferDtoOutput? _$v;

  CaptainCurrentOfferDtoOutputOfferBuilder? _offer;
  CaptainCurrentOfferDtoOutputOfferBuilder get offer =>
      _$this._offer ??= CaptainCurrentOfferDtoOutputOfferBuilder();
  set offer(CaptainCurrentOfferDtoOutputOfferBuilder? offer) =>
      _$this._offer = offer;

  CaptainCurrentOfferDtoOutputBuilder() {
    CaptainCurrentOfferDtoOutput._defaults(this);
  }

  CaptainCurrentOfferDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _offer = $v.offer?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainCurrentOfferDtoOutput other) {
    _$v = other as _$CaptainCurrentOfferDtoOutput;
  }

  @override
  void update(void Function(CaptainCurrentOfferDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainCurrentOfferDtoOutput build() => _build();

  _$CaptainCurrentOfferDtoOutput _build() {
    _$CaptainCurrentOfferDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$CaptainCurrentOfferDtoOutput._(offer: _offer?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'offer';
        _offer?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainCurrentOfferDtoOutput',
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
