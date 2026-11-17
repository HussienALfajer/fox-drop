// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_compensations_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderCompensationsDtoOutput
    extends AdminOrderCompensationsDtoOutput {
  @override
  final BuiltList<AdminOrderCompensationsDtoOutputCompensationsInner>
  compensations;
  @override
  final String currency;
  @override
  final String? capLeft;
  @override
  final bool canCompensate;
  @override
  final BuiltList<AdminCompensationRequestsDtoOutputRequestsInnerReason?>
  reasons;

  factory _$AdminOrderCompensationsDtoOutput([
    void Function(AdminOrderCompensationsDtoOutputBuilder)? updates,
  ]) => (AdminOrderCompensationsDtoOutputBuilder()..update(updates))._build();

  _$AdminOrderCompensationsDtoOutput._({
    required this.compensations,
    required this.currency,
    this.capLeft,
    required this.canCompensate,
    required this.reasons,
  }) : super._();
  @override
  AdminOrderCompensationsDtoOutput rebuild(
    void Function(AdminOrderCompensationsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderCompensationsDtoOutputBuilder toBuilder() =>
      AdminOrderCompensationsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderCompensationsDtoOutput &&
        compensations == other.compensations &&
        currency == other.currency &&
        capLeft == other.capLeft &&
        canCompensate == other.canCompensate &&
        reasons == other.reasons;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, compensations.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, capLeft.hashCode);
    _$hash = $jc(_$hash, canCompensate.hashCode);
    _$hash = $jc(_$hash, reasons.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOrderCompensationsDtoOutput')
          ..add('compensations', compensations)
          ..add('currency', currency)
          ..add('capLeft', capLeft)
          ..add('canCompensate', canCompensate)
          ..add('reasons', reasons))
        .toString();
  }
}

class AdminOrderCompensationsDtoOutputBuilder
    implements
        Builder<
          AdminOrderCompensationsDtoOutput,
          AdminOrderCompensationsDtoOutputBuilder
        > {
  _$AdminOrderCompensationsDtoOutput? _$v;

  ListBuilder<AdminOrderCompensationsDtoOutputCompensationsInner>?
  _compensations;
  ListBuilder<AdminOrderCompensationsDtoOutputCompensationsInner>
  get compensations => _$this._compensations ??=
      ListBuilder<AdminOrderCompensationsDtoOutputCompensationsInner>();
  set compensations(
    ListBuilder<AdminOrderCompensationsDtoOutputCompensationsInner>?
    compensations,
  ) => _$this._compensations = compensations;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _capLeft;
  String? get capLeft => _$this._capLeft;
  set capLeft(String? capLeft) => _$this._capLeft = capLeft;

  bool? _canCompensate;
  bool? get canCompensate => _$this._canCompensate;
  set canCompensate(bool? canCompensate) =>
      _$this._canCompensate = canCompensate;

  ListBuilder<AdminCompensationRequestsDtoOutputRequestsInnerReason?>? _reasons;
  ListBuilder<AdminCompensationRequestsDtoOutputRequestsInnerReason?>
  get reasons => _$this._reasons ??=
      ListBuilder<AdminCompensationRequestsDtoOutputRequestsInnerReason?>();
  set reasons(
    ListBuilder<AdminCompensationRequestsDtoOutputRequestsInnerReason?>?
    reasons,
  ) => _$this._reasons = reasons;

  AdminOrderCompensationsDtoOutputBuilder() {
    AdminOrderCompensationsDtoOutput._defaults(this);
  }

  AdminOrderCompensationsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _compensations = $v.compensations.toBuilder();
      _currency = $v.currency;
      _capLeft = $v.capLeft;
      _canCompensate = $v.canCompensate;
      _reasons = $v.reasons.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderCompensationsDtoOutput other) {
    _$v = other as _$AdminOrderCompensationsDtoOutput;
  }

  @override
  void update(void Function(AdminOrderCompensationsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderCompensationsDtoOutput build() => _build();

  _$AdminOrderCompensationsDtoOutput _build() {
    _$AdminOrderCompensationsDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderCompensationsDtoOutput._(
            compensations: compensations.build(),
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminOrderCompensationsDtoOutput',
              'currency',
            ),
            capLeft: capLeft,
            canCompensate: BuiltValueNullFieldError.checkNotNull(
              canCompensate,
              r'AdminOrderCompensationsDtoOutput',
              'canCompensate',
            ),
            reasons: reasons.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'compensations';
        compensations.build();

        _$failedField = 'reasons';
        reasons.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderCompensationsDtoOutput',
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
