// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_report_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminReportDtoOutputReportEnum _$adminReportDtoOutputReportEnum_orders =
    const AdminReportDtoOutputReportEnum._('orders');
const AdminReportDtoOutputReportEnum _$adminReportDtoOutputReportEnum_timings =
    const AdminReportDtoOutputReportEnum._('timings');
const AdminReportDtoOutputReportEnum
_$adminReportDtoOutputReportEnum_restaurants =
    const AdminReportDtoOutputReportEnum._('restaurants');
const AdminReportDtoOutputReportEnum _$adminReportDtoOutputReportEnum_captains =
    const AdminReportDtoOutputReportEnum._('captains');
const AdminReportDtoOutputReportEnum
_$adminReportDtoOutputReportEnum_customers =
    const AdminReportDtoOutputReportEnum._('customers');
const AdminReportDtoOutputReportEnum
_$adminReportDtoOutputReportEnum_lostDemand =
    const AdminReportDtoOutputReportEnum._('lostDemand');
const AdminReportDtoOutputReportEnum _$adminReportDtoOutputReportEnum_codes =
    const AdminReportDtoOutputReportEnum._('codes');
const AdminReportDtoOutputReportEnum _$adminReportDtoOutputReportEnum_finance =
    const AdminReportDtoOutputReportEnum._('finance');

AdminReportDtoOutputReportEnum _$adminReportDtoOutputReportEnumValueOf(
  String name,
) {
  switch (name) {
    case 'orders':
      return _$adminReportDtoOutputReportEnum_orders;
    case 'timings':
      return _$adminReportDtoOutputReportEnum_timings;
    case 'restaurants':
      return _$adminReportDtoOutputReportEnum_restaurants;
    case 'captains':
      return _$adminReportDtoOutputReportEnum_captains;
    case 'customers':
      return _$adminReportDtoOutputReportEnum_customers;
    case 'lostDemand':
      return _$adminReportDtoOutputReportEnum_lostDemand;
    case 'codes':
      return _$adminReportDtoOutputReportEnum_codes;
    case 'finance':
      return _$adminReportDtoOutputReportEnum_finance;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminReportDtoOutputReportEnum>
_$adminReportDtoOutputReportEnumValues =
    BuiltSet<AdminReportDtoOutputReportEnum>(
      const <AdminReportDtoOutputReportEnum>[
        _$adminReportDtoOutputReportEnum_orders,
        _$adminReportDtoOutputReportEnum_timings,
        _$adminReportDtoOutputReportEnum_restaurants,
        _$adminReportDtoOutputReportEnum_captains,
        _$adminReportDtoOutputReportEnum_customers,
        _$adminReportDtoOutputReportEnum_lostDemand,
        _$adminReportDtoOutputReportEnum_codes,
        _$adminReportDtoOutputReportEnum_finance,
      ],
    );

Serializer<AdminReportDtoOutputReportEnum>
_$adminReportDtoOutputReportEnumSerializer =
    _$AdminReportDtoOutputReportEnumSerializer();

class _$AdminReportDtoOutputReportEnumSerializer
    implements PrimitiveSerializer<AdminReportDtoOutputReportEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'orders': 'orders',
    'timings': 'timings',
    'restaurants': 'restaurants',
    'captains': 'captains',
    'customers': 'customers',
    'lostDemand': 'lost_demand',
    'codes': 'codes',
    'finance': 'finance',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'orders': 'orders',
    'timings': 'timings',
    'restaurants': 'restaurants',
    'captains': 'captains',
    'customers': 'customers',
    'lost_demand': 'lostDemand',
    'codes': 'codes',
    'finance': 'finance',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminReportDtoOutputReportEnum];
  @override
  final String wireName = 'AdminReportDtoOutputReportEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminReportDtoOutputReportEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminReportDtoOutputReportEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminReportDtoOutputReportEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminReportDtoOutput extends AdminReportDtoOutput {
  @override
  final AdminReportDtoOutputReportEnum report;
  @override
  final String cityId;
  @override
  final String fromDay;
  @override
  final String toDay;
  @override
  final DateTime from;
  @override
  final DateTime to;
  @override
  final String currency;
  @override
  final BuiltList<AdminReportDtoOutputTablesInner> tables;

  factory _$AdminReportDtoOutput([
    void Function(AdminReportDtoOutputBuilder)? updates,
  ]) => (AdminReportDtoOutputBuilder()..update(updates))._build();

  _$AdminReportDtoOutput._({
    required this.report,
    required this.cityId,
    required this.fromDay,
    required this.toDay,
    required this.from,
    required this.to,
    required this.currency,
    required this.tables,
  }) : super._();
  @override
  AdminReportDtoOutput rebuild(
    void Function(AdminReportDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminReportDtoOutputBuilder toBuilder() =>
      AdminReportDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminReportDtoOutput &&
        report == other.report &&
        cityId == other.cityId &&
        fromDay == other.fromDay &&
        toDay == other.toDay &&
        from == other.from &&
        to == other.to &&
        currency == other.currency &&
        tables == other.tables;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, report.hashCode);
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, fromDay.hashCode);
    _$hash = $jc(_$hash, toDay.hashCode);
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, tables.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminReportDtoOutput')
          ..add('report', report)
          ..add('cityId', cityId)
          ..add('fromDay', fromDay)
          ..add('toDay', toDay)
          ..add('from', from)
          ..add('to', to)
          ..add('currency', currency)
          ..add('tables', tables))
        .toString();
  }
}

class AdminReportDtoOutputBuilder
    implements Builder<AdminReportDtoOutput, AdminReportDtoOutputBuilder> {
  _$AdminReportDtoOutput? _$v;

  AdminReportDtoOutputReportEnum? _report;
  AdminReportDtoOutputReportEnum? get report => _$this._report;
  set report(AdminReportDtoOutputReportEnum? report) => _$this._report = report;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _fromDay;
  String? get fromDay => _$this._fromDay;
  set fromDay(String? fromDay) => _$this._fromDay = fromDay;

  String? _toDay;
  String? get toDay => _$this._toDay;
  set toDay(String? toDay) => _$this._toDay = toDay;

  DateTime? _from;
  DateTime? get from => _$this._from;
  set from(DateTime? from) => _$this._from = from;

  DateTime? _to;
  DateTime? get to => _$this._to;
  set to(DateTime? to) => _$this._to = to;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  ListBuilder<AdminReportDtoOutputTablesInner>? _tables;
  ListBuilder<AdminReportDtoOutputTablesInner> get tables =>
      _$this._tables ??= ListBuilder<AdminReportDtoOutputTablesInner>();
  set tables(ListBuilder<AdminReportDtoOutputTablesInner>? tables) =>
      _$this._tables = tables;

  AdminReportDtoOutputBuilder() {
    AdminReportDtoOutput._defaults(this);
  }

  AdminReportDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _report = $v.report;
      _cityId = $v.cityId;
      _fromDay = $v.fromDay;
      _toDay = $v.toDay;
      _from = $v.from;
      _to = $v.to;
      _currency = $v.currency;
      _tables = $v.tables.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminReportDtoOutput other) {
    _$v = other as _$AdminReportDtoOutput;
  }

  @override
  void update(void Function(AdminReportDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminReportDtoOutput build() => _build();

  _$AdminReportDtoOutput _build() {
    _$AdminReportDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminReportDtoOutput._(
            report: BuiltValueNullFieldError.checkNotNull(
              report,
              r'AdminReportDtoOutput',
              'report',
            ),
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminReportDtoOutput',
              'cityId',
            ),
            fromDay: BuiltValueNullFieldError.checkNotNull(
              fromDay,
              r'AdminReportDtoOutput',
              'fromDay',
            ),
            toDay: BuiltValueNullFieldError.checkNotNull(
              toDay,
              r'AdminReportDtoOutput',
              'toDay',
            ),
            from: BuiltValueNullFieldError.checkNotNull(
              from,
              r'AdminReportDtoOutput',
              'from',
            ),
            to: BuiltValueNullFieldError.checkNotNull(
              to,
              r'AdminReportDtoOutput',
              'to',
            ),
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminReportDtoOutput',
              'currency',
            ),
            tables: tables.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tables';
        tables.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminReportDtoOutput',
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
