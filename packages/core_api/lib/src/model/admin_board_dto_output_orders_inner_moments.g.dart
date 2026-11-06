// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_board_dto_output_orders_inner_moments.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminBoardDtoOutputOrdersInnerMoments
    extends AdminBoardDtoOutputOrdersInnerMoments {
  @override
  final DateTime? acceptAlertAt;
  @override
  final DateTime? prepLateAlertAt;
  @override
  final DateTime? searchStartedAt;
  @override
  final DateTime? searchAlertAt;
  @override
  final DateTime? noCaptainAlertAt;

  factory _$AdminBoardDtoOutputOrdersInnerMoments([
    void Function(AdminBoardDtoOutputOrdersInnerMomentsBuilder)? updates,
  ]) => (AdminBoardDtoOutputOrdersInnerMomentsBuilder()..update(updates))
      ._build();

  _$AdminBoardDtoOutputOrdersInnerMoments._({
    this.acceptAlertAt,
    this.prepLateAlertAt,
    this.searchStartedAt,
    this.searchAlertAt,
    this.noCaptainAlertAt,
  }) : super._();
  @override
  AdminBoardDtoOutputOrdersInnerMoments rebuild(
    void Function(AdminBoardDtoOutputOrdersInnerMomentsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminBoardDtoOutputOrdersInnerMomentsBuilder toBuilder() =>
      AdminBoardDtoOutputOrdersInnerMomentsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminBoardDtoOutputOrdersInnerMoments &&
        acceptAlertAt == other.acceptAlertAt &&
        prepLateAlertAt == other.prepLateAlertAt &&
        searchStartedAt == other.searchStartedAt &&
        searchAlertAt == other.searchAlertAt &&
        noCaptainAlertAt == other.noCaptainAlertAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, acceptAlertAt.hashCode);
    _$hash = $jc(_$hash, prepLateAlertAt.hashCode);
    _$hash = $jc(_$hash, searchStartedAt.hashCode);
    _$hash = $jc(_$hash, searchAlertAt.hashCode);
    _$hash = $jc(_$hash, noCaptainAlertAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminBoardDtoOutputOrdersInnerMoments',
          )
          ..add('acceptAlertAt', acceptAlertAt)
          ..add('prepLateAlertAt', prepLateAlertAt)
          ..add('searchStartedAt', searchStartedAt)
          ..add('searchAlertAt', searchAlertAt)
          ..add('noCaptainAlertAt', noCaptainAlertAt))
        .toString();
  }
}

class AdminBoardDtoOutputOrdersInnerMomentsBuilder
    implements
        Builder<
          AdminBoardDtoOutputOrdersInnerMoments,
          AdminBoardDtoOutputOrdersInnerMomentsBuilder
        > {
  _$AdminBoardDtoOutputOrdersInnerMoments? _$v;

  DateTime? _acceptAlertAt;
  DateTime? get acceptAlertAt => _$this._acceptAlertAt;
  set acceptAlertAt(DateTime? acceptAlertAt) =>
      _$this._acceptAlertAt = acceptAlertAt;

  DateTime? _prepLateAlertAt;
  DateTime? get prepLateAlertAt => _$this._prepLateAlertAt;
  set prepLateAlertAt(DateTime? prepLateAlertAt) =>
      _$this._prepLateAlertAt = prepLateAlertAt;

  DateTime? _searchStartedAt;
  DateTime? get searchStartedAt => _$this._searchStartedAt;
  set searchStartedAt(DateTime? searchStartedAt) =>
      _$this._searchStartedAt = searchStartedAt;

  DateTime? _searchAlertAt;
  DateTime? get searchAlertAt => _$this._searchAlertAt;
  set searchAlertAt(DateTime? searchAlertAt) =>
      _$this._searchAlertAt = searchAlertAt;

  DateTime? _noCaptainAlertAt;
  DateTime? get noCaptainAlertAt => _$this._noCaptainAlertAt;
  set noCaptainAlertAt(DateTime? noCaptainAlertAt) =>
      _$this._noCaptainAlertAt = noCaptainAlertAt;

  AdminBoardDtoOutputOrdersInnerMomentsBuilder() {
    AdminBoardDtoOutputOrdersInnerMoments._defaults(this);
  }

  AdminBoardDtoOutputOrdersInnerMomentsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _acceptAlertAt = $v.acceptAlertAt;
      _prepLateAlertAt = $v.prepLateAlertAt;
      _searchStartedAt = $v.searchStartedAt;
      _searchAlertAt = $v.searchAlertAt;
      _noCaptainAlertAt = $v.noCaptainAlertAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminBoardDtoOutputOrdersInnerMoments other) {
    _$v = other as _$AdminBoardDtoOutputOrdersInnerMoments;
  }

  @override
  void update(
    void Function(AdminBoardDtoOutputOrdersInnerMomentsBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminBoardDtoOutputOrdersInnerMoments build() => _build();

  _$AdminBoardDtoOutputOrdersInnerMoments _build() {
    final _$result =
        _$v ??
        _$AdminBoardDtoOutputOrdersInnerMoments._(
          acceptAlertAt: acceptAlertAt,
          prepLateAlertAt: prepLateAlertAt,
          searchStartedAt: searchStartedAt,
          searchAlertAt: searchAlertAt,
          noCaptainAlertAt: noCaptainAlertAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
