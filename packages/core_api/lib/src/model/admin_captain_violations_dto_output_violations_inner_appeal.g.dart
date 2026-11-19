// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_violations_dto_output_violations_inner_appeal.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum
_$adminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum_accepted =
    const AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum._(
      'accepted',
    );
const AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum
_$adminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum_rejected =
    const AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum._(
      'rejected',
    );

AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum
_$adminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnumValueOf(
  String name,
) {
  switch (name) {
    case 'accepted':
      return _$adminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum_accepted;
    case 'rejected':
      return _$adminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum_rejected;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum>
_$adminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnumValues =
    BuiltSet<
      AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum
    >(const <AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum>[
      _$adminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum_accepted,
      _$adminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum_rejected,
    ]);

Serializer<AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum>
_$adminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnumSerializer =
    _$AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnumSerializer();

class _$AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnumSerializer
    implements
        PrimitiveSerializer<
          AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'accepted': 'accepted',
    'rejected': 'rejected',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'accepted': 'accepted',
    'rejected': 'rejected',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum,
  ];
  @override
  final String wireName =
      'AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCaptainViolationsDtoOutputViolationsInnerAppeal
    extends AdminCaptainViolationsDtoOutputViolationsInnerAppeal {
  @override
  final String ticketId;
  @override
  final DateTime at;
  @override
  final AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum?
  outcome;
  @override
  final DateTime? decidedAt;

  factory _$AdminCaptainViolationsDtoOutputViolationsInnerAppeal([
    void Function(AdminCaptainViolationsDtoOutputViolationsInnerAppealBuilder)?
    updates,
  ]) =>
      (AdminCaptainViolationsDtoOutputViolationsInnerAppealBuilder()
            ..update(updates))
          ._build();

  _$AdminCaptainViolationsDtoOutputViolationsInnerAppeal._({
    required this.ticketId,
    required this.at,
    this.outcome,
    this.decidedAt,
  }) : super._();
  @override
  AdminCaptainViolationsDtoOutputViolationsInnerAppeal rebuild(
    void Function(AdminCaptainViolationsDtoOutputViolationsInnerAppealBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainViolationsDtoOutputViolationsInnerAppealBuilder toBuilder() =>
      AdminCaptainViolationsDtoOutputViolationsInnerAppealBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainViolationsDtoOutputViolationsInnerAppeal &&
        ticketId == other.ticketId &&
        at == other.at &&
        outcome == other.outcome &&
        decidedAt == other.decidedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ticketId.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, outcome.hashCode);
    _$hash = $jc(_$hash, decidedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCaptainViolationsDtoOutputViolationsInnerAppeal',
          )
          ..add('ticketId', ticketId)
          ..add('at', at)
          ..add('outcome', outcome)
          ..add('decidedAt', decidedAt))
        .toString();
  }
}

class AdminCaptainViolationsDtoOutputViolationsInnerAppealBuilder
    implements
        Builder<
          AdminCaptainViolationsDtoOutputViolationsInnerAppeal,
          AdminCaptainViolationsDtoOutputViolationsInnerAppealBuilder
        > {
  _$AdminCaptainViolationsDtoOutputViolationsInnerAppeal? _$v;

  String? _ticketId;
  String? get ticketId => _$this._ticketId;
  set ticketId(String? ticketId) => _$this._ticketId = ticketId;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum? _outcome;
  AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum?
  get outcome => _$this._outcome;
  set outcome(
    AdminCaptainViolationsDtoOutputViolationsInnerAppealOutcomeEnum? outcome,
  ) => _$this._outcome = outcome;

  DateTime? _decidedAt;
  DateTime? get decidedAt => _$this._decidedAt;
  set decidedAt(DateTime? decidedAt) => _$this._decidedAt = decidedAt;

  AdminCaptainViolationsDtoOutputViolationsInnerAppealBuilder() {
    AdminCaptainViolationsDtoOutputViolationsInnerAppeal._defaults(this);
  }

  AdminCaptainViolationsDtoOutputViolationsInnerAppealBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ticketId = $v.ticketId;
      _at = $v.at;
      _outcome = $v.outcome;
      _decidedAt = $v.decidedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainViolationsDtoOutputViolationsInnerAppeal other) {
    _$v = other as _$AdminCaptainViolationsDtoOutputViolationsInnerAppeal;
  }

  @override
  void update(
    void Function(AdminCaptainViolationsDtoOutputViolationsInnerAppealBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainViolationsDtoOutputViolationsInnerAppeal build() => _build();

  _$AdminCaptainViolationsDtoOutputViolationsInnerAppeal _build() {
    final _$result =
        _$v ??
        _$AdminCaptainViolationsDtoOutputViolationsInnerAppeal._(
          ticketId: BuiltValueNullFieldError.checkNotNull(
            ticketId,
            r'AdminCaptainViolationsDtoOutputViolationsInnerAppeal',
            'ticketId',
          ),
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'AdminCaptainViolationsDtoOutputViolationsInnerAppeal',
            'at',
          ),
          outcome: outcome,
          decidedAt: decidedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
