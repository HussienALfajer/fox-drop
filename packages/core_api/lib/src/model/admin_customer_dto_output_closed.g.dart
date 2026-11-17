// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_dto_output_closed.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCustomerDtoOutputClosed extends AdminCustomerDtoOutputClosed {
  @override
  final DateTime at;
  @override
  final String? byName;
  @override
  final String? reason;

  factory _$AdminCustomerDtoOutputClosed([
    void Function(AdminCustomerDtoOutputClosedBuilder)? updates,
  ]) => (AdminCustomerDtoOutputClosedBuilder()..update(updates))._build();

  _$AdminCustomerDtoOutputClosed._({required this.at, this.byName, this.reason})
    : super._();
  @override
  AdminCustomerDtoOutputClosed rebuild(
    void Function(AdminCustomerDtoOutputClosedBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerDtoOutputClosedBuilder toBuilder() =>
      AdminCustomerDtoOutputClosedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerDtoOutputClosed &&
        at == other.at &&
        byName == other.byName &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, byName.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCustomerDtoOutputClosed')
          ..add('at', at)
          ..add('byName', byName)
          ..add('reason', reason))
        .toString();
  }
}

class AdminCustomerDtoOutputClosedBuilder
    implements
        Builder<
          AdminCustomerDtoOutputClosed,
          AdminCustomerDtoOutputClosedBuilder
        > {
  _$AdminCustomerDtoOutputClosed? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  String? _byName;
  String? get byName => _$this._byName;
  set byName(String? byName) => _$this._byName = byName;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminCustomerDtoOutputClosedBuilder() {
    AdminCustomerDtoOutputClosed._defaults(this);
  }

  AdminCustomerDtoOutputClosedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _byName = $v.byName;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerDtoOutputClosed other) {
    _$v = other as _$AdminCustomerDtoOutputClosed;
  }

  @override
  void update(void Function(AdminCustomerDtoOutputClosedBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerDtoOutputClosed build() => _build();

  _$AdminCustomerDtoOutputClosed _build() {
    final _$result =
        _$v ??
        _$AdminCustomerDtoOutputClosed._(
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'AdminCustomerDtoOutputClosed',
            'at',
          ),
          byName: byName,
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
