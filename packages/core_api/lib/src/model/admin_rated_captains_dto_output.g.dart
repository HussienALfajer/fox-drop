// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_rated_captains_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRatedCaptainsDtoOutput extends AdminRatedCaptainsDtoOutput {
  @override
  final BuiltList<AdminRatedCaptainsDtoOutputCaptainsInner> captains;

  factory _$AdminRatedCaptainsDtoOutput([
    void Function(AdminRatedCaptainsDtoOutputBuilder)? updates,
  ]) => (AdminRatedCaptainsDtoOutputBuilder()..update(updates))._build();

  _$AdminRatedCaptainsDtoOutput._({required this.captains}) : super._();
  @override
  AdminRatedCaptainsDtoOutput rebuild(
    void Function(AdminRatedCaptainsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRatedCaptainsDtoOutputBuilder toBuilder() =>
      AdminRatedCaptainsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRatedCaptainsDtoOutput && captains == other.captains;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, captains.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminRatedCaptainsDtoOutput',
    )..add('captains', captains)).toString();
  }
}

class AdminRatedCaptainsDtoOutputBuilder
    implements
        Builder<
          AdminRatedCaptainsDtoOutput,
          AdminRatedCaptainsDtoOutputBuilder
        > {
  _$AdminRatedCaptainsDtoOutput? _$v;

  ListBuilder<AdminRatedCaptainsDtoOutputCaptainsInner>? _captains;
  ListBuilder<AdminRatedCaptainsDtoOutputCaptainsInner> get captains =>
      _$this._captains ??=
          ListBuilder<AdminRatedCaptainsDtoOutputCaptainsInner>();
  set captains(
    ListBuilder<AdminRatedCaptainsDtoOutputCaptainsInner>? captains,
  ) => _$this._captains = captains;

  AdminRatedCaptainsDtoOutputBuilder() {
    AdminRatedCaptainsDtoOutput._defaults(this);
  }

  AdminRatedCaptainsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _captains = $v.captains.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRatedCaptainsDtoOutput other) {
    _$v = other as _$AdminRatedCaptainsDtoOutput;
  }

  @override
  void update(void Function(AdminRatedCaptainsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRatedCaptainsDtoOutput build() => _build();

  _$AdminRatedCaptainsDtoOutput _build() {
    _$AdminRatedCaptainsDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$AdminRatedCaptainsDtoOutput._(captains: captains.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'captains';
        captains.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRatedCaptainsDtoOutput',
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
