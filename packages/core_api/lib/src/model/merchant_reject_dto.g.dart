// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_reject_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantRejectDto extends MerchantRejectDto {
  @override
  final String reason;
  @override
  final BuiltList<MerchantRejectDtoItemsInner> items;
  @override
  final int? busyExtraMin;
  @override
  final int? pauseMin;

  factory _$MerchantRejectDto([
    void Function(MerchantRejectDtoBuilder)? updates,
  ]) => (MerchantRejectDtoBuilder()..update(updates))._build();

  _$MerchantRejectDto._({
    required this.reason,
    required this.items,
    this.busyExtraMin,
    this.pauseMin,
  }) : super._();
  @override
  MerchantRejectDto rebuild(void Function(MerchantRejectDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MerchantRejectDtoBuilder toBuilder() =>
      MerchantRejectDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantRejectDto &&
        reason == other.reason &&
        items == other.items &&
        busyExtraMin == other.busyExtraMin &&
        pauseMin == other.pauseMin;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, busyExtraMin.hashCode);
    _$hash = $jc(_$hash, pauseMin.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantRejectDto')
          ..add('reason', reason)
          ..add('items', items)
          ..add('busyExtraMin', busyExtraMin)
          ..add('pauseMin', pauseMin))
        .toString();
  }
}

class MerchantRejectDtoBuilder
    implements Builder<MerchantRejectDto, MerchantRejectDtoBuilder> {
  _$MerchantRejectDto? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  ListBuilder<MerchantRejectDtoItemsInner>? _items;
  ListBuilder<MerchantRejectDtoItemsInner> get items =>
      _$this._items ??= ListBuilder<MerchantRejectDtoItemsInner>();
  set items(ListBuilder<MerchantRejectDtoItemsInner>? items) =>
      _$this._items = items;

  int? _busyExtraMin;
  int? get busyExtraMin => _$this._busyExtraMin;
  set busyExtraMin(int? busyExtraMin) => _$this._busyExtraMin = busyExtraMin;

  int? _pauseMin;
  int? get pauseMin => _$this._pauseMin;
  set pauseMin(int? pauseMin) => _$this._pauseMin = pauseMin;

  MerchantRejectDtoBuilder() {
    MerchantRejectDto._defaults(this);
  }

  MerchantRejectDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _items = $v.items.toBuilder();
      _busyExtraMin = $v.busyExtraMin;
      _pauseMin = $v.pauseMin;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantRejectDto other) {
    _$v = other as _$MerchantRejectDto;
  }

  @override
  void update(void Function(MerchantRejectDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantRejectDto build() => _build();

  _$MerchantRejectDto _build() {
    _$MerchantRejectDto _$result;
    try {
      _$result =
          _$v ??
          _$MerchantRejectDto._(
            reason: BuiltValueNullFieldError.checkNotNull(
              reason,
              r'MerchantRejectDto',
              'reason',
            ),
            items: items.build(),
            busyExtraMin: busyExtraMin,
            pauseMin: pauseMin,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantRejectDto',
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
