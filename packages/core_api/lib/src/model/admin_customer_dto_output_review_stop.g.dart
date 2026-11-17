// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_dto_output_review_stop.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCustomerDtoOutputReviewStop
    extends AdminCustomerDtoOutputReviewStop {
  @override
  final DateTime startedAt;

  factory _$AdminCustomerDtoOutputReviewStop([
    void Function(AdminCustomerDtoOutputReviewStopBuilder)? updates,
  ]) => (AdminCustomerDtoOutputReviewStopBuilder()..update(updates))._build();

  _$AdminCustomerDtoOutputReviewStop._({required this.startedAt}) : super._();
  @override
  AdminCustomerDtoOutputReviewStop rebuild(
    void Function(AdminCustomerDtoOutputReviewStopBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerDtoOutputReviewStopBuilder toBuilder() =>
      AdminCustomerDtoOutputReviewStopBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerDtoOutputReviewStop &&
        startedAt == other.startedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, startedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminCustomerDtoOutputReviewStop',
    )..add('startedAt', startedAt)).toString();
  }
}

class AdminCustomerDtoOutputReviewStopBuilder
    implements
        Builder<
          AdminCustomerDtoOutputReviewStop,
          AdminCustomerDtoOutputReviewStopBuilder
        > {
  _$AdminCustomerDtoOutputReviewStop? _$v;

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(DateTime? startedAt) => _$this._startedAt = startedAt;

  AdminCustomerDtoOutputReviewStopBuilder() {
    AdminCustomerDtoOutputReviewStop._defaults(this);
  }

  AdminCustomerDtoOutputReviewStopBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _startedAt = $v.startedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerDtoOutputReviewStop other) {
    _$v = other as _$AdminCustomerDtoOutputReviewStop;
  }

  @override
  void update(void Function(AdminCustomerDtoOutputReviewStopBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerDtoOutputReviewStop build() => _build();

  _$AdminCustomerDtoOutputReviewStop _build() {
    final _$result =
        _$v ??
        _$AdminCustomerDtoOutputReviewStop._(
          startedAt: BuiltValueNullFieldError.checkNotNull(
            startedAt,
            r'AdminCustomerDtoOutputReviewStop',
            'startedAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
