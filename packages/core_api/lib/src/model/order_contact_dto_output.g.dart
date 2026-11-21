// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_contact_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OrderContactDtoOutput extends OrderContactDtoOutput {
  @override
  final String phone;

  factory _$OrderContactDtoOutput([
    void Function(OrderContactDtoOutputBuilder)? updates,
  ]) => (OrderContactDtoOutputBuilder()..update(updates))._build();

  _$OrderContactDtoOutput._({required this.phone}) : super._();
  @override
  OrderContactDtoOutput rebuild(
    void Function(OrderContactDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  OrderContactDtoOutputBuilder toBuilder() =>
      OrderContactDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderContactDtoOutput && phone == other.phone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'OrderContactDtoOutput',
    )..add('phone', phone)).toString();
  }
}

class OrderContactDtoOutputBuilder
    implements Builder<OrderContactDtoOutput, OrderContactDtoOutputBuilder> {
  _$OrderContactDtoOutput? _$v;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  OrderContactDtoOutputBuilder() {
    OrderContactDtoOutput._defaults(this);
  }

  OrderContactDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phone = $v.phone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderContactDtoOutput other) {
    _$v = other as _$OrderContactDtoOutput;
  }

  @override
  void update(void Function(OrderContactDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderContactDtoOutput build() => _build();

  _$OrderContactDtoOutput _build() {
    final _$result =
        _$v ??
        _$OrderContactDtoOutput._(
          phone: BuiltValueNullFieldError.checkNotNull(
            phone,
            r'OrderContactDtoOutput',
            'phone',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
