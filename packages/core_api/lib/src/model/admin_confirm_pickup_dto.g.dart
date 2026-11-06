// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_confirm_pickup_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminConfirmPickupDto extends AdminConfirmPickupDto {
  @override
  final BuiltList<MerchantPickupDisputeDtoReceivedLinesInner> lines;
  @override
  final String reason;

  factory _$AdminConfirmPickupDto([
    void Function(AdminConfirmPickupDtoBuilder)? updates,
  ]) => (AdminConfirmPickupDtoBuilder()..update(updates))._build();

  _$AdminConfirmPickupDto._({required this.lines, required this.reason})
    : super._();
  @override
  AdminConfirmPickupDto rebuild(
    void Function(AdminConfirmPickupDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminConfirmPickupDtoBuilder toBuilder() =>
      AdminConfirmPickupDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminConfirmPickupDto &&
        lines == other.lines &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminConfirmPickupDto')
          ..add('lines', lines)
          ..add('reason', reason))
        .toString();
  }
}

class AdminConfirmPickupDtoBuilder
    implements Builder<AdminConfirmPickupDto, AdminConfirmPickupDtoBuilder> {
  _$AdminConfirmPickupDto? _$v;

  ListBuilder<MerchantPickupDisputeDtoReceivedLinesInner>? _lines;
  ListBuilder<MerchantPickupDisputeDtoReceivedLinesInner> get lines =>
      _$this._lines ??=
          ListBuilder<MerchantPickupDisputeDtoReceivedLinesInner>();
  set lines(ListBuilder<MerchantPickupDisputeDtoReceivedLinesInner>? lines) =>
      _$this._lines = lines;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminConfirmPickupDtoBuilder() {
    AdminConfirmPickupDto._defaults(this);
  }

  AdminConfirmPickupDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lines = $v.lines.toBuilder();
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminConfirmPickupDto other) {
    _$v = other as _$AdminConfirmPickupDto;
  }

  @override
  void update(void Function(AdminConfirmPickupDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminConfirmPickupDto build() => _build();

  _$AdminConfirmPickupDto _build() {
    _$AdminConfirmPickupDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminConfirmPickupDto._(
            lines: lines.build(),
            reason: BuiltValueNullFieldError.checkNotNull(
              reason,
              r'AdminConfirmPickupDto',
              'reason',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminConfirmPickupDto',
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
