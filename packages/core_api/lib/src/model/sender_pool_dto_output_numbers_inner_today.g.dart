// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sender_pool_dto_output_numbers_inner_today.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SenderPoolDtoOutputNumbersInnerToday
    extends SenderPoolDtoOutputNumbersInnerToday {
  @override
  final int sent;
  @override
  final int failed;
  @override
  final int delivered;
  @override
  final int read;

  factory _$SenderPoolDtoOutputNumbersInnerToday([
    void Function(SenderPoolDtoOutputNumbersInnerTodayBuilder)? updates,
  ]) =>
      (SenderPoolDtoOutputNumbersInnerTodayBuilder()..update(updates))._build();

  _$SenderPoolDtoOutputNumbersInnerToday._({
    required this.sent,
    required this.failed,
    required this.delivered,
    required this.read,
  }) : super._();
  @override
  SenderPoolDtoOutputNumbersInnerToday rebuild(
    void Function(SenderPoolDtoOutputNumbersInnerTodayBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SenderPoolDtoOutputNumbersInnerTodayBuilder toBuilder() =>
      SenderPoolDtoOutputNumbersInnerTodayBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SenderPoolDtoOutputNumbersInnerToday &&
        sent == other.sent &&
        failed == other.failed &&
        delivered == other.delivered &&
        read == other.read;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sent.hashCode);
    _$hash = $jc(_$hash, failed.hashCode);
    _$hash = $jc(_$hash, delivered.hashCode);
    _$hash = $jc(_$hash, read.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SenderPoolDtoOutputNumbersInnerToday')
          ..add('sent', sent)
          ..add('failed', failed)
          ..add('delivered', delivered)
          ..add('read', read))
        .toString();
  }
}

class SenderPoolDtoOutputNumbersInnerTodayBuilder
    implements
        Builder<
          SenderPoolDtoOutputNumbersInnerToday,
          SenderPoolDtoOutputNumbersInnerTodayBuilder
        > {
  _$SenderPoolDtoOutputNumbersInnerToday? _$v;

  int? _sent;
  int? get sent => _$this._sent;
  set sent(int? sent) => _$this._sent = sent;

  int? _failed;
  int? get failed => _$this._failed;
  set failed(int? failed) => _$this._failed = failed;

  int? _delivered;
  int? get delivered => _$this._delivered;
  set delivered(int? delivered) => _$this._delivered = delivered;

  int? _read;
  int? get read => _$this._read;
  set read(int? read) => _$this._read = read;

  SenderPoolDtoOutputNumbersInnerTodayBuilder() {
    SenderPoolDtoOutputNumbersInnerToday._defaults(this);
  }

  SenderPoolDtoOutputNumbersInnerTodayBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sent = $v.sent;
      _failed = $v.failed;
      _delivered = $v.delivered;
      _read = $v.read;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SenderPoolDtoOutputNumbersInnerToday other) {
    _$v = other as _$SenderPoolDtoOutputNumbersInnerToday;
  }

  @override
  void update(
    void Function(SenderPoolDtoOutputNumbersInnerTodayBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  SenderPoolDtoOutputNumbersInnerToday build() => _build();

  _$SenderPoolDtoOutputNumbersInnerToday _build() {
    final _$result =
        _$v ??
        _$SenderPoolDtoOutputNumbersInnerToday._(
          sent: BuiltValueNullFieldError.checkNotNull(
            sent,
            r'SenderPoolDtoOutputNumbersInnerToday',
            'sent',
          ),
          failed: BuiltValueNullFieldError.checkNotNull(
            failed,
            r'SenderPoolDtoOutputNumbersInnerToday',
            'failed',
          ),
          delivered: BuiltValueNullFieldError.checkNotNull(
            delivered,
            r'SenderPoolDtoOutputNumbersInnerToday',
            'delivered',
          ),
          read: BuiltValueNullFieldError.checkNotNull(
            read,
            r'SenderPoolDtoOutputNumbersInnerToday',
            'read',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
