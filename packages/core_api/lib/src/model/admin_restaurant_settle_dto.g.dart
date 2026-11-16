// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_settle_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantSettleDto extends AdminRestaurantSettleDto {
  @override
  final String restaurantId;
  @override
  final String due;
  @override
  final BuiltList<AdminRestaurantSettleDtoLinesInner> lines;

  factory _$AdminRestaurantSettleDto([
    void Function(AdminRestaurantSettleDtoBuilder)? updates,
  ]) => (AdminRestaurantSettleDtoBuilder()..update(updates))._build();

  _$AdminRestaurantSettleDto._({
    required this.restaurantId,
    required this.due,
    required this.lines,
  }) : super._();
  @override
  AdminRestaurantSettleDto rebuild(
    void Function(AdminRestaurantSettleDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantSettleDtoBuilder toBuilder() =>
      AdminRestaurantSettleDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantSettleDto &&
        restaurantId == other.restaurantId &&
        due == other.due &&
        lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jc(_$hash, due.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRestaurantSettleDto')
          ..add('restaurantId', restaurantId)
          ..add('due', due)
          ..add('lines', lines))
        .toString();
  }
}

class AdminRestaurantSettleDtoBuilder
    implements
        Builder<AdminRestaurantSettleDto, AdminRestaurantSettleDtoBuilder> {
  _$AdminRestaurantSettleDto? _$v;

  String? _restaurantId;
  String? get restaurantId => _$this._restaurantId;
  set restaurantId(String? restaurantId) => _$this._restaurantId = restaurantId;

  String? _due;
  String? get due => _$this._due;
  set due(String? due) => _$this._due = due;

  ListBuilder<AdminRestaurantSettleDtoLinesInner>? _lines;
  ListBuilder<AdminRestaurantSettleDtoLinesInner> get lines =>
      _$this._lines ??= ListBuilder<AdminRestaurantSettleDtoLinesInner>();
  set lines(ListBuilder<AdminRestaurantSettleDtoLinesInner>? lines) =>
      _$this._lines = lines;

  AdminRestaurantSettleDtoBuilder() {
    AdminRestaurantSettleDto._defaults(this);
  }

  AdminRestaurantSettleDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _restaurantId = $v.restaurantId;
      _due = $v.due;
      _lines = $v.lines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantSettleDto other) {
    _$v = other as _$AdminRestaurantSettleDto;
  }

  @override
  void update(void Function(AdminRestaurantSettleDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantSettleDto build() => _build();

  _$AdminRestaurantSettleDto _build() {
    _$AdminRestaurantSettleDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantSettleDto._(
            restaurantId: BuiltValueNullFieldError.checkNotNull(
              restaurantId,
              r'AdminRestaurantSettleDto',
              'restaurantId',
            ),
            due: BuiltValueNullFieldError.checkNotNull(
              due,
              r'AdminRestaurantSettleDto',
              'due',
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
          r'AdminRestaurantSettleDto',
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
