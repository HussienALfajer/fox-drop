// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sender_pool_dto_output_numbers_inner_warmup.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SenderPoolDtoOutputNumbersInnerWarmup
    extends SenderPoolDtoOutputNumbersInnerWarmup {
  @override
  final int step;
  @override
  final int cap;
  @override
  final DateTime nextStepAt;

  factory _$SenderPoolDtoOutputNumbersInnerWarmup([
    void Function(SenderPoolDtoOutputNumbersInnerWarmupBuilder)? updates,
  ]) => (SenderPoolDtoOutputNumbersInnerWarmupBuilder()..update(updates))
      ._build();

  _$SenderPoolDtoOutputNumbersInnerWarmup._({
    required this.step,
    required this.cap,
    required this.nextStepAt,
  }) : super._();
  @override
  SenderPoolDtoOutputNumbersInnerWarmup rebuild(
    void Function(SenderPoolDtoOutputNumbersInnerWarmupBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SenderPoolDtoOutputNumbersInnerWarmupBuilder toBuilder() =>
      SenderPoolDtoOutputNumbersInnerWarmupBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SenderPoolDtoOutputNumbersInnerWarmup &&
        step == other.step &&
        cap == other.cap &&
        nextStepAt == other.nextStepAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, step.hashCode);
    _$hash = $jc(_$hash, cap.hashCode);
    _$hash = $jc(_$hash, nextStepAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'SenderPoolDtoOutputNumbersInnerWarmup',
          )
          ..add('step', step)
          ..add('cap', cap)
          ..add('nextStepAt', nextStepAt))
        .toString();
  }
}

class SenderPoolDtoOutputNumbersInnerWarmupBuilder
    implements
        Builder<
          SenderPoolDtoOutputNumbersInnerWarmup,
          SenderPoolDtoOutputNumbersInnerWarmupBuilder
        > {
  _$SenderPoolDtoOutputNumbersInnerWarmup? _$v;

  int? _step;
  int? get step => _$this._step;
  set step(int? step) => _$this._step = step;

  int? _cap;
  int? get cap => _$this._cap;
  set cap(int? cap) => _$this._cap = cap;

  DateTime? _nextStepAt;
  DateTime? get nextStepAt => _$this._nextStepAt;
  set nextStepAt(DateTime? nextStepAt) => _$this._nextStepAt = nextStepAt;

  SenderPoolDtoOutputNumbersInnerWarmupBuilder() {
    SenderPoolDtoOutputNumbersInnerWarmup._defaults(this);
  }

  SenderPoolDtoOutputNumbersInnerWarmupBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _step = $v.step;
      _cap = $v.cap;
      _nextStepAt = $v.nextStepAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SenderPoolDtoOutputNumbersInnerWarmup other) {
    _$v = other as _$SenderPoolDtoOutputNumbersInnerWarmup;
  }

  @override
  void update(
    void Function(SenderPoolDtoOutputNumbersInnerWarmupBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  SenderPoolDtoOutputNumbersInnerWarmup build() => _build();

  _$SenderPoolDtoOutputNumbersInnerWarmup _build() {
    final _$result =
        _$v ??
        _$SenderPoolDtoOutputNumbersInnerWarmup._(
          step: BuiltValueNullFieldError.checkNotNull(
            step,
            r'SenderPoolDtoOutputNumbersInnerWarmup',
            'step',
          ),
          cap: BuiltValueNullFieldError.checkNotNull(
            cap,
            r'SenderPoolDtoOutputNumbersInnerWarmup',
            'cap',
          ),
          nextStepAt: BuiltValueNullFieldError.checkNotNull(
            nextStepAt,
            r'SenderPoolDtoOutputNumbersInnerWarmup',
            'nextStepAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
