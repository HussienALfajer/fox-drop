// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'done_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DoneDtoOutputStatusEnum _$doneDtoOutputStatusEnum_done =
    const DoneDtoOutputStatusEnum._('done');

DoneDtoOutputStatusEnum _$doneDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'done':
      return _$doneDtoOutputStatusEnum_done;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DoneDtoOutputStatusEnum> _$doneDtoOutputStatusEnumValues =
    BuiltSet<DoneDtoOutputStatusEnum>(const <DoneDtoOutputStatusEnum>[
      _$doneDtoOutputStatusEnum_done,
    ]);

Serializer<DoneDtoOutputStatusEnum> _$doneDtoOutputStatusEnumSerializer =
    _$DoneDtoOutputStatusEnumSerializer();

class _$DoneDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<DoneDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'done': 'done',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'done': 'done',
  };

  @override
  final Iterable<Type> types = const <Type>[DoneDtoOutputStatusEnum];
  @override
  final String wireName = 'DoneDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    DoneDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  DoneDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => DoneDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$DoneDtoOutput extends DoneDtoOutput {
  @override
  final DoneDtoOutputStatusEnum status;

  factory _$DoneDtoOutput([void Function(DoneDtoOutputBuilder)? updates]) =>
      (DoneDtoOutputBuilder()..update(updates))._build();

  _$DoneDtoOutput._({required this.status}) : super._();
  @override
  DoneDtoOutput rebuild(void Function(DoneDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DoneDtoOutputBuilder toBuilder() => DoneDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DoneDtoOutput && status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'DoneDtoOutput',
    )..add('status', status)).toString();
  }
}

class DoneDtoOutputBuilder
    implements Builder<DoneDtoOutput, DoneDtoOutputBuilder> {
  _$DoneDtoOutput? _$v;

  DoneDtoOutputStatusEnum? _status;
  DoneDtoOutputStatusEnum? get status => _$this._status;
  set status(DoneDtoOutputStatusEnum? status) => _$this._status = status;

  DoneDtoOutputBuilder() {
    DoneDtoOutput._defaults(this);
  }

  DoneDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DoneDtoOutput other) {
    _$v = other as _$DoneDtoOutput;
  }

  @override
  void update(void Function(DoneDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DoneDtoOutput build() => _build();

  _$DoneDtoOutput _build() {
    final _$result =
        _$v ??
        _$DoneDtoOutput._(
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'DoneDtoOutput',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
