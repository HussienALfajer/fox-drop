// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_start_emergency_stop_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminStartEmergencyStopDto extends AdminStartEmergencyStopDto {
  @override
  final String cityId;
  @override
  final String internalReason;
  @override
  final String browseMessage;
  @override
  final String delayNotice;
  @override
  final String customerReason;
  @override
  final DateTime? resumeAt;

  factory _$AdminStartEmergencyStopDto([
    void Function(AdminStartEmergencyStopDtoBuilder)? updates,
  ]) => (AdminStartEmergencyStopDtoBuilder()..update(updates))._build();

  _$AdminStartEmergencyStopDto._({
    required this.cityId,
    required this.internalReason,
    required this.browseMessage,
    required this.delayNotice,
    required this.customerReason,
    this.resumeAt,
  }) : super._();
  @override
  AdminStartEmergencyStopDto rebuild(
    void Function(AdminStartEmergencyStopDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminStartEmergencyStopDtoBuilder toBuilder() =>
      AdminStartEmergencyStopDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminStartEmergencyStopDto &&
        cityId == other.cityId &&
        internalReason == other.internalReason &&
        browseMessage == other.browseMessage &&
        delayNotice == other.delayNotice &&
        customerReason == other.customerReason &&
        resumeAt == other.resumeAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, internalReason.hashCode);
    _$hash = $jc(_$hash, browseMessage.hashCode);
    _$hash = $jc(_$hash, delayNotice.hashCode);
    _$hash = $jc(_$hash, customerReason.hashCode);
    _$hash = $jc(_$hash, resumeAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminStartEmergencyStopDto')
          ..add('cityId', cityId)
          ..add('internalReason', internalReason)
          ..add('browseMessage', browseMessage)
          ..add('delayNotice', delayNotice)
          ..add('customerReason', customerReason)
          ..add('resumeAt', resumeAt))
        .toString();
  }
}

class AdminStartEmergencyStopDtoBuilder
    implements
        Builder<AdminStartEmergencyStopDto, AdminStartEmergencyStopDtoBuilder> {
  _$AdminStartEmergencyStopDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _internalReason;
  String? get internalReason => _$this._internalReason;
  set internalReason(String? internalReason) =>
      _$this._internalReason = internalReason;

  String? _browseMessage;
  String? get browseMessage => _$this._browseMessage;
  set browseMessage(String? browseMessage) =>
      _$this._browseMessage = browseMessage;

  String? _delayNotice;
  String? get delayNotice => _$this._delayNotice;
  set delayNotice(String? delayNotice) => _$this._delayNotice = delayNotice;

  String? _customerReason;
  String? get customerReason => _$this._customerReason;
  set customerReason(String? customerReason) =>
      _$this._customerReason = customerReason;

  DateTime? _resumeAt;
  DateTime? get resumeAt => _$this._resumeAt;
  set resumeAt(DateTime? resumeAt) => _$this._resumeAt = resumeAt;

  AdminStartEmergencyStopDtoBuilder() {
    AdminStartEmergencyStopDto._defaults(this);
  }

  AdminStartEmergencyStopDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _internalReason = $v.internalReason;
      _browseMessage = $v.browseMessage;
      _delayNotice = $v.delayNotice;
      _customerReason = $v.customerReason;
      _resumeAt = $v.resumeAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminStartEmergencyStopDto other) {
    _$v = other as _$AdminStartEmergencyStopDto;
  }

  @override
  void update(void Function(AdminStartEmergencyStopDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminStartEmergencyStopDto build() => _build();

  _$AdminStartEmergencyStopDto _build() {
    final _$result =
        _$v ??
        _$AdminStartEmergencyStopDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminStartEmergencyStopDto',
            'cityId',
          ),
          internalReason: BuiltValueNullFieldError.checkNotNull(
            internalReason,
            r'AdminStartEmergencyStopDto',
            'internalReason',
          ),
          browseMessage: BuiltValueNullFieldError.checkNotNull(
            browseMessage,
            r'AdminStartEmergencyStopDto',
            'browseMessage',
          ),
          delayNotice: BuiltValueNullFieldError.checkNotNull(
            delayNotice,
            r'AdminStartEmergencyStopDto',
            'delayNotice',
          ),
          customerReason: BuiltValueNullFieldError.checkNotNull(
            customerReason,
            r'AdminStartEmergencyStopDto',
            'customerReason',
          ),
          resumeAt: resumeAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
