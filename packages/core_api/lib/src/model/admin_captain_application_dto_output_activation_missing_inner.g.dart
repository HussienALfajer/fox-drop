// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_application_dto_output_activation_missing_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainApplicationDtoOutputActivationMissingInner
    extends AdminCaptainApplicationDtoOutputActivationMissingInner {
  @override
  final AnyOf anyOf;

  factory _$AdminCaptainApplicationDtoOutputActivationMissingInner([
    void Function(
      AdminCaptainApplicationDtoOutputActivationMissingInnerBuilder,
    )?
    updates,
  ]) =>
      (AdminCaptainApplicationDtoOutputActivationMissingInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminCaptainApplicationDtoOutputActivationMissingInner._({
    required this.anyOf,
  }) : super._();
  @override
  AdminCaptainApplicationDtoOutputActivationMissingInner rebuild(
    void Function(AdminCaptainApplicationDtoOutputActivationMissingInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainApplicationDtoOutputActivationMissingInnerBuilder toBuilder() =>
      AdminCaptainApplicationDtoOutputActivationMissingInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainApplicationDtoOutputActivationMissingInner &&
        anyOf == other.anyOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, anyOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminCaptainApplicationDtoOutputActivationMissingInner',
    )..add('anyOf', anyOf)).toString();
  }
}

class AdminCaptainApplicationDtoOutputActivationMissingInnerBuilder
    implements
        Builder<
          AdminCaptainApplicationDtoOutputActivationMissingInner,
          AdminCaptainApplicationDtoOutputActivationMissingInnerBuilder
        > {
  _$AdminCaptainApplicationDtoOutputActivationMissingInner? _$v;

  AnyOf? _anyOf;
  AnyOf? get anyOf => _$this._anyOf;
  set anyOf(AnyOf? anyOf) => _$this._anyOf = anyOf;

  AdminCaptainApplicationDtoOutputActivationMissingInnerBuilder() {
    AdminCaptainApplicationDtoOutputActivationMissingInner._defaults(this);
  }

  AdminCaptainApplicationDtoOutputActivationMissingInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _anyOf = $v.anyOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainApplicationDtoOutputActivationMissingInner other) {
    _$v = other as _$AdminCaptainApplicationDtoOutputActivationMissingInner;
  }

  @override
  void update(
    void Function(
      AdminCaptainApplicationDtoOutputActivationMissingInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainApplicationDtoOutputActivationMissingInner build() => _build();

  _$AdminCaptainApplicationDtoOutputActivationMissingInner _build() {
    final _$result =
        _$v ??
        _$AdminCaptainApplicationDtoOutputActivationMissingInner._(
          anyOf: BuiltValueNullFieldError.checkNotNull(
            anyOf,
            r'AdminCaptainApplicationDtoOutputActivationMissingInner',
            'anyOf',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
