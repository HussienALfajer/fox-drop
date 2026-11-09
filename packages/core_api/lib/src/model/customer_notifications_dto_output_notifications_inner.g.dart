// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_notifications_dto_output_notifications_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerNotificationsDtoOutputNotificationsInner
    extends CustomerNotificationsDtoOutputNotificationsInner {
  @override
  final String id;
  @override
  final DateTime at;
  @override
  final String body;
  @override
  final BuiltMap<String, String> data;

  factory _$CustomerNotificationsDtoOutputNotificationsInner([
    void Function(CustomerNotificationsDtoOutputNotificationsInnerBuilder)?
    updates,
  ]) =>
      (CustomerNotificationsDtoOutputNotificationsInnerBuilder()
            ..update(updates))
          ._build();

  _$CustomerNotificationsDtoOutputNotificationsInner._({
    required this.id,
    required this.at,
    required this.body,
    required this.data,
  }) : super._();
  @override
  CustomerNotificationsDtoOutputNotificationsInner rebuild(
    void Function(CustomerNotificationsDtoOutputNotificationsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerNotificationsDtoOutputNotificationsInnerBuilder toBuilder() =>
      CustomerNotificationsDtoOutputNotificationsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerNotificationsDtoOutputNotificationsInner &&
        id == other.id &&
        at == other.at &&
        body == other.body &&
        data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerNotificationsDtoOutputNotificationsInner',
          )
          ..add('id', id)
          ..add('at', at)
          ..add('body', body)
          ..add('data', data))
        .toString();
  }
}

class CustomerNotificationsDtoOutputNotificationsInnerBuilder
    implements
        Builder<
          CustomerNotificationsDtoOutputNotificationsInner,
          CustomerNotificationsDtoOutputNotificationsInnerBuilder
        > {
  _$CustomerNotificationsDtoOutputNotificationsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  MapBuilder<String, String>? _data;
  MapBuilder<String, String> get data =>
      _$this._data ??= MapBuilder<String, String>();
  set data(MapBuilder<String, String>? data) => _$this._data = data;

  CustomerNotificationsDtoOutputNotificationsInnerBuilder() {
    CustomerNotificationsDtoOutputNotificationsInner._defaults(this);
  }

  CustomerNotificationsDtoOutputNotificationsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _at = $v.at;
      _body = $v.body;
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerNotificationsDtoOutputNotificationsInner other) {
    _$v = other as _$CustomerNotificationsDtoOutputNotificationsInner;
  }

  @override
  void update(
    void Function(CustomerNotificationsDtoOutputNotificationsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerNotificationsDtoOutputNotificationsInner build() => _build();

  _$CustomerNotificationsDtoOutputNotificationsInner _build() {
    _$CustomerNotificationsDtoOutputNotificationsInner _$result;
    try {
      _$result =
          _$v ??
          _$CustomerNotificationsDtoOutputNotificationsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'CustomerNotificationsDtoOutputNotificationsInner',
              'id',
            ),
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'CustomerNotificationsDtoOutputNotificationsInner',
              'at',
            ),
            body: BuiltValueNullFieldError.checkNotNull(
              body,
              r'CustomerNotificationsDtoOutputNotificationsInner',
              'body',
            ),
            data: data.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerNotificationsDtoOutputNotificationsInner',
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
