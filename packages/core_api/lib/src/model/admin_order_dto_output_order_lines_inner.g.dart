// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_lines_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderLinesInner
    extends AdminOrderDtoOutputOrderLinesInner {
  @override
  final String name;
  @override
  final int quantity;
  @override
  final BuiltList<AdminOrderDtoOutputOrderLinesInnerOptionsInner> options;
  @override
  final String? note;
  @override
  final String unitPrice;
  @override
  final String lineTotal;

  factory _$AdminOrderDtoOutputOrderLinesInner([
    void Function(AdminOrderDtoOutputOrderLinesInnerBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderLinesInnerBuilder()..update(updates))._build();

  _$AdminOrderDtoOutputOrderLinesInner._({
    required this.name,
    required this.quantity,
    required this.options,
    this.note,
    required this.unitPrice,
    required this.lineTotal,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderLinesInner rebuild(
    void Function(AdminOrderDtoOutputOrderLinesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderLinesInnerBuilder toBuilder() =>
      AdminOrderDtoOutputOrderLinesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderLinesInner &&
        name == other.name &&
        quantity == other.quantity &&
        options == other.options &&
        note == other.note &&
        unitPrice == other.unitPrice &&
        lineTotal == other.lineTotal;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, options.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, unitPrice.hashCode);
    _$hash = $jc(_$hash, lineTotal.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOrderDtoOutputOrderLinesInner')
          ..add('name', name)
          ..add('quantity', quantity)
          ..add('options', options)
          ..add('note', note)
          ..add('unitPrice', unitPrice)
          ..add('lineTotal', lineTotal))
        .toString();
  }
}

class AdminOrderDtoOutputOrderLinesInnerBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderLinesInner,
          AdminOrderDtoOutputOrderLinesInnerBuilder
        > {
  _$AdminOrderDtoOutputOrderLinesInner? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _quantity;
  int? get quantity => _$this._quantity;
  set quantity(int? quantity) => _$this._quantity = quantity;

  ListBuilder<AdminOrderDtoOutputOrderLinesInnerOptionsInner>? _options;
  ListBuilder<AdminOrderDtoOutputOrderLinesInnerOptionsInner> get options =>
      _$this._options ??=
          ListBuilder<AdminOrderDtoOutputOrderLinesInnerOptionsInner>();
  set options(
    ListBuilder<AdminOrderDtoOutputOrderLinesInnerOptionsInner>? options,
  ) => _$this._options = options;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  String? _unitPrice;
  String? get unitPrice => _$this._unitPrice;
  set unitPrice(String? unitPrice) => _$this._unitPrice = unitPrice;

  String? _lineTotal;
  String? get lineTotal => _$this._lineTotal;
  set lineTotal(String? lineTotal) => _$this._lineTotal = lineTotal;

  AdminOrderDtoOutputOrderLinesInnerBuilder() {
    AdminOrderDtoOutputOrderLinesInner._defaults(this);
  }

  AdminOrderDtoOutputOrderLinesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _quantity = $v.quantity;
      _options = $v.options.toBuilder();
      _note = $v.note;
      _unitPrice = $v.unitPrice;
      _lineTotal = $v.lineTotal;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderLinesInner other) {
    _$v = other as _$AdminOrderDtoOutputOrderLinesInner;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderLinesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderLinesInner build() => _build();

  _$AdminOrderDtoOutputOrderLinesInner _build() {
    _$AdminOrderDtoOutputOrderLinesInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderDtoOutputOrderLinesInner._(
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminOrderDtoOutputOrderLinesInner',
              'name',
            ),
            quantity: BuiltValueNullFieldError.checkNotNull(
              quantity,
              r'AdminOrderDtoOutputOrderLinesInner',
              'quantity',
            ),
            options: options.build(),
            note: note,
            unitPrice: BuiltValueNullFieldError.checkNotNull(
              unitPrice,
              r'AdminOrderDtoOutputOrderLinesInner',
              'unitPrice',
            ),
            lineTotal: BuiltValueNullFieldError.checkNotNull(
              lineTotal,
              r'AdminOrderDtoOutputOrderLinesInner',
              'lineTotal',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'options';
        options.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderDtoOutputOrderLinesInner',
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
