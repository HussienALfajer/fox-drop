// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_push_receipt_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerPushReceiptDto extends CustomerPushReceiptDto {
  @override
  final String messageId;

  factory _$CustomerPushReceiptDto([
    void Function(CustomerPushReceiptDtoBuilder)? updates,
  ]) => (CustomerPushReceiptDtoBuilder()..update(updates))._build();

  _$CustomerPushReceiptDto._({required this.messageId}) : super._();
  @override
  CustomerPushReceiptDto rebuild(
    void Function(CustomerPushReceiptDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerPushReceiptDtoBuilder toBuilder() =>
      CustomerPushReceiptDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerPushReceiptDto && messageId == other.messageId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, messageId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CustomerPushReceiptDto',
    )..add('messageId', messageId)).toString();
  }
}

class CustomerPushReceiptDtoBuilder
    implements Builder<CustomerPushReceiptDto, CustomerPushReceiptDtoBuilder> {
  _$CustomerPushReceiptDto? _$v;

  String? _messageId;
  String? get messageId => _$this._messageId;
  set messageId(String? messageId) => _$this._messageId = messageId;

  CustomerPushReceiptDtoBuilder() {
    CustomerPushReceiptDto._defaults(this);
  }

  CustomerPushReceiptDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _messageId = $v.messageId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerPushReceiptDto other) {
    _$v = other as _$CustomerPushReceiptDto;
  }

  @override
  void update(void Function(CustomerPushReceiptDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerPushReceiptDto build() => _build();

  _$CustomerPushReceiptDto _build() {
    final _$result =
        _$v ??
        _$CustomerPushReceiptDto._(
          messageId: BuiltValueNullFieldError.checkNotNull(
            messageId,
            r'CustomerPushReceiptDto',
            'messageId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
