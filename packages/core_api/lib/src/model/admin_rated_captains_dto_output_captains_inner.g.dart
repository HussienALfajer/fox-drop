// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_rated_captains_dto_output_captains_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRatedCaptainsDtoOutputCaptainsInner
    extends AdminRatedCaptainsDtoOutputCaptainsInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final int count;
  @override
  final num? average;

  factory _$AdminRatedCaptainsDtoOutputCaptainsInner([
    void Function(AdminRatedCaptainsDtoOutputCaptainsInnerBuilder)? updates,
  ]) => (AdminRatedCaptainsDtoOutputCaptainsInnerBuilder()..update(updates))
      ._build();

  _$AdminRatedCaptainsDtoOutputCaptainsInner._({
    required this.id,
    required this.name,
    required this.count,
    this.average,
  }) : super._();
  @override
  AdminRatedCaptainsDtoOutputCaptainsInner rebuild(
    void Function(AdminRatedCaptainsDtoOutputCaptainsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRatedCaptainsDtoOutputCaptainsInnerBuilder toBuilder() =>
      AdminRatedCaptainsDtoOutputCaptainsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRatedCaptainsDtoOutputCaptainsInner &&
        id == other.id &&
        name == other.name &&
        count == other.count &&
        average == other.average;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jc(_$hash, average.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRatedCaptainsDtoOutputCaptainsInner',
          )
          ..add('id', id)
          ..add('name', name)
          ..add('count', count)
          ..add('average', average))
        .toString();
  }
}

class AdminRatedCaptainsDtoOutputCaptainsInnerBuilder
    implements
        Builder<
          AdminRatedCaptainsDtoOutputCaptainsInner,
          AdminRatedCaptainsDtoOutputCaptainsInnerBuilder
        > {
  _$AdminRatedCaptainsDtoOutputCaptainsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  num? _average;
  num? get average => _$this._average;
  set average(num? average) => _$this._average = average;

  AdminRatedCaptainsDtoOutputCaptainsInnerBuilder() {
    AdminRatedCaptainsDtoOutputCaptainsInner._defaults(this);
  }

  AdminRatedCaptainsDtoOutputCaptainsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _count = $v.count;
      _average = $v.average;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRatedCaptainsDtoOutputCaptainsInner other) {
    _$v = other as _$AdminRatedCaptainsDtoOutputCaptainsInner;
  }

  @override
  void update(
    void Function(AdminRatedCaptainsDtoOutputCaptainsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRatedCaptainsDtoOutputCaptainsInner build() => _build();

  _$AdminRatedCaptainsDtoOutputCaptainsInner _build() {
    final _$result =
        _$v ??
        _$AdminRatedCaptainsDtoOutputCaptainsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminRatedCaptainsDtoOutputCaptainsInner',
            'id',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminRatedCaptainsDtoOutputCaptainsInner',
            'name',
          ),
          count: BuiltValueNullFieldError.checkNotNull(
            count,
            r'AdminRatedCaptainsDtoOutputCaptainsInner',
            'count',
          ),
          average: average,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
