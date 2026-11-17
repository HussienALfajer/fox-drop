// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_account_state_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerAccountStateDtoOutput extends CustomerAccountStateDtoOutput {
  @override
  final bool reviewStop;
  @override
  final CustomerAccountStateDtoOutputBlock? block;
  @override
  final CustomerAccountStateDtoOutputDues? dues;
  @override
  final CustomerAccountStateDtoOutputOffice? office;

  factory _$CustomerAccountStateDtoOutput([
    void Function(CustomerAccountStateDtoOutputBuilder)? updates,
  ]) => (CustomerAccountStateDtoOutputBuilder()..update(updates))._build();

  _$CustomerAccountStateDtoOutput._({
    required this.reviewStop,
    this.block,
    this.dues,
    this.office,
  }) : super._();
  @override
  CustomerAccountStateDtoOutput rebuild(
    void Function(CustomerAccountStateDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerAccountStateDtoOutputBuilder toBuilder() =>
      CustomerAccountStateDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerAccountStateDtoOutput &&
        reviewStop == other.reviewStop &&
        block == other.block &&
        dues == other.dues &&
        office == other.office;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reviewStop.hashCode);
    _$hash = $jc(_$hash, block.hashCode);
    _$hash = $jc(_$hash, dues.hashCode);
    _$hash = $jc(_$hash, office.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerAccountStateDtoOutput')
          ..add('reviewStop', reviewStop)
          ..add('block', block)
          ..add('dues', dues)
          ..add('office', office))
        .toString();
  }
}

class CustomerAccountStateDtoOutputBuilder
    implements
        Builder<
          CustomerAccountStateDtoOutput,
          CustomerAccountStateDtoOutputBuilder
        > {
  _$CustomerAccountStateDtoOutput? _$v;

  bool? _reviewStop;
  bool? get reviewStop => _$this._reviewStop;
  set reviewStop(bool? reviewStop) => _$this._reviewStop = reviewStop;

  CustomerAccountStateDtoOutputBlockBuilder? _block;
  CustomerAccountStateDtoOutputBlockBuilder get block =>
      _$this._block ??= CustomerAccountStateDtoOutputBlockBuilder();
  set block(CustomerAccountStateDtoOutputBlockBuilder? block) =>
      _$this._block = block;

  CustomerAccountStateDtoOutputDuesBuilder? _dues;
  CustomerAccountStateDtoOutputDuesBuilder get dues =>
      _$this._dues ??= CustomerAccountStateDtoOutputDuesBuilder();
  set dues(CustomerAccountStateDtoOutputDuesBuilder? dues) =>
      _$this._dues = dues;

  CustomerAccountStateDtoOutputOfficeBuilder? _office;
  CustomerAccountStateDtoOutputOfficeBuilder get office =>
      _$this._office ??= CustomerAccountStateDtoOutputOfficeBuilder();
  set office(CustomerAccountStateDtoOutputOfficeBuilder? office) =>
      _$this._office = office;

  CustomerAccountStateDtoOutputBuilder() {
    CustomerAccountStateDtoOutput._defaults(this);
  }

  CustomerAccountStateDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reviewStop = $v.reviewStop;
      _block = $v.block?.toBuilder();
      _dues = $v.dues?.toBuilder();
      _office = $v.office?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerAccountStateDtoOutput other) {
    _$v = other as _$CustomerAccountStateDtoOutput;
  }

  @override
  void update(void Function(CustomerAccountStateDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerAccountStateDtoOutput build() => _build();

  _$CustomerAccountStateDtoOutput _build() {
    _$CustomerAccountStateDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CustomerAccountStateDtoOutput._(
            reviewStop: BuiltValueNullFieldError.checkNotNull(
              reviewStop,
              r'CustomerAccountStateDtoOutput',
              'reviewStop',
            ),
            block: _block?.build(),
            dues: _dues?.build(),
            office: _office?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'block';
        _block?.build();
        _$failedField = 'dues';
        _dues?.build();
        _$failedField = 'office';
        _office?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerAccountStateDtoOutput',
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
