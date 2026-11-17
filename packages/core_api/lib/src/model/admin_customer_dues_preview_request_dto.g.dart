// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_dues_preview_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCustomerDuesPreviewRequestDto
    extends AdminCustomerDuesPreviewRequestDto {
  @override
  final String cityId;
  @override
  final String customerId;
  @override
  final BuiltList<AdminOpenDrawerSessionDtoFloatsInner> lines;

  factory _$AdminCustomerDuesPreviewRequestDto([
    void Function(AdminCustomerDuesPreviewRequestDtoBuilder)? updates,
  ]) => (AdminCustomerDuesPreviewRequestDtoBuilder()..update(updates))._build();

  _$AdminCustomerDuesPreviewRequestDto._({
    required this.cityId,
    required this.customerId,
    required this.lines,
  }) : super._();
  @override
  AdminCustomerDuesPreviewRequestDto rebuild(
    void Function(AdminCustomerDuesPreviewRequestDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerDuesPreviewRequestDtoBuilder toBuilder() =>
      AdminCustomerDuesPreviewRequestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerDuesPreviewRequestDto &&
        cityId == other.cityId &&
        customerId == other.customerId &&
        lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, customerId.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCustomerDuesPreviewRequestDto')
          ..add('cityId', cityId)
          ..add('customerId', customerId)
          ..add('lines', lines))
        .toString();
  }
}

class AdminCustomerDuesPreviewRequestDtoBuilder
    implements
        Builder<
          AdminCustomerDuesPreviewRequestDto,
          AdminCustomerDuesPreviewRequestDtoBuilder
        > {
  _$AdminCustomerDuesPreviewRequestDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _customerId;
  String? get customerId => _$this._customerId;
  set customerId(String? customerId) => _$this._customerId = customerId;

  ListBuilder<AdminOpenDrawerSessionDtoFloatsInner>? _lines;
  ListBuilder<AdminOpenDrawerSessionDtoFloatsInner> get lines =>
      _$this._lines ??= ListBuilder<AdminOpenDrawerSessionDtoFloatsInner>();
  set lines(ListBuilder<AdminOpenDrawerSessionDtoFloatsInner>? lines) =>
      _$this._lines = lines;

  AdminCustomerDuesPreviewRequestDtoBuilder() {
    AdminCustomerDuesPreviewRequestDto._defaults(this);
  }

  AdminCustomerDuesPreviewRequestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _customerId = $v.customerId;
      _lines = $v.lines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerDuesPreviewRequestDto other) {
    _$v = other as _$AdminCustomerDuesPreviewRequestDto;
  }

  @override
  void update(
    void Function(AdminCustomerDuesPreviewRequestDtoBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerDuesPreviewRequestDto build() => _build();

  _$AdminCustomerDuesPreviewRequestDto _build() {
    _$AdminCustomerDuesPreviewRequestDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminCustomerDuesPreviewRequestDto._(
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminCustomerDuesPreviewRequestDto',
              'cityId',
            ),
            customerId: BuiltValueNullFieldError.checkNotNull(
              customerId,
              r'AdminCustomerDuesPreviewRequestDto',
              'customerId',
            ),
            lines: lines.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCustomerDuesPreviewRequestDto',
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
