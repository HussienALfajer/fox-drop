// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_settlement_preview_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantSettlementPreviewRequestDto
    extends AdminRestaurantSettlementPreviewRequestDto {
  @override
  final String restaurantId;
  @override
  final BuiltList<AdminOpenDrawerSessionDtoFloatsInner> lines;

  factory _$AdminRestaurantSettlementPreviewRequestDto([
    void Function(AdminRestaurantSettlementPreviewRequestDtoBuilder)? updates,
  ]) => (AdminRestaurantSettlementPreviewRequestDtoBuilder()..update(updates))
      ._build();

  _$AdminRestaurantSettlementPreviewRequestDto._({
    required this.restaurantId,
    required this.lines,
  }) : super._();
  @override
  AdminRestaurantSettlementPreviewRequestDto rebuild(
    void Function(AdminRestaurantSettlementPreviewRequestDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantSettlementPreviewRequestDtoBuilder toBuilder() =>
      AdminRestaurantSettlementPreviewRequestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantSettlementPreviewRequestDto &&
        restaurantId == other.restaurantId &&
        lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantSettlementPreviewRequestDto',
          )
          ..add('restaurantId', restaurantId)
          ..add('lines', lines))
        .toString();
  }
}

class AdminRestaurantSettlementPreviewRequestDtoBuilder
    implements
        Builder<
          AdminRestaurantSettlementPreviewRequestDto,
          AdminRestaurantSettlementPreviewRequestDtoBuilder
        > {
  _$AdminRestaurantSettlementPreviewRequestDto? _$v;

  String? _restaurantId;
  String? get restaurantId => _$this._restaurantId;
  set restaurantId(String? restaurantId) => _$this._restaurantId = restaurantId;

  ListBuilder<AdminOpenDrawerSessionDtoFloatsInner>? _lines;
  ListBuilder<AdminOpenDrawerSessionDtoFloatsInner> get lines =>
      _$this._lines ??= ListBuilder<AdminOpenDrawerSessionDtoFloatsInner>();
  set lines(ListBuilder<AdminOpenDrawerSessionDtoFloatsInner>? lines) =>
      _$this._lines = lines;

  AdminRestaurantSettlementPreviewRequestDtoBuilder() {
    AdminRestaurantSettlementPreviewRequestDto._defaults(this);
  }

  AdminRestaurantSettlementPreviewRequestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _restaurantId = $v.restaurantId;
      _lines = $v.lines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantSettlementPreviewRequestDto other) {
    _$v = other as _$AdminRestaurantSettlementPreviewRequestDto;
  }

  @override
  void update(
    void Function(AdminRestaurantSettlementPreviewRequestDtoBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantSettlementPreviewRequestDto build() => _build();

  _$AdminRestaurantSettlementPreviewRequestDto _build() {
    _$AdminRestaurantSettlementPreviewRequestDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantSettlementPreviewRequestDto._(
            restaurantId: BuiltValueNullFieldError.checkNotNull(
              restaurantId,
              r'AdminRestaurantSettlementPreviewRequestDto',
              'restaurantId',
            ),
            lines: lines.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantSettlementPreviewRequestDto',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
