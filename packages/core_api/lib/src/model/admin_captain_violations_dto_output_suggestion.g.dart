// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_violations_dto_output_suggestion.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCaptainViolationsDtoOutputSuggestionStepEnum
_$adminCaptainViolationsDtoOutputSuggestionStepEnum_warning =
    const AdminCaptainViolationsDtoOutputSuggestionStepEnum._('warning');
const AdminCaptainViolationsDtoOutputSuggestionStepEnum
_$adminCaptainViolationsDtoOutputSuggestionStepEnum_suspension1d =
    const AdminCaptainViolationsDtoOutputSuggestionStepEnum._('suspension1d');
const AdminCaptainViolationsDtoOutputSuggestionStepEnum
_$adminCaptainViolationsDtoOutputSuggestionStepEnum_suspension7d =
    const AdminCaptainViolationsDtoOutputSuggestionStepEnum._('suspension7d');
const AdminCaptainViolationsDtoOutputSuggestionStepEnum
_$adminCaptainViolationsDtoOutputSuggestionStepEnum_termination =
    const AdminCaptainViolationsDtoOutputSuggestionStepEnum._('termination');

AdminCaptainViolationsDtoOutputSuggestionStepEnum
_$adminCaptainViolationsDtoOutputSuggestionStepEnumValueOf(String name) {
  switch (name) {
    case 'warning':
      return _$adminCaptainViolationsDtoOutputSuggestionStepEnum_warning;
    case 'suspension1d':
      return _$adminCaptainViolationsDtoOutputSuggestionStepEnum_suspension1d;
    case 'suspension7d':
      return _$adminCaptainViolationsDtoOutputSuggestionStepEnum_suspension7d;
    case 'termination':
      return _$adminCaptainViolationsDtoOutputSuggestionStepEnum_termination;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCaptainViolationsDtoOutputSuggestionStepEnum>
_$adminCaptainViolationsDtoOutputSuggestionStepEnumValues =
    BuiltSet<AdminCaptainViolationsDtoOutputSuggestionStepEnum>(
      const <AdminCaptainViolationsDtoOutputSuggestionStepEnum>[
        _$adminCaptainViolationsDtoOutputSuggestionStepEnum_warning,
        _$adminCaptainViolationsDtoOutputSuggestionStepEnum_suspension1d,
        _$adminCaptainViolationsDtoOutputSuggestionStepEnum_suspension7d,
        _$adminCaptainViolationsDtoOutputSuggestionStepEnum_termination,
      ],
    );

Serializer<AdminCaptainViolationsDtoOutputSuggestionStepEnum>
_$adminCaptainViolationsDtoOutputSuggestionStepEnumSerializer =
    _$AdminCaptainViolationsDtoOutputSuggestionStepEnumSerializer();

class _$AdminCaptainViolationsDtoOutputSuggestionStepEnumSerializer
    implements
        PrimitiveSerializer<AdminCaptainViolationsDtoOutputSuggestionStepEnum> {
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
  final Iterable<Type> types = const <Type>[
    AdminCaptainViolationsDtoOutputSuggestionStepEnum,
  ];
  @override
  final String wireName = 'AdminCaptainViolationsDtoOutputSuggestionStepEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainViolationsDtoOutputSuggestionStepEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCaptainViolationsDtoOutputSuggestionStepEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCaptainViolationsDtoOutputSuggestionStepEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCaptainViolationsDtoOutputSuggestion
    extends AdminCaptainViolationsDtoOutputSuggestion {
  @override
  final AdminCaptainViolationsDtoOutputSuggestionStepEnum step;
  @override
  final int windowDays;

  factory _$AdminCaptainViolationsDtoOutputSuggestion([
    void Function(AdminCaptainViolationsDtoOutputSuggestionBuilder)? updates,
  ]) => (AdminCaptainViolationsDtoOutputSuggestionBuilder()..update(updates))
      ._build();

  _$AdminCaptainViolationsDtoOutputSuggestion._({
    required this.step,
    required this.windowDays,
  }) : super._();
  @override
  AdminCaptainViolationsDtoOutputSuggestion rebuild(
    void Function(AdminCaptainViolationsDtoOutputSuggestionBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainViolationsDtoOutputSuggestionBuilder toBuilder() =>
      AdminCaptainViolationsDtoOutputSuggestionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainViolationsDtoOutputSuggestion &&
        step == other.step &&
        windowDays == other.windowDays;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, step.hashCode);
    _$hash = $jc(_$hash, windowDays.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCaptainViolationsDtoOutputSuggestion',
          )
          ..add('step', step)
          ..add('windowDays', windowDays))
        .toString();
  }
}

class AdminCaptainViolationsDtoOutputSuggestionBuilder
    implements
        Builder<
          AdminCaptainViolationsDtoOutputSuggestion,
          AdminCaptainViolationsDtoOutputSuggestionBuilder
        > {
  _$AdminCaptainViolationsDtoOutputSuggestion? _$v;

  AdminCaptainViolationsDtoOutputSuggestionStepEnum? _step;
  AdminCaptainViolationsDtoOutputSuggestionStepEnum? get step => _$this._step;
  set step(AdminCaptainViolationsDtoOutputSuggestionStepEnum? step) =>
      _$this._step = step;

  int? _windowDays;
  int? get windowDays => _$this._windowDays;
  set windowDays(int? windowDays) => _$this._windowDays = windowDays;

  AdminCaptainViolationsDtoOutputSuggestionBuilder() {
    AdminCaptainViolationsDtoOutputSuggestion._defaults(this);
  }

  AdminCaptainViolationsDtoOutputSuggestionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _step = $v.step;
      _windowDays = $v.windowDays;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainViolationsDtoOutputSuggestion other) {
    _$v = other as _$AdminCaptainViolationsDtoOutputSuggestion;
  }

  @override
  void update(
    void Function(AdminCaptainViolationsDtoOutputSuggestionBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainViolationsDtoOutputSuggestion build() => _build();

  _$AdminCaptainViolationsDtoOutputSuggestion _build() {
    final _$result =
        _$v ??
        _$AdminCaptainViolationsDtoOutputSuggestion._(
          step: BuiltValueNullFieldError.checkNotNull(
            step,
            r'AdminCaptainViolationsDtoOutputSuggestion',
            'step',
          ),
          windowDays: BuiltValueNullFieldError.checkNotNull(
            windowDays,
            r'AdminCaptainViolationsDtoOutputSuggestion',
            'windowDays',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
