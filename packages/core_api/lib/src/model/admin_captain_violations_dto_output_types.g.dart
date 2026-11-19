// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_violations_dto_output_types.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainViolationsDtoOutputTypes
    extends AdminCaptainViolationsDtoOutputTypes {
  @override
  final BuiltList<AdminCaptainViolationsDtoOutputTypesRegularInner> regular;
  @override
  final BuiltList<AdminCaptainViolationsDtoOutputTypesRegularInner> severe;

  factory _$AdminCaptainViolationsDtoOutputTypes([
    void Function(AdminCaptainViolationsDtoOutputTypesBuilder)? updates,
  ]) =>
      (AdminCaptainViolationsDtoOutputTypesBuilder()..update(updates))._build();

  _$AdminCaptainViolationsDtoOutputTypes._({
    required this.regular,
    required this.severe,
  }) : super._();
  @override
  AdminCaptainViolationsDtoOutputTypes rebuild(
    void Function(AdminCaptainViolationsDtoOutputTypesBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainViolationsDtoOutputTypesBuilder toBuilder() =>
      AdminCaptainViolationsDtoOutputTypesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainViolationsDtoOutputTypes &&
        regular == other.regular &&
        severe == other.severe;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, regular.hashCode);
    _$hash = $jc(_$hash, severe.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCaptainViolationsDtoOutputTypes')
          ..add('regular', regular)
          ..add('severe', severe))
        .toString();
  }
}

class AdminCaptainViolationsDtoOutputTypesBuilder
    implements
        Builder<
          AdminCaptainViolationsDtoOutputTypes,
          AdminCaptainViolationsDtoOutputTypesBuilder
        > {
  _$AdminCaptainViolationsDtoOutputTypes? _$v;

  ListBuilder<AdminCaptainViolationsDtoOutputTypesRegularInner>? _regular;
  ListBuilder<AdminCaptainViolationsDtoOutputTypesRegularInner> get regular =>
      _$this._regular ??=
          ListBuilder<AdminCaptainViolationsDtoOutputTypesRegularInner>();
  set regular(
    ListBuilder<AdminCaptainViolationsDtoOutputTypesRegularInner>? regular,
  ) => _$this._regular = regular;

  ListBuilder<AdminCaptainViolationsDtoOutputTypesRegularInner>? _severe;
  ListBuilder<AdminCaptainViolationsDtoOutputTypesRegularInner> get severe =>
      _$this._severe ??=
          ListBuilder<AdminCaptainViolationsDtoOutputTypesRegularInner>();
  set severe(
    ListBuilder<AdminCaptainViolationsDtoOutputTypesRegularInner>? severe,
  ) => _$this._severe = severe;

  AdminCaptainViolationsDtoOutputTypesBuilder() {
    AdminCaptainViolationsDtoOutputTypes._defaults(this);
  }

  AdminCaptainViolationsDtoOutputTypesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _regular = $v.regular.toBuilder();
      _severe = $v.severe.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainViolationsDtoOutputTypes other) {
    _$v = other as _$AdminCaptainViolationsDtoOutputTypes;
  }

  @override
  void update(
    void Function(AdminCaptainViolationsDtoOutputTypesBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainViolationsDtoOutputTypes build() => _build();

  _$AdminCaptainViolationsDtoOutputTypes _build() {
    _$AdminCaptainViolationsDtoOutputTypes _$result;
    try {
      _$result =
          _$v ??
          _$AdminCaptainViolationsDtoOutputTypes._(
            regular: regular.build(),
            severe: severe.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'regular';
        regular.build();
        _$failedField = 'severe';
        severe.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCaptainViolationsDtoOutputTypes',
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
