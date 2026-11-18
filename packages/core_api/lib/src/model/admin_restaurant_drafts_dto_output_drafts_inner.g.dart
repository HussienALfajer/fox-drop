// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_drafts_dto_output_drafts_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum
_$adminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum_draft =
    const AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum._('draft');
const AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum
_$adminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum_test =
    const AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum._('test');

AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum
_$adminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnumValueOf(
  String name,
) {
  switch (name) {
    case 'draft':
      return _$adminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum_draft;
    case 'test':
      return _$adminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum_test;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum>
_$adminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnumValues =
    BuiltSet<AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum>(
      const <AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum>[
        _$adminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum_draft,
        _$adminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum_test,
      ],
    );

Serializer<AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum>
_$adminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnumSerializer =
    _$AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnumSerializer();

class _$AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnumSerializer
    implements
        PrimitiveSerializer<
          AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'draft': 'draft',
    'test': 'test',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'draft': 'draft',
    'test': 'test',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum,
  ];
  @override
  final String wireName =
      'AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminRestaurantDraftsDtoOutputDraftsInner
    extends AdminRestaurantDraftsDtoOutputDraftsInner {
  @override
  final String id;
  @override
  final String nameAr;
  @override
  final AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum
  accountStatus;
  @override
  final AdminRestaurantDraftsDtoOutputDraftsInnerSteps steps;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$AdminRestaurantDraftsDtoOutputDraftsInner([
    void Function(AdminRestaurantDraftsDtoOutputDraftsInnerBuilder)? updates,
  ]) => (AdminRestaurantDraftsDtoOutputDraftsInnerBuilder()..update(updates))
      ._build();

  _$AdminRestaurantDraftsDtoOutputDraftsInner._({
    required this.id,
    required this.nameAr,
    required this.accountStatus,
    required this.steps,
    required this.createdAt,
    required this.updatedAt,
  }) : super._();
  @override
  AdminRestaurantDraftsDtoOutputDraftsInner rebuild(
    void Function(AdminRestaurantDraftsDtoOutputDraftsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantDraftsDtoOutputDraftsInnerBuilder toBuilder() =>
      AdminRestaurantDraftsDtoOutputDraftsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantDraftsDtoOutputDraftsInner &&
        id == other.id &&
        nameAr == other.nameAr &&
        accountStatus == other.accountStatus &&
        steps == other.steps &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, nameAr.hashCode);
    _$hash = $jc(_$hash, accountStatus.hashCode);
    _$hash = $jc(_$hash, steps.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantDraftsDtoOutputDraftsInner',
          )
          ..add('id', id)
          ..add('nameAr', nameAr)
          ..add('accountStatus', accountStatus)
          ..add('steps', steps)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class AdminRestaurantDraftsDtoOutputDraftsInnerBuilder
    implements
        Builder<
          AdminRestaurantDraftsDtoOutputDraftsInner,
          AdminRestaurantDraftsDtoOutputDraftsInnerBuilder
        > {
  _$AdminRestaurantDraftsDtoOutputDraftsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _nameAr;
  String? get nameAr => _$this._nameAr;
  set nameAr(String? nameAr) => _$this._nameAr = nameAr;

  AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum? _accountStatus;
  AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum?
  get accountStatus => _$this._accountStatus;
  set accountStatus(
    AdminRestaurantDraftsDtoOutputDraftsInnerAccountStatusEnum? accountStatus,
  ) => _$this._accountStatus = accountStatus;

  AdminRestaurantDraftsDtoOutputDraftsInnerStepsBuilder? _steps;
  AdminRestaurantDraftsDtoOutputDraftsInnerStepsBuilder get steps =>
      _$this._steps ??= AdminRestaurantDraftsDtoOutputDraftsInnerStepsBuilder();
  set steps(AdminRestaurantDraftsDtoOutputDraftsInnerStepsBuilder? steps) =>
      _$this._steps = steps;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  AdminRestaurantDraftsDtoOutputDraftsInnerBuilder() {
    AdminRestaurantDraftsDtoOutputDraftsInner._defaults(this);
  }

  AdminRestaurantDraftsDtoOutputDraftsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _nameAr = $v.nameAr;
      _accountStatus = $v.accountStatus;
      _steps = $v.steps.toBuilder();
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantDraftsDtoOutputDraftsInner other) {
    _$v = other as _$AdminRestaurantDraftsDtoOutputDraftsInner;
  }

  @override
  void update(
    void Function(AdminRestaurantDraftsDtoOutputDraftsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantDraftsDtoOutputDraftsInner build() => _build();

  _$AdminRestaurantDraftsDtoOutputDraftsInner _build() {
    _$AdminRestaurantDraftsDtoOutputDraftsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantDraftsDtoOutputDraftsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminRestaurantDraftsDtoOutputDraftsInner',
              'id',
            ),
            nameAr: BuiltValueNullFieldError.checkNotNull(
              nameAr,
              r'AdminRestaurantDraftsDtoOutputDraftsInner',
              'nameAr',
            ),
            accountStatus: BuiltValueNullFieldError.checkNotNull(
              accountStatus,
              r'AdminRestaurantDraftsDtoOutputDraftsInner',
              'accountStatus',
            ),
            steps: steps.build(),
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'AdminRestaurantDraftsDtoOutputDraftsInner',
              'createdAt',
            ),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt,
              r'AdminRestaurantDraftsDtoOutputDraftsInner',
              'updatedAt',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'steps';
        steps.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantDraftsDtoOutputDraftsInner',
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
