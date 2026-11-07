// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_notification_texts_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminNotificationTextsDtoOutput
    extends AdminNotificationTextsDtoOutput {
  @override
  final BuiltList<AdminNotificationTextsDtoOutputTemplatesInner> templates;

  factory _$AdminNotificationTextsDtoOutput([
    void Function(AdminNotificationTextsDtoOutputBuilder)? updates,
  ]) => (AdminNotificationTextsDtoOutputBuilder()..update(updates))._build();

  _$AdminNotificationTextsDtoOutput._({required this.templates}) : super._();
  @override
  AdminNotificationTextsDtoOutput rebuild(
    void Function(AdminNotificationTextsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminNotificationTextsDtoOutputBuilder toBuilder() =>
      AdminNotificationTextsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminNotificationTextsDtoOutput &&
        templates == other.templates;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, templates.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminNotificationTextsDtoOutput',
    )..add('templates', templates)).toString();
  }
}

class AdminNotificationTextsDtoOutputBuilder
    implements
        Builder<
          AdminNotificationTextsDtoOutput,
          AdminNotificationTextsDtoOutputBuilder
        > {
  _$AdminNotificationTextsDtoOutput? _$v;

  ListBuilder<AdminNotificationTextsDtoOutputTemplatesInner>? _templates;
  ListBuilder<AdminNotificationTextsDtoOutputTemplatesInner> get templates =>
      _$this._templates ??=
          ListBuilder<AdminNotificationTextsDtoOutputTemplatesInner>();
  set templates(
    ListBuilder<AdminNotificationTextsDtoOutputTemplatesInner>? templates,
  ) => _$this._templates = templates;

  AdminNotificationTextsDtoOutputBuilder() {
    AdminNotificationTextsDtoOutput._defaults(this);
  }

  AdminNotificationTextsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _templates = $v.templates.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminNotificationTextsDtoOutput other) {
    _$v = other as _$AdminNotificationTextsDtoOutput;
  }

  @override
  void update(void Function(AdminNotificationTextsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminNotificationTextsDtoOutput build() => _build();

  _$AdminNotificationTextsDtoOutput _build() {
    _$AdminNotificationTextsDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminNotificationTextsDtoOutput._(templates: templates.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'templates';
        templates.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminNotificationTextsDtoOutput',
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
