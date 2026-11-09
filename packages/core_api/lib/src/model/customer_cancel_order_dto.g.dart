// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_cancel_order_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerCancelOrderDto extends CustomerCancelOrderDto {
  @override
  final String reason;
  @override
  final String? note;

  factory _$CustomerCancelOrderDto([
    void Function(CustomerCancelOrderDtoBuilder)? updates,
  ]) => (CustomerCancelOrderDtoBuilder()..update(updates))._build();

  _$CustomerCancelOrderDto._({required this.reason, this.note}) : super._();
  @override
  CustomerCancelOrderDto rebuild(
    void Function(CustomerCancelOrderDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerCancelOrderDtoBuilder toBuilder() =>
      CustomerCancelOrderDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerCancelOrderDto &&
        reason == other.reason &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerCancelOrderDto')
          ..add('reason', reason)
          ..add('note', note))
        .toString();
  }
}

class CustomerCancelOrderDtoBuilder
    implements Builder<CustomerCancelOrderDto, CustomerCancelOrderDtoBuilder> {
  _$CustomerCancelOrderDto? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  CustomerCancelOrderDtoBuilder() {
    CustomerCancelOrderDto._defaults(this);
  }

  CustomerCancelOrderDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerCancelOrderDto other) {
    _$v = other as _$CustomerCancelOrderDto;
  }

  @override
  void update(void Function(CustomerCancelOrderDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerCancelOrderDto build() => _build();

  _$CustomerCancelOrderDto _build() {
    final _$result =
        _$v ??
        _$CustomerCancelOrderDto._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'CustomerCancelOrderDto',
            'reason',
          ),
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
