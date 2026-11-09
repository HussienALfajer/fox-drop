// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_hours_dto_output_coverage.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantHoursDtoOutputCoverageKindEnum
_$merchantHoursDtoOutputCoverageKindEnum_radius =
    const MerchantHoursDtoOutputCoverageKindEnum._('radius');
const MerchantHoursDtoOutputCoverageKindEnum
_$merchantHoursDtoOutputCoverageKindEnum_zones =
    const MerchantHoursDtoOutputCoverageKindEnum._('zones');

MerchantHoursDtoOutputCoverageKindEnum
_$merchantHoursDtoOutputCoverageKindEnumValueOf(String name) {
  switch (name) {
    case 'radius':
      return _$merchantHoursDtoOutputCoverageKindEnum_radius;
    case 'zones':
      return _$merchantHoursDtoOutputCoverageKindEnum_zones;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MerchantHoursDtoOutputCoverageKindEnum>
_$merchantHoursDtoOutputCoverageKindEnumValues =
    BuiltSet<MerchantHoursDtoOutputCoverageKindEnum>(
      const <MerchantHoursDtoOutputCoverageKindEnum>[
        _$merchantHoursDtoOutputCoverageKindEnum_radius,
        _$merchantHoursDtoOutputCoverageKindEnum_zones,
      ],
    );

Serializer<MerchantHoursDtoOutputCoverageKindEnum>
_$merchantHoursDtoOutputCoverageKindEnumSerializer =
    _$MerchantHoursDtoOutputCoverageKindEnumSerializer();

class _$MerchantHoursDtoOutputCoverageKindEnumSerializer
    implements PrimitiveSerializer<MerchantHoursDtoOutputCoverageKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'radius': 'radius',
    'zones': 'zones',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'radius': 'radius',
    'zones': 'zones',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MerchantHoursDtoOutputCoverageKindEnum,
  ];
  @override
  final String wireName = 'MerchantHoursDtoOutputCoverageKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantHoursDtoOutputCoverageKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantHoursDtoOutputCoverageKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MerchantHoursDtoOutputCoverageKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MerchantHoursDtoOutputCoverage extends MerchantHoursDtoOutputCoverage {
  @override
  final MerchantHoursDtoOutputCoverageKindEnum kind;
  @override
  final int? radiusMetres;
  @override
  final int? zoneCount;

  factory _$MerchantHoursDtoOutputCoverage([
    void Function(MerchantHoursDtoOutputCoverageBuilder)? updates,
  ]) => (MerchantHoursDtoOutputCoverageBuilder()..update(updates))._build();

  _$MerchantHoursDtoOutputCoverage._({
    required this.kind,
    this.radiusMetres,
    this.zoneCount,
  }) : super._();
  @override
  MerchantHoursDtoOutputCoverage rebuild(
    void Function(MerchantHoursDtoOutputCoverageBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantHoursDtoOutputCoverageBuilder toBuilder() =>
      MerchantHoursDtoOutputCoverageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantHoursDtoOutputCoverage &&
        kind == other.kind &&
        radiusMetres == other.radiusMetres &&
        zoneCount == other.zoneCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, radiusMetres.hashCode);
    _$hash = $jc(_$hash, zoneCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantHoursDtoOutputCoverage')
          ..add('kind', kind)
          ..add('radiusMetres', radiusMetres)
          ..add('zoneCount', zoneCount))
        .toString();
  }
}

class MerchantHoursDtoOutputCoverageBuilder
    implements
        Builder<
          MerchantHoursDtoOutputCoverage,
          MerchantHoursDtoOutputCoverageBuilder
        > {
  _$MerchantHoursDtoOutputCoverage? _$v;

  MerchantHoursDtoOutputCoverageKindEnum? _kind;
  MerchantHoursDtoOutputCoverageKindEnum? get kind => _$this._kind;
  set kind(MerchantHoursDtoOutputCoverageKindEnum? kind) => _$this._kind = kind;

  int? _radiusMetres;
  int? get radiusMetres => _$this._radiusMetres;
  set radiusMetres(int? radiusMetres) => _$this._radiusMetres = radiusMetres;

  int? _zoneCount;
  int? get zoneCount => _$this._zoneCount;
  set zoneCount(int? zoneCount) => _$this._zoneCount = zoneCount;

  MerchantHoursDtoOutputCoverageBuilder() {
    MerchantHoursDtoOutputCoverage._defaults(this);
  }

  MerchantHoursDtoOutputCoverageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _radiusMetres = $v.radiusMetres;
      _zoneCount = $v.zoneCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantHoursDtoOutputCoverage other) {
    _$v = other as _$MerchantHoursDtoOutputCoverage;
  }

  @override
  void update(void Function(MerchantHoursDtoOutputCoverageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantHoursDtoOutputCoverage build() => _build();

  _$MerchantHoursDtoOutputCoverage _build() {
    final _$result =
        _$v ??
        _$MerchantHoursDtoOutputCoverage._(
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'MerchantHoursDtoOutputCoverage',
            'kind',
          ),
          radiusMetres: radiusMetres,
          zoneCount: zoneCount,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
