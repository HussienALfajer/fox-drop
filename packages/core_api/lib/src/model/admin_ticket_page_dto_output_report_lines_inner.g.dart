// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_page_dto_output_report_lines_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTicketPageDtoOutputReportLinesInner
    extends AdminTicketPageDtoOutputReportLinesInner {
  @override
  final int position;
  @override
  final String name;
  @override
  final int quantity;

  factory _$AdminTicketPageDtoOutputReportLinesInner([
    void Function(AdminTicketPageDtoOutputReportLinesInnerBuilder)? updates,
  ]) => (AdminTicketPageDtoOutputReportLinesInnerBuilder()..update(updates))
      ._build();

  _$AdminTicketPageDtoOutputReportLinesInner._({
    required this.position,
    required this.name,
    required this.quantity,
  }) : super._();
  @override
  AdminTicketPageDtoOutputReportLinesInner rebuild(
    void Function(AdminTicketPageDtoOutputReportLinesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketPageDtoOutputReportLinesInnerBuilder toBuilder() =>
      AdminTicketPageDtoOutputReportLinesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketPageDtoOutputReportLinesInner &&
        position == other.position &&
        name == other.name &&
        quantity == other.quantity;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, position.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminTicketPageDtoOutputReportLinesInner',
          )
          ..add('position', position)
          ..add('name', name)
          ..add('quantity', quantity))
        .toString();
  }
}

class AdminTicketPageDtoOutputReportLinesInnerBuilder
    implements
        Builder<
          AdminTicketPageDtoOutputReportLinesInner,
          AdminTicketPageDtoOutputReportLinesInnerBuilder
        > {
  _$AdminTicketPageDtoOutputReportLinesInner? _$v;

  int? _position;
  int? get position => _$this._position;
  set position(int? position) => _$this._position = position;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _quantity;
  int? get quantity => _$this._quantity;
  set quantity(int? quantity) => _$this._quantity = quantity;

  AdminTicketPageDtoOutputReportLinesInnerBuilder() {
    AdminTicketPageDtoOutputReportLinesInner._defaults(this);
  }

  AdminTicketPageDtoOutputReportLinesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _position = $v.position;
      _name = $v.name;
      _quantity = $v.quantity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketPageDtoOutputReportLinesInner other) {
    _$v = other as _$AdminTicketPageDtoOutputReportLinesInner;
  }

  @override
  void update(
    void Function(AdminTicketPageDtoOutputReportLinesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketPageDtoOutputReportLinesInner build() => _build();

  _$AdminTicketPageDtoOutputReportLinesInner _build() {
    final _$result =
        _$v ??
        _$AdminTicketPageDtoOutputReportLinesInner._(
          position: BuiltValueNullFieldError.checkNotNull(
            position,
            r'AdminTicketPageDtoOutputReportLinesInner',
            'position',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminTicketPageDtoOutputReportLinesInner',
            'name',
          ),
          quantity: BuiltValueNullFieldError.checkNotNull(
            quantity,
            r'AdminTicketPageDtoOutputReportLinesInner',
            'quantity',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
