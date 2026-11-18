// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_parties_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTicketPartiesDtoOutput extends AdminTicketPartiesDtoOutput {
  @override
  final BuiltList<AdminRestaurantDraftChoicesDtoOutputCategoriesInner> parties;

  factory _$AdminTicketPartiesDtoOutput([
    void Function(AdminTicketPartiesDtoOutputBuilder)? updates,
  ]) => (AdminTicketPartiesDtoOutputBuilder()..update(updates))._build();

  _$AdminTicketPartiesDtoOutput._({required this.parties}) : super._();
  @override
  AdminTicketPartiesDtoOutput rebuild(
    void Function(AdminTicketPartiesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketPartiesDtoOutputBuilder toBuilder() =>
      AdminTicketPartiesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketPartiesDtoOutput && parties == other.parties;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, parties.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminTicketPartiesDtoOutput',
    )..add('parties', parties)).toString();
  }
}

class AdminTicketPartiesDtoOutputBuilder
    implements
        Builder<
          AdminTicketPartiesDtoOutput,
          AdminTicketPartiesDtoOutputBuilder
        > {
  _$AdminTicketPartiesDtoOutput? _$v;

  ListBuilder<AdminRestaurantDraftChoicesDtoOutputCategoriesInner>? _parties;
  ListBuilder<AdminRestaurantDraftChoicesDtoOutputCategoriesInner>
  get parties => _$this._parties ??=
      ListBuilder<AdminRestaurantDraftChoicesDtoOutputCategoriesInner>();
  set parties(
    ListBuilder<AdminRestaurantDraftChoicesDtoOutputCategoriesInner>? parties,
  ) => _$this._parties = parties;

  AdminTicketPartiesDtoOutputBuilder() {
    AdminTicketPartiesDtoOutput._defaults(this);
  }

  AdminTicketPartiesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _parties = $v.parties.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketPartiesDtoOutput other) {
    _$v = other as _$AdminTicketPartiesDtoOutput;
  }

  @override
  void update(void Function(AdminTicketPartiesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketPartiesDtoOutput build() => _build();

  _$AdminTicketPartiesDtoOutput _build() {
    _$AdminTicketPartiesDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$AdminTicketPartiesDtoOutput._(parties: parties.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'parties';
        parties.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminTicketPartiesDtoOutput',
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
