// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_list_dto_output_captains_inner_acceptance.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainListDtoOutputCaptainsInnerAcceptance
    extends AdminCaptainListDtoOutputCaptainsInnerAcceptance {
  @override
  final int accepted;
  @override
  final int answered;

  factory _$AdminCaptainListDtoOutputCaptainsInnerAcceptance([
    void Function(AdminCaptainListDtoOutputCaptainsInnerAcceptanceBuilder)?
    updates,
  ]) =>
      (AdminCaptainListDtoOutputCaptainsInnerAcceptanceBuilder()
            ..update(updates))
          ._build();

  _$AdminCaptainListDtoOutputCaptainsInnerAcceptance._({
    required this.accepted,
    required this.answered,
  }) : super._();
  @override
  AdminCaptainListDtoOutputCaptainsInnerAcceptance rebuild(
    void Function(AdminCaptainListDtoOutputCaptainsInnerAcceptanceBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainListDtoOutputCaptainsInnerAcceptanceBuilder toBuilder() =>
      AdminCaptainListDtoOutputCaptainsInnerAcceptanceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainListDtoOutputCaptainsInnerAcceptance &&
        accepted == other.accepted &&
        answered == other.answered;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accepted.hashCode);
    _$hash = $jc(_$hash, answered.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCaptainListDtoOutputCaptainsInnerAcceptance',
          )
          ..add('accepted', accepted)
          ..add('answered', answered))
        .toString();
  }
}

class AdminCaptainListDtoOutputCaptainsInnerAcceptanceBuilder
    implements
        Builder<
          AdminCaptainListDtoOutputCaptainsInnerAcceptance,
          AdminCaptainListDtoOutputCaptainsInnerAcceptanceBuilder
        > {
  _$AdminCaptainListDtoOutputCaptainsInnerAcceptance? _$v;

  int? _accepted;
  int? get accepted => _$this._accepted;
  set accepted(int? accepted) => _$this._accepted = accepted;

  int? _answered;
  int? get answered => _$this._answered;
  set answered(int? answered) => _$this._answered = answered;

  AdminCaptainListDtoOutputCaptainsInnerAcceptanceBuilder() {
    AdminCaptainListDtoOutputCaptainsInnerAcceptance._defaults(this);
  }

  AdminCaptainListDtoOutputCaptainsInnerAcceptanceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accepted = $v.accepted;
      _answered = $v.answered;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainListDtoOutputCaptainsInnerAcceptance other) {
    _$v = other as _$AdminCaptainListDtoOutputCaptainsInnerAcceptance;
  }

  @override
  void update(
    void Function(AdminCaptainListDtoOutputCaptainsInnerAcceptanceBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainListDtoOutputCaptainsInnerAcceptance build() => _build();

  _$AdminCaptainListDtoOutputCaptainsInnerAcceptance _build() {
    final _$result =
        _$v ??
        _$AdminCaptainListDtoOutputCaptainsInnerAcceptance._(
          accepted: BuiltValueNullFieldError.checkNotNull(
            accepted,
            r'AdminCaptainListDtoOutputCaptainsInnerAcceptance',
            'accepted',
          ),
          answered: BuiltValueNullFieldError.checkNotNull(
            answered,
            r'AdminCaptainListDtoOutputCaptainsInnerAcceptance',
            'answered',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
