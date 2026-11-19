// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_search_results_dto_output_tickets_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSearchResultsDtoOutputTicketsInnerStatusEnum
_$adminSearchResultsDtoOutputTicketsInnerStatusEnum_new_ =
    const AdminSearchResultsDtoOutputTicketsInnerStatusEnum._('new_');
const AdminSearchResultsDtoOutputTicketsInnerStatusEnum
_$adminSearchResultsDtoOutputTicketsInnerStatusEnum_inProgress =
    const AdminSearchResultsDtoOutputTicketsInnerStatusEnum._('inProgress');
const AdminSearchResultsDtoOutputTicketsInnerStatusEnum
_$adminSearchResultsDtoOutputTicketsInnerStatusEnum_waiting =
    const AdminSearchResultsDtoOutputTicketsInnerStatusEnum._('waiting');
const AdminSearchResultsDtoOutputTicketsInnerStatusEnum
_$adminSearchResultsDtoOutputTicketsInnerStatusEnum_resolved =
    const AdminSearchResultsDtoOutputTicketsInnerStatusEnum._('resolved');
const AdminSearchResultsDtoOutputTicketsInnerStatusEnum
_$adminSearchResultsDtoOutputTicketsInnerStatusEnum_closed =
    const AdminSearchResultsDtoOutputTicketsInnerStatusEnum._('closed');

AdminSearchResultsDtoOutputTicketsInnerStatusEnum
_$adminSearchResultsDtoOutputTicketsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'new_':
      return _$adminSearchResultsDtoOutputTicketsInnerStatusEnum_new_;
    case 'inProgress':
      return _$adminSearchResultsDtoOutputTicketsInnerStatusEnum_inProgress;
    case 'waiting':
      return _$adminSearchResultsDtoOutputTicketsInnerStatusEnum_waiting;
    case 'resolved':
      return _$adminSearchResultsDtoOutputTicketsInnerStatusEnum_resolved;
    case 'closed':
      return _$adminSearchResultsDtoOutputTicketsInnerStatusEnum_closed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSearchResultsDtoOutputTicketsInnerStatusEnum>
_$adminSearchResultsDtoOutputTicketsInnerStatusEnumValues =
    BuiltSet<AdminSearchResultsDtoOutputTicketsInnerStatusEnum>(
      const <AdminSearchResultsDtoOutputTicketsInnerStatusEnum>[
        _$adminSearchResultsDtoOutputTicketsInnerStatusEnum_new_,
        _$adminSearchResultsDtoOutputTicketsInnerStatusEnum_inProgress,
        _$adminSearchResultsDtoOutputTicketsInnerStatusEnum_waiting,
        _$adminSearchResultsDtoOutputTicketsInnerStatusEnum_resolved,
        _$adminSearchResultsDtoOutputTicketsInnerStatusEnum_closed,
      ],
    );

Serializer<AdminSearchResultsDtoOutputTicketsInnerStatusEnum>
_$adminSearchResultsDtoOutputTicketsInnerStatusEnumSerializer =
    _$AdminSearchResultsDtoOutputTicketsInnerStatusEnumSerializer();

class _$AdminSearchResultsDtoOutputTicketsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminSearchResultsDtoOutputTicketsInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'new_': 'new',
    'inProgress': 'in_progress',
    'waiting': 'waiting',
    'resolved': 'resolved',
    'closed': 'closed',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'new': 'new_',
    'in_progress': 'inProgress',
    'waiting': 'waiting',
    'resolved': 'resolved',
    'closed': 'closed',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminSearchResultsDtoOutputTicketsInnerStatusEnum,
  ];
  @override
  final String wireName = 'AdminSearchResultsDtoOutputTicketsInnerStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminSearchResultsDtoOutputTicketsInnerStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminSearchResultsDtoOutputTicketsInnerStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminSearchResultsDtoOutputTicketsInnerStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminSearchResultsDtoOutputTicketsInner
    extends AdminSearchResultsDtoOutputTicketsInner {
  @override
  final String id;
  @override
  final String number;
  @override
  final AdminSearchResultsDtoOutputTicketsInnerStatusEnum status;

  factory _$AdminSearchResultsDtoOutputTicketsInner([
    void Function(AdminSearchResultsDtoOutputTicketsInnerBuilder)? updates,
  ]) => (AdminSearchResultsDtoOutputTicketsInnerBuilder()..update(updates))
      ._build();

  _$AdminSearchResultsDtoOutputTicketsInner._({
    required this.id,
    required this.number,
    required this.status,
  }) : super._();
  @override
  AdminSearchResultsDtoOutputTicketsInner rebuild(
    void Function(AdminSearchResultsDtoOutputTicketsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSearchResultsDtoOutputTicketsInnerBuilder toBuilder() =>
      AdminSearchResultsDtoOutputTicketsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSearchResultsDtoOutputTicketsInner &&
        id == other.id &&
        number == other.number &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminSearchResultsDtoOutputTicketsInner',
          )
          ..add('id', id)
          ..add('number', number)
          ..add('status', status))
        .toString();
  }
}

class AdminSearchResultsDtoOutputTicketsInnerBuilder
    implements
        Builder<
          AdminSearchResultsDtoOutputTicketsInner,
          AdminSearchResultsDtoOutputTicketsInnerBuilder
        > {
  _$AdminSearchResultsDtoOutputTicketsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  AdminSearchResultsDtoOutputTicketsInnerStatusEnum? _status;
  AdminSearchResultsDtoOutputTicketsInnerStatusEnum? get status =>
      _$this._status;
  set status(AdminSearchResultsDtoOutputTicketsInnerStatusEnum? status) =>
      _$this._status = status;

  AdminSearchResultsDtoOutputTicketsInnerBuilder() {
    AdminSearchResultsDtoOutputTicketsInner._defaults(this);
  }

  AdminSearchResultsDtoOutputTicketsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _number = $v.number;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSearchResultsDtoOutputTicketsInner other) {
    _$v = other as _$AdminSearchResultsDtoOutputTicketsInner;
  }

  @override
  void update(
    void Function(AdminSearchResultsDtoOutputTicketsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminSearchResultsDtoOutputTicketsInner build() => _build();

  _$AdminSearchResultsDtoOutputTicketsInner _build() {
    final _$result =
        _$v ??
        _$AdminSearchResultsDtoOutputTicketsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminSearchResultsDtoOutputTicketsInner',
            'id',
          ),
          number: BuiltValueNullFieldError.checkNotNull(
            number,
            r'AdminSearchResultsDtoOutputTicketsInner',
            'number',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'AdminSearchResultsDtoOutputTicketsInner',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
