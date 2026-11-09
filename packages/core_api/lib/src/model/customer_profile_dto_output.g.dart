// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_profile_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerProfileDtoOutput extends CustomerProfileDtoOutput {
  @override
  final bool completed;
  @override
  final CustomerProfileDtoOutputProfile? profile;

  factory _$CustomerProfileDtoOutput([
    void Function(CustomerProfileDtoOutputBuilder)? updates,
  ]) => (CustomerProfileDtoOutputBuilder()..update(updates))._build();

  _$CustomerProfileDtoOutput._({required this.completed, this.profile})
    : super._();
  @override
  CustomerProfileDtoOutput rebuild(
    void Function(CustomerProfileDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerProfileDtoOutputBuilder toBuilder() =>
      CustomerProfileDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerProfileDtoOutput &&
        completed == other.completed &&
        profile == other.profile;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, completed.hashCode);
    _$hash = $jc(_$hash, profile.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerProfileDtoOutput')
          ..add('completed', completed)
          ..add('profile', profile))
        .toString();
  }
}

class CustomerProfileDtoOutputBuilder
    implements
        Builder<CustomerProfileDtoOutput, CustomerProfileDtoOutputBuilder> {
  _$CustomerProfileDtoOutput? _$v;

  bool? _completed;
  bool? get completed => _$this._completed;
  set completed(bool? completed) => _$this._completed = completed;

  CustomerProfileDtoOutputProfileBuilder? _profile;
  CustomerProfileDtoOutputProfileBuilder get profile =>
      _$this._profile ??= CustomerProfileDtoOutputProfileBuilder();
  set profile(CustomerProfileDtoOutputProfileBuilder? profile) =>
      _$this._profile = profile;

  CustomerProfileDtoOutputBuilder() {
    CustomerProfileDtoOutput._defaults(this);
  }

  CustomerProfileDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _completed = $v.completed;
      _profile = $v.profile?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerProfileDtoOutput other) {
    _$v = other as _$CustomerProfileDtoOutput;
  }

  @override
  void update(void Function(CustomerProfileDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerProfileDtoOutput build() => _build();

  _$CustomerProfileDtoOutput _build() {
    _$CustomerProfileDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CustomerProfileDtoOutput._(
            completed: BuiltValueNullFieldError.checkNotNull(
              completed,
              r'CustomerProfileDtoOutput',
              'completed',
            ),
            profile: _profile?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'profile';
        _profile?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerProfileDtoOutput',
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
