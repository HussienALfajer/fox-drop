// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_tickets_dto_output_tickets_inner_resolution_affected_lines_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner
    extends AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner {
  @override
  final int position;
  @override
  final int quantity;
  @override
  final String name;
  @override
  final String value;

  factory _$AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner([
    void Function(
      AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInnerBuilder,
    )?
    updates,
  ]) =>
      (AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner._({
    required this.position,
    required this.quantity,
    required this.name,
    required this.value,
  }) : super._();
  @override
  AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner rebuild(
    void Function(
      AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInnerBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInnerBuilder
  toBuilder() =>
      AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner &&
        position == other.position &&
        quantity == other.quantity &&
        name == other.name &&
        value == other.value;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, position.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner',
          )
          ..add('position', position)
          ..add('quantity', quantity)
          ..add('name', name)
          ..add('value', value))
        .toString();
  }
}

class AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInnerBuilder
    implements
        Builder<
          AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner,
          AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInnerBuilder
        > {
  _$AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner? _$v;

  int? _position;
  int? get position => _$this._position;
  set position(int? position) => _$this._position = position;

  int? _quantity;
  int? get quantity => _$this._quantity;
  set quantity(int? quantity) => _$this._quantity = quantity;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInnerBuilder() {
    AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner._defaults(
      this,
    );
  }

  AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInnerBuilder
  get _$this {
    final $v = _$v;
    if ($v != null) {
      _position = $v.position;
      _quantity = $v.quantity;
      _name = $v.name;
      _value = $v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
    AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner other,
  ) {
    _$v =
        other
            as _$AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner;
  }

  @override
  void update(
    void Function(
      AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner build() =>
      _build();

  _$AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner
  _build() {
    final _$result =
        _$v ??
        _$AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner._(
          position: BuiltValueNullFieldError.checkNotNull(
            position,
            r'AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner',
            'position',
          ),
          quantity: BuiltValueNullFieldError.checkNotNull(
            quantity,
            r'AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner',
            'quantity',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner',
            'name',
          ),
          value: BuiltValueNullFieldError.checkNotNull(
            value,
            r'AdminOrderTicketsDtoOutputTicketsInnerResolutionAffectedLinesInner',
            'value',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
