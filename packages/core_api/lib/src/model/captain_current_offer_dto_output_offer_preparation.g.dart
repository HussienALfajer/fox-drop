// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_current_offer_dto_output_offer_preparation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainCurrentOfferDtoOutputOfferPreparation
    extends CaptainCurrentOfferDtoOutputOfferPreparation {
  @override
  final bool ready;
  @override
  final DateTime? readyAt;

  factory _$CaptainCurrentOfferDtoOutputOfferPreparation([
    void Function(CaptainCurrentOfferDtoOutputOfferPreparationBuilder)? updates,
  ]) => (CaptainCurrentOfferDtoOutputOfferPreparationBuilder()..update(updates))
      ._build();

  _$CaptainCurrentOfferDtoOutputOfferPreparation._({
    required this.ready,
    this.readyAt,
  }) : super._();
  @override
  CaptainCurrentOfferDtoOutputOfferPreparation rebuild(
    void Function(CaptainCurrentOfferDtoOutputOfferPreparationBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainCurrentOfferDtoOutputOfferPreparationBuilder toBuilder() =>
      CaptainCurrentOfferDtoOutputOfferPreparationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainCurrentOfferDtoOutputOfferPreparation &&
        ready == other.ready &&
        readyAt == other.readyAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ready.hashCode);
    _$hash = $jc(_$hash, readyAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainCurrentOfferDtoOutputOfferPreparation',
          )
          ..add('ready', ready)
          ..add('readyAt', readyAt))
        .toString();
  }
}

class CaptainCurrentOfferDtoOutputOfferPreparationBuilder
    implements
        Builder<
          CaptainCurrentOfferDtoOutputOfferPreparation,
          CaptainCurrentOfferDtoOutputOfferPreparationBuilder
        > {
  _$CaptainCurrentOfferDtoOutputOfferPreparation? _$v;

  bool? _ready;
  bool? get ready => _$this._ready;
  set ready(bool? ready) => _$this._ready = ready;

  DateTime? _readyAt;
  DateTime? get readyAt => _$this._readyAt;
  set readyAt(DateTime? readyAt) => _$this._readyAt = readyAt;

  CaptainCurrentOfferDtoOutputOfferPreparationBuilder() {
    CaptainCurrentOfferDtoOutputOfferPreparation._defaults(this);
  }

  CaptainCurrentOfferDtoOutputOfferPreparationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ready = $v.ready;
      _readyAt = $v.readyAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainCurrentOfferDtoOutputOfferPreparation other) {
    _$v = other as _$CaptainCurrentOfferDtoOutputOfferPreparation;
  }

  @override
  void update(
    void Function(CaptainCurrentOfferDtoOutputOfferPreparationBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainCurrentOfferDtoOutputOfferPreparation build() => _build();

  _$CaptainCurrentOfferDtoOutputOfferPreparation _build() {
    final _$result =
        _$v ??
        _$CaptainCurrentOfferDtoOutputOfferPreparation._(
          ready: BuiltValueNullFieldError.checkNotNull(
            ready,
            r'CaptainCurrentOfferDtoOutputOfferPreparation',
            'ready',
          ),
          readyAt: readyAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
