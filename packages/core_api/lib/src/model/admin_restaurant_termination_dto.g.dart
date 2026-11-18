// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_termination_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantTerminationDto extends AdminRestaurantTerminationDto {
  @override
  final String reason;

  factory _$AdminRestaurantTerminationDto([
    void Function(AdminRestaurantTerminationDtoBuilder)? updates,
  ]) => (AdminRestaurantTerminationDtoBuilder()..update(updates))._build();

  _$AdminRestaurantTerminationDto._({required this.reason}) : super._();
  @override
  AdminRestaurantTerminationDto rebuild(
    void Function(AdminRestaurantTerminationDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantTerminationDtoBuilder toBuilder() =>
      AdminRestaurantTerminationDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantTerminationDto && reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminRestaurantTerminationDto',
    )..add('reason', reason)).toString();
  }
}

class AdminRestaurantTerminationDtoBuilder
    implements
        Builder<
          AdminRestaurantTerminationDto,
          AdminRestaurantTerminationDtoBuilder
        > {
  _$AdminRestaurantTerminationDto? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminRestaurantTerminationDtoBuilder() {
    AdminRestaurantTerminationDto._defaults(this);
  }

  AdminRestaurantTerminationDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantTerminationDto other) {
    _$v = other as _$AdminRestaurantTerminationDto;
  }

  @override
  void update(void Function(AdminRestaurantTerminationDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantTerminationDto build() => _build();

  _$AdminRestaurantTerminationDto _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantTerminationDto._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminRestaurantTerminationDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
