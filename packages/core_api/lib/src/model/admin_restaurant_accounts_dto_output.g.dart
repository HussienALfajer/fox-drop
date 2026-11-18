// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_accounts_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantAccountsDtoOutput
    extends AdminRestaurantAccountsDtoOutput {
  @override
  final BuiltList<AdminRestaurantAccountsDtoOutputAccountsInner> accounts;

  factory _$AdminRestaurantAccountsDtoOutput([
    void Function(AdminRestaurantAccountsDtoOutputBuilder)? updates,
  ]) => (AdminRestaurantAccountsDtoOutputBuilder()..update(updates))._build();

  _$AdminRestaurantAccountsDtoOutput._({required this.accounts}) : super._();
  @override
  AdminRestaurantAccountsDtoOutput rebuild(
    void Function(AdminRestaurantAccountsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantAccountsDtoOutputBuilder toBuilder() =>
      AdminRestaurantAccountsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantAccountsDtoOutput &&
        accounts == other.accounts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accounts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminRestaurantAccountsDtoOutput',
    )..add('accounts', accounts)).toString();
  }
}

class AdminRestaurantAccountsDtoOutputBuilder
    implements
        Builder<
          AdminRestaurantAccountsDtoOutput,
          AdminRestaurantAccountsDtoOutputBuilder
        > {
  _$AdminRestaurantAccountsDtoOutput? _$v;

  ListBuilder<AdminRestaurantAccountsDtoOutputAccountsInner>? _accounts;
  ListBuilder<AdminRestaurantAccountsDtoOutputAccountsInner> get accounts =>
      _$this._accounts ??=
          ListBuilder<AdminRestaurantAccountsDtoOutputAccountsInner>();
  set accounts(
    ListBuilder<AdminRestaurantAccountsDtoOutputAccountsInner>? accounts,
  ) => _$this._accounts = accounts;

  AdminRestaurantAccountsDtoOutputBuilder() {
    AdminRestaurantAccountsDtoOutput._defaults(this);
  }

  AdminRestaurantAccountsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accounts = $v.accounts.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantAccountsDtoOutput other) {
    _$v = other as _$AdminRestaurantAccountsDtoOutput;
  }

  @override
  void update(void Function(AdminRestaurantAccountsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantAccountsDtoOutput build() => _build();

  _$AdminRestaurantAccountsDtoOutput _build() {
    _$AdminRestaurantAccountsDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantAccountsDtoOutput._(accounts: accounts.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'accounts';
        accounts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantAccountsDtoOutput',
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
