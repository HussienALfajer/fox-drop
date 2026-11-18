// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_lost_demand_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminLostDemandDtoOutput extends AdminLostDemandDtoOutput {
  @override
  final DateTime since;
  @override
  final BuiltList<AdminLostDemandDtoOutputSearchesInner> searches;
  @override
  final BuiltList<AdminLostDemandDtoOutputSuggestionsInner> suggestions;

  factory _$AdminLostDemandDtoOutput([
    void Function(AdminLostDemandDtoOutputBuilder)? updates,
  ]) => (AdminLostDemandDtoOutputBuilder()..update(updates))._build();

  _$AdminLostDemandDtoOutput._({
    required this.since,
    required this.searches,
    required this.suggestions,
  }) : super._();
  @override
  AdminLostDemandDtoOutput rebuild(
    void Function(AdminLostDemandDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminLostDemandDtoOutputBuilder toBuilder() =>
      AdminLostDemandDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminLostDemandDtoOutput &&
        since == other.since &&
        searches == other.searches &&
        suggestions == other.suggestions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, since.hashCode);
    _$hash = $jc(_$hash, searches.hashCode);
    _$hash = $jc(_$hash, suggestions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminLostDemandDtoOutput')
          ..add('since', since)
          ..add('searches', searches)
          ..add('suggestions', suggestions))
        .toString();
  }
}

class AdminLostDemandDtoOutputBuilder
    implements
        Builder<AdminLostDemandDtoOutput, AdminLostDemandDtoOutputBuilder> {
  _$AdminLostDemandDtoOutput? _$v;

  DateTime? _since;
  DateTime? get since => _$this._since;
  set since(DateTime? since) => _$this._since = since;

  ListBuilder<AdminLostDemandDtoOutputSearchesInner>? _searches;
  ListBuilder<AdminLostDemandDtoOutputSearchesInner> get searches =>
      _$this._searches ??= ListBuilder<AdminLostDemandDtoOutputSearchesInner>();
  set searches(ListBuilder<AdminLostDemandDtoOutputSearchesInner>? searches) =>
      _$this._searches = searches;

  ListBuilder<AdminLostDemandDtoOutputSuggestionsInner>? _suggestions;
  ListBuilder<AdminLostDemandDtoOutputSuggestionsInner> get suggestions =>
      _$this._suggestions ??=
          ListBuilder<AdminLostDemandDtoOutputSuggestionsInner>();
  set suggestions(
    ListBuilder<AdminLostDemandDtoOutputSuggestionsInner>? suggestions,
  ) => _$this._suggestions = suggestions;

  AdminLostDemandDtoOutputBuilder() {
    AdminLostDemandDtoOutput._defaults(this);
  }

  AdminLostDemandDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _since = $v.since;
      _searches = $v.searches.toBuilder();
      _suggestions = $v.suggestions.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminLostDemandDtoOutput other) {
    _$v = other as _$AdminLostDemandDtoOutput;
  }

  @override
  void update(void Function(AdminLostDemandDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminLostDemandDtoOutput build() => _build();

  _$AdminLostDemandDtoOutput _build() {
    _$AdminLostDemandDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminLostDemandDtoOutput._(
            since: BuiltValueNullFieldError.checkNotNull(
              since,
              r'AdminLostDemandDtoOutput',
              'since',
            ),
            searches: searches.build(),
            suggestions: suggestions.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'searches';
        searches.build();
        _$failedField = 'suggestions';
        suggestions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminLostDemandDtoOutput',
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
