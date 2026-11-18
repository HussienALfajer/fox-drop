// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_lost_demand_dto_output_suggestions_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminLostDemandDtoOutputSuggestionsInner
    extends AdminLostDemandDtoOutputSuggestionsInner {
  @override
  final String id;
  @override
  final String restaurantName;
  @override
  final String? note;
  @override
  final String? query;
  @override
  final DateTime at;

  factory _$AdminLostDemandDtoOutputSuggestionsInner([
    void Function(AdminLostDemandDtoOutputSuggestionsInnerBuilder)? updates,
  ]) => (AdminLostDemandDtoOutputSuggestionsInnerBuilder()..update(updates))
      ._build();

  _$AdminLostDemandDtoOutputSuggestionsInner._({
    required this.id,
    required this.restaurantName,
    this.note,
    this.query,
    required this.at,
  }) : super._();
  @override
  AdminLostDemandDtoOutputSuggestionsInner rebuild(
    void Function(AdminLostDemandDtoOutputSuggestionsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminLostDemandDtoOutputSuggestionsInnerBuilder toBuilder() =>
      AdminLostDemandDtoOutputSuggestionsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminLostDemandDtoOutputSuggestionsInner &&
        id == other.id &&
        restaurantName == other.restaurantName &&
        note == other.note &&
        query == other.query &&
        at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, restaurantName.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, query.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminLostDemandDtoOutputSuggestionsInner',
          )
          ..add('id', id)
          ..add('restaurantName', restaurantName)
          ..add('note', note)
          ..add('query', query)
          ..add('at', at))
        .toString();
  }
}

class AdminLostDemandDtoOutputSuggestionsInnerBuilder
    implements
        Builder<
          AdminLostDemandDtoOutputSuggestionsInner,
          AdminLostDemandDtoOutputSuggestionsInnerBuilder
        > {
  _$AdminLostDemandDtoOutputSuggestionsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _restaurantName;
  String? get restaurantName => _$this._restaurantName;
  set restaurantName(String? restaurantName) =>
      _$this._restaurantName = restaurantName;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  String? _query;
  String? get query => _$this._query;
  set query(String? query) => _$this._query = query;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  AdminLostDemandDtoOutputSuggestionsInnerBuilder() {
    AdminLostDemandDtoOutputSuggestionsInner._defaults(this);
  }

  AdminLostDemandDtoOutputSuggestionsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _restaurantName = $v.restaurantName;
      _note = $v.note;
      _query = $v.query;
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminLostDemandDtoOutputSuggestionsInner other) {
    _$v = other as _$AdminLostDemandDtoOutputSuggestionsInner;
  }

  @override
  void update(
    void Function(AdminLostDemandDtoOutputSuggestionsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminLostDemandDtoOutputSuggestionsInner build() => _build();

  _$AdminLostDemandDtoOutputSuggestionsInner _build() {
    final _$result =
        _$v ??
        _$AdminLostDemandDtoOutputSuggestionsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminLostDemandDtoOutputSuggestionsInner',
            'id',
          ),
          restaurantName: BuiltValueNullFieldError.checkNotNull(
            restaurantName,
            r'AdminLostDemandDtoOutputSuggestionsInner',
            'restaurantName',
          ),
          note: note,
          query: query,
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'AdminLostDemandDtoOutputSuggestionsInner',
            'at',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
