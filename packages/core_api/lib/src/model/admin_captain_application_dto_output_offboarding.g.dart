// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_application_dto_output_offboarding.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum
_$adminCaptainApplicationDtoOutputOffboardingDepositSettledEnum_refunded =
    const AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum._(
      'refunded',
    );
const AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum
_$adminCaptainApplicationDtoOutputOffboardingDepositSettledEnum_withheld =
    const AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum._(
      'withheld',
    );

AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum
_$adminCaptainApplicationDtoOutputOffboardingDepositSettledEnumValueOf(
  String name,
) {
  switch (name) {
    case 'refunded':
      return _$adminCaptainApplicationDtoOutputOffboardingDepositSettledEnum_refunded;
    case 'withheld':
      return _$adminCaptainApplicationDtoOutputOffboardingDepositSettledEnum_withheld;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum>
_$adminCaptainApplicationDtoOutputOffboardingDepositSettledEnumValues =
    BuiltSet<
      AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum
    >(const <AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum>[
      _$adminCaptainApplicationDtoOutputOffboardingDepositSettledEnum_refunded,
      _$adminCaptainApplicationDtoOutputOffboardingDepositSettledEnum_withheld,
    ]);

const AdminCaptainApplicationDtoOutputOffboardingMissingEnum
_$adminCaptainApplicationDtoOutputOffboardingMissingEnum_kit =
    const AdminCaptainApplicationDtoOutputOffboardingMissingEnum._('kit');
const AdminCaptainApplicationDtoOutputOffboardingMissingEnum
_$adminCaptainApplicationDtoOutputOffboardingMissingEnum_custody =
    const AdminCaptainApplicationDtoOutputOffboardingMissingEnum._('custody');
const AdminCaptainApplicationDtoOutputOffboardingMissingEnum
_$adminCaptainApplicationDtoOutputOffboardingMissingEnum_earnings =
    const AdminCaptainApplicationDtoOutputOffboardingMissingEnum._('earnings');
const AdminCaptainApplicationDtoOutputOffboardingMissingEnum
_$adminCaptainApplicationDtoOutputOffboardingMissingEnum_deposit =
    const AdminCaptainApplicationDtoOutputOffboardingMissingEnum._('deposit');

AdminCaptainApplicationDtoOutputOffboardingMissingEnum
_$adminCaptainApplicationDtoOutputOffboardingMissingEnumValueOf(String name) {
  switch (name) {
    case 'kit':
      return _$adminCaptainApplicationDtoOutputOffboardingMissingEnum_kit;
    case 'custody':
      return _$adminCaptainApplicationDtoOutputOffboardingMissingEnum_custody;
    case 'earnings':
      return _$adminCaptainApplicationDtoOutputOffboardingMissingEnum_earnings;
    case 'deposit':
      return _$adminCaptainApplicationDtoOutputOffboardingMissingEnum_deposit;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCaptainApplicationDtoOutputOffboardingMissingEnum>
_$adminCaptainApplicationDtoOutputOffboardingMissingEnumValues =
    BuiltSet<AdminCaptainApplicationDtoOutputOffboardingMissingEnum>(
      const <AdminCaptainApplicationDtoOutputOffboardingMissingEnum>[
        _$adminCaptainApplicationDtoOutputOffboardingMissingEnum_kit,
        _$adminCaptainApplicationDtoOutputOffboardingMissingEnum_custody,
        _$adminCaptainApplicationDtoOutputOffboardingMissingEnum_earnings,
        _$adminCaptainApplicationDtoOutputOffboardingMissingEnum_deposit,
      ],
    );

Serializer<AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum>
_$adminCaptainApplicationDtoOutputOffboardingDepositSettledEnumSerializer =
    _$AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnumSerializer();
Serializer<AdminCaptainApplicationDtoOutputOffboardingMissingEnum>
_$adminCaptainApplicationDtoOutputOffboardingMissingEnumSerializer =
    _$AdminCaptainApplicationDtoOutputOffboardingMissingEnumSerializer();

class _$AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnumSerializer
    implements
        PrimitiveSerializer<
          AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'refunded': 'refunded',
    'withheld': 'withheld',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'refunded': 'refunded',
    'withheld': 'withheld',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum,
  ];
  @override
  final String wireName =
      'AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCaptainApplicationDtoOutputOffboardingMissingEnumSerializer
    implements
        PrimitiveSerializer<
          AdminCaptainApplicationDtoOutputOffboardingMissingEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'kit': 'kit',
    'custody': 'custody',
    'earnings': 'earnings',
    'deposit': 'deposit',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'kit': 'kit',
    'custody': 'custody',
    'earnings': 'earnings',
    'deposit': 'deposit',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminCaptainApplicationDtoOutputOffboardingMissingEnum,
  ];
  @override
  final String wireName =
      'AdminCaptainApplicationDtoOutputOffboardingMissingEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputOffboardingMissingEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCaptainApplicationDtoOutputOffboardingMissingEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCaptainApplicationDtoOutputOffboardingMissingEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCaptainApplicationDtoOutputOffboarding
    extends AdminCaptainApplicationDtoOutputOffboarding {
  @override
  final DateTime terminatedAt;
  @override
  final String? terminatedBy;
  @override
  final String reason;
  @override
  final bool earlyExit;
  @override
  final bool? kitReturned;
  @override
  final bool custodyZero;
  @override
  final bool earningsZero;
  @override
  final String depositHeld;
  @override
  final AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum?
  depositSettled;
  @override
  final BuiltList<AdminCaptainApplicationDtoOutputOffboardingMissingEnum>
  missing;
  @override
  final DateTime? endedAt;

  factory _$AdminCaptainApplicationDtoOutputOffboarding([
    void Function(AdminCaptainApplicationDtoOutputOffboardingBuilder)? updates,
  ]) => (AdminCaptainApplicationDtoOutputOffboardingBuilder()..update(updates))
      ._build();

  _$AdminCaptainApplicationDtoOutputOffboarding._({
    required this.terminatedAt,
    this.terminatedBy,
    required this.reason,
    required this.earlyExit,
    this.kitReturned,
    required this.custodyZero,
    required this.earningsZero,
    required this.depositHeld,
    this.depositSettled,
    required this.missing,
    this.endedAt,
  }) : super._();
  @override
  AdminCaptainApplicationDtoOutputOffboarding rebuild(
    void Function(AdminCaptainApplicationDtoOutputOffboardingBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainApplicationDtoOutputOffboardingBuilder toBuilder() =>
      AdminCaptainApplicationDtoOutputOffboardingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainApplicationDtoOutputOffboarding &&
        terminatedAt == other.terminatedAt &&
        terminatedBy == other.terminatedBy &&
        reason == other.reason &&
        earlyExit == other.earlyExit &&
        kitReturned == other.kitReturned &&
        custodyZero == other.custodyZero &&
        earningsZero == other.earningsZero &&
        depositHeld == other.depositHeld &&
        depositSettled == other.depositSettled &&
        missing == other.missing &&
        endedAt == other.endedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, terminatedAt.hashCode);
    _$hash = $jc(_$hash, terminatedBy.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, earlyExit.hashCode);
    _$hash = $jc(_$hash, kitReturned.hashCode);
    _$hash = $jc(_$hash, custodyZero.hashCode);
    _$hash = $jc(_$hash, earningsZero.hashCode);
    _$hash = $jc(_$hash, depositHeld.hashCode);
    _$hash = $jc(_$hash, depositSettled.hashCode);
    _$hash = $jc(_$hash, missing.hashCode);
    _$hash = $jc(_$hash, endedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCaptainApplicationDtoOutputOffboarding',
          )
          ..add('terminatedAt', terminatedAt)
          ..add('terminatedBy', terminatedBy)
          ..add('reason', reason)
          ..add('earlyExit', earlyExit)
          ..add('kitReturned', kitReturned)
          ..add('custodyZero', custodyZero)
          ..add('earningsZero', earningsZero)
          ..add('depositHeld', depositHeld)
          ..add('depositSettled', depositSettled)
          ..add('missing', missing)
          ..add('endedAt', endedAt))
        .toString();
  }
}

class AdminCaptainApplicationDtoOutputOffboardingBuilder
    implements
        Builder<
          AdminCaptainApplicationDtoOutputOffboarding,
          AdminCaptainApplicationDtoOutputOffboardingBuilder
        > {
  _$AdminCaptainApplicationDtoOutputOffboarding? _$v;

  DateTime? _terminatedAt;
  DateTime? get terminatedAt => _$this._terminatedAt;
  set terminatedAt(DateTime? terminatedAt) =>
      _$this._terminatedAt = terminatedAt;

  String? _terminatedBy;
  String? get terminatedBy => _$this._terminatedBy;
  set terminatedBy(String? terminatedBy) => _$this._terminatedBy = terminatedBy;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  bool? _earlyExit;
  bool? get earlyExit => _$this._earlyExit;
  set earlyExit(bool? earlyExit) => _$this._earlyExit = earlyExit;

  bool? _kitReturned;
  bool? get kitReturned => _$this._kitReturned;
  set kitReturned(bool? kitReturned) => _$this._kitReturned = kitReturned;

  bool? _custodyZero;
  bool? get custodyZero => _$this._custodyZero;
  set custodyZero(bool? custodyZero) => _$this._custodyZero = custodyZero;

  bool? _earningsZero;
  bool? get earningsZero => _$this._earningsZero;
  set earningsZero(bool? earningsZero) => _$this._earningsZero = earningsZero;

  String? _depositHeld;
  String? get depositHeld => _$this._depositHeld;
  set depositHeld(String? depositHeld) => _$this._depositHeld = depositHeld;

  AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum?
  _depositSettled;
  AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum?
  get depositSettled => _$this._depositSettled;
  set depositSettled(
    AdminCaptainApplicationDtoOutputOffboardingDepositSettledEnum?
    depositSettled,
  ) => _$this._depositSettled = depositSettled;

  ListBuilder<AdminCaptainApplicationDtoOutputOffboardingMissingEnum>? _missing;
  ListBuilder<AdminCaptainApplicationDtoOutputOffboardingMissingEnum>
  get missing => _$this._missing ??=
      ListBuilder<AdminCaptainApplicationDtoOutputOffboardingMissingEnum>();
  set missing(
    ListBuilder<AdminCaptainApplicationDtoOutputOffboardingMissingEnum>?
    missing,
  ) => _$this._missing = missing;

  DateTime? _endedAt;
  DateTime? get endedAt => _$this._endedAt;
  set endedAt(DateTime? endedAt) => _$this._endedAt = endedAt;

  AdminCaptainApplicationDtoOutputOffboardingBuilder() {
    AdminCaptainApplicationDtoOutputOffboarding._defaults(this);
  }

  AdminCaptainApplicationDtoOutputOffboardingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _terminatedAt = $v.terminatedAt;
      _terminatedBy = $v.terminatedBy;
      _reason = $v.reason;
      _earlyExit = $v.earlyExit;
      _kitReturned = $v.kitReturned;
      _custodyZero = $v.custodyZero;
      _earningsZero = $v.earningsZero;
      _depositHeld = $v.depositHeld;
      _depositSettled = $v.depositSettled;
      _missing = $v.missing.toBuilder();
      _endedAt = $v.endedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainApplicationDtoOutputOffboarding other) {
    _$v = other as _$AdminCaptainApplicationDtoOutputOffboarding;
  }

  @override
  void update(
    void Function(AdminCaptainApplicationDtoOutputOffboardingBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainApplicationDtoOutputOffboarding build() => _build();

  _$AdminCaptainApplicationDtoOutputOffboarding _build() {
    _$AdminCaptainApplicationDtoOutputOffboarding _$result;
    try {
      _$result =
          _$v ??
          _$AdminCaptainApplicationDtoOutputOffboarding._(
            terminatedAt: BuiltValueNullFieldError.checkNotNull(
              terminatedAt,
              r'AdminCaptainApplicationDtoOutputOffboarding',
              'terminatedAt',
            ),
            terminatedBy: terminatedBy,
            reason: BuiltValueNullFieldError.checkNotNull(
              reason,
              r'AdminCaptainApplicationDtoOutputOffboarding',
              'reason',
            ),
            earlyExit: BuiltValueNullFieldError.checkNotNull(
              earlyExit,
              r'AdminCaptainApplicationDtoOutputOffboarding',
              'earlyExit',
            ),
            kitReturned: kitReturned,
            custodyZero: BuiltValueNullFieldError.checkNotNull(
              custodyZero,
              r'AdminCaptainApplicationDtoOutputOffboarding',
              'custodyZero',
            ),
            earningsZero: BuiltValueNullFieldError.checkNotNull(
              earningsZero,
              r'AdminCaptainApplicationDtoOutputOffboarding',
              'earningsZero',
            ),
            depositHeld: BuiltValueNullFieldError.checkNotNull(
              depositHeld,
              r'AdminCaptainApplicationDtoOutputOffboarding',
              'depositHeld',
            ),
            depositSettled: depositSettled,
            missing: missing.build(),
            endedAt: endedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'missing';
        missing.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCaptainApplicationDtoOutputOffboarding',
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
