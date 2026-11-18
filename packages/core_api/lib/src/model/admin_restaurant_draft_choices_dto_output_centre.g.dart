// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_draft_choices_dto_output_centre.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantDraftChoicesDtoOutputCentre
    extends AdminRestaurantDraftChoicesDtoOutputCentre {
  @override
  final num latitude;
  @override
  final num longitude;

  factory _$AdminRestaurantDraftChoicesDtoOutputCentre([
    void Function(AdminRestaurantDraftChoicesDtoOutputCentreBuilder)? updates,
  ]) => (AdminRestaurantDraftChoicesDtoOutputCentreBuilder()..update(updates))
      ._build();

  _$AdminRestaurantDraftChoicesDtoOutputCentre._({
    required this.latitude,
    required this.longitude,
  }) : super._();
  @override
  AdminRestaurantDraftChoicesDtoOutputCentre rebuild(
    void Function(AdminRestaurantDraftChoicesDtoOutputCentreBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantDraftChoicesDtoOutputCentreBuilder toBuilder() =>
      AdminRestaurantDraftChoicesDtoOutputCentreBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantDraftChoicesDtoOutputCentre &&
        latitude == other.latitude &&
        longitude == other.longitude;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantDraftChoicesDtoOutputCentre',
          )
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class AdminRestaurantDraftChoicesDtoOutputCentreBuilder
    implements
        Builder<
          AdminRestaurantDraftChoicesDtoOutputCentre,
          AdminRestaurantDraftChoicesDtoOutputCentreBuilder
        > {
  _$AdminRestaurantDraftChoicesDtoOutputCentre? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  AdminRestaurantDraftChoicesDtoOutputCentreBuilder() {
    AdminRestaurantDraftChoicesDtoOutputCentre._defaults(this);
  }

  AdminRestaurantDraftChoicesDtoOutputCentreBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantDraftChoicesDtoOutputCentre other) {
    _$v = other as _$AdminRestaurantDraftChoicesDtoOutputCentre;
  }

  @override
  void update(
    void Function(AdminRestaurantDraftChoicesDtoOutputCentreBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantDraftChoicesDtoOutputCentre build() => _build();

  _$AdminRestaurantDraftChoicesDtoOutputCentre _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantDraftChoicesDtoOutputCentre._(
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'AdminRestaurantDraftChoicesDtoOutputCentre',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'AdminRestaurantDraftChoicesDtoOutputCentre',
            'longitude',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
