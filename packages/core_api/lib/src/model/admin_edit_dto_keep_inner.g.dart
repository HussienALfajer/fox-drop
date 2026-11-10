// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_edit_dto_keep_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminEditDtoKeepInner extends AdminEditDtoKeepInner {
  @override
  final int position;
  @override
  final int quantity;

  factory _$AdminEditDtoKeepInner([
    void Function(AdminEditDtoKeepInnerBuilder)? updates,
  ]) => (AdminEditDtoKeepInnerBuilder()..update(updates))._build();

  _$AdminEditDtoKeepInner._({required this.position, required this.quantity})
    : super._();
  @override
  AdminEditDtoKeepInner rebuild(
    void Function(AdminEditDtoKeepInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminEditDtoKeepInnerBuilder toBuilder() =>
      AdminEditDtoKeepInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminEditDtoKeepInner &&
        position == other.position &&
        quantity == other.quantity;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, position.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminEditDtoKeepInner')
          ..add('position', position)
          ..add('quantity', quantity))
        .toString();
  }
}

class AdminEditDtoKeepInnerBuilder
    implements Builder<AdminEditDtoKeepInner, AdminEditDtoKeepInnerBuilder> {
  _$AdminEditDtoKeepInner? _$v;

  int? _position;
  int? get position => _$this._position;
  set position(int? position) => _$this._position = position;

  int? _quantity;
  int? get quantity => _$this._quantity;
  set quantity(int? quantity) => _$this._quantity = quantity;

  AdminEditDtoKeepInnerBuilder() {
    AdminEditDtoKeepInner._defaults(this);
  }

  AdminEditDtoKeepInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _position = $v.position;
      _quantity = $v.quantity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminEditDtoKeepInner other) {
    _$v = other as _$AdminEditDtoKeepInner;
  }

  @override
  void update(void Function(AdminEditDtoKeepInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminEditDtoKeepInner build() => _build();

  _$AdminEditDtoKeepInner _build() {
    final _$result =
        _$v ??
        _$AdminEditDtoKeepInner._(
          position: BuiltValueNullFieldError.checkNotNull(
            position,
            r'AdminEditDtoKeepInner',
            'position',
          ),
          quantity: BuiltValueNullFieldError.checkNotNull(
            quantity,
            r'AdminEditDtoKeepInner',
            'quantity',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
