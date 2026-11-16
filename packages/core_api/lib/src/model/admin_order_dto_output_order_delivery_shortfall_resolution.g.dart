// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_delivery_shortfall_resolution.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum
_$adminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum_captain =
    const AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum._(
      'captain',
    );
const AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum
_$adminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum_customer =
    const AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum._(
      'customer',
    );
const AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum
_$adminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum_platform =
    const AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum._(
      'platform',
    );

AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum
_$adminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnumValueOf(
  String name,
) {
  switch (name) {
    case 'captain':
      return _$adminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum_captain;
    case 'customer':
      return _$adminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum_customer;
    case 'platform':
      return _$adminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum_platform;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<
  AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum
>
_$adminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnumValues =
    BuiltSet<
      AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum
    >(const <
      AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum
    >[
      _$adminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum_captain,
      _$adminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum_customer,
      _$adminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum_platform,
    ]);

Serializer<AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum>
_$adminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnumSerializer =
    _$AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnumSerializer();

class _$AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnumSerializer
    implements
        PrimitiveSerializer<
          AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'captain': 'captain',
    'customer': 'customer',
    'platform': 'platform',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'captain': 'captain',
    'customer': 'customer',
    'platform': 'platform',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum,
  ];
  @override
  final String wireName =
      'AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum
  deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum.valueOf(
        _fromWire[serialized] ?? (serialized is String ? serialized : ''),
      );
}

class _$AdminOrderDtoOutputOrderDeliveryShortfallResolution
    extends AdminOrderDtoOutputOrderDeliveryShortfallResolution {
  @override
  final AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum
  responsible;
  @override
  final String note;
  @override
  final DateTime at;
  @override
  final String by;

  factory _$AdminOrderDtoOutputOrderDeliveryShortfallResolution([
    void Function(AdminOrderDtoOutputOrderDeliveryShortfallResolutionBuilder)?
    updates,
  ]) =>
      (AdminOrderDtoOutputOrderDeliveryShortfallResolutionBuilder()
            ..update(updates))
          ._build();

  _$AdminOrderDtoOutputOrderDeliveryShortfallResolution._({
    required this.responsible,
    required this.note,
    required this.at,
    required this.by,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderDeliveryShortfallResolution rebuild(
    void Function(AdminOrderDtoOutputOrderDeliveryShortfallResolutionBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderDeliveryShortfallResolutionBuilder toBuilder() =>
      AdminOrderDtoOutputOrderDeliveryShortfallResolutionBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderDeliveryShortfallResolution &&
        responsible == other.responsible &&
        note == other.note &&
        at == other.at &&
        by == other.by;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, responsible.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, by.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderDeliveryShortfallResolution',
          )
          ..add('responsible', responsible)
          ..add('note', note)
          ..add('at', at)
          ..add('by', by))
        .toString();
  }
}

class AdminOrderDtoOutputOrderDeliveryShortfallResolutionBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderDeliveryShortfallResolution,
          AdminOrderDtoOutputOrderDeliveryShortfallResolutionBuilder
        > {
  _$AdminOrderDtoOutputOrderDeliveryShortfallResolution? _$v;

  AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum?
  _responsible;
  AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum?
  get responsible => _$this._responsible;
  set responsible(
    AdminOrderDtoOutputOrderDeliveryShortfallResolutionResponsibleEnum?
    responsible,
  ) => _$this._responsible = responsible;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  String? _by;
  String? get by => _$this._by;
  set by(String? by) => _$this._by = by;

  AdminOrderDtoOutputOrderDeliveryShortfallResolutionBuilder() {
    AdminOrderDtoOutputOrderDeliveryShortfallResolution._defaults(this);
  }

  AdminOrderDtoOutputOrderDeliveryShortfallResolutionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _responsible = $v.responsible;
      _note = $v.note;
      _at = $v.at;
      _by = $v.by;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderDeliveryShortfallResolution other) {
    _$v = other as _$AdminOrderDtoOutputOrderDeliveryShortfallResolution;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderDeliveryShortfallResolutionBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderDeliveryShortfallResolution build() => _build();

  _$AdminOrderDtoOutputOrderDeliveryShortfallResolution _build() {
    final _$result =
        _$v ??
        _$AdminOrderDtoOutputOrderDeliveryShortfallResolution._(
          responsible: BuiltValueNullFieldError.checkNotNull(
            responsible,
            r'AdminOrderDtoOutputOrderDeliveryShortfallResolution',
            'responsible',
          ),
          note: BuiltValueNullFieldError.checkNotNull(
            note,
            r'AdminOrderDtoOutputOrderDeliveryShortfallResolution',
            'note',
          ),
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'AdminOrderDtoOutputOrderDeliveryShortfallResolution',
            'at',
          ),
          by: BuiltValueNullFieldError.checkNotNull(
            by,
            r'AdminOrderDtoOutputOrderDeliveryShortfallResolution',
            'by',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
