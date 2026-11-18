// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_lost_demand_dto_output_searches_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminLostDemandDtoOutputSearchesInner
    extends AdminLostDemandDtoOutputSearchesInner {
  @override
  final String query;
  @override
  final int count;
  @override
  final DateTime lastAt;

  factory _$AdminLostDemandDtoOutputSearchesInner([
    void Function(AdminLostDemandDtoOutputSearchesInnerBuilder)? updates,
  ]) => (AdminLostDemandDtoOutputSearchesInnerBuilder()..update(updates))
      ._build();

  _$AdminLostDemandDtoOutputSearchesInner._({
    required this.query,
    required this.count,
    required this.lastAt,
  }) : super._();
  @override
  AdminLostDemandDtoOutputSearchesInner rebuild(
    void Function(AdminLostDemandDtoOutputSearchesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminLostDemandDtoOutputSearchesInnerBuilder toBuilder() =>
      AdminLostDemandDtoOutputSearchesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminLostDemandDtoOutputSearchesInner &&
        query == other.query &&
        count == other.count &&
        lastAt == other.lastAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, query.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jc(_$hash, lastAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminLostDemandDtoOutputSearchesInner',
          )
          ..add('query', query)
          ..add('count', count)
          ..add('lastAt', lastAt))
        .toString();
  }
}

class AdminLostDemandDtoOutputSearchesInnerBuilder
    implements
        Builder<
          AdminLostDemandDtoOutputSearchesInner,
          AdminLostDemandDtoOutputSearchesInnerBuilder
        > {
  _$AdminLostDemandDtoOutputSearchesInner? _$v;

  String? _query;
  String? get query => _$this._query;
  set query(String? query) => _$this._query = query;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  DateTime? _lastAt;
  DateTime? get lastAt => _$this._lastAt;
  set lastAt(DateTime? lastAt) => _$this._lastAt = lastAt;

  AdminLostDemandDtoOutputSearchesInnerBuilder() {
    AdminLostDemandDtoOutputSearchesInner._defaults(this);
  }

  AdminLostDemandDtoOutputSearchesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _query = $v.query;
      _count = $v.count;
      _lastAt = $v.lastAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminLostDemandDtoOutputSearchesInner other) {
    _$v = other as _$AdminLostDemandDtoOutputSearchesInner;
  }

  @override
  void update(
    void Function(AdminLostDemandDtoOutputSearchesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminLostDemandDtoOutputSearchesInner build() => _build();

  _$AdminLostDemandDtoOutputSearchesInner _build() {
    final _$result =
        _$v ??
        _$AdminLostDemandDtoOutputSearchesInner._(
          query: BuiltValueNullFieldError.checkNotNull(
            query,
            r'AdminLostDemandDtoOutputSearchesInner',
            'query',
          ),
          count: BuiltValueNullFieldError.checkNotNull(
            count,
            r'AdminLostDemandDtoOutputSearchesInner',
            'count',
          ),
          lastAt: BuiltValueNullFieldError.checkNotNull(
            lastAt,
            r'AdminLostDemandDtoOutputSearchesInner',
            'lastAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
