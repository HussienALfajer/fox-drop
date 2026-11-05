// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_history_dto_output_changes_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SettingHistoryDtoOutputChangesInnerActionEnum
_$settingHistoryDtoOutputChangesInnerActionEnum_update =
    const SettingHistoryDtoOutputChangesInnerActionEnum._('update');
const SettingHistoryDtoOutputChangesInnerActionEnum
_$settingHistoryDtoOutputChangesInnerActionEnum_reset =
    const SettingHistoryDtoOutputChangesInnerActionEnum._('reset');

SettingHistoryDtoOutputChangesInnerActionEnum
_$settingHistoryDtoOutputChangesInnerActionEnumValueOf(String name) {
  switch (name) {
    case 'update':
      return _$settingHistoryDtoOutputChangesInnerActionEnum_update;
    case 'reset':
      return _$settingHistoryDtoOutputChangesInnerActionEnum_reset;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SettingHistoryDtoOutputChangesInnerActionEnum>
_$settingHistoryDtoOutputChangesInnerActionEnumValues =
    BuiltSet<SettingHistoryDtoOutputChangesInnerActionEnum>(
      const <SettingHistoryDtoOutputChangesInnerActionEnum>[
        _$settingHistoryDtoOutputChangesInnerActionEnum_update,
        _$settingHistoryDtoOutputChangesInnerActionEnum_reset,
      ],
    );

Serializer<SettingHistoryDtoOutputChangesInnerActionEnum>
_$settingHistoryDtoOutputChangesInnerActionEnumSerializer =
    _$SettingHistoryDtoOutputChangesInnerActionEnumSerializer();

class _$SettingHistoryDtoOutputChangesInnerActionEnumSerializer
    implements
        PrimitiveSerializer<SettingHistoryDtoOutputChangesInnerActionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'update': 'update',
    'reset': 'reset',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'update': 'update',
    'reset': 'reset',
  };

  @override
  final Iterable<Type> types = const <Type>[
    SettingHistoryDtoOutputChangesInnerActionEnum,
  ];
  @override
  final String wireName = 'SettingHistoryDtoOutputChangesInnerActionEnum';

  @override
  Object serialize(
    Serializers serializers,
    SettingHistoryDtoOutputChangesInnerActionEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  SettingHistoryDtoOutputChangesInnerActionEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => SettingHistoryDtoOutputChangesInnerActionEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$SettingHistoryDtoOutputChangesInner
    extends SettingHistoryDtoOutputChangesInner {
  @override
  final SettingHistoryDtoOutputChangesInnerActionEnum action;
  @override
  final JsonObject? before;
  @override
  final JsonObject? after;
  @override
  final String editorId;
  @override
  final BuiltList<String> editorRoles;
  @override
  final String? reason;
  @override
  final DateTime changedAt;

  factory _$SettingHistoryDtoOutputChangesInner([
    void Function(SettingHistoryDtoOutputChangesInnerBuilder)? updates,
  ]) =>
      (SettingHistoryDtoOutputChangesInnerBuilder()..update(updates))._build();

  _$SettingHistoryDtoOutputChangesInner._({
    required this.action,
    this.before,
    this.after,
    required this.editorId,
    required this.editorRoles,
    this.reason,
    required this.changedAt,
  }) : super._();
  @override
  SettingHistoryDtoOutputChangesInner rebuild(
    void Function(SettingHistoryDtoOutputChangesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SettingHistoryDtoOutputChangesInnerBuilder toBuilder() =>
      SettingHistoryDtoOutputChangesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SettingHistoryDtoOutputChangesInner &&
        action == other.action &&
        before == other.before &&
        after == other.after &&
        editorId == other.editorId &&
        editorRoles == other.editorRoles &&
        reason == other.reason &&
        changedAt == other.changedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, before.hashCode);
    _$hash = $jc(_$hash, after.hashCode);
    _$hash = $jc(_$hash, editorId.hashCode);
    _$hash = $jc(_$hash, editorRoles.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, changedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SettingHistoryDtoOutputChangesInner')
          ..add('action', action)
          ..add('before', before)
          ..add('after', after)
          ..add('editorId', editorId)
          ..add('editorRoles', editorRoles)
          ..add('reason', reason)
          ..add('changedAt', changedAt))
        .toString();
  }
}

class SettingHistoryDtoOutputChangesInnerBuilder
    implements
        Builder<
          SettingHistoryDtoOutputChangesInner,
          SettingHistoryDtoOutputChangesInnerBuilder
        > {
  _$SettingHistoryDtoOutputChangesInner? _$v;

  SettingHistoryDtoOutputChangesInnerActionEnum? _action;
  SettingHistoryDtoOutputChangesInnerActionEnum? get action => _$this._action;
  set action(SettingHistoryDtoOutputChangesInnerActionEnum? action) =>
      _$this._action = action;

  JsonObject? _before;
  JsonObject? get before => _$this._before;
  set before(JsonObject? before) => _$this._before = before;

  JsonObject? _after;
  JsonObject? get after => _$this._after;
  set after(JsonObject? after) => _$this._after = after;

  String? _editorId;
  String? get editorId => _$this._editorId;
  set editorId(String? editorId) => _$this._editorId = editorId;

  ListBuilder<String>? _editorRoles;
  ListBuilder<String> get editorRoles =>
      _$this._editorRoles ??= ListBuilder<String>();
  set editorRoles(ListBuilder<String>? editorRoles) =>
      _$this._editorRoles = editorRoles;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DateTime? _changedAt;
  DateTime? get changedAt => _$this._changedAt;
  set changedAt(DateTime? changedAt) => _$this._changedAt = changedAt;

  SettingHistoryDtoOutputChangesInnerBuilder() {
    SettingHistoryDtoOutputChangesInner._defaults(this);
  }

  SettingHistoryDtoOutputChangesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _action = $v.action;
      _before = $v.before;
      _after = $v.after;
      _editorId = $v.editorId;
      _editorRoles = $v.editorRoles.toBuilder();
      _reason = $v.reason;
      _changedAt = $v.changedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SettingHistoryDtoOutputChangesInner other) {
    _$v = other as _$SettingHistoryDtoOutputChangesInner;
  }

  @override
  void update(
    void Function(SettingHistoryDtoOutputChangesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  SettingHistoryDtoOutputChangesInner build() => _build();

  _$SettingHistoryDtoOutputChangesInner _build() {
    _$SettingHistoryDtoOutputChangesInner _$result;
    try {
      _$result =
          _$v ??
          _$SettingHistoryDtoOutputChangesInner._(
            action: BuiltValueNullFieldError.checkNotNull(
              action,
              r'SettingHistoryDtoOutputChangesInner',
              'action',
            ),
            before: before,
            after: after,
            editorId: BuiltValueNullFieldError.checkNotNull(
              editorId,
              r'SettingHistoryDtoOutputChangesInner',
              'editorId',
            ),
            editorRoles: editorRoles.build(),
            reason: reason,
            changedAt: BuiltValueNullFieldError.checkNotNull(
              changedAt,
              r'SettingHistoryDtoOutputChangesInner',
              'changedAt',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'editorRoles';
        editorRoles.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'SettingHistoryDtoOutputChangesInner',
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
