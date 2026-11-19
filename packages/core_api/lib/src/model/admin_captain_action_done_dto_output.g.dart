// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_action_done_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCaptainActionDoneDtoOutputDoneEnum
_$adminCaptainActionDoneDtoOutputDoneEnum_true_ =
    const AdminCaptainActionDoneDtoOutputDoneEnum._('true_');

AdminCaptainActionDoneDtoOutputDoneEnum
_$adminCaptainActionDoneDtoOutputDoneEnumValueOf(String name) {
  switch (name) {
    case 'true_':
      return _$adminCaptainActionDoneDtoOutputDoneEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCaptainActionDoneDtoOutputDoneEnum>
_$adminCaptainActionDoneDtoOutputDoneEnumValues =
    BuiltSet<AdminCaptainActionDoneDtoOutputDoneEnum>(
      const <AdminCaptainActionDoneDtoOutputDoneEnum>[
        _$adminCaptainActionDoneDtoOutputDoneEnum_true_,
      ],
    );

Serializer<AdminCaptainActionDoneDtoOutputDoneEnum>
_$adminCaptainActionDoneDtoOutputDoneEnumSerializer =
    _$AdminCaptainActionDoneDtoOutputDoneEnumSerializer();

class _$AdminCaptainActionDoneDtoOutputDoneEnumSerializer
    implements PrimitiveSerializer<AdminCaptainActionDoneDtoOutputDoneEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminCaptainActionDoneDtoOutputDoneEnum,
  ];
  @override
  final String wireName = 'AdminCaptainActionDoneDtoOutputDoneEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainActionDoneDtoOutputDoneEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCaptainActionDoneDtoOutputDoneEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCaptainActionDoneDtoOutputDoneEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCaptainActionDoneDtoOutput
    extends AdminCaptainActionDoneDtoOutput {
  @override
  final AdminCaptainActionDoneDtoOutputDoneEnum done;

  factory _$AdminCaptainActionDoneDtoOutput([
    void Function(AdminCaptainActionDoneDtoOutputBuilder)? updates,
  ]) => (AdminCaptainActionDoneDtoOutputBuilder()..update(updates))._build();

  _$AdminCaptainActionDoneDtoOutput._({required this.done}) : super._();
  @override
  AdminCaptainActionDoneDtoOutput rebuild(
    void Function(AdminCaptainActionDoneDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainActionDoneDtoOutputBuilder toBuilder() =>
      AdminCaptainActionDoneDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainActionDoneDtoOutput && done == other.done;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, done.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminCaptainActionDoneDtoOutput',
    )..add('done', done)).toString();
  }
}

class AdminCaptainActionDoneDtoOutputBuilder
    implements
        Builder<
          AdminCaptainActionDoneDtoOutput,
          AdminCaptainActionDoneDtoOutputBuilder
        > {
  _$AdminCaptainActionDoneDtoOutput? _$v;

  AdminCaptainActionDoneDtoOutputDoneEnum? _done;
  AdminCaptainActionDoneDtoOutputDoneEnum? get done => _$this._done;
  set done(AdminCaptainActionDoneDtoOutputDoneEnum? done) =>
      _$this._done = done;

  AdminCaptainActionDoneDtoOutputBuilder() {
    AdminCaptainActionDoneDtoOutput._defaults(this);
  }

  AdminCaptainActionDoneDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _done = $v.done;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainActionDoneDtoOutput other) {
    _$v = other as _$AdminCaptainActionDoneDtoOutput;
  }

  @override
  void update(void Function(AdminCaptainActionDoneDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainActionDoneDtoOutput build() => _build();

  _$AdminCaptainActionDoneDtoOutput _build() {
    final _$result =
        _$v ??
        _$AdminCaptainActionDoneDtoOutput._(
          done: BuiltValueNullFieldError.checkNotNull(
            done,
            r'AdminCaptainActionDoneDtoOutput',
            'done',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
