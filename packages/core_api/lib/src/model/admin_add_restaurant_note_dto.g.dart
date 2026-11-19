// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_add_restaurant_note_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminAddRestaurantNoteDto extends AdminAddRestaurantNoteDto {
  @override
  final String body;

  factory _$AdminAddRestaurantNoteDto([
    void Function(AdminAddRestaurantNoteDtoBuilder)? updates,
  ]) => (AdminAddRestaurantNoteDtoBuilder()..update(updates))._build();

  _$AdminAddRestaurantNoteDto._({required this.body}) : super._();
  @override
  AdminAddRestaurantNoteDto rebuild(
    void Function(AdminAddRestaurantNoteDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminAddRestaurantNoteDtoBuilder toBuilder() =>
      AdminAddRestaurantNoteDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminAddRestaurantNoteDto && body == other.body;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminAddRestaurantNoteDto',
    )..add('body', body)).toString();
  }
}

class AdminAddRestaurantNoteDtoBuilder
    implements
        Builder<AdminAddRestaurantNoteDto, AdminAddRestaurantNoteDtoBuilder> {
  _$AdminAddRestaurantNoteDto? _$v;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  AdminAddRestaurantNoteDtoBuilder() {
    AdminAddRestaurantNoteDto._defaults(this);
  }

  AdminAddRestaurantNoteDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _body = $v.body;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminAddRestaurantNoteDto other) {
    _$v = other as _$AdminAddRestaurantNoteDto;
  }

  @override
  void update(void Function(AdminAddRestaurantNoteDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminAddRestaurantNoteDto build() => _build();

  _$AdminAddRestaurantNoteDto _build() {
    final _$result =
        _$v ??
        _$AdminAddRestaurantNoteDto._(
          body: BuiltValueNullFieldError.checkNotNull(
            body,
            r'AdminAddRestaurantNoteDto',
            'body',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
