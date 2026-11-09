// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dispatch_state_dto_output_order_offer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDispatchStateDtoOutputOrderOffer
    extends AdminDispatchStateDtoOutputOrderOffer {
  @override
  final String id;
  @override
  final String captainId;
  @override
  final DateTime expiresAt;

  factory _$AdminDispatchStateDtoOutputOrderOffer([
    void Function(AdminDispatchStateDtoOutputOrderOfferBuilder)? updates,
  ]) => (AdminDispatchStateDtoOutputOrderOfferBuilder()..update(updates))
      ._build();

  _$AdminDispatchStateDtoOutputOrderOffer._({
    required this.id,
    required this.captainId,
    required this.expiresAt,
  }) : super._();
  @override
  AdminDispatchStateDtoOutputOrderOffer rebuild(
    void Function(AdminDispatchStateDtoOutputOrderOfferBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDispatchStateDtoOutputOrderOfferBuilder toBuilder() =>
      AdminDispatchStateDtoOutputOrderOfferBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDispatchStateDtoOutputOrderOffer &&
        id == other.id &&
        captainId == other.captainId &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, captainId.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminDispatchStateDtoOutputOrderOffer',
          )
          ..add('id', id)
          ..add('captainId', captainId)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class AdminDispatchStateDtoOutputOrderOfferBuilder
    implements
        Builder<
          AdminDispatchStateDtoOutputOrderOffer,
          AdminDispatchStateDtoOutputOrderOfferBuilder
        > {
  _$AdminDispatchStateDtoOutputOrderOffer? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _captainId;
  String? get captainId => _$this._captainId;
  set captainId(String? captainId) => _$this._captainId = captainId;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  AdminDispatchStateDtoOutputOrderOfferBuilder() {
    AdminDispatchStateDtoOutputOrderOffer._defaults(this);
  }

  AdminDispatchStateDtoOutputOrderOfferBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _captainId = $v.captainId;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDispatchStateDtoOutputOrderOffer other) {
    _$v = other as _$AdminDispatchStateDtoOutputOrderOffer;
  }

  @override
  void update(
    void Function(AdminDispatchStateDtoOutputOrderOfferBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDispatchStateDtoOutputOrderOffer build() => _build();

  _$AdminDispatchStateDtoOutputOrderOffer _build() {
    final _$result =
        _$v ??
        _$AdminDispatchStateDtoOutputOrderOffer._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminDispatchStateDtoOutputOrderOffer',
            'id',
          ),
          captainId: BuiltValueNullFieldError.checkNotNull(
            captainId,
            r'AdminDispatchStateDtoOutputOrderOffer',
            'captainId',
          ),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
            expiresAt,
            r'AdminDispatchStateDtoOutputOrderOffer',
            'expiresAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
