// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_dto_output_trust_mark.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCustomerDtoOutputTrustMark
    extends AdminCustomerDtoOutputTrustMark {
  @override
  final DateTime at;
  @override
  final String? byName;
  @override
  final String note;
  @override
  final bool trusted;

  factory _$AdminCustomerDtoOutputTrustMark([
    void Function(AdminCustomerDtoOutputTrustMarkBuilder)? updates,
  ]) => (AdminCustomerDtoOutputTrustMarkBuilder()..update(updates))._build();

  _$AdminCustomerDtoOutputTrustMark._({
    required this.at,
    this.byName,
    required this.note,
    required this.trusted,
  }) : super._();
  @override
  AdminCustomerDtoOutputTrustMark rebuild(
    void Function(AdminCustomerDtoOutputTrustMarkBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerDtoOutputTrustMarkBuilder toBuilder() =>
      AdminCustomerDtoOutputTrustMarkBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerDtoOutputTrustMark &&
        at == other.at &&
        byName == other.byName &&
        note == other.note &&
        trusted == other.trusted;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, byName.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, trusted.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCustomerDtoOutputTrustMark')
          ..add('at', at)
          ..add('byName', byName)
          ..add('note', note)
          ..add('trusted', trusted))
        .toString();
  }
}

class AdminCustomerDtoOutputTrustMarkBuilder
    implements
        Builder<
          AdminCustomerDtoOutputTrustMark,
          AdminCustomerDtoOutputTrustMarkBuilder
        > {
  _$AdminCustomerDtoOutputTrustMark? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  String? _byName;
  String? get byName => _$this._byName;
  set byName(String? byName) => _$this._byName = byName;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  bool? _trusted;
  bool? get trusted => _$this._trusted;
  set trusted(bool? trusted) => _$this._trusted = trusted;

  AdminCustomerDtoOutputTrustMarkBuilder() {
    AdminCustomerDtoOutputTrustMark._defaults(this);
  }

  AdminCustomerDtoOutputTrustMarkBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _byName = $v.byName;
      _note = $v.note;
      _trusted = $v.trusted;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerDtoOutputTrustMark other) {
    _$v = other as _$AdminCustomerDtoOutputTrustMark;
  }

  @override
  void update(void Function(AdminCustomerDtoOutputTrustMarkBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerDtoOutputTrustMark build() => _build();

  _$AdminCustomerDtoOutputTrustMark _build() {
    final _$result =
        _$v ??
        _$AdminCustomerDtoOutputTrustMark._(
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'AdminCustomerDtoOutputTrustMark',
            'at',
          ),
          byName: byName,
          note: BuiltValueNullFieldError.checkNotNull(
            note,
            r'AdminCustomerDtoOutputTrustMark',
            'note',
          ),
          trusted: BuiltValueNullFieldError.checkNotNull(
            trusted,
            r'AdminCustomerDtoOutputTrustMark',
            'trusted',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
