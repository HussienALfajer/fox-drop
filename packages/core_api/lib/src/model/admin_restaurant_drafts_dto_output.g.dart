// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_drafts_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantDraftsDtoOutput extends AdminRestaurantDraftsDtoOutput {
  @override
  final BuiltList<AdminRestaurantDraftsDtoOutputDraftsInner> drafts;

  factory _$AdminRestaurantDraftsDtoOutput([
    void Function(AdminRestaurantDraftsDtoOutputBuilder)? updates,
  ]) => (AdminRestaurantDraftsDtoOutputBuilder()..update(updates))._build();

  _$AdminRestaurantDraftsDtoOutput._({required this.drafts}) : super._();
  @override
  AdminRestaurantDraftsDtoOutput rebuild(
    void Function(AdminRestaurantDraftsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantDraftsDtoOutputBuilder toBuilder() =>
      AdminRestaurantDraftsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantDraftsDtoOutput && drafts == other.drafts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, drafts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminRestaurantDraftsDtoOutput',
    )..add('drafts', drafts)).toString();
  }
}

class AdminRestaurantDraftsDtoOutputBuilder
    implements
        Builder<
          AdminRestaurantDraftsDtoOutput,
          AdminRestaurantDraftsDtoOutputBuilder
        > {
  _$AdminRestaurantDraftsDtoOutput? _$v;

  ListBuilder<AdminRestaurantDraftsDtoOutputDraftsInner>? _drafts;
  ListBuilder<AdminRestaurantDraftsDtoOutputDraftsInner> get drafts =>
      _$this._drafts ??=
          ListBuilder<AdminRestaurantDraftsDtoOutputDraftsInner>();
  set drafts(ListBuilder<AdminRestaurantDraftsDtoOutputDraftsInner>? drafts) =>
      _$this._drafts = drafts;

  AdminRestaurantDraftsDtoOutputBuilder() {
    AdminRestaurantDraftsDtoOutput._defaults(this);
  }

  AdminRestaurantDraftsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _drafts = $v.drafts.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantDraftsDtoOutput other) {
    _$v = other as _$AdminRestaurantDraftsDtoOutput;
  }

  @override
  void update(void Function(AdminRestaurantDraftsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantDraftsDtoOutput build() => _build();

  _$AdminRestaurantDraftsDtoOutput _build() {
    _$AdminRestaurantDraftsDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$AdminRestaurantDraftsDtoOutput._(drafts: drafts.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'drafts';
        drafts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantDraftsDtoOutput',
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
