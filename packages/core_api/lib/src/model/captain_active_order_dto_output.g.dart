// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainActiveOrderDtoOutput extends CaptainActiveOrderDtoOutput {
  @override
  final CaptainActiveOrderDtoOutputOrder? order;
  @override
  final CaptainActiveOrderDtoOutputCancelled? cancelled;
  @override
  final CaptainActiveOrderDtoOutputWithdrawn? withdrawn;
  @override
  final CaptainActiveOrderDtoOutputEnded? ended;

  factory _$CaptainActiveOrderDtoOutput([
    void Function(CaptainActiveOrderDtoOutputBuilder)? updates,
  ]) => (CaptainActiveOrderDtoOutputBuilder()..update(updates))._build();

  _$CaptainActiveOrderDtoOutput._({
    this.order,
    this.cancelled,
    this.withdrawn,
    this.ended,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutput rebuild(
    void Function(CaptainActiveOrderDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutput &&
        order == other.order &&
        cancelled == other.cancelled &&
        withdrawn == other.withdrawn &&
        ended == other.ended;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, order.hashCode);
    _$hash = $jc(_$hash, cancelled.hashCode);
    _$hash = $jc(_$hash, withdrawn.hashCode);
    _$hash = $jc(_$hash, ended.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainActiveOrderDtoOutput')
          ..add('order', order)
          ..add('cancelled', cancelled)
          ..add('withdrawn', withdrawn)
          ..add('ended', ended))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutput,
          CaptainActiveOrderDtoOutputBuilder
        > {
  _$CaptainActiveOrderDtoOutput? _$v;

  CaptainActiveOrderDtoOutputOrderBuilder? _order;
  CaptainActiveOrderDtoOutputOrderBuilder get order =>
      _$this._order ??= CaptainActiveOrderDtoOutputOrderBuilder();
  set order(CaptainActiveOrderDtoOutputOrderBuilder? order) =>
      _$this._order = order;

  CaptainActiveOrderDtoOutputCancelledBuilder? _cancelled;
  CaptainActiveOrderDtoOutputCancelledBuilder get cancelled =>
      _$this._cancelled ??= CaptainActiveOrderDtoOutputCancelledBuilder();
  set cancelled(CaptainActiveOrderDtoOutputCancelledBuilder? cancelled) =>
      _$this._cancelled = cancelled;

  CaptainActiveOrderDtoOutputWithdrawnBuilder? _withdrawn;
  CaptainActiveOrderDtoOutputWithdrawnBuilder get withdrawn =>
      _$this._withdrawn ??= CaptainActiveOrderDtoOutputWithdrawnBuilder();
  set withdrawn(CaptainActiveOrderDtoOutputWithdrawnBuilder? withdrawn) =>
      _$this._withdrawn = withdrawn;

  CaptainActiveOrderDtoOutputEndedBuilder? _ended;
  CaptainActiveOrderDtoOutputEndedBuilder get ended =>
      _$this._ended ??= CaptainActiveOrderDtoOutputEndedBuilder();
  set ended(CaptainActiveOrderDtoOutputEndedBuilder? ended) =>
      _$this._ended = ended;

  CaptainActiveOrderDtoOutputBuilder() {
    CaptainActiveOrderDtoOutput._defaults(this);
  }

  CaptainActiveOrderDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _order = $v.order?.toBuilder();
      _cancelled = $v.cancelled?.toBuilder();
      _withdrawn = $v.withdrawn?.toBuilder();
      _ended = $v.ended?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutput other) {
    _$v = other as _$CaptainActiveOrderDtoOutput;
  }

  @override
  void update(void Function(CaptainActiveOrderDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutput build() => _build();

  _$CaptainActiveOrderDtoOutput _build() {
    _$CaptainActiveOrderDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CaptainActiveOrderDtoOutput._(
            order: _order?.build(),
            cancelled: _cancelled?.build(),
            withdrawn: _withdrawn?.build(),
            ended: _ended?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'order';
        _order?.build();
        _$failedField = 'cancelled';
        _cancelled?.build();
        _$failedField = 'withdrawn';
        _withdrawn?.build();
        _$failedField = 'ended';
        _ended?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainActiveOrderDtoOutput',
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
