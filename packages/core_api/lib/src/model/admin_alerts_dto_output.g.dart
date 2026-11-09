// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_alerts_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminAlertsDtoOutput extends AdminAlertsDtoOutput {
  @override
  final BuiltList<AdminAlertsDtoOutputAlertsInner> alerts;

  factory _$AdminAlertsDtoOutput([
    void Function(AdminAlertsDtoOutputBuilder)? updates,
  ]) => (AdminAlertsDtoOutputBuilder()..update(updates))._build();

  _$AdminAlertsDtoOutput._({required this.alerts}) : super._();
  @override
  AdminAlertsDtoOutput rebuild(
    void Function(AdminAlertsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminAlertsDtoOutputBuilder toBuilder() =>
      AdminAlertsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminAlertsDtoOutput && alerts == other.alerts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, alerts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminAlertsDtoOutput',
    )..add('alerts', alerts)).toString();
  }
}

class AdminAlertsDtoOutputBuilder
    implements Builder<AdminAlertsDtoOutput, AdminAlertsDtoOutputBuilder> {
  _$AdminAlertsDtoOutput? _$v;

  ListBuilder<AdminAlertsDtoOutputAlertsInner>? _alerts;
  ListBuilder<AdminAlertsDtoOutputAlertsInner> get alerts =>
      _$this._alerts ??= ListBuilder<AdminAlertsDtoOutputAlertsInner>();
  set alerts(ListBuilder<AdminAlertsDtoOutputAlertsInner>? alerts) =>
      _$this._alerts = alerts;

  AdminAlertsDtoOutputBuilder() {
    AdminAlertsDtoOutput._defaults(this);
  }

  AdminAlertsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _alerts = $v.alerts.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminAlertsDtoOutput other) {
    _$v = other as _$AdminAlertsDtoOutput;
  }

  @override
  void update(void Function(AdminAlertsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminAlertsDtoOutput build() => _build();

  _$AdminAlertsDtoOutput _build() {
    _$AdminAlertsDtoOutput _$result;
    try {
      _$result = _$v ?? _$AdminAlertsDtoOutput._(alerts: alerts.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'alerts';
        alerts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminAlertsDtoOutput',
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
