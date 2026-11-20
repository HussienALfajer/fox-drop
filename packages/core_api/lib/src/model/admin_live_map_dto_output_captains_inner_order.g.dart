// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_live_map_dto_output_captains_inner_order.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminLiveMapDtoOutputCaptainsInnerOrder
    extends AdminLiveMapDtoOutputCaptainsInnerOrder {
  @override
  final String id;
  @override
  final String number;

  factory _$AdminLiveMapDtoOutputCaptainsInnerOrder([
    void Function(AdminLiveMapDtoOutputCaptainsInnerOrderBuilder)? updates,
  ]) => (AdminLiveMapDtoOutputCaptainsInnerOrderBuilder()..update(updates))
      ._build();

  _$AdminLiveMapDtoOutputCaptainsInnerOrder._({
    required this.id,
    required this.number,
  }) : super._();
  @override
  AdminLiveMapDtoOutputCaptainsInnerOrder rebuild(
    void Function(AdminLiveMapDtoOutputCaptainsInnerOrderBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminLiveMapDtoOutputCaptainsInnerOrderBuilder toBuilder() =>
      AdminLiveMapDtoOutputCaptainsInnerOrderBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminLiveMapDtoOutputCaptainsInnerOrder &&
        id == other.id &&
        number == other.number;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminLiveMapDtoOutputCaptainsInnerOrder',
          )
          ..add('id', id)
          ..add('number', number))
        .toString();
  }
}

class AdminLiveMapDtoOutputCaptainsInnerOrderBuilder
    implements
        Builder<
          AdminLiveMapDtoOutputCaptainsInnerOrder,
          AdminLiveMapDtoOutputCaptainsInnerOrderBuilder
        > {
  _$AdminLiveMapDtoOutputCaptainsInnerOrder? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  AdminLiveMapDtoOutputCaptainsInnerOrderBuilder() {
    AdminLiveMapDtoOutputCaptainsInnerOrder._defaults(this);
  }

  AdminLiveMapDtoOutputCaptainsInnerOrderBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _number = $v.number;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminLiveMapDtoOutputCaptainsInnerOrder other) {
    _$v = other as _$AdminLiveMapDtoOutputCaptainsInnerOrder;
  }

  @override
  void update(
    void Function(AdminLiveMapDtoOutputCaptainsInnerOrderBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminLiveMapDtoOutputCaptainsInnerOrder build() => _build();

  _$AdminLiveMapDtoOutputCaptainsInnerOrder _build() {
    final _$result =
        _$v ??
        _$AdminLiveMapDtoOutputCaptainsInnerOrder._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminLiveMapDtoOutputCaptainsInnerOrder',
            'id',
          ),
          number: BuiltValueNullFieldError.checkNotNull(
            number,
            r'AdminLiveMapDtoOutputCaptainsInnerOrder',
            'number',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
