// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_cities_dto_output_cities_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCitiesDtoOutputCitiesInner
    extends AdminCitiesDtoOutputCitiesInner {
  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final String timeZone;

  factory _$AdminCitiesDtoOutputCitiesInner([
    void Function(AdminCitiesDtoOutputCitiesInnerBuilder)? updates,
  ]) => (AdminCitiesDtoOutputCitiesInnerBuilder()..update(updates))._build();

  _$AdminCitiesDtoOutputCitiesInner._({
    required this.id,
    required this.code,
    required this.name,
    required this.timeZone,
  }) : super._();
  @override
  AdminCitiesDtoOutputCitiesInner rebuild(
    void Function(AdminCitiesDtoOutputCitiesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCitiesDtoOutputCitiesInnerBuilder toBuilder() =>
      AdminCitiesDtoOutputCitiesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCitiesDtoOutputCitiesInner &&
        id == other.id &&
        code == other.code &&
        name == other.name &&
        timeZone == other.timeZone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, timeZone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCitiesDtoOutputCitiesInner')
          ..add('id', id)
          ..add('code', code)
          ..add('name', name)
          ..add('timeZone', timeZone))
        .toString();
  }
}

class AdminCitiesDtoOutputCitiesInnerBuilder
    implements
        Builder<
          AdminCitiesDtoOutputCitiesInner,
          AdminCitiesDtoOutputCitiesInnerBuilder
        > {
  _$AdminCitiesDtoOutputCitiesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _timeZone;
  String? get timeZone => _$this._timeZone;
  set timeZone(String? timeZone) => _$this._timeZone = timeZone;

  AdminCitiesDtoOutputCitiesInnerBuilder() {
    AdminCitiesDtoOutputCitiesInner._defaults(this);
  }

  AdminCitiesDtoOutputCitiesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _name = $v.name;
      _timeZone = $v.timeZone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCitiesDtoOutputCitiesInner other) {
    _$v = other as _$AdminCitiesDtoOutputCitiesInner;
  }

  @override
  void update(void Function(AdminCitiesDtoOutputCitiesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCitiesDtoOutputCitiesInner build() => _build();

  _$AdminCitiesDtoOutputCitiesInner _build() {
    final _$result =
        _$v ??
        _$AdminCitiesDtoOutputCitiesInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminCitiesDtoOutputCitiesInner',
            'id',
          ),
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'AdminCitiesDtoOutputCitiesInner',
            'code',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminCitiesDtoOutputCitiesInner',
            'name',
          ),
          timeZone: BuiltValueNullFieldError.checkNotNull(
            timeZone,
            r'AdminCitiesDtoOutputCitiesInner',
            'timeZone',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
