// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_notification_text_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminNotificationTextDtoOutputAudienceEnum
_$adminNotificationTextDtoOutputAudienceEnum_customer =
    const AdminNotificationTextDtoOutputAudienceEnum._('customer');
const AdminNotificationTextDtoOutputAudienceEnum
_$adminNotificationTextDtoOutputAudienceEnum_merchant =
    const AdminNotificationTextDtoOutputAudienceEnum._('merchant');
const AdminNotificationTextDtoOutputAudienceEnum
_$adminNotificationTextDtoOutputAudienceEnum_captain =
    const AdminNotificationTextDtoOutputAudienceEnum._('captain');

AdminNotificationTextDtoOutputAudienceEnum
_$adminNotificationTextDtoOutputAudienceEnumValueOf(String name) {
  switch (name) {
    case 'customer':
      return _$adminNotificationTextDtoOutputAudienceEnum_customer;
    case 'merchant':
      return _$adminNotificationTextDtoOutputAudienceEnum_merchant;
    case 'captain':
      return _$adminNotificationTextDtoOutputAudienceEnum_captain;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminNotificationTextDtoOutputAudienceEnum>
_$adminNotificationTextDtoOutputAudienceEnumValues =
    BuiltSet<AdminNotificationTextDtoOutputAudienceEnum>(
      const <AdminNotificationTextDtoOutputAudienceEnum>[
        _$adminNotificationTextDtoOutputAudienceEnum_customer,
        _$adminNotificationTextDtoOutputAudienceEnum_merchant,
        _$adminNotificationTextDtoOutputAudienceEnum_captain,
      ],
    );

const AdminNotificationTextDtoOutputLevelEnum
_$adminNotificationTextDtoOutputLevelEnum_default_ =
    const AdminNotificationTextDtoOutputLevelEnum._('default_');
const AdminNotificationTextDtoOutputLevelEnum
_$adminNotificationTextDtoOutputLevelEnum_ring =
    const AdminNotificationTextDtoOutputLevelEnum._('ring');
const AdminNotificationTextDtoOutputLevelEnum
_$adminNotificationTextDtoOutputLevelEnum_chime =
    const AdminNotificationTextDtoOutputLevelEnum._('chime');
const AdminNotificationTextDtoOutputLevelEnum
_$adminNotificationTextDtoOutputLevelEnum_offer =
    const AdminNotificationTextDtoOutputLevelEnum._('offer');
const AdminNotificationTextDtoOutputLevelEnum
_$adminNotificationTextDtoOutputLevelEnum_cancellation =
    const AdminNotificationTextDtoOutputLevelEnum._('cancellation');
const AdminNotificationTextDtoOutputLevelEnum
_$adminNotificationTextDtoOutputLevelEnum_silent =
    const AdminNotificationTextDtoOutputLevelEnum._('silent');

AdminNotificationTextDtoOutputLevelEnum
_$adminNotificationTextDtoOutputLevelEnumValueOf(String name) {
  switch (name) {
    case 'default_':
      return _$adminNotificationTextDtoOutputLevelEnum_default_;
    case 'ring':
      return _$adminNotificationTextDtoOutputLevelEnum_ring;
    case 'chime':
      return _$adminNotificationTextDtoOutputLevelEnum_chime;
    case 'offer':
      return _$adminNotificationTextDtoOutputLevelEnum_offer;
    case 'cancellation':
      return _$adminNotificationTextDtoOutputLevelEnum_cancellation;
    case 'silent':
      return _$adminNotificationTextDtoOutputLevelEnum_silent;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminNotificationTextDtoOutputLevelEnum>
_$adminNotificationTextDtoOutputLevelEnumValues =
    BuiltSet<AdminNotificationTextDtoOutputLevelEnum>(
      const <AdminNotificationTextDtoOutputLevelEnum>[
        _$adminNotificationTextDtoOutputLevelEnum_default_,
        _$adminNotificationTextDtoOutputLevelEnum_ring,
        _$adminNotificationTextDtoOutputLevelEnum_chime,
        _$adminNotificationTextDtoOutputLevelEnum_offer,
        _$adminNotificationTextDtoOutputLevelEnum_cancellation,
        _$adminNotificationTextDtoOutputLevelEnum_silent,
      ],
    );

const AdminNotificationTextDtoOutputPriorityEnum
_$adminNotificationTextDtoOutputPriorityEnum_high =
    const AdminNotificationTextDtoOutputPriorityEnum._('high');
const AdminNotificationTextDtoOutputPriorityEnum
_$adminNotificationTextDtoOutputPriorityEnum_normal =
    const AdminNotificationTextDtoOutputPriorityEnum._('normal');

AdminNotificationTextDtoOutputPriorityEnum
_$adminNotificationTextDtoOutputPriorityEnumValueOf(String name) {
  switch (name) {
    case 'high':
      return _$adminNotificationTextDtoOutputPriorityEnum_high;
    case 'normal':
      return _$adminNotificationTextDtoOutputPriorityEnum_normal;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminNotificationTextDtoOutputPriorityEnum>
_$adminNotificationTextDtoOutputPriorityEnumValues =
    BuiltSet<AdminNotificationTextDtoOutputPriorityEnum>(
      const <AdminNotificationTextDtoOutputPriorityEnum>[
        _$adminNotificationTextDtoOutputPriorityEnum_high,
        _$adminNotificationTextDtoOutputPriorityEnum_normal,
      ],
    );

Serializer<AdminNotificationTextDtoOutputAudienceEnum>
_$adminNotificationTextDtoOutputAudienceEnumSerializer =
    _$AdminNotificationTextDtoOutputAudienceEnumSerializer();
Serializer<AdminNotificationTextDtoOutputLevelEnum>
_$adminNotificationTextDtoOutputLevelEnumSerializer =
    _$AdminNotificationTextDtoOutputLevelEnumSerializer();
Serializer<AdminNotificationTextDtoOutputPriorityEnum>
_$adminNotificationTextDtoOutputPriorityEnumSerializer =
    _$AdminNotificationTextDtoOutputPriorityEnumSerializer();

class _$AdminNotificationTextDtoOutputAudienceEnumSerializer
    implements PrimitiveSerializer<AdminNotificationTextDtoOutputAudienceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'customer': 'customer',
    'merchant': 'merchant',
    'captain': 'captain',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'customer': 'customer',
    'merchant': 'merchant',
    'captain': 'captain',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminNotificationTextDtoOutputAudienceEnum,
  ];
  @override
  final String wireName = 'AdminNotificationTextDtoOutputAudienceEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminNotificationTextDtoOutputAudienceEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminNotificationTextDtoOutputAudienceEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminNotificationTextDtoOutputAudienceEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminNotificationTextDtoOutputLevelEnumSerializer
    implements PrimitiveSerializer<AdminNotificationTextDtoOutputLevelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'default_': 'default',
    'ring': 'ring',
    'chime': 'chime',
    'offer': 'offer',
    'cancellation': 'cancellation',
    'silent': 'silent',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'default': 'default_',
    'ring': 'ring',
    'chime': 'chime',
    'offer': 'offer',
    'cancellation': 'cancellation',
    'silent': 'silent',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminNotificationTextDtoOutputLevelEnum,
  ];
  @override
  final String wireName = 'AdminNotificationTextDtoOutputLevelEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminNotificationTextDtoOutputLevelEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminNotificationTextDtoOutputLevelEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminNotificationTextDtoOutputLevelEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminNotificationTextDtoOutputPriorityEnumSerializer
    implements PrimitiveSerializer<AdminNotificationTextDtoOutputPriorityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'high': 'high',
    'normal': 'normal',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'high': 'high',
    'normal': 'normal',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminNotificationTextDtoOutputPriorityEnum,
  ];
  @override
  final String wireName = 'AdminNotificationTextDtoOutputPriorityEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminNotificationTextDtoOutputPriorityEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminNotificationTextDtoOutputPriorityEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminNotificationTextDtoOutputPriorityEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminNotificationTextDtoOutput extends AdminNotificationTextDtoOutput {
  @override
  final String key;
  @override
  final AdminNotificationTextDtoOutputAudienceEnum audience;
  @override
  final String row;
  @override
  final BuiltList<String> variables;
  @override
  final AdminNotificationTextDtoOutputLevelEnum level;
  @override
  final AdminNotificationTextDtoOutputPriorityEnum priority;
  @override
  final String text;
  @override
  final String current;

  factory _$AdminNotificationTextDtoOutput([
    void Function(AdminNotificationTextDtoOutputBuilder)? updates,
  ]) => (AdminNotificationTextDtoOutputBuilder()..update(updates))._build();

  _$AdminNotificationTextDtoOutput._({
    required this.key,
    required this.audience,
    required this.row,
    required this.variables,
    required this.level,
    required this.priority,
    required this.text,
    required this.current,
  }) : super._();
  @override
  AdminNotificationTextDtoOutput rebuild(
    void Function(AdminNotificationTextDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminNotificationTextDtoOutputBuilder toBuilder() =>
      AdminNotificationTextDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminNotificationTextDtoOutput &&
        key == other.key &&
        audience == other.audience &&
        row == other.row &&
        variables == other.variables &&
        level == other.level &&
        priority == other.priority &&
        text == other.text &&
        current == other.current;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, audience.hashCode);
    _$hash = $jc(_$hash, row.hashCode);
    _$hash = $jc(_$hash, variables.hashCode);
    _$hash = $jc(_$hash, level.hashCode);
    _$hash = $jc(_$hash, priority.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, current.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminNotificationTextDtoOutput')
          ..add('key', key)
          ..add('audience', audience)
          ..add('row', row)
          ..add('variables', variables)
          ..add('level', level)
          ..add('priority', priority)
          ..add('text', text)
          ..add('current', current))
        .toString();
  }
}

class AdminNotificationTextDtoOutputBuilder
    implements
        Builder<
          AdminNotificationTextDtoOutput,
          AdminNotificationTextDtoOutputBuilder
        > {
  _$AdminNotificationTextDtoOutput? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  AdminNotificationTextDtoOutputAudienceEnum? _audience;
  AdminNotificationTextDtoOutputAudienceEnum? get audience => _$this._audience;
  set audience(AdminNotificationTextDtoOutputAudienceEnum? audience) =>
      _$this._audience = audience;

  String? _row;
  String? get row => _$this._row;
  set row(String? row) => _$this._row = row;

  ListBuilder<String>? _variables;
  ListBuilder<String> get variables =>
      _$this._variables ??= ListBuilder<String>();
  set variables(ListBuilder<String>? variables) =>
      _$this._variables = variables;

  AdminNotificationTextDtoOutputLevelEnum? _level;
  AdminNotificationTextDtoOutputLevelEnum? get level => _$this._level;
  set level(AdminNotificationTextDtoOutputLevelEnum? level) =>
      _$this._level = level;

  AdminNotificationTextDtoOutputPriorityEnum? _priority;
  AdminNotificationTextDtoOutputPriorityEnum? get priority => _$this._priority;
  set priority(AdminNotificationTextDtoOutputPriorityEnum? priority) =>
      _$this._priority = priority;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  String? _current;
  String? get current => _$this._current;
  set current(String? current) => _$this._current = current;

  AdminNotificationTextDtoOutputBuilder() {
    AdminNotificationTextDtoOutput._defaults(this);
  }

  AdminNotificationTextDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _audience = $v.audience;
      _row = $v.row;
      _variables = $v.variables.toBuilder();
      _level = $v.level;
      _priority = $v.priority;
      _text = $v.text;
      _current = $v.current;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminNotificationTextDtoOutput other) {
    _$v = other as _$AdminNotificationTextDtoOutput;
  }

  @override
  void update(void Function(AdminNotificationTextDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminNotificationTextDtoOutput build() => _build();

  _$AdminNotificationTextDtoOutput _build() {
    _$AdminNotificationTextDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminNotificationTextDtoOutput._(
            key: BuiltValueNullFieldError.checkNotNull(
              key,
              r'AdminNotificationTextDtoOutput',
              'key',
            ),
            audience: BuiltValueNullFieldError.checkNotNull(
              audience,
              r'AdminNotificationTextDtoOutput',
              'audience',
            ),
            row: BuiltValueNullFieldError.checkNotNull(
              row,
              r'AdminNotificationTextDtoOutput',
              'row',
            ),
            variables: variables.build(),
            level: BuiltValueNullFieldError.checkNotNull(
              level,
              r'AdminNotificationTextDtoOutput',
              'level',
            ),
            priority: BuiltValueNullFieldError.checkNotNull(
              priority,
              r'AdminNotificationTextDtoOutput',
              'priority',
            ),
            text: BuiltValueNullFieldError.checkNotNull(
              text,
              r'AdminNotificationTextDtoOutput',
              'text',
            ),
            current: BuiltValueNullFieldError.checkNotNull(
              current,
              r'AdminNotificationTextDtoOutput',
              'current',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'variables';
        variables.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminNotificationTextDtoOutput',
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
