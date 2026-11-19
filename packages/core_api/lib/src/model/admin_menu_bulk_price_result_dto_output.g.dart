// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_bulk_price_result_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMenuBulkPriceResultDtoOutput
    extends AdminMenuBulkPriceResultDtoOutput {
  @override
  final int changed;
  @override
  final int unchanged;

  factory _$AdminMenuBulkPriceResultDtoOutput([
    void Function(AdminMenuBulkPriceResultDtoOutputBuilder)? updates,
  ]) => (AdminMenuBulkPriceResultDtoOutputBuilder()..update(updates))._build();

  _$AdminMenuBulkPriceResultDtoOutput._({
    required this.changed,
    required this.unchanged,
  }) : super._();
  @override
  AdminMenuBulkPriceResultDtoOutput rebuild(
    void Function(AdminMenuBulkPriceResultDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuBulkPriceResultDtoOutputBuilder toBuilder() =>
      AdminMenuBulkPriceResultDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuBulkPriceResultDtoOutput &&
        changed == other.changed &&
        unchanged == other.unchanged;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, changed.hashCode);
    _$hash = $jc(_$hash, unchanged.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminMenuBulkPriceResultDtoOutput')
          ..add('changed', changed)
          ..add('unchanged', unchanged))
        .toString();
  }
}

class AdminMenuBulkPriceResultDtoOutputBuilder
    implements
        Builder<
          AdminMenuBulkPriceResultDtoOutput,
          AdminMenuBulkPriceResultDtoOutputBuilder
        > {
  _$AdminMenuBulkPriceResultDtoOutput? _$v;

  int? _changed;
  int? get changed => _$this._changed;
  set changed(int? changed) => _$this._changed = changed;

  int? _unchanged;
  int? get unchanged => _$this._unchanged;
  set unchanged(int? unchanged) => _$this._unchanged = unchanged;

  AdminMenuBulkPriceResultDtoOutputBuilder() {
    AdminMenuBulkPriceResultDtoOutput._defaults(this);
  }

  AdminMenuBulkPriceResultDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _changed = $v.changed;
      _unchanged = $v.unchanged;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuBulkPriceResultDtoOutput other) {
    _$v = other as _$AdminMenuBulkPriceResultDtoOutput;
  }

  @override
  void update(
    void Function(AdminMenuBulkPriceResultDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuBulkPriceResultDtoOutput build() => _build();

  _$AdminMenuBulkPriceResultDtoOutput _build() {
    final _$result =
        _$v ??
        _$AdminMenuBulkPriceResultDtoOutput._(
          changed: BuiltValueNullFieldError.checkNotNull(
            changed,
            r'AdminMenuBulkPriceResultDtoOutput',
            'changed',
          ),
          unchanged: BuiltValueNullFieldError.checkNotNull(
            unchanged,
            r'AdminMenuBulkPriceResultDtoOutput',
            'unchanged',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
