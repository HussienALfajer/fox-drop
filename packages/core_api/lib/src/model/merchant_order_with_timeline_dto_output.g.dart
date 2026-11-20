// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_order_with_timeline_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantOrderWithTimelineDtoOutput
    extends MerchantOrderWithTimelineDtoOutput {
  @override
  final MerchantOrderWithTimelineDtoOutputOrder order;
  @override
  final BuiltList<MerchantOrderWithTimelineDtoOutputTimelineInner> timeline;

  factory _$MerchantOrderWithTimelineDtoOutput([
    void Function(MerchantOrderWithTimelineDtoOutputBuilder)? updates,
  ]) => (MerchantOrderWithTimelineDtoOutputBuilder()..update(updates))._build();

  _$MerchantOrderWithTimelineDtoOutput._({
    required this.order,
    required this.timeline,
  }) : super._();
  @override
  MerchantOrderWithTimelineDtoOutput rebuild(
    void Function(MerchantOrderWithTimelineDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrderWithTimelineDtoOutputBuilder toBuilder() =>
      MerchantOrderWithTimelineDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrderWithTimelineDtoOutput &&
        order == other.order &&
        timeline == other.timeline;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, order.hashCode);
    _$hash = $jc(_$hash, timeline.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantOrderWithTimelineDtoOutput')
          ..add('order', order)
          ..add('timeline', timeline))
        .toString();
  }
}

class MerchantOrderWithTimelineDtoOutputBuilder
    implements
        Builder<
          MerchantOrderWithTimelineDtoOutput,
          MerchantOrderWithTimelineDtoOutputBuilder
        > {
  _$MerchantOrderWithTimelineDtoOutput? _$v;

  MerchantOrderWithTimelineDtoOutputOrderBuilder? _order;
  MerchantOrderWithTimelineDtoOutputOrderBuilder get order =>
      _$this._order ??= MerchantOrderWithTimelineDtoOutputOrderBuilder();
  set order(MerchantOrderWithTimelineDtoOutputOrderBuilder? order) =>
      _$this._order = order;

  ListBuilder<MerchantOrderWithTimelineDtoOutputTimelineInner>? _timeline;
  ListBuilder<MerchantOrderWithTimelineDtoOutputTimelineInner> get timeline =>
      _$this._timeline ??=
          ListBuilder<MerchantOrderWithTimelineDtoOutputTimelineInner>();
  set timeline(
    ListBuilder<MerchantOrderWithTimelineDtoOutputTimelineInner>? timeline,
  ) => _$this._timeline = timeline;

  MerchantOrderWithTimelineDtoOutputBuilder() {
    MerchantOrderWithTimelineDtoOutput._defaults(this);
  }

  MerchantOrderWithTimelineDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _order = $v.order.toBuilder();
      _timeline = $v.timeline.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOrderWithTimelineDtoOutput other) {
    _$v = other as _$MerchantOrderWithTimelineDtoOutput;
  }

  @override
  void update(
    void Function(MerchantOrderWithTimelineDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrderWithTimelineDtoOutput build() => _build();

  _$MerchantOrderWithTimelineDtoOutput _build() {
    _$MerchantOrderWithTimelineDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$MerchantOrderWithTimelineDtoOutput._(
            order: order.build(),
            timeline: timeline.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'order';
        order.build();
        _$failedField = 'timeline';
        timeline.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantOrderWithTimelineDtoOutput',
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
