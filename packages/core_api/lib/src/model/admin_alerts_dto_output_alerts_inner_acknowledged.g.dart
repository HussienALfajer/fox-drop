// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_alerts_dto_output_alerts_inner_acknowledged.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminAlertsDtoOutputAlertsInnerAcknowledged
    extends AdminAlertsDtoOutputAlertsInnerAcknowledged {
  @override
  final DateTime at;
  @override
  final String byId;
  @override
  final String? byName;

  factory _$AdminAlertsDtoOutputAlertsInnerAcknowledged([
    void Function(AdminAlertsDtoOutputAlertsInnerAcknowledgedBuilder)? updates,
  ]) => (AdminAlertsDtoOutputAlertsInnerAcknowledgedBuilder()..update(updates))
      ._build();

  _$AdminAlertsDtoOutputAlertsInnerAcknowledged._({
    required this.at,
    required this.byId,
    this.byName,
  }) : super._();
  @override
  AdminAlertsDtoOutputAlertsInnerAcknowledged rebuild(
    void Function(AdminAlertsDtoOutputAlertsInnerAcknowledgedBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminAlertsDtoOutputAlertsInnerAcknowledgedBuilder toBuilder() =>
      AdminAlertsDtoOutputAlertsInnerAcknowledgedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminAlertsDtoOutputAlertsInnerAcknowledged &&
        at == other.at &&
        byId == other.byId &&
        byName == other.byName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, byId.hashCode);
    _$hash = $jc(_$hash, byName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminAlertsDtoOutputAlertsInnerAcknowledged',
          )
          ..add('at', at)
          ..add('byId', byId)
          ..add('byName', byName))
        .toString();
  }
}

class AdminAlertsDtoOutputAlertsInnerAcknowledgedBuilder
    implements
        Builder<
          AdminAlertsDtoOutputAlertsInnerAcknowledged,
          AdminAlertsDtoOutputAlertsInnerAcknowledgedBuilder
        > {
  _$AdminAlertsDtoOutputAlertsInnerAcknowledged? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  String? _byId;
  String? get byId => _$this._byId;
  set byId(String? byId) => _$this._byId = byId;

  String? _byName;
  String? get byName => _$this._byName;
  set byName(String? byName) => _$this._byName = byName;

  AdminAlertsDtoOutputAlertsInnerAcknowledgedBuilder() {
    AdminAlertsDtoOutputAlertsInnerAcknowledged._defaults(this);
  }

  AdminAlertsDtoOutputAlertsInnerAcknowledgedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _byId = $v.byId;
      _byName = $v.byName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminAlertsDtoOutputAlertsInnerAcknowledged other) {
    _$v = other as _$AdminAlertsDtoOutputAlertsInnerAcknowledged;
  }

  @override
  void update(
    void Function(AdminAlertsDtoOutputAlertsInnerAcknowledgedBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminAlertsDtoOutputAlertsInnerAcknowledged build() => _build();

  _$AdminAlertsDtoOutputAlertsInnerAcknowledged _build() {
    final _$result =
        _$v ??
        _$AdminAlertsDtoOutputAlertsInnerAcknowledged._(
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'AdminAlertsDtoOutputAlertsInnerAcknowledged',
            'at',
          ),
          byId: BuiltValueNullFieldError.checkNotNull(
            byId,
            r'AdminAlertsDtoOutputAlertsInnerAcknowledged',
            'byId',
          ),
          byName: byName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
