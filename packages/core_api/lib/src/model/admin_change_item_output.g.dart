// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_change_item_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminChangeItemOutput extends AdminChangeItemOutput {
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? photoKey;
  @override
  final AdminChangeMoneyOutput price;

  factory _$AdminChangeItemOutput([
    void Function(AdminChangeItemOutputBuilder)? updates,
  ]) => (AdminChangeItemOutputBuilder()..update(updates))._build();

  _$AdminChangeItemOutput._({
    required this.name,
    this.description,
    this.photoKey,
    required this.price,
  }) : super._();
  @override
  AdminChangeItemOutput rebuild(
    void Function(AdminChangeItemOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminChangeItemOutputBuilder toBuilder() =>
      AdminChangeItemOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminChangeItemOutput &&
        name == other.name &&
        description == other.description &&
        photoKey == other.photoKey &&
        price == other.price;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, photoKey.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminChangeItemOutput')
          ..add('name', name)
          ..add('description', description)
          ..add('photoKey', photoKey)
          ..add('price', price))
        .toString();
  }
}

class AdminChangeItemOutputBuilder
    implements Builder<AdminChangeItemOutput, AdminChangeItemOutputBuilder> {
  _$AdminChangeItemOutput? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _photoKey;
  String? get photoKey => _$this._photoKey;
  set photoKey(String? photoKey) => _$this._photoKey = photoKey;

  AdminChangeMoneyOutputBuilder? _price;
  AdminChangeMoneyOutputBuilder get price =>
      _$this._price ??= AdminChangeMoneyOutputBuilder();
  set price(AdminChangeMoneyOutputBuilder? price) => _$this._price = price;

  AdminChangeItemOutputBuilder() {
    AdminChangeItemOutput._defaults(this);
  }

  AdminChangeItemOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _description = $v.description;
      _photoKey = $v.photoKey;
      _price = $v.price.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminChangeItemOutput other) {
    _$v = other as _$AdminChangeItemOutput;
  }

  @override
  void update(void Function(AdminChangeItemOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminChangeItemOutput build() => _build();

  _$AdminChangeItemOutput _build() {
    _$AdminChangeItemOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminChangeItemOutput._(
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminChangeItemOutput',
              'name',
            ),
            description: description,
            photoKey: photoKey,
            price: price.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'price';
        price.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminChangeItemOutput',
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
