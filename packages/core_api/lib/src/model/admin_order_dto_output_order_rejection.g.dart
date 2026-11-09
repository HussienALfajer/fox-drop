// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_rejection.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderRejection
    extends AdminOrderDtoOutputOrderRejection {
  @override
  final DateTime at;
  @override
  final String reason;
  @override
  final String label;
  @override
  final String customerText;
  @override
  final BuiltList<String> itemIds;
  @override
  final bool byOperations;

  factory _$AdminOrderDtoOutputOrderRejection([
    void Function(AdminOrderDtoOutputOrderRejectionBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderRejectionBuilder()..update(updates))._build();

  _$AdminOrderDtoOutputOrderRejection._({
    required this.at,
    required this.reason,
    required this.label,
    required this.customerText,
    required this.itemIds,
    required this.byOperations,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderRejection rebuild(
    void Function(AdminOrderDtoOutputOrderRejectionBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderRejectionBuilder toBuilder() =>
      AdminOrderDtoOutputOrderRejectionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderRejection &&
        at == other.at &&
        reason == other.reason &&
        label == other.label &&
        customerText == other.customerText &&
        itemIds == other.itemIds &&
        byOperations == other.byOperations;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, customerText.hashCode);
    _$hash = $jc(_$hash, itemIds.hashCode);
    _$hash = $jc(_$hash, byOperations.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOrderDtoOutputOrderRejection')
          ..add('at', at)
          ..add('reason', reason)
          ..add('label', label)
          ..add('customerText', customerText)
          ..add('itemIds', itemIds)
          ..add('byOperations', byOperations))
        .toString();
  }
}

class AdminOrderDtoOutputOrderRejectionBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderRejection,
          AdminOrderDtoOutputOrderRejectionBuilder
        > {
  _$AdminOrderDtoOutputOrderRejection? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _customerText;
  String? get customerText => _$this._customerText;
  set customerText(String? customerText) => _$this._customerText = customerText;

  ListBuilder<String>? _itemIds;
  ListBuilder<String> get itemIds => _$this._itemIds ??= ListBuilder<String>();
  set itemIds(ListBuilder<String>? itemIds) => _$this._itemIds = itemIds;

  bool? _byOperations;
  bool? get byOperations => _$this._byOperations;
  set byOperations(bool? byOperations) => _$this._byOperations = byOperations;

  AdminOrderDtoOutputOrderRejectionBuilder() {
    AdminOrderDtoOutputOrderRejection._defaults(this);
  }

  AdminOrderDtoOutputOrderRejectionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _reason = $v.reason;
      _label = $v.label;
      _customerText = $v.customerText;
      _itemIds = $v.itemIds.toBuilder();
      _byOperations = $v.byOperations;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderRejection other) {
    _$v = other as _$AdminOrderDtoOutputOrderRejection;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderRejectionBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderRejection build() => _build();

  _$AdminOrderDtoOutputOrderRejection _build() {
    _$AdminOrderDtoOutputOrderRejection _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderDtoOutputOrderRejection._(
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'AdminOrderDtoOutputOrderRejection',
              'at',
            ),
            reason: BuiltValueNullFieldError.checkNotNull(
              reason,
              r'AdminOrderDtoOutputOrderRejection',
              'reason',
            ),
            label: BuiltValueNullFieldError.checkNotNull(
              label,
              r'AdminOrderDtoOutputOrderRejection',
              'label',
            ),
            customerText: BuiltValueNullFieldError.checkNotNull(
              customerText,
              r'AdminOrderDtoOutputOrderRejection',
              'customerText',
            ),
            itemIds: itemIds.build(),
            byOperations: BuiltValueNullFieldError.checkNotNull(
              byOperations,
              r'AdminOrderDtoOutputOrderRejection',
              'byOperations',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'itemIds';
        itemIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderDtoOutputOrderRejection',
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
