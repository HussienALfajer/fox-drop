// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_overview_dto_output_rejection_reasons_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantOverviewDtoOutputRejectionReasonsInner
    extends AdminRestaurantOverviewDtoOutputRejectionReasonsInner {
  @override
  final String label;
  @override
  final int count;

  factory _$AdminRestaurantOverviewDtoOutputRejectionReasonsInner([
    void Function(AdminRestaurantOverviewDtoOutputRejectionReasonsInnerBuilder)?
    updates,
  ]) =>
      (AdminRestaurantOverviewDtoOutputRejectionReasonsInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminRestaurantOverviewDtoOutputRejectionReasonsInner._({
    required this.label,
    required this.count,
  }) : super._();
  @override
  AdminRestaurantOverviewDtoOutputRejectionReasonsInner rebuild(
    void Function(AdminRestaurantOverviewDtoOutputRejectionReasonsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantOverviewDtoOutputRejectionReasonsInnerBuilder toBuilder() =>
      AdminRestaurantOverviewDtoOutputRejectionReasonsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantOverviewDtoOutputRejectionReasonsInner &&
        label == other.label &&
        count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantOverviewDtoOutputRejectionReasonsInner',
          )
          ..add('label', label)
          ..add('count', count))
        .toString();
  }
}

class AdminRestaurantOverviewDtoOutputRejectionReasonsInnerBuilder
    implements
        Builder<
          AdminRestaurantOverviewDtoOutputRejectionReasonsInner,
          AdminRestaurantOverviewDtoOutputRejectionReasonsInnerBuilder
        > {
  _$AdminRestaurantOverviewDtoOutputRejectionReasonsInner? _$v;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  AdminRestaurantOverviewDtoOutputRejectionReasonsInnerBuilder() {
    AdminRestaurantOverviewDtoOutputRejectionReasonsInner._defaults(this);
  }

  AdminRestaurantOverviewDtoOutputRejectionReasonsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _label = $v.label;
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantOverviewDtoOutputRejectionReasonsInner other) {
    _$v = other as _$AdminRestaurantOverviewDtoOutputRejectionReasonsInner;
  }

  @override
  void update(
    void Function(AdminRestaurantOverviewDtoOutputRejectionReasonsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantOverviewDtoOutputRejectionReasonsInner build() => _build();

  _$AdminRestaurantOverviewDtoOutputRejectionReasonsInner _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantOverviewDtoOutputRejectionReasonsInner._(
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'AdminRestaurantOverviewDtoOutputRejectionReasonsInner',
            'label',
          ),
          count: BuiltValueNullFieldError.checkNotNull(
            count,
            r'AdminRestaurantOverviewDtoOutputRejectionReasonsInner',
            'count',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
