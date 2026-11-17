// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_dto_output_late_cancels_cleared.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCustomerDtoOutputLateCancelsCleared
    extends AdminCustomerDtoOutputLateCancelsCleared {
  @override
  final DateTime at;
  @override
  final String? byName;
  @override
  final String note;

  factory _$AdminCustomerDtoOutputLateCancelsCleared([
    void Function(AdminCustomerDtoOutputLateCancelsClearedBuilder)? updates,
  ]) => (AdminCustomerDtoOutputLateCancelsClearedBuilder()..update(updates))
      ._build();

  _$AdminCustomerDtoOutputLateCancelsCleared._({
    required this.at,
    this.byName,
    required this.note,
  }) : super._();
  @override
  AdminCustomerDtoOutputLateCancelsCleared rebuild(
    void Function(AdminCustomerDtoOutputLateCancelsClearedBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerDtoOutputLateCancelsClearedBuilder toBuilder() =>
      AdminCustomerDtoOutputLateCancelsClearedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerDtoOutputLateCancelsCleared &&
        at == other.at &&
        byName == other.byName &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, byName.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCustomerDtoOutputLateCancelsCleared',
          )
          ..add('at', at)
          ..add('byName', byName)
          ..add('note', note))
        .toString();
  }
}

class AdminCustomerDtoOutputLateCancelsClearedBuilder
    implements
        Builder<
          AdminCustomerDtoOutputLateCancelsCleared,
          AdminCustomerDtoOutputLateCancelsClearedBuilder
        > {
  _$AdminCustomerDtoOutputLateCancelsCleared? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  String? _byName;
  String? get byName => _$this._byName;
  set byName(String? byName) => _$this._byName = byName;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  AdminCustomerDtoOutputLateCancelsClearedBuilder() {
    AdminCustomerDtoOutputLateCancelsCleared._defaults(this);
  }

  AdminCustomerDtoOutputLateCancelsClearedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _byName = $v.byName;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerDtoOutputLateCancelsCleared other) {
    _$v = other as _$AdminCustomerDtoOutputLateCancelsCleared;
  }

  @override
  void update(
    void Function(AdminCustomerDtoOutputLateCancelsClearedBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerDtoOutputLateCancelsCleared build() => _build();

  _$AdminCustomerDtoOutputLateCancelsCleared _build() {
    final _$result =
        _$v ??
        _$AdminCustomerDtoOutputLateCancelsCleared._(
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'AdminCustomerDtoOutputLateCancelsCleared',
            'at',
          ),
          byName: byName,
          note: BuiltValueNullFieldError.checkNotNull(
            note,
            r'AdminCustomerDtoOutputLateCancelsCleared',
            'note',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
