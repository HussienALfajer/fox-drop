// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_all_cities_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminAllCitiesDtoOutput extends AdminAllCitiesDtoOutput {
  @override
  final BuiltList<AdminAllCitiesDtoOutputCitiesInner> cities;

  factory _$AdminAllCitiesDtoOutput([
    void Function(AdminAllCitiesDtoOutputBuilder)? updates,
  ]) => (AdminAllCitiesDtoOutputBuilder()..update(updates))._build();

  _$AdminAllCitiesDtoOutput._({required this.cities}) : super._();
  @override
  AdminAllCitiesDtoOutput rebuild(
    void Function(AdminAllCitiesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminAllCitiesDtoOutputBuilder toBuilder() =>
      AdminAllCitiesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminAllCitiesDtoOutput && cities == other.cities;
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
      r'AdminAllCitiesDtoOutput',
    )..add('cities', cities)).toString();
  }
}

class AdminAllCitiesDtoOutputBuilder
    implements
        Builder<AdminAllCitiesDtoOutput, AdminAllCitiesDtoOutputBuilder> {
  _$AdminAllCitiesDtoOutput? _$v;

  ListBuilder<AdminAllCitiesDtoOutputCitiesInner>? _cities;
  ListBuilder<AdminAllCitiesDtoOutputCitiesInner> get cities =>
      _$this._cities ??= ListBuilder<AdminAllCitiesDtoOutputCitiesInner>();
  set cities(ListBuilder<AdminAllCitiesDtoOutputCitiesInner>? cities) =>
      _$this._cities = cities;

  AdminAllCitiesDtoOutputBuilder() {
    AdminAllCitiesDtoOutput._defaults(this);
  }

  AdminAllCitiesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cities = $v.cities.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminAllCitiesDtoOutput other) {
    _$v = other as _$AdminAllCitiesDtoOutput;
  }

  @override
  void update(void Function(AdminAllCitiesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminAllCitiesDtoOutput build() => _build();

  _$AdminAllCitiesDtoOutput _build() {
    _$AdminAllCitiesDtoOutput _$result;
    try {
      _$result = _$v ?? _$AdminAllCitiesDtoOutput._(cities: cities.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'cities';
        cities.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminAllCitiesDtoOutput',
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
