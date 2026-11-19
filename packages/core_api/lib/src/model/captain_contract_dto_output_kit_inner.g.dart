// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_contract_dto_output_kit_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainContractDtoOutputKitInner
    extends CaptainContractDtoOutputKitInner {
  @override
  final String label;
  @override
  final String? size;
  @override
  final int quantity;

  factory _$CaptainContractDtoOutputKitInner([
    void Function(CaptainContractDtoOutputKitInnerBuilder)? updates,
  ]) => (CaptainContractDtoOutputKitInnerBuilder()..update(updates))._build();

  _$CaptainContractDtoOutputKitInner._({
    required this.label,
    this.size,
    required this.quantity,
  }) : super._();
  @override
  CaptainContractDtoOutputKitInner rebuild(
    void Function(CaptainContractDtoOutputKitInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainContractDtoOutputKitInnerBuilder toBuilder() =>
      CaptainContractDtoOutputKitInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainContractDtoOutputKitInner &&
        label == other.label &&
        size == other.size &&
        quantity == other.quantity;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, size.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainContractDtoOutputKitInner')
          ..add('label', label)
          ..add('size', size)
          ..add('quantity', quantity))
        .toString();
  }
}

class CaptainContractDtoOutputKitInnerBuilder
    implements
        Builder<
          CaptainContractDtoOutputKitInner,
          CaptainContractDtoOutputKitInnerBuilder
        > {
  _$CaptainContractDtoOutputKitInner? _$v;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _size;
  String? get size => _$this._size;
  set size(String? size) => _$this._size = size;

  int? _quantity;
  int? get quantity => _$this._quantity;
  set quantity(int? quantity) => _$this._quantity = quantity;

  CaptainContractDtoOutputKitInnerBuilder() {
    CaptainContractDtoOutputKitInner._defaults(this);
  }

  CaptainContractDtoOutputKitInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _label = $v.label;
      _size = $v.size;
      _quantity = $v.quantity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainContractDtoOutputKitInner other) {
    _$v = other as _$CaptainContractDtoOutputKitInner;
  }

  @override
  void update(void Function(CaptainContractDtoOutputKitInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainContractDtoOutputKitInner build() => _build();

  _$CaptainContractDtoOutputKitInner _build() {
    final _$result =
        _$v ??
        _$CaptainContractDtoOutputKitInner._(
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'CaptainContractDtoOutputKitInner',
            'label',
          ),
          size: size,
          quantity: BuiltValueNullFieldError.checkNotNull(
            quantity,
            r'CaptainContractDtoOutputKitInner',
            'quantity',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
