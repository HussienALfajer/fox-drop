// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_account_state_dto_output_block.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerAccountStateDtoOutputBlock
    extends CustomerAccountStateDtoOutputBlock {
  @override
  final DateTime? until;
  @override
  final String reason;

  factory _$CustomerAccountStateDtoOutputBlock([
    void Function(CustomerAccountStateDtoOutputBlockBuilder)? updates,
  ]) => (CustomerAccountStateDtoOutputBlockBuilder()..update(updates))._build();

  _$CustomerAccountStateDtoOutputBlock._({this.until, required this.reason})
    : super._();
  @override
  CustomerAccountStateDtoOutputBlock rebuild(
    void Function(CustomerAccountStateDtoOutputBlockBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerAccountStateDtoOutputBlockBuilder toBuilder() =>
      CustomerAccountStateDtoOutputBlockBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerAccountStateDtoOutputBlock &&
        until == other.until &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, until.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerAccountStateDtoOutputBlock')
          ..add('until', until)
          ..add('reason', reason))
        .toString();
  }
}

class CustomerAccountStateDtoOutputBlockBuilder
    implements
        Builder<
          CustomerAccountStateDtoOutputBlock,
          CustomerAccountStateDtoOutputBlockBuilder
        > {
  _$CustomerAccountStateDtoOutputBlock? _$v;

  DateTime? _until;
  DateTime? get until => _$this._until;
  set until(DateTime? until) => _$this._until = until;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  CustomerAccountStateDtoOutputBlockBuilder() {
    CustomerAccountStateDtoOutputBlock._defaults(this);
  }

  CustomerAccountStateDtoOutputBlockBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _until = $v.until;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerAccountStateDtoOutputBlock other) {
    _$v = other as _$CustomerAccountStateDtoOutputBlock;
  }

  @override
  void update(
    void Function(CustomerAccountStateDtoOutputBlockBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerAccountStateDtoOutputBlock build() => _build();

  _$CustomerAccountStateDtoOutputBlock _build() {
    final _$result =
        _$v ??
        _$CustomerAccountStateDtoOutputBlock._(
          until: until,
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'CustomerAccountStateDtoOutputBlock',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
