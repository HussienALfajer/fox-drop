// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_statement_export_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantStatementExportDto
    extends AdminRestaurantStatementExportDto {
  @override
  final String restaurantId;
  @override
  final String from;
  @override
  final String to;

  factory _$AdminRestaurantStatementExportDto([
    void Function(AdminRestaurantStatementExportDtoBuilder)? updates,
  ]) => (AdminRestaurantStatementExportDtoBuilder()..update(updates))._build();

  _$AdminRestaurantStatementExportDto._({
    required this.restaurantId,
    required this.from,
    required this.to,
  }) : super._();
  @override
  AdminRestaurantStatementExportDto rebuild(
    void Function(AdminRestaurantStatementExportDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantStatementExportDtoBuilder toBuilder() =>
      AdminRestaurantStatementExportDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantStatementExportDto &&
        restaurantId == other.restaurantId &&
        from == other.from &&
        to == other.to;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRestaurantStatementExportDto')
          ..add('restaurantId', restaurantId)
          ..add('from', from)
          ..add('to', to))
        .toString();
  }
}

class AdminRestaurantStatementExportDtoBuilder
    implements
        Builder<
          AdminRestaurantStatementExportDto,
          AdminRestaurantStatementExportDtoBuilder
        > {
  _$AdminRestaurantStatementExportDto? _$v;

  String? _restaurantId;
  String? get restaurantId => _$this._restaurantId;
  set restaurantId(String? restaurantId) => _$this._restaurantId = restaurantId;

  String? _from;
  String? get from => _$this._from;
  set from(String? from) => _$this._from = from;

  String? _to;
  String? get to => _$this._to;
  set to(String? to) => _$this._to = to;

  AdminRestaurantStatementExportDtoBuilder() {
    AdminRestaurantStatementExportDto._defaults(this);
  }

  AdminRestaurantStatementExportDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _restaurantId = $v.restaurantId;
      _from = $v.from;
      _to = $v.to;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantStatementExportDto other) {
    _$v = other as _$AdminRestaurantStatementExportDto;
  }

  @override
  void update(
    void Function(AdminRestaurantStatementExportDtoBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantStatementExportDto build() => _build();

  _$AdminRestaurantStatementExportDto _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantStatementExportDto._(
          restaurantId: BuiltValueNullFieldError.checkNotNull(
            restaurantId,
            r'AdminRestaurantStatementExportDto',
            'restaurantId',
          ),
          from: BuiltValueNullFieldError.checkNotNull(
            from,
            r'AdminRestaurantStatementExportDto',
            'from',
          ),
          to: BuiltValueNullFieldError.checkNotNull(
            to,
            r'AdminRestaurantStatementExportDto',
            'to',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
