// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_update_notification_text_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminUpdateNotificationTextDto extends AdminUpdateNotificationTextDto {
  @override
  final String text;

  factory _$AdminUpdateNotificationTextDto([
    void Function(AdminUpdateNotificationTextDtoBuilder)? updates,
  ]) => (AdminUpdateNotificationTextDtoBuilder()..update(updates))._build();

  _$AdminUpdateNotificationTextDto._({required this.text}) : super._();
  @override
  AdminUpdateNotificationTextDto rebuild(
    void Function(AdminUpdateNotificationTextDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminUpdateNotificationTextDtoBuilder toBuilder() =>
      AdminUpdateNotificationTextDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminUpdateNotificationTextDto && text == other.text;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminUpdateNotificationTextDto',
    )..add('text', text)).toString();
  }
}

class AdminUpdateNotificationTextDtoBuilder
    implements
        Builder<
          AdminUpdateNotificationTextDto,
          AdminUpdateNotificationTextDtoBuilder
        > {
  _$AdminUpdateNotificationTextDto? _$v;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  AdminUpdateNotificationTextDtoBuilder() {
    AdminUpdateNotificationTextDto._defaults(this);
  }

  AdminUpdateNotificationTextDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _text = $v.text;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminUpdateNotificationTextDto other) {
    _$v = other as _$AdminUpdateNotificationTextDto;
  }

  @override
  void update(void Function(AdminUpdateNotificationTextDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminUpdateNotificationTextDto build() => _build();

  _$AdminUpdateNotificationTextDto _build() {
    final _$result =
        _$v ??
        _$AdminUpdateNotificationTextDto._(
          text: BuiltValueNullFieldError.checkNotNull(
            text,
            r'AdminUpdateNotificationTextDto',
            'text',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
