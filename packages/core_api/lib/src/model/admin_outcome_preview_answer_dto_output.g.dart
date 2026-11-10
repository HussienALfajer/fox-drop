// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_outcome_preview_answer_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOutcomePreviewAnswerDtoOutputStatusEnum
_$adminOutcomePreviewAnswerDtoOutputStatusEnum_delivered =
    const AdminOutcomePreviewAnswerDtoOutputStatusEnum._('delivered');
const AdminOutcomePreviewAnswerDtoOutputStatusEnum
_$adminOutcomePreviewAnswerDtoOutputStatusEnum_failed =
    const AdminOutcomePreviewAnswerDtoOutputStatusEnum._('failed');

AdminOutcomePreviewAnswerDtoOutputStatusEnum
_$adminOutcomePreviewAnswerDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'delivered':
      return _$adminOutcomePreviewAnswerDtoOutputStatusEnum_delivered;
    case 'failed':
      return _$adminOutcomePreviewAnswerDtoOutputStatusEnum_failed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOutcomePreviewAnswerDtoOutputStatusEnum>
_$adminOutcomePreviewAnswerDtoOutputStatusEnumValues =
    BuiltSet<AdminOutcomePreviewAnswerDtoOutputStatusEnum>(
      const <AdminOutcomePreviewAnswerDtoOutputStatusEnum>[
        _$adminOutcomePreviewAnswerDtoOutputStatusEnum_delivered,
        _$adminOutcomePreviewAnswerDtoOutputStatusEnum_failed,
      ],
    );

Serializer<AdminOutcomePreviewAnswerDtoOutputStatusEnum>
_$adminOutcomePreviewAnswerDtoOutputStatusEnumSerializer =
    _$AdminOutcomePreviewAnswerDtoOutputStatusEnumSerializer();

class _$AdminOutcomePreviewAnswerDtoOutputStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminOutcomePreviewAnswerDtoOutputStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'delivered': 'delivered',
    'failed': 'failed',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'delivered': 'delivered',
    'failed': 'failed',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminOutcomePreviewAnswerDtoOutputStatusEnum,
  ];
  @override
  final String wireName = 'AdminOutcomePreviewAnswerDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOutcomePreviewAnswerDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOutcomePreviewAnswerDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOutcomePreviewAnswerDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOutcomePreviewAnswerDtoOutput
    extends AdminOutcomePreviewAnswerDtoOutput {
  @override
  final AdminOutcomePreviewAnswerDtoOutputStatusEnum status;
  @override
  final bool provisional;
  @override
  final AdminOutcomePreviewAnswerDtoOutputLoss loss;
  @override
  final CaptainWentOfflineDtoOutputHandIn? dues;
  @override
  final AdminOutcomePreviewAnswerDtoOutputCaptainPay captainPay;
  @override
  final BuiltList<AdminOutcomePreviewAnswerDtoOutputEntriesInner> entries;

  factory _$AdminOutcomePreviewAnswerDtoOutput([
    void Function(AdminOutcomePreviewAnswerDtoOutputBuilder)? updates,
  ]) => (AdminOutcomePreviewAnswerDtoOutputBuilder()..update(updates))._build();

  _$AdminOutcomePreviewAnswerDtoOutput._({
    required this.status,
    required this.provisional,
    required this.loss,
    this.dues,
    required this.captainPay,
    required this.entries,
  }) : super._();
  @override
  AdminOutcomePreviewAnswerDtoOutput rebuild(
    void Function(AdminOutcomePreviewAnswerDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOutcomePreviewAnswerDtoOutputBuilder toBuilder() =>
      AdminOutcomePreviewAnswerDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOutcomePreviewAnswerDtoOutput &&
        status == other.status &&
        provisional == other.provisional &&
        loss == other.loss &&
        dues == other.dues &&
        captainPay == other.captainPay &&
        entries == other.entries;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, provisional.hashCode);
    _$hash = $jc(_$hash, loss.hashCode);
    _$hash = $jc(_$hash, dues.hashCode);
    _$hash = $jc(_$hash, captainPay.hashCode);
    _$hash = $jc(_$hash, entries.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOutcomePreviewAnswerDtoOutput')
          ..add('status', status)
          ..add('provisional', provisional)
          ..add('loss', loss)
          ..add('dues', dues)
          ..add('captainPay', captainPay)
          ..add('entries', entries))
        .toString();
  }
}

class AdminOutcomePreviewAnswerDtoOutputBuilder
    implements
        Builder<
          AdminOutcomePreviewAnswerDtoOutput,
          AdminOutcomePreviewAnswerDtoOutputBuilder
        > {
  _$AdminOutcomePreviewAnswerDtoOutput? _$v;

  AdminOutcomePreviewAnswerDtoOutputStatusEnum? _status;
  AdminOutcomePreviewAnswerDtoOutputStatusEnum? get status => _$this._status;
  set status(AdminOutcomePreviewAnswerDtoOutputStatusEnum? status) =>
      _$this._status = status;

  bool? _provisional;
  bool? get provisional => _$this._provisional;
  set provisional(bool? provisional) => _$this._provisional = provisional;

  AdminOutcomePreviewAnswerDtoOutputLossBuilder? _loss;
  AdminOutcomePreviewAnswerDtoOutputLossBuilder get loss =>
      _$this._loss ??= AdminOutcomePreviewAnswerDtoOutputLossBuilder();
  set loss(AdminOutcomePreviewAnswerDtoOutputLossBuilder? loss) =>
      _$this._loss = loss;

  CaptainWentOfflineDtoOutputHandInBuilder? _dues;
  CaptainWentOfflineDtoOutputHandInBuilder get dues =>
      _$this._dues ??= CaptainWentOfflineDtoOutputHandInBuilder();
  set dues(CaptainWentOfflineDtoOutputHandInBuilder? dues) =>
      _$this._dues = dues;

  AdminOutcomePreviewAnswerDtoOutputCaptainPayBuilder? _captainPay;
  AdminOutcomePreviewAnswerDtoOutputCaptainPayBuilder get captainPay =>
      _$this._captainPay ??=
          AdminOutcomePreviewAnswerDtoOutputCaptainPayBuilder();
  set captainPay(
    AdminOutcomePreviewAnswerDtoOutputCaptainPayBuilder? captainPay,
  ) => _$this._captainPay = captainPay;

  ListBuilder<AdminOutcomePreviewAnswerDtoOutputEntriesInner>? _entries;
  ListBuilder<AdminOutcomePreviewAnswerDtoOutputEntriesInner> get entries =>
      _$this._entries ??=
          ListBuilder<AdminOutcomePreviewAnswerDtoOutputEntriesInner>();
  set entries(
    ListBuilder<AdminOutcomePreviewAnswerDtoOutputEntriesInner>? entries,
  ) => _$this._entries = entries;

  AdminOutcomePreviewAnswerDtoOutputBuilder() {
    AdminOutcomePreviewAnswerDtoOutput._defaults(this);
  }

  AdminOutcomePreviewAnswerDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _provisional = $v.provisional;
      _loss = $v.loss.toBuilder();
      _dues = $v.dues?.toBuilder();
      _captainPay = $v.captainPay.toBuilder();
      _entries = $v.entries.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOutcomePreviewAnswerDtoOutput other) {
    _$v = other as _$AdminOutcomePreviewAnswerDtoOutput;
  }

  @override
  void update(
    void Function(AdminOutcomePreviewAnswerDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOutcomePreviewAnswerDtoOutput build() => _build();

  _$AdminOutcomePreviewAnswerDtoOutput _build() {
    _$AdminOutcomePreviewAnswerDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminOutcomePreviewAnswerDtoOutput._(
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'AdminOutcomePreviewAnswerDtoOutput',
              'status',
            ),
            provisional: BuiltValueNullFieldError.checkNotNull(
              provisional,
              r'AdminOutcomePreviewAnswerDtoOutput',
              'provisional',
            ),
            loss: loss.build(),
            dues: _dues?.build(),
            captainPay: captainPay.build(),
            entries: entries.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'loss';
        loss.build();
        _$failedField = 'dues';
        _dues?.build();
        _$failedField = 'captainPay';
        captainPay.build();
        _$failedField = 'entries';
        entries.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOutcomePreviewAnswerDtoOutput',
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
