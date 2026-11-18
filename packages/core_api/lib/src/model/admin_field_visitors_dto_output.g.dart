// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_field_visitors_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminFieldVisitorsDtoOutput extends AdminFieldVisitorsDtoOutput {
  @override
  final BuiltList<AdminRestaurantDraftChoicesDtoOutputCategoriesInner> visitors;

  factory _$AdminFieldVisitorsDtoOutput([
    void Function(AdminFieldVisitorsDtoOutputBuilder)? updates,
  ]) => (AdminFieldVisitorsDtoOutputBuilder()..update(updates))._build();

  _$AdminFieldVisitorsDtoOutput._({required this.visitors}) : super._();
  @override
  AdminFieldVisitorsDtoOutput rebuild(
    void Function(AdminFieldVisitorsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminFieldVisitorsDtoOutputBuilder toBuilder() =>
      AdminFieldVisitorsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminFieldVisitorsDtoOutput && visitors == other.visitors;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, visitors.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminFieldVisitorsDtoOutput',
    )..add('visitors', visitors)).toString();
  }
}

class AdminFieldVisitorsDtoOutputBuilder
    implements
        Builder<
          AdminFieldVisitorsDtoOutput,
          AdminFieldVisitorsDtoOutputBuilder
        > {
  _$AdminFieldVisitorsDtoOutput? _$v;

  ListBuilder<AdminRestaurantDraftChoicesDtoOutputCategoriesInner>? _visitors;
  ListBuilder<AdminRestaurantDraftChoicesDtoOutputCategoriesInner>
  get visitors => _$this._visitors ??=
      ListBuilder<AdminRestaurantDraftChoicesDtoOutputCategoriesInner>();
  set visitors(
    ListBuilder<AdminRestaurantDraftChoicesDtoOutputCategoriesInner>? visitors,
  ) => _$this._visitors = visitors;

  AdminFieldVisitorsDtoOutputBuilder() {
    AdminFieldVisitorsDtoOutput._defaults(this);
  }

  AdminFieldVisitorsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _visitors = $v.visitors.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminFieldVisitorsDtoOutput other) {
    _$v = other as _$AdminFieldVisitorsDtoOutput;
  }

  @override
  void update(void Function(AdminFieldVisitorsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminFieldVisitorsDtoOutput build() => _build();

  _$AdminFieldVisitorsDtoOutput _build() {
    _$AdminFieldVisitorsDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$AdminFieldVisitorsDtoOutput._(visitors: visitors.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'visitors';
        visitors.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminFieldVisitorsDtoOutput',
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
