// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_cities_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCitiesDtoOutput extends AdminCitiesDtoOutput {
  @override
  final BuiltList<AdminCitiesDtoOutputCitiesInner> cities;

  factory _$AdminCitiesDtoOutput([
    void Function(AdminCitiesDtoOutputBuilder)? updates,
  ]) => (AdminCitiesDtoOutputBuilder()..update(updates))._build();

  _$AdminCitiesDtoOutput._({required this.cities}) : super._();
  @override
  AdminCitiesDtoOutput rebuild(
    void Function(AdminCitiesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCitiesDtoOutputBuilder toBuilder() =>
      AdminCitiesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCitiesDtoOutput && cities == other.cities;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cities.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminCitiesDtoOutput',
    )..add('cities', cities)).toString();
  }
}

class AdminCitiesDtoOutputBuilder
    implements Builder<AdminCitiesDtoOutput, AdminCitiesDtoOutputBuilder> {
  _$AdminCitiesDtoOutput? _$v;

  ListBuilder<AdminCitiesDtoOutputCitiesInner>? _cities;
  ListBuilder<AdminCitiesDtoOutputCitiesInner> get cities =>
      _$this._cities ??= ListBuilder<AdminCitiesDtoOutputCitiesInner>();
  set cities(ListBuilder<AdminCitiesDtoOutputCitiesInner>? cities) =>
      _$this._cities = cities;

  AdminCitiesDtoOutputBuilder() {
    AdminCitiesDtoOutput._defaults(this);
  }

  AdminCitiesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cities = $v.cities.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCitiesDtoOutput other) {
    _$v = other as _$AdminCitiesDtoOutput;
  }

  @override
  void update(void Function(AdminCitiesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCitiesDtoOutput build() => _build();

  _$AdminCitiesDtoOutput _build() {
    _$AdminCitiesDtoOutput _$result;
    try {
      _$result = _$v ?? _$AdminCitiesDtoOutput._(cities: cities.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'cities';
        cities.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCitiesDtoOutput',
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
