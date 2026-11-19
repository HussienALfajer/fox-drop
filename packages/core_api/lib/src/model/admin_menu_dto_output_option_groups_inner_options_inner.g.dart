// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_dto_output_option_groups_inner_options_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMenuDtoOutputOptionGroupsInnerOptionsInner
    extends AdminMenuDtoOutputOptionGroupsInnerOptionsInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final AdminMenuMoneyOutput priceDelta;
  @override
  final AdminMenuSwitchedOffOutput? switchedOff;

  factory _$AdminMenuDtoOutputOptionGroupsInnerOptionsInner([
    void Function(AdminMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder)?
    updates,
  ]) =>
      (AdminMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminMenuDtoOutputOptionGroupsInnerOptionsInner._({
    required this.id,
    required this.name,
    required this.priceDelta,
    this.switchedOff,
  }) : super._();
  @override
  AdminMenuDtoOutputOptionGroupsInnerOptionsInner rebuild(
    void Function(AdminMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder toBuilder() =>
      AdminMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuDtoOutputOptionGroupsInnerOptionsInner &&
        id == other.id &&
        name == other.name &&
        priceDelta == other.priceDelta &&
        switchedOff == other.switchedOff;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, priceDelta.hashCode);
    _$hash = $jc(_$hash, switchedOff.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminMenuDtoOutputOptionGroupsInnerOptionsInner',
          )
          ..add('id', id)
          ..add('name', name)
          ..add('priceDelta', priceDelta)
          ..add('switchedOff', switchedOff))
        .toString();
  }
}

class AdminMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder
    implements
        Builder<
          AdminMenuDtoOutputOptionGroupsInnerOptionsInner,
          AdminMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder
        > {
  _$AdminMenuDtoOutputOptionGroupsInnerOptionsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminMenuMoneyOutputBuilder? _priceDelta;
  AdminMenuMoneyOutputBuilder get priceDelta =>
      _$this._priceDelta ??= AdminMenuMoneyOutputBuilder();
  set priceDelta(AdminMenuMoneyOutputBuilder? priceDelta) =>
      _$this._priceDelta = priceDelta;

  AdminMenuSwitchedOffOutputBuilder? _switchedOff;
  AdminMenuSwitchedOffOutputBuilder get switchedOff =>
      _$this._switchedOff ??= AdminMenuSwitchedOffOutputBuilder();
  set switchedOff(AdminMenuSwitchedOffOutputBuilder? switchedOff) =>
      _$this._switchedOff = switchedOff;

  AdminMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder() {
    AdminMenuDtoOutputOptionGroupsInnerOptionsInner._defaults(this);
  }

  AdminMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _priceDelta = $v.priceDelta.toBuilder();
      _switchedOff = $v.switchedOff?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuDtoOutputOptionGroupsInnerOptionsInner other) {
    _$v = other as _$AdminMenuDtoOutputOptionGroupsInnerOptionsInner;
  }

  @override
  void update(
    void Function(AdminMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuDtoOutputOptionGroupsInnerOptionsInner build() => _build();

  _$AdminMenuDtoOutputOptionGroupsInnerOptionsInner _build() {
    _$AdminMenuDtoOutputOptionGroupsInnerOptionsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminMenuDtoOutputOptionGroupsInnerOptionsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminMenuDtoOutputOptionGroupsInnerOptionsInner',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminMenuDtoOutputOptionGroupsInnerOptionsInner',
              'name',
            ),
            priceDelta: priceDelta.build(),
            switchedOff: _switchedOff?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'priceDelta';
        priceDelta.build();
        _$failedField = 'switchedOff';
        _switchedOff?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminMenuDtoOutputOptionGroupsInnerOptionsInner',
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
