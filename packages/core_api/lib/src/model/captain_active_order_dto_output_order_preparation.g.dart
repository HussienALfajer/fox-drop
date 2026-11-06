// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_order_preparation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainActiveOrderDtoOutputOrderPreparation
    extends CaptainActiveOrderDtoOutputOrderPreparation {
  @override
  final bool ready;
  @override
  final DateTime? readyAt;
  @override
  final DateTime prepDueAt;

  factory _$CaptainActiveOrderDtoOutputOrderPreparation([
    void Function(CaptainActiveOrderDtoOutputOrderPreparationBuilder)? updates,
  ]) => (CaptainActiveOrderDtoOutputOrderPreparationBuilder()..update(updates))
      ._build();

  _$CaptainActiveOrderDtoOutputOrderPreparation._({
    required this.ready,
    this.readyAt,
    required this.prepDueAt,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputOrderPreparation rebuild(
    void Function(CaptainActiveOrderDtoOutputOrderPreparationBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputOrderPreparationBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputOrderPreparationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputOrderPreparation &&
        ready == other.ready &&
        readyAt == other.readyAt &&
        prepDueAt == other.prepDueAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ready.hashCode);
    _$hash = $jc(_$hash, readyAt.hashCode);
    _$hash = $jc(_$hash, prepDueAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainActiveOrderDtoOutputOrderPreparation',
          )
          ..add('ready', ready)
          ..add('readyAt', readyAt)
          ..add('prepDueAt', prepDueAt))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputOrderPreparationBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputOrderPreparation,
          CaptainActiveOrderDtoOutputOrderPreparationBuilder
        > {
  _$CaptainActiveOrderDtoOutputOrderPreparation? _$v;

  bool? _ready;
  bool? get ready => _$this._ready;
  set ready(bool? ready) => _$this._ready = ready;

  DateTime? _readyAt;
  DateTime? get readyAt => _$this._readyAt;
  set readyAt(DateTime? readyAt) => _$this._readyAt = readyAt;

  DateTime? _prepDueAt;
  DateTime? get prepDueAt => _$this._prepDueAt;
  set prepDueAt(DateTime? prepDueAt) => _$this._prepDueAt = prepDueAt;

  CaptainActiveOrderDtoOutputOrderPreparationBuilder() {
    CaptainActiveOrderDtoOutputOrderPreparation._defaults(this);
  }

  CaptainActiveOrderDtoOutputOrderPreparationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ready = $v.ready;
      _readyAt = $v.readyAt;
      _prepDueAt = $v.prepDueAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputOrderPreparation other) {
    _$v = other as _$CaptainActiveOrderDtoOutputOrderPreparation;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputOrderPreparationBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputOrderPreparation build() => _build();

  _$CaptainActiveOrderDtoOutputOrderPreparation _build() {
    final _$result =
        _$v ??
        _$CaptainActiveOrderDtoOutputOrderPreparation._(
          ready: BuiltValueNullFieldError.checkNotNull(
            ready,
            r'CaptainActiveOrderDtoOutputOrderPreparation',
            'ready',
          ),
          readyAt: readyAt,
          prepDueAt: BuiltValueNullFieldError.checkNotNull(
            prepDueAt,
            r'CaptainActiveOrderDtoOutputOrderPreparation',
            'prepDueAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
