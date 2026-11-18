// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_draft_commission_dto_launch.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDraftCommissionDtoLaunch extends AdminDraftCommissionDtoLaunch {
  @override
  final int rateBp;
  @override
  final DateTime until;

  factory _$AdminDraftCommissionDtoLaunch([
    void Function(AdminDraftCommissionDtoLaunchBuilder)? updates,
  ]) => (AdminDraftCommissionDtoLaunchBuilder()..update(updates))._build();

  _$AdminDraftCommissionDtoLaunch._({required this.rateBp, required this.until})
    : super._();
  @override
  AdminDraftCommissionDtoLaunch rebuild(
    void Function(AdminDraftCommissionDtoLaunchBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDraftCommissionDtoLaunchBuilder toBuilder() =>
      AdminDraftCommissionDtoLaunchBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDraftCommissionDtoLaunch &&
        rateBp == other.rateBp &&
        until == other.until;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, rateBp.hashCode);
    _$hash = $jc(_$hash, until.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDraftCommissionDtoLaunch')
          ..add('rateBp', rateBp)
          ..add('until', until))
        .toString();
  }
}

class AdminDraftCommissionDtoLaunchBuilder
    implements
        Builder<
          AdminDraftCommissionDtoLaunch,
          AdminDraftCommissionDtoLaunchBuilder
        > {
  _$AdminDraftCommissionDtoLaunch? _$v;

  int? _rateBp;
  int? get rateBp => _$this._rateBp;
  set rateBp(int? rateBp) => _$this._rateBp = rateBp;

  DateTime? _until;
  DateTime? get until => _$this._until;
  set until(DateTime? until) => _$this._until = until;

  AdminDraftCommissionDtoLaunchBuilder() {
    AdminDraftCommissionDtoLaunch._defaults(this);
  }

  AdminDraftCommissionDtoLaunchBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rateBp = $v.rateBp;
      _until = $v.until;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDraftCommissionDtoLaunch other) {
    _$v = other as _$AdminDraftCommissionDtoLaunch;
  }

  @override
  void update(void Function(AdminDraftCommissionDtoLaunchBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDraftCommissionDtoLaunch build() => _build();

  _$AdminDraftCommissionDtoLaunch _build() {
    final _$result =
        _$v ??
        _$AdminDraftCommissionDtoLaunch._(
          rateBp: BuiltValueNullFieldError.checkNotNull(
            rateBp,
            r'AdminDraftCommissionDtoLaunch',
            'rateBp',
          ),
          until: BuiltValueNullFieldError.checkNotNull(
            until,
            r'AdminDraftCommissionDtoLaunch',
            'until',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
