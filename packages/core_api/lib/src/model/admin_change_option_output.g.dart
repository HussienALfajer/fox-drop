// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_change_option_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminChangeOptionOutput extends AdminChangeOptionOutput {
  @override
  final String id;
  @override
  final String name;
  @override
  final AdminChangeMoneyOutput priceDelta;

  factory _$AdminChangeOptionOutput([
    void Function(AdminChangeOptionOutputBuilder)? updates,
  ]) => (AdminChangeOptionOutputBuilder()..update(updates))._build();

  _$AdminChangeOptionOutput._({
    required this.id,
    required this.name,
    required this.priceDelta,
  }) : super._();
  @override
  AdminChangeOptionOutput rebuild(
    void Function(AdminChangeOptionOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminChangeOptionOutputBuilder toBuilder() =>
      AdminChangeOptionOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminChangeOptionOutput &&
        id == other.id &&
        name == other.name &&
        priceDelta == other.priceDelta;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, priceDelta.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminChangeOptionOutput')
          ..add('id', id)
          ..add('name', name)
          ..add('priceDelta', priceDelta))
        .toString();
  }
}

class AdminChangeOptionOutputBuilder
    implements
        Builder<AdminChangeOptionOutput, AdminChangeOptionOutputBuilder> {
  _$AdminChangeOptionOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminChangeMoneyOutputBuilder? _priceDelta;
  AdminChangeMoneyOutputBuilder get priceDelta =>
      _$this._priceDelta ??= AdminChangeMoneyOutputBuilder();
  set priceDelta(AdminChangeMoneyOutputBuilder? priceDelta) =>
      _$this._priceDelta = priceDelta;

  AdminChangeOptionOutputBuilder() {
    AdminChangeOptionOutput._defaults(this);
  }

  AdminChangeOptionOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _priceDelta = $v.priceDelta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminChangeOptionOutput other) {
    _$v = other as _$AdminChangeOptionOutput;
  }

  @override
  void update(void Function(AdminChangeOptionOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminChangeOptionOutput build() => _build();

  _$AdminChangeOptionOutput _build() {
    _$AdminChangeOptionOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminChangeOptionOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminChangeOptionOutput',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminChangeOptionOutput',
              'name',
            ),
            priceDelta: priceDelta.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'priceDelta';
        priceDelta.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminChangeOptionOutput',
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
