// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_application_kit_dto_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainApplicationKitDtoItemsInner
    extends AdminCaptainApplicationKitDtoItemsInner {
  @override
  final String code;
  @override
  final String? size;
  @override
  final int quantity;

  factory _$AdminCaptainApplicationKitDtoItemsInner([
    void Function(AdminCaptainApplicationKitDtoItemsInnerBuilder)? updates,
  ]) => (AdminCaptainApplicationKitDtoItemsInnerBuilder()..update(updates))
      ._build();

  _$AdminCaptainApplicationKitDtoItemsInner._({
    required this.code,
    this.size,
    required this.quantity,
  }) : super._();
  @override
  AdminCaptainApplicationKitDtoItemsInner rebuild(
    void Function(AdminCaptainApplicationKitDtoItemsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainApplicationKitDtoItemsInnerBuilder toBuilder() =>
      AdminCaptainApplicationKitDtoItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainApplicationKitDtoItemsInner &&
        code == other.code &&
        size == other.size &&
        quantity == other.quantity;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, size.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCaptainApplicationKitDtoItemsInner',
          )
          ..add('code', code)
          ..add('size', size)
          ..add('quantity', quantity))
        .toString();
  }
}

class AdminCaptainApplicationKitDtoItemsInnerBuilder
    implements
        Builder<
          AdminCaptainApplicationKitDtoItemsInner,
          AdminCaptainApplicationKitDtoItemsInnerBuilder
        > {
  _$AdminCaptainApplicationKitDtoItemsInner? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _size;
  String? get size => _$this._size;
  set size(String? size) => _$this._size = size;

  int? _quantity;
  int? get quantity => _$this._quantity;
  set quantity(int? quantity) => _$this._quantity = quantity;

  AdminCaptainApplicationKitDtoItemsInnerBuilder() {
    AdminCaptainApplicationKitDtoItemsInner._defaults(this);
  }

  AdminCaptainApplicationKitDtoItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _size = $v.size;
      _quantity = $v.quantity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainApplicationKitDtoItemsInner other) {
    _$v = other as _$AdminCaptainApplicationKitDtoItemsInner;
  }

  @override
  void update(
    void Function(AdminCaptainApplicationKitDtoItemsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainApplicationKitDtoItemsInner build() => _build();

  _$AdminCaptainApplicationKitDtoItemsInner _build() {
    final _$result =
        _$v ??
        _$AdminCaptainApplicationKitDtoItemsInner._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'AdminCaptainApplicationKitDtoItemsInner',
            'code',
          ),
          size: size,
          quantity: BuiltValueNullFieldError.checkNotNull(
            quantity,
            r'AdminCaptainApplicationKitDtoItemsInner',
            'quantity',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
