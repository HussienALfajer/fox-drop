// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_application_dto_output_application_history_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum
_$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_draft =
    const CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum._(
      'draft',
    );
const CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum
_$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_new_ =
    const CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum._('new_');
const CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum
_$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_underReview =
    const CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum._(
      'underReview',
    );
const CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum
_$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_interview =
    const CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum._(
      'interview',
    );
const CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum
_$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_awaitingKit =
    const CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum._(
      'awaitingKit',
    );
const CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum
_$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_active =
    const CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum._(
      'active',
    );
const CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum
_$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_waitlist =
    const CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum._(
      'waitlist',
    );
const CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum
_$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_rejected =
    const CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum._(
      'rejected',
    );

CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum
_$captainApplicationDtoOutputApplicationHistoryInnerStageEnumValueOf(
  String name,
) {
  switch (name) {
    case 'draft':
      return _$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_draft;
    case 'new_':
      return _$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_new_;
    case 'underReview':
      return _$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_underReview;
    case 'interview':
      return _$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_interview;
    case 'awaitingKit':
      return _$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_awaitingKit;
    case 'active':
      return _$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_active;
    case 'waitlist':
      return _$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_waitlist;
    case 'rejected':
      return _$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_rejected;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum>
_$captainApplicationDtoOutputApplicationHistoryInnerStageEnumValues =
    BuiltSet<
      CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum
    >(const <CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum>[
      _$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_draft,
      _$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_new_,
      _$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_underReview,
      _$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_interview,
      _$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_awaitingKit,
      _$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_active,
      _$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_waitlist,
      _$captainApplicationDtoOutputApplicationHistoryInnerStageEnum_rejected,
    ]);

Serializer<CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum>
_$captainApplicationDtoOutputApplicationHistoryInnerStageEnumSerializer =
    _$CaptainApplicationDtoOutputApplicationHistoryInnerStageEnumSerializer();

class _$CaptainApplicationDtoOutputApplicationHistoryInnerStageEnumSerializer
    implements
        PrimitiveSerializer<
          CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'draft': 'draft',
    'new_': 'new',
    'underReview': 'under_review',
    'interview': 'interview',
    'awaitingKit': 'awaiting_kit',
    'active': 'active',
    'waitlist': 'waitlist',
    'rejected': 'rejected',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'draft': 'draft',
    'new': 'new_',
    'under_review': 'underReview',
    'interview': 'interview',
    'awaiting_kit': 'awaitingKit',
    'active': 'active',
    'waitlist': 'waitlist',
    'rejected': 'rejected',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum,
  ];
  @override
  final String wireName =
      'CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum';

  @override
  Object serialize(
    Serializers serializers,
    CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CaptainApplicationDtoOutputApplicationHistoryInner
    extends CaptainApplicationDtoOutputApplicationHistoryInner {
  @override
  final CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum stage;
  @override
  final DateTime at;

  factory _$CaptainApplicationDtoOutputApplicationHistoryInner([
    void Function(CaptainApplicationDtoOutputApplicationHistoryInnerBuilder)?
    updates,
  ]) =>
      (CaptainApplicationDtoOutputApplicationHistoryInnerBuilder()
            ..update(updates))
          ._build();

  _$CaptainApplicationDtoOutputApplicationHistoryInner._({
    required this.stage,
    required this.at,
  }) : super._();
  @override
  CaptainApplicationDtoOutputApplicationHistoryInner rebuild(
    void Function(CaptainApplicationDtoOutputApplicationHistoryInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainApplicationDtoOutputApplicationHistoryInnerBuilder toBuilder() =>
      CaptainApplicationDtoOutputApplicationHistoryInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainApplicationDtoOutputApplicationHistoryInner &&
        stage == other.stage &&
        at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, stage.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainApplicationDtoOutputApplicationHistoryInner',
          )
          ..add('stage', stage)
          ..add('at', at))
        .toString();
  }
}

class CaptainApplicationDtoOutputApplicationHistoryInnerBuilder
    implements
        Builder<
          CaptainApplicationDtoOutputApplicationHistoryInner,
          CaptainApplicationDtoOutputApplicationHistoryInnerBuilder
        > {
  _$CaptainApplicationDtoOutputApplicationHistoryInner? _$v;

  CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum? _stage;
  CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum? get stage =>
      _$this._stage;
  set stage(
    CaptainApplicationDtoOutputApplicationHistoryInnerStageEnum? stage,
  ) => _$this._stage = stage;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  CaptainApplicationDtoOutputApplicationHistoryInnerBuilder() {
    CaptainApplicationDtoOutputApplicationHistoryInner._defaults(this);
  }

  CaptainApplicationDtoOutputApplicationHistoryInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _stage = $v.stage;
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainApplicationDtoOutputApplicationHistoryInner other) {
    _$v = other as _$CaptainApplicationDtoOutputApplicationHistoryInner;
  }

  @override
  void update(
    void Function(CaptainApplicationDtoOutputApplicationHistoryInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainApplicationDtoOutputApplicationHistoryInner build() => _build();

  _$CaptainApplicationDtoOutputApplicationHistoryInner _build() {
    final _$result =
        _$v ??
        _$CaptainApplicationDtoOutputApplicationHistoryInner._(
          stage: BuiltValueNullFieldError.checkNotNull(
            stage,
            r'CaptainApplicationDtoOutputApplicationHistoryInner',
            'stage',
          ),
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'CaptainApplicationDtoOutputApplicationHistoryInner',
            'at',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
