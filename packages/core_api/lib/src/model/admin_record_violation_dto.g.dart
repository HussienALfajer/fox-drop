// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_record_violation_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminRecordViolationDtoStepEnum
_$adminRecordViolationDtoStepEnum_warning =
    const AdminRecordViolationDtoStepEnum._('warning');
const AdminRecordViolationDtoStepEnum
_$adminRecordViolationDtoStepEnum_suspension1d =
    const AdminRecordViolationDtoStepEnum._('suspension1d');
const AdminRecordViolationDtoStepEnum
_$adminRecordViolationDtoStepEnum_suspension7d =
    const AdminRecordViolationDtoStepEnum._('suspension7d');
const AdminRecordViolationDtoStepEnum
_$adminRecordViolationDtoStepEnum_termination =
    const AdminRecordViolationDtoStepEnum._('termination');

AdminRecordViolationDtoStepEnum _$adminRecordViolationDtoStepEnumValueOf(
  String name,
) {
  switch (name) {
    case 'warning':
      return _$adminRecordViolationDtoStepEnum_warning;
    case 'suspension1d':
      return _$adminRecordViolationDtoStepEnum_suspension1d;
    case 'suspension7d':
      return _$adminRecordViolationDtoStepEnum_suspension7d;
    case 'termination':
      return _$adminRecordViolationDtoStepEnum_termination;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRecordViolationDtoStepEnum>
_$adminRecordViolationDtoStepEnumValues =
    BuiltSet<AdminRecordViolationDtoStepEnum>(
      const <AdminRecordViolationDtoStepEnum>[
        _$adminRecordViolationDtoStepEnum_warning,
        _$adminRecordViolationDtoStepEnum_suspension1d,
        _$adminRecordViolationDtoStepEnum_suspension7d,
        _$adminRecordViolationDtoStepEnum_termination,
      ],
    );

Serializer<AdminRecordViolationDtoStepEnum>
_$adminRecordViolationDtoStepEnumSerializer =
    _$AdminRecordViolationDtoStepEnumSerializer();

class _$AdminRecordViolationDtoStepEnumSerializer
    implements PrimitiveSerializer<AdminRecordViolationDtoStepEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'warning': 'warning',
    'suspension1d': 'suspension_1d',
    'suspension7d': 'suspension_7d',
    'termination': 'termination',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'warning': 'warning',
    'suspension_1d': 'suspension1d',
    'suspension_7d': 'suspension7d',
    'termination': 'termination',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminRecordViolationDtoStepEnum];
  @override
  final String wireName = 'AdminRecordViolationDtoStepEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminRecordViolationDtoStepEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminRecordViolationDtoStepEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminRecordViolationDtoStepEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminRecordViolationDto extends AdminRecordViolationDto {
  @override
  final bool severe;
  @override
  final String typeCode;
  @override
  final String? typeNote;
  @override
  final AdminRecordViolationDtoStepEnum step;
  @override
  final String? orderId;
  @override
  final String reason;

  factory _$AdminRecordViolationDto([
    void Function(AdminRecordViolationDtoBuilder)? updates,
  ]) => (AdminRecordViolationDtoBuilder()..update(updates))._build();

  _$AdminRecordViolationDto._({
    required this.severe,
    required this.typeCode,
    this.typeNote,
    required this.step,
    this.orderId,
    required this.reason,
  }) : super._();
  @override
  AdminRecordViolationDto rebuild(
    void Function(AdminRecordViolationDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRecordViolationDtoBuilder toBuilder() =>
      AdminRecordViolationDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRecordViolationDto &&
        severe == other.severe &&
        typeCode == other.typeCode &&
        typeNote == other.typeNote &&
        step == other.step &&
        orderId == other.orderId &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, severe.hashCode);
    _$hash = $jc(_$hash, typeCode.hashCode);
    _$hash = $jc(_$hash, typeNote.hashCode);
    _$hash = $jc(_$hash, step.hashCode);
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRecordViolationDto')
          ..add('severe', severe)
          ..add('typeCode', typeCode)
          ..add('typeNote', typeNote)
          ..add('step', step)
          ..add('orderId', orderId)
          ..add('reason', reason))
        .toString();
  }
}

class AdminRecordViolationDtoBuilder
    implements
        Builder<AdminRecordViolationDto, AdminRecordViolationDtoBuilder> {
  _$AdminRecordViolationDto? _$v;

  bool? _severe;
  bool? get severe => _$this._severe;
  set severe(bool? severe) => _$this._severe = severe;

  String? _typeCode;
  String? get typeCode => _$this._typeCode;
  set typeCode(String? typeCode) => _$this._typeCode = typeCode;

  String? _typeNote;
  String? get typeNote => _$this._typeNote;
  set typeNote(String? typeNote) => _$this._typeNote = typeNote;

  AdminRecordViolationDtoStepEnum? _step;
  AdminRecordViolationDtoStepEnum? get step => _$this._step;
  set step(AdminRecordViolationDtoStepEnum? step) => _$this._step = step;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminRecordViolationDtoBuilder() {
    AdminRecordViolationDto._defaults(this);
  }

  AdminRecordViolationDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _severe = $v.severe;
      _typeCode = $v.typeCode;
      _typeNote = $v.typeNote;
      _step = $v.step;
      _orderId = $v.orderId;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRecordViolationDto other) {
    _$v = other as _$AdminRecordViolationDto;
  }

  @override
  void update(void Function(AdminRecordViolationDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRecordViolationDto build() => _build();

  _$AdminRecordViolationDto _build() {
    final _$result =
        _$v ??
        _$AdminRecordViolationDto._(
          severe: BuiltValueNullFieldError.checkNotNull(
            severe,
            r'AdminRecordViolationDto',
            'severe',
          ),
          typeCode: BuiltValueNullFieldError.checkNotNull(
            typeCode,
            r'AdminRecordViolationDto',
            'typeCode',
          ),
          typeNote: typeNote,
          step: BuiltValueNullFieldError.checkNotNull(
            step,
            r'AdminRecordViolationDto',
            'step',
          ),
          orderId: orderId,
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminRecordViolationDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
