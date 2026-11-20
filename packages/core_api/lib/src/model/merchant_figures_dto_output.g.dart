// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_figures_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantFiguresDtoOutput extends MerchantFiguresDtoOutput {
  @override
  final DateTime from;
  @override
  final DateTime to;
  @override
  final String currency;
  @override
  final MerchantFiguresOutput current;
  @override
  final MerchantFiguresOutput previous;

  factory _$MerchantFiguresDtoOutput([
    void Function(MerchantFiguresDtoOutputBuilder)? updates,
  ]) => (MerchantFiguresDtoOutputBuilder()..update(updates))._build();

  _$MerchantFiguresDtoOutput._({
    required this.from,
    required this.to,
    required this.currency,
    required this.current,
    required this.previous,
  }) : super._();
  @override
  MerchantFiguresDtoOutput rebuild(
    void Function(MerchantFiguresDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantFiguresDtoOutputBuilder toBuilder() =>
      MerchantFiguresDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantFiguresDtoOutput &&
        from == other.from &&
        to == other.to &&
        currency == other.currency &&
        current == other.current &&
        previous == other.previous;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, current.hashCode);
    _$hash = $jc(_$hash, previous.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantFiguresDtoOutput')
          ..add('from', from)
          ..add('to', to)
          ..add('currency', currency)
          ..add('current', current)
          ..add('previous', previous))
        .toString();
  }
}

class MerchantFiguresDtoOutputBuilder
    implements
        Builder<MerchantFiguresDtoOutput, MerchantFiguresDtoOutputBuilder> {
  _$MerchantFiguresDtoOutput? _$v;

  DateTime? _from;
  DateTime? get from => _$this._from;
  set from(DateTime? from) => _$this._from = from;

  DateTime? _to;
  DateTime? get to => _$this._to;
  set to(DateTime? to) => _$this._to = to;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  MerchantFiguresOutputBuilder? _current;
  MerchantFiguresOutputBuilder get current =>
      _$this._current ??= MerchantFiguresOutputBuilder();
  set current(MerchantFiguresOutputBuilder? current) =>
      _$this._current = current;

  MerchantFiguresOutputBuilder? _previous;
  MerchantFiguresOutputBuilder get previous =>
      _$this._previous ??= MerchantFiguresOutputBuilder();
  set previous(MerchantFiguresOutputBuilder? previous) =>
      _$this._previous = previous;

  MerchantFiguresDtoOutputBuilder() {
    MerchantFiguresDtoOutput._defaults(this);
  }

  MerchantFiguresDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _from = $v.from;
      _to = $v.to;
      _currency = $v.currency;
      _current = $v.current.toBuilder();
      _previous = $v.previous.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantFiguresDtoOutput other) {
    _$v = other as _$MerchantFiguresDtoOutput;
  }

  @override
  void update(void Function(MerchantFiguresDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantFiguresDtoOutput build() => _build();

  _$MerchantFiguresDtoOutput _build() {
    _$MerchantFiguresDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$MerchantFiguresDtoOutput._(
            from: BuiltValueNullFieldError.checkNotNull(
              from,
              r'MerchantFiguresDtoOutput',
              'from',
            ),
            to: BuiltValueNullFieldError.checkNotNull(
              to,
              r'MerchantFiguresDtoOutput',
              'to',
            ),
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'MerchantFiguresDtoOutput',
              'currency',
            ),
            current: current.build(),
            previous: previous.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'current';
        current.build();
        _$failedField = 'previous';
        previous.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantFiguresDtoOutput',
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
