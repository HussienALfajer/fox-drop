// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_search_results_dto_output_customers_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSearchResultsDtoOutputCustomersInner
    extends AdminSearchResultsDtoOutputCustomersInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final String maskedPhone;

  factory _$AdminSearchResultsDtoOutputCustomersInner([
    void Function(AdminSearchResultsDtoOutputCustomersInnerBuilder)? updates,
  ]) => (AdminSearchResultsDtoOutputCustomersInnerBuilder()..update(updates))
      ._build();

  _$AdminSearchResultsDtoOutputCustomersInner._({
    required this.id,
    required this.name,
    required this.maskedPhone,
  }) : super._();
  @override
  AdminSearchResultsDtoOutputCustomersInner rebuild(
    void Function(AdminSearchResultsDtoOutputCustomersInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSearchResultsDtoOutputCustomersInnerBuilder toBuilder() =>
      AdminSearchResultsDtoOutputCustomersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSearchResultsDtoOutputCustomersInner &&
        id == other.id &&
        name == other.name &&
        maskedPhone == other.maskedPhone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, maskedPhone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminSearchResultsDtoOutputCustomersInner',
          )
          ..add('id', id)
          ..add('name', name)
          ..add('maskedPhone', maskedPhone))
        .toString();
  }
}

class AdminSearchResultsDtoOutputCustomersInnerBuilder
    implements
        Builder<
          AdminSearchResultsDtoOutputCustomersInner,
          AdminSearchResultsDtoOutputCustomersInnerBuilder
        > {
  _$AdminSearchResultsDtoOutputCustomersInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _maskedPhone;
  String? get maskedPhone => _$this._maskedPhone;
  set maskedPhone(String? maskedPhone) => _$this._maskedPhone = maskedPhone;

  AdminSearchResultsDtoOutputCustomersInnerBuilder() {
    AdminSearchResultsDtoOutputCustomersInner._defaults(this);
  }

  AdminSearchResultsDtoOutputCustomersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _maskedPhone = $v.maskedPhone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSearchResultsDtoOutputCustomersInner other) {
    _$v = other as _$AdminSearchResultsDtoOutputCustomersInner;
  }

  @override
  void update(
    void Function(AdminSearchResultsDtoOutputCustomersInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminSearchResultsDtoOutputCustomersInner build() => _build();

  _$AdminSearchResultsDtoOutputCustomersInner _build() {
    final _$result =
        _$v ??
        _$AdminSearchResultsDtoOutputCustomersInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminSearchResultsDtoOutputCustomersInner',
            'id',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminSearchResultsDtoOutputCustomersInner',
            'name',
          ),
          maskedPhone: BuiltValueNullFieldError.checkNotNull(
            maskedPhone,
            r'AdminSearchResultsDtoOutputCustomersInner',
            'maskedPhone',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
