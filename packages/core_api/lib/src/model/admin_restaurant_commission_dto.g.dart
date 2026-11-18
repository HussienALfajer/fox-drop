// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_commission_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantCommissionDto extends AdminRestaurantCommissionDto {
  @override
  final int rateBp;
  @override
  final DateTime? effectiveFrom;
  @override
  final String reason;

  factory _$AdminRestaurantCommissionDto([
    void Function(AdminRestaurantCommissionDtoBuilder)? updates,
  ]) => (AdminRestaurantCommissionDtoBuilder()..update(updates))._build();

  _$AdminRestaurantCommissionDto._({
    required this.rateBp,
    this.effectiveFrom,
    required this.reason,
  }) : super._();
  @override
  AdminRestaurantCommissionDto rebuild(
    void Function(AdminRestaurantCommissionDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantCommissionDtoBuilder toBuilder() =>
      AdminRestaurantCommissionDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantCommissionDto &&
        rateBp == other.rateBp &&
        effectiveFrom == other.effectiveFrom &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, rateBp.hashCode);
    _$hash = $jc(_$hash, effectiveFrom.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRestaurantCommissionDto')
          ..add('rateBp', rateBp)
          ..add('effectiveFrom', effectiveFrom)
          ..add('reason', reason))
        .toString();
  }
}

class AdminRestaurantCommissionDtoBuilder
    implements
        Builder<
          AdminRestaurantCommissionDto,
          AdminRestaurantCommissionDtoBuilder
        > {
  _$AdminRestaurantCommissionDto? _$v;

  int? _rateBp;
  int? get rateBp => _$this._rateBp;
  set rateBp(int? rateBp) => _$this._rateBp = rateBp;

  DateTime? _effectiveFrom;
  DateTime? get effectiveFrom => _$this._effectiveFrom;
  set effectiveFrom(DateTime? effectiveFrom) =>
      _$this._effectiveFrom = effectiveFrom;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminRestaurantCommissionDtoBuilder() {
    AdminRestaurantCommissionDto._defaults(this);
  }

  AdminRestaurantCommissionDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rateBp = $v.rateBp;
      _effectiveFrom = $v.effectiveFrom;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantCommissionDto other) {
    _$v = other as _$AdminRestaurantCommissionDto;
  }

  @override
  void update(void Function(AdminRestaurantCommissionDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantCommissionDto build() => _build();

  _$AdminRestaurantCommissionDto _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantCommissionDto._(
          rateBp: BuiltValueNullFieldError.checkNotNull(
            rateBp,
            r'AdminRestaurantCommissionDto',
            'rateBp',
          ),
          effectiveFrom: effectiveFrom,
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminRestaurantCommissionDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
