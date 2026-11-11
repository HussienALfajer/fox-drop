// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_no_answer_reports_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderNoAnswerReportsInner
    extends AdminOrderDtoOutputOrderNoAnswerReportsInner {
  @override
  final String captainId;
  @override
  final DateTime at;
  @override
  final DateTime? waitedAt;
  @override
  final String? waitMessage;

  factory _$AdminOrderDtoOutputOrderNoAnswerReportsInner([
    void Function(AdminOrderDtoOutputOrderNoAnswerReportsInnerBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderNoAnswerReportsInnerBuilder()..update(updates))
      ._build();

  _$AdminOrderDtoOutputOrderNoAnswerReportsInner._({
    required this.captainId,
    required this.at,
    this.waitedAt,
    this.waitMessage,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderNoAnswerReportsInner rebuild(
    void Function(AdminOrderDtoOutputOrderNoAnswerReportsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderNoAnswerReportsInnerBuilder toBuilder() =>
      AdminOrderDtoOutputOrderNoAnswerReportsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderNoAnswerReportsInner &&
        captainId == other.captainId &&
        at == other.at &&
        waitedAt == other.waitedAt &&
        waitMessage == other.waitMessage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, captainId.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, waitedAt.hashCode);
    _$hash = $jc(_$hash, waitMessage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderNoAnswerReportsInner',
          )
          ..add('captainId', captainId)
          ..add('at', at)
          ..add('waitedAt', waitedAt)
          ..add('waitMessage', waitMessage))
        .toString();
  }
}

class AdminOrderDtoOutputOrderNoAnswerReportsInnerBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderNoAnswerReportsInner,
          AdminOrderDtoOutputOrderNoAnswerReportsInnerBuilder
        > {
  _$AdminOrderDtoOutputOrderNoAnswerReportsInner? _$v;

  String? _captainId;
  String? get captainId => _$this._captainId;
  set captainId(String? captainId) => _$this._captainId = captainId;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  DateTime? _waitedAt;
  DateTime? get waitedAt => _$this._waitedAt;
  set waitedAt(DateTime? waitedAt) => _$this._waitedAt = waitedAt;

  String? _waitMessage;
  String? get waitMessage => _$this._waitMessage;
  set waitMessage(String? waitMessage) => _$this._waitMessage = waitMessage;

  AdminOrderDtoOutputOrderNoAnswerReportsInnerBuilder() {
    AdminOrderDtoOutputOrderNoAnswerReportsInner._defaults(this);
  }

  AdminOrderDtoOutputOrderNoAnswerReportsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _captainId = $v.captainId;
      _at = $v.at;
      _waitedAt = $v.waitedAt;
      _waitMessage = $v.waitMessage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderNoAnswerReportsInner other) {
    _$v = other as _$AdminOrderDtoOutputOrderNoAnswerReportsInner;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderNoAnswerReportsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderNoAnswerReportsInner build() => _build();

  _$AdminOrderDtoOutputOrderNoAnswerReportsInner _build() {
    final _$result =
        _$v ??
        _$AdminOrderDtoOutputOrderNoAnswerReportsInner._(
          captainId: BuiltValueNullFieldError.checkNotNull(
            captainId,
            r'AdminOrderDtoOutputOrderNoAnswerReportsInner',
            'captainId',
          ),
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'AdminOrderDtoOutputOrderNoAnswerReportsInner',
            'at',
          ),
          waitedAt: waitedAt,
          waitMessage: waitMessage,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
