// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_no_answer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderNoAnswer
    extends AdminOrderDtoOutputOrderNoAnswer {
  @override
  final BuiltList<AdminOrderDtoOutputOrderNoAnswerPingsInner> pings;
  @override
  final BuiltList<AdminOrderDtoOutputOrderNoAnswerReportsInner> reports;
  @override
  final bool waitAllowed;

  factory _$AdminOrderDtoOutputOrderNoAnswer([
    void Function(AdminOrderDtoOutputOrderNoAnswerBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderNoAnswerBuilder()..update(updates))._build();

  _$AdminOrderDtoOutputOrderNoAnswer._({
    required this.pings,
    required this.reports,
    required this.waitAllowed,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderNoAnswer rebuild(
    void Function(AdminOrderDtoOutputOrderNoAnswerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderNoAnswerBuilder toBuilder() =>
      AdminOrderDtoOutputOrderNoAnswerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderNoAnswer &&
        pings == other.pings &&
        reports == other.reports &&
        waitAllowed == other.waitAllowed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pings.hashCode);
    _$hash = $jc(_$hash, reports.hashCode);
    _$hash = $jc(_$hash, waitAllowed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOrderDtoOutputOrderNoAnswer')
          ..add('pings', pings)
          ..add('reports', reports)
          ..add('waitAllowed', waitAllowed))
        .toString();
  }
}

class AdminOrderDtoOutputOrderNoAnswerBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderNoAnswer,
          AdminOrderDtoOutputOrderNoAnswerBuilder
        > {
  _$AdminOrderDtoOutputOrderNoAnswer? _$v;

  ListBuilder<AdminOrderDtoOutputOrderNoAnswerPingsInner>? _pings;
  ListBuilder<AdminOrderDtoOutputOrderNoAnswerPingsInner> get pings =>
      _$this._pings ??=
          ListBuilder<AdminOrderDtoOutputOrderNoAnswerPingsInner>();
  set pings(ListBuilder<AdminOrderDtoOutputOrderNoAnswerPingsInner>? pings) =>
      _$this._pings = pings;

  ListBuilder<AdminOrderDtoOutputOrderNoAnswerReportsInner>? _reports;
  ListBuilder<AdminOrderDtoOutputOrderNoAnswerReportsInner> get reports =>
      _$this._reports ??=
          ListBuilder<AdminOrderDtoOutputOrderNoAnswerReportsInner>();
  set reports(
    ListBuilder<AdminOrderDtoOutputOrderNoAnswerReportsInner>? reports,
  ) => _$this._reports = reports;

  bool? _waitAllowed;
  bool? get waitAllowed => _$this._waitAllowed;
  set waitAllowed(bool? waitAllowed) => _$this._waitAllowed = waitAllowed;

  AdminOrderDtoOutputOrderNoAnswerBuilder() {
    AdminOrderDtoOutputOrderNoAnswer._defaults(this);
  }

  AdminOrderDtoOutputOrderNoAnswerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pings = $v.pings.toBuilder();
      _reports = $v.reports.toBuilder();
      _waitAllowed = $v.waitAllowed;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderNoAnswer other) {
    _$v = other as _$AdminOrderDtoOutputOrderNoAnswer;
  }

  @override
  void update(void Function(AdminOrderDtoOutputOrderNoAnswerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderNoAnswer build() => _build();

  _$AdminOrderDtoOutputOrderNoAnswer _build() {
    _$AdminOrderDtoOutputOrderNoAnswer _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderDtoOutputOrderNoAnswer._(
            pings: pings.build(),
            reports: reports.build(),
            waitAllowed: BuiltValueNullFieldError.checkNotNull(
              waitAllowed,
              r'AdminOrderDtoOutputOrderNoAnswer',
              'waitAllowed',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'pings';
        pings.build();
        _$failedField = 'reports';
        reports.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderDtoOutputOrderNoAnswer',
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
