// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_notifications_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerNotificationsDtoOutput extends CustomerNotificationsDtoOutput {
  @override
  final BuiltList<CustomerNotificationsDtoOutputNotificationsInner>
  notifications;

  factory _$CustomerNotificationsDtoOutput([
    void Function(CustomerNotificationsDtoOutputBuilder)? updates,
  ]) => (CustomerNotificationsDtoOutputBuilder()..update(updates))._build();

  _$CustomerNotificationsDtoOutput._({required this.notifications}) : super._();
  @override
  CustomerNotificationsDtoOutput rebuild(
    void Function(CustomerNotificationsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerNotificationsDtoOutputBuilder toBuilder() =>
      CustomerNotificationsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerNotificationsDtoOutput &&
        notifications == other.notifications;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, notifications.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CustomerNotificationsDtoOutput',
    )..add('notifications', notifications)).toString();
  }
}

class CustomerNotificationsDtoOutputBuilder
    implements
        Builder<
          CustomerNotificationsDtoOutput,
          CustomerNotificationsDtoOutputBuilder
        > {
  _$CustomerNotificationsDtoOutput? _$v;

  ListBuilder<CustomerNotificationsDtoOutputNotificationsInner>? _notifications;
  ListBuilder<CustomerNotificationsDtoOutputNotificationsInner>
  get notifications => _$this._notifications ??=
      ListBuilder<CustomerNotificationsDtoOutputNotificationsInner>();
  set notifications(
    ListBuilder<CustomerNotificationsDtoOutputNotificationsInner>?
    notifications,
  ) => _$this._notifications = notifications;

  CustomerNotificationsDtoOutputBuilder() {
    CustomerNotificationsDtoOutput._defaults(this);
  }

  CustomerNotificationsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _notifications = $v.notifications.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerNotificationsDtoOutput other) {
    _$v = other as _$CustomerNotificationsDtoOutput;
  }

  @override
  void update(void Function(CustomerNotificationsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerNotificationsDtoOutput build() => _build();

  _$CustomerNotificationsDtoOutput _build() {
    _$CustomerNotificationsDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CustomerNotificationsDtoOutput._(
            notifications: notifications.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'notifications';
        notifications.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerNotificationsDtoOutput',
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
