// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_acceptance.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderAcceptance
    extends AdminOrderDtoOutputOrderAcceptance {
  @override
  final DateTime at;
  @override
  final int prepMin;
  @override
  final DateTime prepDueAt;

  factory _$AdminOrderDtoOutputOrderAcceptance([
    void Function(AdminOrderDtoOutputOrderAcceptanceBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderAcceptanceBuilder()..update(updates))._build();

  _$AdminOrderDtoOutputOrderAcceptance._({
    required this.at,
    required this.prepMin,
    required this.prepDueAt,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderAcceptance rebuild(
    void Function(AdminOrderDtoOutputOrderAcceptanceBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderAcceptanceBuilder toBuilder() =>
      AdminOrderDtoOutputOrderAcceptanceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderAcceptance &&
        at == other.at &&
        prepMin == other.prepMin &&
        prepDueAt == other.prepDueAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, prepMin.hashCode);
    _$hash = $jc(_$hash, prepDueAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOrderDtoOutputOrderAcceptance')
          ..add('at', at)
          ..add('prepMin', prepMin)
          ..add('prepDueAt', prepDueAt))
        .toString();
  }
}

class AdminOrderDtoOutputOrderAcceptanceBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderAcceptance,
          AdminOrderDtoOutputOrderAcceptanceBuilder
        > {
  _$AdminOrderDtoOutputOrderAcceptance? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  int? _prepMin;
  int? get prepMin => _$this._prepMin;
  set prepMin(int? prepMin) => _$this._prepMin = prepMin;

  DateTime? _prepDueAt;
  DateTime? get prepDueAt => _$this._prepDueAt;
  set prepDueAt(DateTime? prepDueAt) => _$this._prepDueAt = prepDueAt;

  AdminOrderDtoOutputOrderAcceptanceBuilder() {
    AdminOrderDtoOutputOrderAcceptance._defaults(this);
  }

  AdminOrderDtoOutputOrderAcceptanceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _prepMin = $v.prepMin;
      _prepDueAt = $v.prepDueAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderAcceptance other) {
    _$v = other as _$AdminOrderDtoOutputOrderAcceptance;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderAcceptanceBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderAcceptance build() => _build();

  _$AdminOrderDtoOutputOrderAcceptance _build() {
    final _$result =
        _$v ??
        _$AdminOrderDtoOutputOrderAcceptance._(
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'AdminOrderDtoOutputOrderAcceptance',
            'at',
          ),
          prepMin: BuiltValueNullFieldError.checkNotNull(
            prepMin,
            r'AdminOrderDtoOutputOrderAcceptance',
            'prepMin',
          ),
          prepDueAt: BuiltValueNullFieldError.checkNotNull(
            prepDueAt,
            r'AdminOrderDtoOutputOrderAcceptance',
            'prepDueAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
