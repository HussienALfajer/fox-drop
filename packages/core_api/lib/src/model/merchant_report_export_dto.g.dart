// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_report_export_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantReportExportDtoPeriodEnum
_$merchantReportExportDtoPeriodEnum_today =
    const MerchantReportExportDtoPeriodEnum._('today');
const MerchantReportExportDtoPeriodEnum
_$merchantReportExportDtoPeriodEnum_yesterday =
    const MerchantReportExportDtoPeriodEnum._('yesterday');
const MerchantReportExportDtoPeriodEnum
_$merchantReportExportDtoPeriodEnum_last7Days =
    const MerchantReportExportDtoPeriodEnum._('last7Days');
const MerchantReportExportDtoPeriodEnum
_$merchantReportExportDtoPeriodEnum_last30Days =
    const MerchantReportExportDtoPeriodEnum._('last30Days');

MerchantReportExportDtoPeriodEnum _$merchantReportExportDtoPeriodEnumValueOf(
  String name,
) {
  switch (name) {
    case 'today':
      return _$merchantReportExportDtoPeriodEnum_today;
    case 'yesterday':
      return _$merchantReportExportDtoPeriodEnum_yesterday;
    case 'last7Days':
      return _$merchantReportExportDtoPeriodEnum_last7Days;
    case 'last30Days':
      return _$merchantReportExportDtoPeriodEnum_last30Days;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantReportExportDtoPeriodEnum>
_$merchantReportExportDtoPeriodEnumValues =
    BuiltSet<MerchantReportExportDtoPeriodEnum>(
      const <MerchantReportExportDtoPeriodEnum>[
        _$merchantReportExportDtoPeriodEnum_today,
        _$merchantReportExportDtoPeriodEnum_yesterday,
        _$merchantReportExportDtoPeriodEnum_last7Days,
        _$merchantReportExportDtoPeriodEnum_last30Days,
      ],
    );

Serializer<MerchantReportExportDtoPeriodEnum>
_$merchantReportExportDtoPeriodEnumSerializer =
    _$MerchantReportExportDtoPeriodEnumSerializer();

class _$MerchantReportExportDtoPeriodEnumSerializer
    implements PrimitiveSerializer<MerchantReportExportDtoPeriodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'today': 'today',
    'yesterday': 'yesterday',
    'last7Days': 'last_7_days',
    'last30Days': 'last_30_days',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'today': 'today',
    'yesterday': 'yesterday',
    'last_7_days': 'last7Days',
    'last_30_days': 'last30Days',
  };

  @override
  final Iterable<Type> types = const <Type>[MerchantReportExportDtoPeriodEnum];
  @override
  final String wireName = 'MerchantReportExportDtoPeriodEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantReportExportDtoPeriodEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantReportExportDtoPeriodEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantReportExportDtoPeriodEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantReportExportDto extends MerchantReportExportDto {
  @override
  final MerchantReportExportDtoPeriodEnum? period;
  @override
  final String? from;
  @override
  final String? to;

  factory _$MerchantReportExportDto([
    void Function(MerchantReportExportDtoBuilder)? updates,
  ]) => (MerchantReportExportDtoBuilder()..update(updates))._build();

  _$MerchantReportExportDto._({this.period, this.from, this.to}) : super._();
  @override
  MerchantReportExportDto rebuild(
    void Function(MerchantReportExportDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantReportExportDtoBuilder toBuilder() =>
      MerchantReportExportDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantReportExportDto &&
        period == other.period &&
        from == other.from &&
        to == other.to;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, period.hashCode);
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantReportExportDto')
          ..add('period', period)
          ..add('from', from)
          ..add('to', to))
        .toString();
  }
}

class MerchantReportExportDtoBuilder
    implements
        Builder<MerchantReportExportDto, MerchantReportExportDtoBuilder> {
  _$MerchantReportExportDto? _$v;

  MerchantReportExportDtoPeriodEnum? _period;
  MerchantReportExportDtoPeriodEnum? get period => _$this._period;
  set period(MerchantReportExportDtoPeriodEnum? period) =>
      _$this._period = period;

  String? _from;
  String? get from => _$this._from;
  set from(String? from) => _$this._from = from;

  String? _to;
  String? get to => _$this._to;
  set to(String? to) => _$this._to = to;

  MerchantReportExportDtoBuilder() {
    MerchantReportExportDto._defaults(this);
  }

  MerchantReportExportDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _period = $v.period;
      _from = $v.from;
      _to = $v.to;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantReportExportDto other) {
    _$v = other as _$MerchantReportExportDto;
  }

  @override
  void update(void Function(MerchantReportExportDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantReportExportDto build() => _build();

  _$MerchantReportExportDto _build() {
    final _$result =
        _$v ?? _$MerchantReportExportDto._(period: period, from: from, to: to);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
