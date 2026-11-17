// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_dto_output_devices_inner_lift.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCustomerDtoOutputDevicesInnerLift
    extends AdminCustomerDtoOutputDevicesInnerLift {
  @override
  final DateTime at;
  @override
  final String? byName;
  @override
  final String note;

  factory _$AdminCustomerDtoOutputDevicesInnerLift([
    void Function(AdminCustomerDtoOutputDevicesInnerLiftBuilder)? updates,
  ]) => (AdminCustomerDtoOutputDevicesInnerLiftBuilder()..update(updates))
      ._build();

  _$AdminCustomerDtoOutputDevicesInnerLift._({
    required this.at,
    this.byName,
    required this.note,
  }) : super._();
  @override
  AdminCustomerDtoOutputDevicesInnerLift rebuild(
    void Function(AdminCustomerDtoOutputDevicesInnerLiftBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerDtoOutputDevicesInnerLiftBuilder toBuilder() =>
      AdminCustomerDtoOutputDevicesInnerLiftBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerDtoOutputDevicesInnerLift &&
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
            r'AdminCustomerDtoOutputDevicesInnerLift',
          )
          ..add('at', at)
          ..add('byName', byName)
          ..add('note', note))
        .toString();
  }
}

class AdminCustomerDtoOutputDevicesInnerLiftBuilder
    implements
        Builder<
          AdminCustomerDtoOutputDevicesInnerLift,
          AdminCustomerDtoOutputDevicesInnerLiftBuilder
        > {
  _$AdminCustomerDtoOutputDevicesInnerLift? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  String? _byName;
  String? get byName => _$this._byName;
  set byName(String? byName) => _$this._byName = byName;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  AdminCustomerDtoOutputDevicesInnerLiftBuilder() {
    AdminCustomerDtoOutputDevicesInnerLift._defaults(this);
  }

  AdminCustomerDtoOutputDevicesInnerLiftBuilder get _$this {
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
  void replace(AdminCustomerDtoOutputDevicesInnerLift other) {
    _$v = other as _$AdminCustomerDtoOutputDevicesInnerLift;
  }

  @override
  void update(
    void Function(AdminCustomerDtoOutputDevicesInnerLiftBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerDtoOutputDevicesInnerLift build() => _build();

  _$AdminCustomerDtoOutputDevicesInnerLift _build() {
    final _$result =
        _$v ??
        _$AdminCustomerDtoOutputDevicesInnerLift._(
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'AdminCustomerDtoOutputDevicesInnerLift',
            'at',
          ),
          byName: byName,
          note: BuiltValueNullFieldError.checkNotNull(
            note,
            r'AdminCustomerDtoOutputDevicesInnerLift',
            'note',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
