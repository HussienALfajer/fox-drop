// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_application_dto_output_activation_kit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainApplicationDtoOutputActivationKit
    extends AdminCaptainApplicationDtoOutputActivationKit {
  @override
  final BuiltList<AdminCaptainApplicationDtoOutputActivationKitItemsInner>
  items;
  @override
  final DateTime issuedAt;

  factory _$AdminCaptainApplicationDtoOutputActivationKit([
    void Function(AdminCaptainApplicationDtoOutputActivationKitBuilder)?
    updates,
  ]) =>
      (AdminCaptainApplicationDtoOutputActivationKitBuilder()..update(updates))
          ._build();

  _$AdminCaptainApplicationDtoOutputActivationKit._({
    required this.items,
    required this.issuedAt,
  }) : super._();
  @override
  AdminCaptainApplicationDtoOutputActivationKit rebuild(
    void Function(AdminCaptainApplicationDtoOutputActivationKitBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainApplicationDtoOutputActivationKitBuilder toBuilder() =>
      AdminCaptainApplicationDtoOutputActivationKitBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainApplicationDtoOutputActivationKit &&
        items == other.items &&
        issuedAt == other.issuedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, issuedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCaptainApplicationDtoOutputActivationKit',
          )
          ..add('items', items)
          ..add('issuedAt', issuedAt))
        .toString();
  }
}

class AdminCaptainApplicationDtoOutputActivationKitBuilder
    implements
        Builder<
          AdminCaptainApplicationDtoOutputActivationKit,
          AdminCaptainApplicationDtoOutputActivationKitBuilder
        > {
  _$AdminCaptainApplicationDtoOutputActivationKit? _$v;

  ListBuilder<AdminCaptainApplicationDtoOutputActivationKitItemsInner>? _items;
  ListBuilder<AdminCaptainApplicationDtoOutputActivationKitItemsInner>
  get items => _$this._items ??=
      ListBuilder<AdminCaptainApplicationDtoOutputActivationKitItemsInner>();
  set items(
    ListBuilder<AdminCaptainApplicationDtoOutputActivationKitItemsInner>? items,
  ) => _$this._items = items;

  DateTime? _issuedAt;
  DateTime? get issuedAt => _$this._issuedAt;
  set issuedAt(DateTime? issuedAt) => _$this._issuedAt = issuedAt;

  AdminCaptainApplicationDtoOutputActivationKitBuilder() {
    AdminCaptainApplicationDtoOutputActivationKit._defaults(this);
  }

  AdminCaptainApplicationDtoOutputActivationKitBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _issuedAt = $v.issuedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainApplicationDtoOutputActivationKit other) {
    _$v = other as _$AdminCaptainApplicationDtoOutputActivationKit;
  }

  @override
  void update(
    void Function(AdminCaptainApplicationDtoOutputActivationKitBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainApplicationDtoOutputActivationKit build() => _build();

  _$AdminCaptainApplicationDtoOutputActivationKit _build() {
    _$AdminCaptainApplicationDtoOutputActivationKit _$result;
    try {
      _$result =
          _$v ??
          _$AdminCaptainApplicationDtoOutputActivationKit._(
            items: items.build(),
            issuedAt: BuiltValueNullFieldError.checkNotNull(
              issuedAt,
              r'AdminCaptainApplicationDtoOutputActivationKit',
              'issuedAt',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCaptainApplicationDtoOutputActivationKit',
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
