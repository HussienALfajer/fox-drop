// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_application_dto_output_activation_kit_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainApplicationDtoOutputActivationKitItemsInner
    extends AdminCaptainApplicationDtoOutputActivationKitItemsInner {
  @override
  final String code;
  @override
  final String label;
  @override
  final String? size;
  @override
  final int quantity;

  factory _$AdminCaptainApplicationDtoOutputActivationKitItemsInner([
    void Function(
      AdminCaptainApplicationDtoOutputActivationKitItemsInnerBuilder,
    )?
    updates,
  ]) =>
      (AdminCaptainApplicationDtoOutputActivationKitItemsInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminCaptainApplicationDtoOutputActivationKitItemsInner._({
    required this.code,
    required this.label,
    this.size,
    required this.quantity,
  }) : super._();
  @override
  AdminCaptainApplicationDtoOutputActivationKitItemsInner rebuild(
    void Function(
      AdminCaptainApplicationDtoOutputActivationKitItemsInnerBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainApplicationDtoOutputActivationKitItemsInnerBuilder toBuilder() =>
      AdminCaptainApplicationDtoOutputActivationKitItemsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainApplicationDtoOutputActivationKitItemsInner &&
        code == other.code &&
        label == other.label &&
        size == other.size &&
        quantity == other.quantity;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, size.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCaptainApplicationDtoOutputActivationKitItemsInner',
          )
          ..add('code', code)
          ..add('label', label)
          ..add('size', size)
          ..add('quantity', quantity))
        .toString();
  }
}

class AdminCaptainApplicationDtoOutputActivationKitItemsInnerBuilder
    implements
        Builder<
          AdminCaptainApplicationDtoOutputActivationKitItemsInner,
          AdminCaptainApplicationDtoOutputActivationKitItemsInnerBuilder
        > {
  _$AdminCaptainApplicationDtoOutputActivationKitItemsInner? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _size;
  String? get size => _$this._size;
  set size(String? size) => _$this._size = size;

  int? _quantity;
  int? get quantity => _$this._quantity;
  set quantity(int? quantity) => _$this._quantity = quantity;

  AdminCaptainApplicationDtoOutputActivationKitItemsInnerBuilder() {
    AdminCaptainApplicationDtoOutputActivationKitItemsInner._defaults(this);
  }

  AdminCaptainApplicationDtoOutputActivationKitItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _label = $v.label;
      _size = $v.size;
      _quantity = $v.quantity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainApplicationDtoOutputActivationKitItemsInner other) {
    _$v = other as _$AdminCaptainApplicationDtoOutputActivationKitItemsInner;
  }

  @override
  void update(
    void Function(
      AdminCaptainApplicationDtoOutputActivationKitItemsInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainApplicationDtoOutputActivationKitItemsInner build() => _build();

  _$AdminCaptainApplicationDtoOutputActivationKitItemsInner _build() {
    final _$result =
        _$v ??
        _$AdminCaptainApplicationDtoOutputActivationKitItemsInner._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'AdminCaptainApplicationDtoOutputActivationKitItemsInner',
            'code',
          ),
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'AdminCaptainApplicationDtoOutputActivationKitItemsInner',
            'label',
          ),
          size: size,
          quantity: BuiltValueNullFieldError.checkNotNull(
            quantity,
            r'AdminCaptainApplicationDtoOutputActivationKitItemsInner',
            'quantity',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
