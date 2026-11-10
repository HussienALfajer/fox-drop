// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_handover.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderHandover
    extends AdminOrderDtoOutputOrderHandover {
  @override
  final bool allowed;
  @override
  final BuiltList<AdminOrderDtoOutputOrderHandoverHandoversInner> handovers;

  factory _$AdminOrderDtoOutputOrderHandover([
    void Function(AdminOrderDtoOutputOrderHandoverBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderHandoverBuilder()..update(updates))._build();

  _$AdminOrderDtoOutputOrderHandover._({
    required this.allowed,
    required this.handovers,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderHandover rebuild(
    void Function(AdminOrderDtoOutputOrderHandoverBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderHandoverBuilder toBuilder() =>
      AdminOrderDtoOutputOrderHandoverBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderHandover &&
        allowed == other.allowed &&
        handovers == other.handovers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, allowed.hashCode);
    _$hash = $jc(_$hash, handovers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOrderDtoOutputOrderHandover')
          ..add('allowed', allowed)
          ..add('handovers', handovers))
        .toString();
  }
}

class AdminOrderDtoOutputOrderHandoverBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderHandover,
          AdminOrderDtoOutputOrderHandoverBuilder
        > {
  _$AdminOrderDtoOutputOrderHandover? _$v;

  bool? _allowed;
  bool? get allowed => _$this._allowed;
  set allowed(bool? allowed) => _$this._allowed = allowed;

  ListBuilder<AdminOrderDtoOutputOrderHandoverHandoversInner>? _handovers;
  ListBuilder<AdminOrderDtoOutputOrderHandoverHandoversInner> get handovers =>
      _$this._handovers ??=
          ListBuilder<AdminOrderDtoOutputOrderHandoverHandoversInner>();
  set handovers(
    ListBuilder<AdminOrderDtoOutputOrderHandoverHandoversInner>? handovers,
  ) => _$this._handovers = handovers;

  AdminOrderDtoOutputOrderHandoverBuilder() {
    AdminOrderDtoOutputOrderHandover._defaults(this);
  }

  AdminOrderDtoOutputOrderHandoverBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _allowed = $v.allowed;
      _handovers = $v.handovers.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderHandover other) {
    _$v = other as _$AdminOrderDtoOutputOrderHandover;
  }

  @override
  void update(void Function(AdminOrderDtoOutputOrderHandoverBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderHandover build() => _build();

  _$AdminOrderDtoOutputOrderHandover _build() {
    _$AdminOrderDtoOutputOrderHandover _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderDtoOutputOrderHandover._(
            allowed: BuiltValueNullFieldError.checkNotNull(
              allowed,
              r'AdminOrderDtoOutputOrderHandover',
              'allowed',
            ),
            handovers: handovers.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'handovers';
        handovers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderDtoOutputOrderHandover',
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
