// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_money_preview_body_dto_affected_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTicketMoneyPreviewBodyDtoAffectedInner
    extends AdminTicketMoneyPreviewBodyDtoAffectedInner {
  @override
  final int position;
  @override
  final int quantity;

  factory _$AdminTicketMoneyPreviewBodyDtoAffectedInner([
    void Function(AdminTicketMoneyPreviewBodyDtoAffectedInnerBuilder)? updates,
  ]) => (AdminTicketMoneyPreviewBodyDtoAffectedInnerBuilder()..update(updates))
      ._build();

  _$AdminTicketMoneyPreviewBodyDtoAffectedInner._({
    required this.position,
    required this.quantity,
  }) : super._();
  @override
  AdminTicketMoneyPreviewBodyDtoAffectedInner rebuild(
    void Function(AdminTicketMoneyPreviewBodyDtoAffectedInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketMoneyPreviewBodyDtoAffectedInnerBuilder toBuilder() =>
      AdminTicketMoneyPreviewBodyDtoAffectedInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketMoneyPreviewBodyDtoAffectedInner &&
        position == other.position &&
        quantity == other.quantity;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, position.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminTicketMoneyPreviewBodyDtoAffectedInner',
          )
          ..add('position', position)
          ..add('quantity', quantity))
        .toString();
  }
}

class AdminTicketMoneyPreviewBodyDtoAffectedInnerBuilder
    implements
        Builder<
          AdminTicketMoneyPreviewBodyDtoAffectedInner,
          AdminTicketMoneyPreviewBodyDtoAffectedInnerBuilder
        > {
  _$AdminTicketMoneyPreviewBodyDtoAffectedInner? _$v;

  int? _position;
  int? get position => _$this._position;
  set position(int? position) => _$this._position = position;

  int? _quantity;
  int? get quantity => _$this._quantity;
  set quantity(int? quantity) => _$this._quantity = quantity;

  AdminTicketMoneyPreviewBodyDtoAffectedInnerBuilder() {
    AdminTicketMoneyPreviewBodyDtoAffectedInner._defaults(this);
  }

  AdminTicketMoneyPreviewBodyDtoAffectedInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _position = $v.position;
      _quantity = $v.quantity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketMoneyPreviewBodyDtoAffectedInner other) {
    _$v = other as _$AdminTicketMoneyPreviewBodyDtoAffectedInner;
  }

  @override
  void update(
    void Function(AdminTicketMoneyPreviewBodyDtoAffectedInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketMoneyPreviewBodyDtoAffectedInner build() => _build();

  _$AdminTicketMoneyPreviewBodyDtoAffectedInner _build() {
    final _$result =
        _$v ??
        _$AdminTicketMoneyPreviewBodyDtoAffectedInner._(
          position: BuiltValueNullFieldError.checkNotNull(
            position,
            r'AdminTicketMoneyPreviewBodyDtoAffectedInner',
            'position',
          ),
          quantity: BuiltValueNullFieldError.checkNotNull(
            quantity,
            r'AdminTicketMoneyPreviewBodyDtoAffectedInner',
            'quantity',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
