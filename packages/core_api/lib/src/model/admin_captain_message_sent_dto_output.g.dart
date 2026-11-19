// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_message_sent_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCaptainMessageSentDtoOutputSentEnum
_$adminCaptainMessageSentDtoOutputSentEnum_true_ =
    const AdminCaptainMessageSentDtoOutputSentEnum._('true_');

AdminCaptainMessageSentDtoOutputSentEnum
_$adminCaptainMessageSentDtoOutputSentEnumValueOf(String name) {
  switch (name) {
    case 'true_':
      return _$adminCaptainMessageSentDtoOutputSentEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCaptainMessageSentDtoOutputSentEnum>
_$adminCaptainMessageSentDtoOutputSentEnumValues =
    BuiltSet<AdminCaptainMessageSentDtoOutputSentEnum>(
      const <AdminCaptainMessageSentDtoOutputSentEnum>[
        _$adminCaptainMessageSentDtoOutputSentEnum_true_,
      ],
    );

Serializer<AdminCaptainMessageSentDtoOutputSentEnum>
_$adminCaptainMessageSentDtoOutputSentEnumSerializer =
    _$AdminCaptainMessageSentDtoOutputSentEnumSerializer();

class _$AdminCaptainMessageSentDtoOutputSentEnumSerializer
    implements PrimitiveSerializer<AdminCaptainMessageSentDtoOutputSentEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminCaptainMessageSentDtoOutputSentEnum,
  ];
  @override
  final String wireName = 'AdminCaptainMessageSentDtoOutputSentEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainMessageSentDtoOutputSentEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCaptainMessageSentDtoOutputSentEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCaptainMessageSentDtoOutputSentEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCaptainMessageSentDtoOutput
    extends AdminCaptainMessageSentDtoOutput {
  @override
  final AdminCaptainMessageSentDtoOutputSentEnum sent;

  factory _$AdminCaptainMessageSentDtoOutput([
    void Function(AdminCaptainMessageSentDtoOutputBuilder)? updates,
  ]) => (AdminCaptainMessageSentDtoOutputBuilder()..update(updates))._build();

  _$AdminCaptainMessageSentDtoOutput._({required this.sent}) : super._();
  @override
  AdminCaptainMessageSentDtoOutput rebuild(
    void Function(AdminCaptainMessageSentDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainMessageSentDtoOutputBuilder toBuilder() =>
      AdminCaptainMessageSentDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainMessageSentDtoOutput && sent == other.sent;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sent.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminCaptainMessageSentDtoOutput',
    )..add('sent', sent)).toString();
  }
}

class AdminCaptainMessageSentDtoOutputBuilder
    implements
        Builder<
          AdminCaptainMessageSentDtoOutput,
          AdminCaptainMessageSentDtoOutputBuilder
        > {
  _$AdminCaptainMessageSentDtoOutput? _$v;

  AdminCaptainMessageSentDtoOutputSentEnum? _sent;
  AdminCaptainMessageSentDtoOutputSentEnum? get sent => _$this._sent;
  set sent(AdminCaptainMessageSentDtoOutputSentEnum? sent) =>
      _$this._sent = sent;

  AdminCaptainMessageSentDtoOutputBuilder() {
    AdminCaptainMessageSentDtoOutput._defaults(this);
  }

  AdminCaptainMessageSentDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sent = $v.sent;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainMessageSentDtoOutput other) {
    _$v = other as _$AdminCaptainMessageSentDtoOutput;
  }

  @override
  void update(void Function(AdminCaptainMessageSentDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainMessageSentDtoOutput build() => _build();

  _$AdminCaptainMessageSentDtoOutput _build() {
    final _$result =
        _$v ??
        _$AdminCaptainMessageSentDtoOutput._(
          sent: BuiltValueNullFieldError.checkNotNull(
            sent,
            r'AdminCaptainMessageSentDtoOutput',
            'sent',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
