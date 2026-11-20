// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_dto_output_today_orders.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardDtoOutputTodayOrders
    extends AdminDashboardDtoOutputTodayOrders {
  @override
  final int placed;
  @override
  final int delivered;
  @override
  final int inProgress;
  @override
  final int cancelled;
  @override
  final int rejected;
  @override
  final int failed;
  @override
  final num? deliveryMinutes;
  @override
  final int? onTimeBp;
  @override
  final int? successBp;
  @override
  final int firstOrders;

  factory _$AdminDashboardDtoOutputTodayOrders([
    void Function(AdminDashboardDtoOutputTodayOrdersBuilder)? updates,
  ]) => (AdminDashboardDtoOutputTodayOrdersBuilder()..update(updates))._build();

  _$AdminDashboardDtoOutputTodayOrders._({
    required this.placed,
    required this.delivered,
    required this.inProgress,
    required this.cancelled,
    required this.rejected,
    required this.failed,
    this.deliveryMinutes,
    this.onTimeBp,
    this.successBp,
    required this.firstOrders,
  }) : super._();
  @override
  AdminDashboardDtoOutputTodayOrders rebuild(
    void Function(AdminDashboardDtoOutputTodayOrdersBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDashboardDtoOutputTodayOrdersBuilder toBuilder() =>
      AdminDashboardDtoOutputTodayOrdersBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardDtoOutputTodayOrders &&
        placed == other.placed &&
        delivered == other.delivered &&
        inProgress == other.inProgress &&
        cancelled == other.cancelled &&
        rejected == other.rejected &&
        failed == other.failed &&
        deliveryMinutes == other.deliveryMinutes &&
        onTimeBp == other.onTimeBp &&
        successBp == other.successBp &&
        firstOrders == other.firstOrders;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, placed.hashCode);
    _$hash = $jc(_$hash, delivered.hashCode);
    _$hash = $jc(_$hash, inProgress.hashCode);
    _$hash = $jc(_$hash, cancelled.hashCode);
    _$hash = $jc(_$hash, rejected.hashCode);
    _$hash = $jc(_$hash, failed.hashCode);
    _$hash = $jc(_$hash, deliveryMinutes.hashCode);
    _$hash = $jc(_$hash, onTimeBp.hashCode);
    _$hash = $jc(_$hash, successBp.hashCode);
    _$hash = $jc(_$hash, firstOrders.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboardDtoOutputTodayOrders')
          ..add('placed', placed)
          ..add('delivered', delivered)
          ..add('inProgress', inProgress)
          ..add('cancelled', cancelled)
          ..add('rejected', rejected)
          ..add('failed', failed)
          ..add('deliveryMinutes', deliveryMinutes)
          ..add('onTimeBp', onTimeBp)
          ..add('successBp', successBp)
          ..add('firstOrders', firstOrders))
        .toString();
  }
}

class AdminDashboardDtoOutputTodayOrdersBuilder
    implements
        Builder<
          AdminDashboardDtoOutputTodayOrders,
          AdminDashboardDtoOutputTodayOrdersBuilder
        > {
  _$AdminDashboardDtoOutputTodayOrders? _$v;

  int? _placed;
  int? get placed => _$this._placed;
  set placed(int? placed) => _$this._placed = placed;

  int? _delivered;
  int? get delivered => _$this._delivered;
  set delivered(int? delivered) => _$this._delivered = delivered;

  int? _inProgress;
  int? get inProgress => _$this._inProgress;
  set inProgress(int? inProgress) => _$this._inProgress = inProgress;

  int? _cancelled;
  int? get cancelled => _$this._cancelled;
  set cancelled(int? cancelled) => _$this._cancelled = cancelled;

  int? _rejected;
  int? get rejected => _$this._rejected;
  set rejected(int? rejected) => _$this._rejected = rejected;

  int? _failed;
  int? get failed => _$this._failed;
  set failed(int? failed) => _$this._failed = failed;

  num? _deliveryMinutes;
  num? get deliveryMinutes => _$this._deliveryMinutes;
  set deliveryMinutes(num? deliveryMinutes) =>
      _$this._deliveryMinutes = deliveryMinutes;

  int? _onTimeBp;
  int? get onTimeBp => _$this._onTimeBp;
  set onTimeBp(int? onTimeBp) => _$this._onTimeBp = onTimeBp;

  int? _successBp;
  int? get successBp => _$this._successBp;
  set successBp(int? successBp) => _$this._successBp = successBp;

  int? _firstOrders;
  int? get firstOrders => _$this._firstOrders;
  set firstOrders(int? firstOrders) => _$this._firstOrders = firstOrders;

  AdminDashboardDtoOutputTodayOrdersBuilder() {
    AdminDashboardDtoOutputTodayOrders._defaults(this);
  }

  AdminDashboardDtoOutputTodayOrdersBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _placed = $v.placed;
      _delivered = $v.delivered;
      _inProgress = $v.inProgress;
      _cancelled = $v.cancelled;
      _rejected = $v.rejected;
      _failed = $v.failed;
      _deliveryMinutes = $v.deliveryMinutes;
      _onTimeBp = $v.onTimeBp;
      _successBp = $v.successBp;
      _firstOrders = $v.firstOrders;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardDtoOutputTodayOrders other) {
    _$v = other as _$AdminDashboardDtoOutputTodayOrders;
  }

  @override
  void update(
    void Function(AdminDashboardDtoOutputTodayOrdersBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardDtoOutputTodayOrders build() => _build();

  _$AdminDashboardDtoOutputTodayOrders _build() {
    final _$result =
        _$v ??
        _$AdminDashboardDtoOutputTodayOrders._(
          placed: BuiltValueNullFieldError.checkNotNull(
            placed,
            r'AdminDashboardDtoOutputTodayOrders',
            'placed',
          ),
          delivered: BuiltValueNullFieldError.checkNotNull(
            delivered,
            r'AdminDashboardDtoOutputTodayOrders',
            'delivered',
          ),
          inProgress: BuiltValueNullFieldError.checkNotNull(
            inProgress,
            r'AdminDashboardDtoOutputTodayOrders',
            'inProgress',
          ),
          cancelled: BuiltValueNullFieldError.checkNotNull(
            cancelled,
            r'AdminDashboardDtoOutputTodayOrders',
            'cancelled',
          ),
          rejected: BuiltValueNullFieldError.checkNotNull(
            rejected,
            r'AdminDashboardDtoOutputTodayOrders',
            'rejected',
          ),
          failed: BuiltValueNullFieldError.checkNotNull(
            failed,
            r'AdminDashboardDtoOutputTodayOrders',
            'failed',
          ),
          deliveryMinutes: deliveryMinutes,
          onTimeBp: onTimeBp,
          successBp: successBp,
          firstOrders: BuiltValueNullFieldError.checkNotNull(
            firstOrders,
            r'AdminDashboardDtoOutputTodayOrders',
            'firstOrders',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
