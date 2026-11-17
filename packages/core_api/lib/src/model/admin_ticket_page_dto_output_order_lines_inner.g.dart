// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_page_dto_output_order_lines_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTicketPageDtoOutputOrderLinesInner
    extends AdminTicketPageDtoOutputOrderLinesInner {
  @override
  final int position;
  @override
  final String name;
  @override
  final int quantity;
  @override
  final String unitPrice;
  @override
  final String lineTotal;

  factory _$AdminTicketPageDtoOutputOrderLinesInner([
    void Function(AdminTicketPageDtoOutputOrderLinesInnerBuilder)? updates,
  ]) => (AdminTicketPageDtoOutputOrderLinesInnerBuilder()..update(updates))
      ._build();

  _$AdminTicketPageDtoOutputOrderLinesInner._({
    required this.position,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
  }) : super._();
  @override
  AdminTicketPageDtoOutputOrderLinesInner rebuild(
    void Function(AdminTicketPageDtoOutputOrderLinesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketPageDtoOutputOrderLinesInnerBuilder toBuilder() =>
      AdminTicketPageDtoOutputOrderLinesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketPageDtoOutputOrderLinesInner &&
        position == other.position &&
        name == other.name &&
        quantity == other.quantity &&
        unitPrice == other.unitPrice &&
        lineTotal == other.lineTotal;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, position.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, unitPrice.hashCode);
    _$hash = $jc(_$hash, lineTotal.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminTicketPageDtoOutputOrderLinesInner',
          )
          ..add('position', position)
          ..add('name', name)
          ..add('quantity', quantity)
          ..add('unitPrice', unitPrice)
          ..add('lineTotal', lineTotal))
        .toString();
  }
}

class AdminTicketPageDtoOutputOrderLinesInnerBuilder
    implements
        Builder<
          AdminTicketPageDtoOutputOrderLinesInner,
          AdminTicketPageDtoOutputOrderLinesInnerBuilder
        > {
  _$AdminTicketPageDtoOutputOrderLinesInner? _$v;

  int? _position;
  int? get position => _$this._position;
  set position(int? position) => _$this._position = position;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _quantity;
  int? get quantity => _$this._quantity;
  set quantity(int? quantity) => _$this._quantity = quantity;

  String? _unitPrice;
  String? get unitPrice => _$this._unitPrice;
  set unitPrice(String? unitPrice) => _$this._unitPrice = unitPrice;

  String? _lineTotal;
  String? get lineTotal => _$this._lineTotal;
  set lineTotal(String? lineTotal) => _$this._lineTotal = lineTotal;

  AdminTicketPageDtoOutputOrderLinesInnerBuilder() {
    AdminTicketPageDtoOutputOrderLinesInner._defaults(this);
  }

  AdminTicketPageDtoOutputOrderLinesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _position = $v.position;
      _name = $v.name;
      _quantity = $v.quantity;
      _unitPrice = $v.unitPrice;
      _lineTotal = $v.lineTotal;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketPageDtoOutputOrderLinesInner other) {
    _$v = other as _$AdminTicketPageDtoOutputOrderLinesInner;
  }

  @override
  void update(
    void Function(AdminTicketPageDtoOutputOrderLinesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketPageDtoOutputOrderLinesInner build() => _build();

  _$AdminTicketPageDtoOutputOrderLinesInner _build() {
    final _$result =
        _$v ??
        _$AdminTicketPageDtoOutputOrderLinesInner._(
          position: BuiltValueNullFieldError.checkNotNull(
            position,
            r'AdminTicketPageDtoOutputOrderLinesInner',
            'position',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminTicketPageDtoOutputOrderLinesInner',
            'name',
          ),
          quantity: BuiltValueNullFieldError.checkNotNull(
            quantity,
            r'AdminTicketPageDtoOutputOrderLinesInner',
            'quantity',
          ),
          unitPrice: BuiltValueNullFieldError.checkNotNull(
            unitPrice,
            r'AdminTicketPageDtoOutputOrderLinesInner',
            'unitPrice',
          ),
          lineTotal: BuiltValueNullFieldError.checkNotNull(
            lineTotal,
            r'AdminTicketPageDtoOutputOrderLinesInner',
            'lineTotal',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
