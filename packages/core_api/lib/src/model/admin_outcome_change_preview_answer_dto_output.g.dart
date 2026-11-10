// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_outcome_change_preview_answer_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum
_$adminOutcomeChangePreviewAnswerDtoOutputStatusEnum_delivered =
    const AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum._('delivered');
const AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum
_$adminOutcomeChangePreviewAnswerDtoOutputStatusEnum_failed =
    const AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum._('failed');

AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum
_$adminOutcomeChangePreviewAnswerDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'delivered':
      return _$adminOutcomeChangePreviewAnswerDtoOutputStatusEnum_delivered;
    case 'failed':
      return _$adminOutcomeChangePreviewAnswerDtoOutputStatusEnum_failed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum>
_$adminOutcomeChangePreviewAnswerDtoOutputStatusEnumValues =
    BuiltSet<AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum>(
      const <AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum>[
        _$adminOutcomeChangePreviewAnswerDtoOutputStatusEnum_delivered,
        _$adminOutcomeChangePreviewAnswerDtoOutputStatusEnum_failed,
      ],
    );

Serializer<AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum>
_$adminOutcomeChangePreviewAnswerDtoOutputStatusEnumSerializer =
    _$AdminOutcomeChangePreviewAnswerDtoOutputStatusEnumSerializer();

class _$AdminOutcomeChangePreviewAnswerDtoOutputStatusEnumSerializer
    implements
        PrimitiveSerializer<
          AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum
        > {
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
    AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum,
  ];
  @override
  final String wireName = 'AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOutcomeChangePreviewAnswerDtoOutput
    extends AdminOutcomeChangePreviewAnswerDtoOutput {
  @override
  final AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum status;
  @override
  final bool provisional;
  @override
  final AdminOutcomePreviewAnswerDtoOutputLoss loss;
  @override
  final AdminOutcomeChangePreviewAnswerDtoOutputDues? dues;
  @override
  final AdminOutcomePreviewAnswerDtoOutputCaptainPay captainPay;
  @override
  final BuiltList<AdminOutcomePreviewAnswerDtoOutputEntriesInner> entries;
  @override
  final BuiltList<AdminOutcomePreviewAnswerDtoOutputEntriesInner> reversed;

  factory _$AdminOutcomeChangePreviewAnswerDtoOutput([
    void Function(AdminOutcomeChangePreviewAnswerDtoOutputBuilder)? updates,
  ]) => (AdminOutcomeChangePreviewAnswerDtoOutputBuilder()..update(updates))
      ._build();

  _$AdminOutcomeChangePreviewAnswerDtoOutput._({
    required this.status,
    required this.provisional,
    required this.loss,
    this.dues,
    required this.captainPay,
    required this.entries,
    required this.reversed,
  }) : super._();
  @override
  AdminOutcomeChangePreviewAnswerDtoOutput rebuild(
    void Function(AdminOutcomeChangePreviewAnswerDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOutcomeChangePreviewAnswerDtoOutputBuilder toBuilder() =>
      AdminOutcomeChangePreviewAnswerDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOutcomeChangePreviewAnswerDtoOutput &&
        status == other.status &&
        provisional == other.provisional &&
        loss == other.loss &&
        dues == other.dues &&
        captainPay == other.captainPay &&
        entries == other.entries &&
        reversed == other.reversed;
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
    _$hash = $jc(_$hash, reversed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOutcomeChangePreviewAnswerDtoOutput',
          )
          ..add('status', status)
          ..add('provisional', provisional)
          ..add('loss', loss)
          ..add('dues', dues)
          ..add('captainPay', captainPay)
          ..add('entries', entries)
          ..add('reversed', reversed))
        .toString();
  }
}

class AdminOutcomeChangePreviewAnswerDtoOutputBuilder
    implements
        Builder<
          AdminOutcomeChangePreviewAnswerDtoOutput,
          AdminOutcomeChangePreviewAnswerDtoOutputBuilder
        > {
  _$AdminOutcomeChangePreviewAnswerDtoOutput? _$v;

  AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum? _status;
  AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum? get status =>
      _$this._status;
  set status(AdminOutcomeChangePreviewAnswerDtoOutputStatusEnum? status) =>
      _$this._status = status;

  bool? _provisional;
  bool? get provisional => _$this._provisional;
  set provisional(bool? provisional) => _$this._provisional = provisional;

  AdminOutcomePreviewAnswerDtoOutputLossBuilder? _loss;
  AdminOutcomePreviewAnswerDtoOutputLossBuilder get loss =>
      _$this._loss ??= AdminOutcomePreviewAnswerDtoOutputLossBuilder();
  set loss(AdminOutcomePreviewAnswerDtoOutputLossBuilder? loss) =>
      _$this._loss = loss;

  AdminOutcomeChangePreviewAnswerDtoOutputDuesBuilder? _dues;
  AdminOutcomeChangePreviewAnswerDtoOutputDuesBuilder get dues =>
      _$this._dues ??= AdminOutcomeChangePreviewAnswerDtoOutputDuesBuilder();
  set dues(AdminOutcomeChangePreviewAnswerDtoOutputDuesBuilder? dues) =>
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

  ListBuilder<AdminOutcomePreviewAnswerDtoOutputEntriesInner>? _reversed;
  ListBuilder<AdminOutcomePreviewAnswerDtoOutputEntriesInner> get reversed =>
      _$this._reversed ??=
          ListBuilder<AdminOutcomePreviewAnswerDtoOutputEntriesInner>();
  set reversed(
    ListBuilder<AdminOutcomePreviewAnswerDtoOutputEntriesInner>? reversed,
  ) => _$this._reversed = reversed;

  AdminOutcomeChangePreviewAnswerDtoOutputBuilder() {
    AdminOutcomeChangePreviewAnswerDtoOutput._defaults(this);
  }

  AdminOutcomeChangePreviewAnswerDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _provisional = $v.provisional;
      _loss = $v.loss.toBuilder();
      _dues = $v.dues?.toBuilder();
      _captainPay = $v.captainPay.toBuilder();
      _entries = $v.entries.toBuilder();
      _reversed = $v.reversed.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOutcomeChangePreviewAnswerDtoOutput other) {
    _$v = other as _$AdminOutcomeChangePreviewAnswerDtoOutput;
  }

  @override
  void update(
    void Function(AdminOutcomeChangePreviewAnswerDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOutcomeChangePreviewAnswerDtoOutput build() => _build();

  _$AdminOutcomeChangePreviewAnswerDtoOutput _build() {
    _$AdminOutcomeChangePreviewAnswerDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminOutcomeChangePreviewAnswerDtoOutput._(
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'AdminOutcomeChangePreviewAnswerDtoOutput',
              'status',
            ),
            provisional: BuiltValueNullFieldError.checkNotNull(
              provisional,
              r'AdminOutcomeChangePreviewAnswerDtoOutput',
              'provisional',
            ),
            loss: loss.build(),
            dues: _dues?.build(),
            captainPay: captainPay.build(),
            entries: entries.build(),
            reversed: reversed.build(),
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
        _$failedField = 'reversed';
        reversed.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOutcomeChangePreviewAnswerDtoOutput',
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
