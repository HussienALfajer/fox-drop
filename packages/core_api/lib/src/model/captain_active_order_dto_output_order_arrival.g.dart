// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_order_arrival.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainActiveOrderDtoOutputOrderArrival
    extends CaptainActiveOrderDtoOutputOrderArrival {
  @override
  final DateTime at;

  factory _$CaptainActiveOrderDtoOutputOrderArrival([
    void Function(CaptainActiveOrderDtoOutputOrderArrivalBuilder)? updates,
  ]) => (CaptainActiveOrderDtoOutputOrderArrivalBuilder()..update(updates))
      ._build();

  _$CaptainActiveOrderDtoOutputOrderArrival._({required this.at}) : super._();
  @override
  CaptainActiveOrderDtoOutputOrderArrival rebuild(
    void Function(CaptainActiveOrderDtoOutputOrderArrivalBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputOrderArrivalBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputOrderArrivalBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputOrderArrival && at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CaptainActiveOrderDtoOutputOrderArrival',
    )..add('at', at)).toString();
  }
}

class CaptainActiveOrderDtoOutputOrderArrivalBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputOrderArrival,
          CaptainActiveOrderDtoOutputOrderArrivalBuilder
        > {
  _$CaptainActiveOrderDtoOutputOrderArrival? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  CaptainActiveOrderDtoOutputOrderArrivalBuilder() {
    CaptainActiveOrderDtoOutputOrderArrival._defaults(this);
  }

  CaptainActiveOrderDtoOutputOrderArrivalBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputOrderArrival other) {
    _$v = other as _$CaptainActiveOrderDtoOutputOrderArrival;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputOrderArrivalBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputOrderArrival build() => _build();

  _$CaptainActiveOrderDtoOutputOrderArrival _build() {
    final _$result =
        _$v ??
        _$CaptainActiveOrderDtoOutputOrderArrival._(
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'CaptainActiveOrderDtoOutputOrderArrival',
            'at',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
