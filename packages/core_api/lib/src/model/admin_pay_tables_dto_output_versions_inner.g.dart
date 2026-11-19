// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_pay_tables_dto_output_versions_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminPayTablesDtoOutputVersionsInnerStateEnum
_$adminPayTablesDtoOutputVersionsInnerStateEnum_inForce =
    const AdminPayTablesDtoOutputVersionsInnerStateEnum._('inForce');
const AdminPayTablesDtoOutputVersionsInnerStateEnum
_$adminPayTablesDtoOutputVersionsInnerStateEnum_announced =
    const AdminPayTablesDtoOutputVersionsInnerStateEnum._('announced');
const AdminPayTablesDtoOutputVersionsInnerStateEnum
_$adminPayTablesDtoOutputVersionsInnerStateEnum_replaced =
    const AdminPayTablesDtoOutputVersionsInnerStateEnum._('replaced');
const AdminPayTablesDtoOutputVersionsInnerStateEnum
_$adminPayTablesDtoOutputVersionsInnerStateEnum_ended =
    const AdminPayTablesDtoOutputVersionsInnerStateEnum._('ended');

AdminPayTablesDtoOutputVersionsInnerStateEnum
_$adminPayTablesDtoOutputVersionsInnerStateEnumValueOf(String name) {
  switch (name) {
    case 'inForce':
      return _$adminPayTablesDtoOutputVersionsInnerStateEnum_inForce;
    case 'announced':
      return _$adminPayTablesDtoOutputVersionsInnerStateEnum_announced;
    case 'replaced':
      return _$adminPayTablesDtoOutputVersionsInnerStateEnum_replaced;
    case 'ended':
      return _$adminPayTablesDtoOutputVersionsInnerStateEnum_ended;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminPayTablesDtoOutputVersionsInnerStateEnum>
_$adminPayTablesDtoOutputVersionsInnerStateEnumValues =
    BuiltSet<AdminPayTablesDtoOutputVersionsInnerStateEnum>(
      const <AdminPayTablesDtoOutputVersionsInnerStateEnum>[
        _$adminPayTablesDtoOutputVersionsInnerStateEnum_inForce,
        _$adminPayTablesDtoOutputVersionsInnerStateEnum_announced,
        _$adminPayTablesDtoOutputVersionsInnerStateEnum_replaced,
        _$adminPayTablesDtoOutputVersionsInnerStateEnum_ended,
      ],
    );

Serializer<AdminPayTablesDtoOutputVersionsInnerStateEnum>
_$adminPayTablesDtoOutputVersionsInnerStateEnumSerializer =
    _$AdminPayTablesDtoOutputVersionsInnerStateEnumSerializer();

class _$AdminPayTablesDtoOutputVersionsInnerStateEnumSerializer
    implements
        PrimitiveSerializer<AdminPayTablesDtoOutputVersionsInnerStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'inForce': 'in_force',
    'announced': 'announced',
    'replaced': 'replaced',
    'ended': 'ended',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'in_force': 'inForce',
    'announced': 'announced',
    'replaced': 'replaced',
    'ended': 'ended',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminPayTablesDtoOutputVersionsInnerStateEnum,
  ];
  @override
  final String wireName = 'AdminPayTablesDtoOutputVersionsInnerStateEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminPayTablesDtoOutputVersionsInnerStateEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminPayTablesDtoOutputVersionsInnerStateEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminPayTablesDtoOutputVersionsInnerStateEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminPayTablesDtoOutputVersionsInner
    extends AdminPayTablesDtoOutputVersionsInner {
  @override
  final String id;
  @override
  final AdminPayTablesDtoOutputVersionsInnerStateEnum state;
  @override
  final String currency;
  @override
  final DateTime effectiveFrom;
  @override
  final BuiltList<AdminPayTablesDtoOutputVersionsInnerRatesInner> rates;
  @override
  final String? editorName;
  @override
  final String? reason;
  @override
  final DateTime createdAt;

  factory _$AdminPayTablesDtoOutputVersionsInner([
    void Function(AdminPayTablesDtoOutputVersionsInnerBuilder)? updates,
  ]) =>
      (AdminPayTablesDtoOutputVersionsInnerBuilder()..update(updates))._build();

  _$AdminPayTablesDtoOutputVersionsInner._({
    required this.id,
    required this.state,
    required this.currency,
    required this.effectiveFrom,
    required this.rates,
    this.editorName,
    this.reason,
    required this.createdAt,
  }) : super._();
  @override
  AdminPayTablesDtoOutputVersionsInner rebuild(
    void Function(AdminPayTablesDtoOutputVersionsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPayTablesDtoOutputVersionsInnerBuilder toBuilder() =>
      AdminPayTablesDtoOutputVersionsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPayTablesDtoOutputVersionsInner &&
        id == other.id &&
        state == other.state &&
        currency == other.currency &&
        effectiveFrom == other.effectiveFrom &&
        rates == other.rates &&
        editorName == other.editorName &&
        reason == other.reason &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, effectiveFrom.hashCode);
    _$hash = $jc(_$hash, rates.hashCode);
    _$hash = $jc(_$hash, editorName.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminPayTablesDtoOutputVersionsInner')
          ..add('id', id)
          ..add('state', state)
          ..add('currency', currency)
          ..add('effectiveFrom', effectiveFrom)
          ..add('rates', rates)
          ..add('editorName', editorName)
          ..add('reason', reason)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class AdminPayTablesDtoOutputVersionsInnerBuilder
    implements
        Builder<
          AdminPayTablesDtoOutputVersionsInner,
          AdminPayTablesDtoOutputVersionsInnerBuilder
        > {
  _$AdminPayTablesDtoOutputVersionsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  AdminPayTablesDtoOutputVersionsInnerStateEnum? _state;
  AdminPayTablesDtoOutputVersionsInnerStateEnum? get state => _$this._state;
  set state(AdminPayTablesDtoOutputVersionsInnerStateEnum? state) =>
      _$this._state = state;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  DateTime? _effectiveFrom;
  DateTime? get effectiveFrom => _$this._effectiveFrom;
  set effectiveFrom(DateTime? effectiveFrom) =>
      _$this._effectiveFrom = effectiveFrom;

  ListBuilder<AdminPayTablesDtoOutputVersionsInnerRatesInner>? _rates;
  ListBuilder<AdminPayTablesDtoOutputVersionsInnerRatesInner> get rates =>
      _$this._rates ??=
          ListBuilder<AdminPayTablesDtoOutputVersionsInnerRatesInner>();
  set rates(
    ListBuilder<AdminPayTablesDtoOutputVersionsInnerRatesInner>? rates,
  ) => _$this._rates = rates;

  String? _editorName;
  String? get editorName => _$this._editorName;
  set editorName(String? editorName) => _$this._editorName = editorName;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  AdminPayTablesDtoOutputVersionsInnerBuilder() {
    AdminPayTablesDtoOutputVersionsInner._defaults(this);
  }

  AdminPayTablesDtoOutputVersionsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _state = $v.state;
      _currency = $v.currency;
      _effectiveFrom = $v.effectiveFrom;
      _rates = $v.rates.toBuilder();
      _editorName = $v.editorName;
      _reason = $v.reason;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPayTablesDtoOutputVersionsInner other) {
    _$v = other as _$AdminPayTablesDtoOutputVersionsInner;
  }

  @override
  void update(
    void Function(AdminPayTablesDtoOutputVersionsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminPayTablesDtoOutputVersionsInner build() => _build();

  _$AdminPayTablesDtoOutputVersionsInner _build() {
    _$AdminPayTablesDtoOutputVersionsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminPayTablesDtoOutputVersionsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminPayTablesDtoOutputVersionsInner',
              'id',
            ),
            state: BuiltValueNullFieldError.checkNotNull(
              state,
              r'AdminPayTablesDtoOutputVersionsInner',
              'state',
            ),
            currency: BuiltValueNullFieldError.checkNotNull(
              currency,
              r'AdminPayTablesDtoOutputVersionsInner',
              'currency',
            ),
            effectiveFrom: BuiltValueNullFieldError.checkNotNull(
              effectiveFrom,
              r'AdminPayTablesDtoOutputVersionsInner',
              'effectiveFrom',
            ),
            rates: rates.build(),
            editorName: editorName,
            reason: reason,
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'AdminPayTablesDtoOutputVersionsInner',
              'createdAt',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rates';
        rates.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminPayTablesDtoOutputVersionsInner',
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
