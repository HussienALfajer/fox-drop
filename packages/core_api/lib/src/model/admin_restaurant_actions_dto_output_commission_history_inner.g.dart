// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_actions_dto_output_commission_history_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantActionsDtoOutputCommissionHistoryInner
    extends AdminRestaurantActionsDtoOutputCommissionHistoryInner {
  @override
  final String id;
  @override
  final int rateBp;
  @override
  final DateTime from;
  @override
  final String? reason;
  @override
  final DateTime setAt;
  @override
  final bool byAdmin;

  factory _$AdminRestaurantActionsDtoOutputCommissionHistoryInner([
    void Function(AdminRestaurantActionsDtoOutputCommissionHistoryInnerBuilder)?
    updates,
  ]) =>
      (AdminRestaurantActionsDtoOutputCommissionHistoryInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminRestaurantActionsDtoOutputCommissionHistoryInner._({
    required this.id,
    required this.rateBp,
    required this.from,
    this.reason,
    required this.setAt,
    required this.byAdmin,
  }) : super._();
  @override
  AdminRestaurantActionsDtoOutputCommissionHistoryInner rebuild(
    void Function(AdminRestaurantActionsDtoOutputCommissionHistoryInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantActionsDtoOutputCommissionHistoryInnerBuilder toBuilder() =>
      AdminRestaurantActionsDtoOutputCommissionHistoryInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantActionsDtoOutputCommissionHistoryInner &&
        id == other.id &&
        rateBp == other.rateBp &&
        from == other.from &&
        reason == other.reason &&
        setAt == other.setAt &&
        byAdmin == other.byAdmin;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, rateBp.hashCode);
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, setAt.hashCode);
    _$hash = $jc(_$hash, byAdmin.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantActionsDtoOutputCommissionHistoryInner',
          )
          ..add('id', id)
          ..add('rateBp', rateBp)
          ..add('from', from)
          ..add('reason', reason)
          ..add('setAt', setAt)
          ..add('byAdmin', byAdmin))
        .toString();
  }
}

class AdminRestaurantActionsDtoOutputCommissionHistoryInnerBuilder
    implements
        Builder<
          AdminRestaurantActionsDtoOutputCommissionHistoryInner,
          AdminRestaurantActionsDtoOutputCommissionHistoryInnerBuilder
        > {
  _$AdminRestaurantActionsDtoOutputCommissionHistoryInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _rateBp;
  int? get rateBp => _$this._rateBp;
  set rateBp(int? rateBp) => _$this._rateBp = rateBp;

  DateTime? _from;
  DateTime? get from => _$this._from;
  set from(DateTime? from) => _$this._from = from;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DateTime? _setAt;
  DateTime? get setAt => _$this._setAt;
  set setAt(DateTime? setAt) => _$this._setAt = setAt;

  bool? _byAdmin;
  bool? get byAdmin => _$this._byAdmin;
  set byAdmin(bool? byAdmin) => _$this._byAdmin = byAdmin;

  AdminRestaurantActionsDtoOutputCommissionHistoryInnerBuilder() {
    AdminRestaurantActionsDtoOutputCommissionHistoryInner._defaults(this);
  }

  AdminRestaurantActionsDtoOutputCommissionHistoryInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _rateBp = $v.rateBp;
      _from = $v.from;
      _reason = $v.reason;
      _setAt = $v.setAt;
      _byAdmin = $v.byAdmin;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantActionsDtoOutputCommissionHistoryInner other) {
    _$v = other as _$AdminRestaurantActionsDtoOutputCommissionHistoryInner;
  }

  @override
  void update(
    void Function(AdminRestaurantActionsDtoOutputCommissionHistoryInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantActionsDtoOutputCommissionHistoryInner build() => _build();

  _$AdminRestaurantActionsDtoOutputCommissionHistoryInner _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantActionsDtoOutputCommissionHistoryInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminRestaurantActionsDtoOutputCommissionHistoryInner',
            'id',
          ),
          rateBp: BuiltValueNullFieldError.checkNotNull(
            rateBp,
            r'AdminRestaurantActionsDtoOutputCommissionHistoryInner',
            'rateBp',
          ),
          from: BuiltValueNullFieldError.checkNotNull(
            from,
            r'AdminRestaurantActionsDtoOutputCommissionHistoryInner',
            'from',
          ),
          reason: reason,
          setAt: BuiltValueNullFieldError.checkNotNull(
            setAt,
            r'AdminRestaurantActionsDtoOutputCommissionHistoryInner',
            'setAt',
          ),
          byAdmin: BuiltValueNullFieldError.checkNotNull(
            byAdmin,
            r'AdminRestaurantActionsDtoOutputCommissionHistoryInner',
            'byAdmin',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
