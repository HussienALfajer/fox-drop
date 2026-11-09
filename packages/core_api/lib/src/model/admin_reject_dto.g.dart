// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_reject_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRejectDto extends AdminRejectDto {
  @override
  final String rejection;
  @override
  final BuiltList<AdminRejectDtoItemsInner> items;
  @override
  final int? busyExtraMin;
  @override
  final int? pauseMin;
  @override
  final String reason;

  factory _$AdminRejectDto([void Function(AdminRejectDtoBuilder)? updates]) =>
      (AdminRejectDtoBuilder()..update(updates))._build();

  _$AdminRejectDto._({
    required this.rejection,
    required this.items,
    this.busyExtraMin,
    this.pauseMin,
    required this.reason,
  }) : super._();
  @override
  AdminRejectDto rebuild(void Function(AdminRejectDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminRejectDtoBuilder toBuilder() => AdminRejectDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRejectDto &&
        rejection == other.rejection &&
        items == other.items &&
        busyExtraMin == other.busyExtraMin &&
        pauseMin == other.pauseMin &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, rejection.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, busyExtraMin.hashCode);
    _$hash = $jc(_$hash, pauseMin.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRejectDto')
          ..add('rejection', rejection)
          ..add('items', items)
          ..add('busyExtraMin', busyExtraMin)
          ..add('pauseMin', pauseMin)
          ..add('reason', reason))
        .toString();
  }
}

class AdminRejectDtoBuilder
    implements Builder<AdminRejectDto, AdminRejectDtoBuilder> {
  _$AdminRejectDto? _$v;

  String? _rejection;
  String? get rejection => _$this._rejection;
  set rejection(String? rejection) => _$this._rejection = rejection;

  ListBuilder<AdminRejectDtoItemsInner>? _items;
  ListBuilder<AdminRejectDtoItemsInner> get items =>
      _$this._items ??= ListBuilder<AdminRejectDtoItemsInner>();
  set items(ListBuilder<AdminRejectDtoItemsInner>? items) =>
      _$this._items = items;

  int? _busyExtraMin;
  int? get busyExtraMin => _$this._busyExtraMin;
  set busyExtraMin(int? busyExtraMin) => _$this._busyExtraMin = busyExtraMin;

  int? _pauseMin;
  int? get pauseMin => _$this._pauseMin;
  set pauseMin(int? pauseMin) => _$this._pauseMin = pauseMin;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminRejectDtoBuilder() {
    AdminRejectDto._defaults(this);
  }

  AdminRejectDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rejection = $v.rejection;
      _items = $v.items.toBuilder();
      _busyExtraMin = $v.busyExtraMin;
      _pauseMin = $v.pauseMin;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRejectDto other) {
    _$v = other as _$AdminRejectDto;
  }

  @override
  void update(void Function(AdminRejectDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRejectDto build() => _build();

  _$AdminRejectDto _build() {
    _$AdminRejectDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminRejectDto._(
            rejection: BuiltValueNullFieldError.checkNotNull(
              rejection,
              r'AdminRejectDto',
              'rejection',
            ),
            items: items.build(),
            busyExtraMin: busyExtraMin,
            pauseMin: pauseMin,
            reason: BuiltValueNullFieldError.checkNotNull(
              reason,
              r'AdminRejectDto',
              'reason',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRejectDto',
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
