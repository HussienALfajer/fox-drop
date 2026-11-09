// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner_rejection.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerActiveOrdersDtoOutputOrdersInnerRejection
    extends CustomerActiveOrdersDtoOutputOrdersInnerRejection {
  @override
  final DateTime at;
  @override
  final String reason;
  @override
  final String text;
  @override
  final BuiltList<String> unavailableItemIds;

  factory _$CustomerActiveOrdersDtoOutputOrdersInnerRejection([
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerRejectionBuilder)?
    updates,
  ]) =>
      (CustomerActiveOrdersDtoOutputOrdersInnerRejectionBuilder()
            ..update(updates))
          ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerRejection._({
    required this.at,
    required this.reason,
    required this.text,
    required this.unavailableItemIds,
  }) : super._();
  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRejection rebuild(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerRejectionBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRejectionBuilder toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerRejectionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerActiveOrdersDtoOutputOrdersInnerRejection &&
        at == other.at &&
        reason == other.reason &&
        text == other.text &&
        unavailableItemIds == other.unavailableItemIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, unavailableItemIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerActiveOrdersDtoOutputOrdersInnerRejection',
          )
          ..add('at', at)
          ..add('reason', reason)
          ..add('text', text)
          ..add('unavailableItemIds', unavailableItemIds))
        .toString();
  }
}

class CustomerActiveOrdersDtoOutputOrdersInnerRejectionBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInnerRejection,
          CustomerActiveOrdersDtoOutputOrdersInnerRejectionBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInnerRejection? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  ListBuilder<String>? _unavailableItemIds;
  ListBuilder<String> get unavailableItemIds =>
      _$this._unavailableItemIds ??= ListBuilder<String>();
  set unavailableItemIds(ListBuilder<String>? unavailableItemIds) =>
      _$this._unavailableItemIds = unavailableItemIds;

  CustomerActiveOrdersDtoOutputOrdersInnerRejectionBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInnerRejection._defaults(this);
  }

  CustomerActiveOrdersDtoOutputOrdersInnerRejectionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _reason = $v.reason;
      _text = $v.text;
      _unavailableItemIds = $v.unavailableItemIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerActiveOrdersDtoOutputOrdersInnerRejection other) {
    _$v = other as _$CustomerActiveOrdersDtoOutputOrdersInnerRejection;
  }

  @override
  void update(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerRejectionBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRejection build() => _build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerRejection _build() {
    _$CustomerActiveOrdersDtoOutputOrdersInnerRejection _$result;
    try {
      _$result =
          _$v ??
          _$CustomerActiveOrdersDtoOutputOrdersInnerRejection._(
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'CustomerActiveOrdersDtoOutputOrdersInnerRejection',
              'at',
            ),
            reason: BuiltValueNullFieldError.checkNotNull(
              reason,
              r'CustomerActiveOrdersDtoOutputOrdersInnerRejection',
              'reason',
            ),
            text: BuiltValueNullFieldError.checkNotNull(
              text,
              r'CustomerActiveOrdersDtoOutputOrdersInnerRejection',
              'text',
            ),
            unavailableItemIds: unavailableItemIds.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'unavailableItemIds';
        unavailableItemIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerActiveOrdersDtoOutputOrdersInnerRejection',
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
