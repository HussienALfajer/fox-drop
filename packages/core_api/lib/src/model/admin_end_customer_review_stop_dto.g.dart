// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_end_customer_review_stop_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminEndCustomerReviewStopDto extends AdminEndCustomerReviewStopDto {
  @override
  final String cityId;
  @override
  final String stopId;
  @override
  final String note;

  factory _$AdminEndCustomerReviewStopDto([
    void Function(AdminEndCustomerReviewStopDtoBuilder)? updates,
  ]) => (AdminEndCustomerReviewStopDtoBuilder()..update(updates))._build();

  _$AdminEndCustomerReviewStopDto._({
    required this.cityId,
    required this.stopId,
    required this.note,
  }) : super._();
  @override
  AdminEndCustomerReviewStopDto rebuild(
    void Function(AdminEndCustomerReviewStopDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminEndCustomerReviewStopDtoBuilder toBuilder() =>
      AdminEndCustomerReviewStopDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminEndCustomerReviewStopDto &&
        cityId == other.cityId &&
        stopId == other.stopId &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, stopId.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminEndCustomerReviewStopDto')
          ..add('cityId', cityId)
          ..add('stopId', stopId)
          ..add('note', note))
        .toString();
  }
}

class AdminEndCustomerReviewStopDtoBuilder
    implements
        Builder<
          AdminEndCustomerReviewStopDto,
          AdminEndCustomerReviewStopDtoBuilder
        > {
  _$AdminEndCustomerReviewStopDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _stopId;
  String? get stopId => _$this._stopId;
  set stopId(String? stopId) => _$this._stopId = stopId;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  AdminEndCustomerReviewStopDtoBuilder() {
    AdminEndCustomerReviewStopDto._defaults(this);
  }

  AdminEndCustomerReviewStopDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _stopId = $v.stopId;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminEndCustomerReviewStopDto other) {
    _$v = other as _$AdminEndCustomerReviewStopDto;
  }

  @override
  void update(void Function(AdminEndCustomerReviewStopDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminEndCustomerReviewStopDto build() => _build();

  _$AdminEndCustomerReviewStopDto _build() {
    final _$result =
        _$v ??
        _$AdminEndCustomerReviewStopDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminEndCustomerReviewStopDto',
            'cityId',
          ),
          stopId: BuiltValueNullFieldError.checkNotNull(
            stopId,
            r'AdminEndCustomerReviewStopDto',
            'stopId',
          ),
          note: BuiltValueNullFieldError.checkNotNull(
            note,
            r'AdminEndCustomerReviewStopDto',
            'note',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
