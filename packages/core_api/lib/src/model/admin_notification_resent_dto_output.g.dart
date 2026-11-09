// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_notification_resent_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminNotificationResentDtoOutput
    extends AdminNotificationResentDtoOutput {
  @override
  final String body;

  factory _$AdminNotificationResentDtoOutput([
    void Function(AdminNotificationResentDtoOutputBuilder)? updates,
  ]) => (AdminNotificationResentDtoOutputBuilder()..update(updates))._build();

  _$AdminNotificationResentDtoOutput._({required this.body}) : super._();
  @override
  AdminNotificationResentDtoOutput rebuild(
    void Function(AdminNotificationResentDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminNotificationResentDtoOutputBuilder toBuilder() =>
      AdminNotificationResentDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminNotificationResentDtoOutput && body == other.body;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminNotificationResentDtoOutput',
    )..add('body', body)).toString();
  }
}

class AdminNotificationResentDtoOutputBuilder
    implements
        Builder<
          AdminNotificationResentDtoOutput,
          AdminNotificationResentDtoOutputBuilder
        > {
  _$AdminNotificationResentDtoOutput? _$v;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  AdminNotificationResentDtoOutputBuilder() {
    AdminNotificationResentDtoOutput._defaults(this);
  }

  AdminNotificationResentDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _body = $v.body;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminNotificationResentDtoOutput other) {
    _$v = other as _$AdminNotificationResentDtoOutput;
  }

  @override
  void update(void Function(AdminNotificationResentDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminNotificationResentDtoOutput build() => _build();

  _$AdminNotificationResentDtoOutput _build() {
    final _$result =
        _$v ??
        _$AdminNotificationResentDtoOutput._(
          body: BuiltValueNullFieldError.checkNotNull(
            body,
            r'AdminNotificationResentDtoOutput',
            'body',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
