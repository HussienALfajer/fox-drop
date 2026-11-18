// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminMenuDtoOutputAccountStatusEnum
_$adminMenuDtoOutputAccountStatusEnum_draft =
    const AdminMenuDtoOutputAccountStatusEnum._('draft');
const AdminMenuDtoOutputAccountStatusEnum
_$adminMenuDtoOutputAccountStatusEnum_test =
    const AdminMenuDtoOutputAccountStatusEnum._('test');
const AdminMenuDtoOutputAccountStatusEnum
_$adminMenuDtoOutputAccountStatusEnum_active =
    const AdminMenuDtoOutputAccountStatusEnum._('active');
const AdminMenuDtoOutputAccountStatusEnum
_$adminMenuDtoOutputAccountStatusEnum_suspended =
    const AdminMenuDtoOutputAccountStatusEnum._('suspended');
const AdminMenuDtoOutputAccountStatusEnum
_$adminMenuDtoOutputAccountStatusEnum_terminated =
    const AdminMenuDtoOutputAccountStatusEnum._('terminated');

AdminMenuDtoOutputAccountStatusEnum
_$adminMenuDtoOutputAccountStatusEnumValueOf(String name) {
  switch (name) {
    case 'draft':
      return _$adminMenuDtoOutputAccountStatusEnum_draft;
    case 'test':
      return _$adminMenuDtoOutputAccountStatusEnum_test;
    case 'active':
      return _$adminMenuDtoOutputAccountStatusEnum_active;
    case 'suspended':
      return _$adminMenuDtoOutputAccountStatusEnum_suspended;
    case 'terminated':
      return _$adminMenuDtoOutputAccountStatusEnum_terminated;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminMenuDtoOutputAccountStatusEnum>
_$adminMenuDtoOutputAccountStatusEnumValues =
    BuiltSet<AdminMenuDtoOutputAccountStatusEnum>(
      const <AdminMenuDtoOutputAccountStatusEnum>[
        _$adminMenuDtoOutputAccountStatusEnum_draft,
        _$adminMenuDtoOutputAccountStatusEnum_test,
        _$adminMenuDtoOutputAccountStatusEnum_active,
        _$adminMenuDtoOutputAccountStatusEnum_suspended,
        _$adminMenuDtoOutputAccountStatusEnum_terminated,
      ],
    );

Serializer<AdminMenuDtoOutputAccountStatusEnum>
_$adminMenuDtoOutputAccountStatusEnumSerializer =
    _$AdminMenuDtoOutputAccountStatusEnumSerializer();

class _$AdminMenuDtoOutputAccountStatusEnumSerializer
    implements PrimitiveSerializer<AdminMenuDtoOutputAccountStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'draft': 'draft',
    'test': 'test',
    'active': 'active',
    'suspended': 'suspended',
    'terminated': 'terminated',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'draft': 'draft',
    'test': 'test',
    'active': 'active',
    'suspended': 'suspended',
    'terminated': 'terminated',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminMenuDtoOutputAccountStatusEnum,
  ];
  @override
  final String wireName = 'AdminMenuDtoOutputAccountStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuDtoOutputAccountStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminMenuDtoOutputAccountStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminMenuDtoOutputAccountStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminMenuDtoOutput extends AdminMenuDtoOutput {
  @override
  final AdminMenuDtoOutputAccountStatusEnum accountStatus;
  @override
  final bool editable;
  @override
  final int nameMax;
  @override
  final int descriptionMax;
  @override
  final int codeMax;
  @override
  final BuiltList<AdminMenuDtoOutputCategoriesInner> categories;

  factory _$AdminMenuDtoOutput([
    void Function(AdminMenuDtoOutputBuilder)? updates,
  ]) => (AdminMenuDtoOutputBuilder()..update(updates))._build();

  _$AdminMenuDtoOutput._({
    required this.accountStatus,
    required this.editable,
    required this.nameMax,
    required this.descriptionMax,
    required this.codeMax,
    required this.categories,
  }) : super._();
  @override
  AdminMenuDtoOutput rebuild(
    void Function(AdminMenuDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuDtoOutputBuilder toBuilder() =>
      AdminMenuDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuDtoOutput &&
        accountStatus == other.accountStatus &&
        editable == other.editable &&
        nameMax == other.nameMax &&
        descriptionMax == other.descriptionMax &&
        codeMax == other.codeMax &&
        categories == other.categories;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accountStatus.hashCode);
    _$hash = $jc(_$hash, editable.hashCode);
    _$hash = $jc(_$hash, nameMax.hashCode);
    _$hash = $jc(_$hash, descriptionMax.hashCode);
    _$hash = $jc(_$hash, codeMax.hashCode);
    _$hash = $jc(_$hash, categories.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminMenuDtoOutput')
          ..add('accountStatus', accountStatus)
          ..add('editable', editable)
          ..add('nameMax', nameMax)
          ..add('descriptionMax', descriptionMax)
          ..add('codeMax', codeMax)
          ..add('categories', categories))
        .toString();
  }
}

class AdminMenuDtoOutputBuilder
    implements Builder<AdminMenuDtoOutput, AdminMenuDtoOutputBuilder> {
  _$AdminMenuDtoOutput? _$v;

  AdminMenuDtoOutputAccountStatusEnum? _accountStatus;
  AdminMenuDtoOutputAccountStatusEnum? get accountStatus =>
      _$this._accountStatus;
  set accountStatus(AdminMenuDtoOutputAccountStatusEnum? accountStatus) =>
      _$this._accountStatus = accountStatus;

  bool? _editable;
  bool? get editable => _$this._editable;
  set editable(bool? editable) => _$this._editable = editable;

  int? _nameMax;
  int? get nameMax => _$this._nameMax;
  set nameMax(int? nameMax) => _$this._nameMax = nameMax;

  int? _descriptionMax;
  int? get descriptionMax => _$this._descriptionMax;
  set descriptionMax(int? descriptionMax) =>
      _$this._descriptionMax = descriptionMax;

  int? _codeMax;
  int? get codeMax => _$this._codeMax;
  set codeMax(int? codeMax) => _$this._codeMax = codeMax;

  ListBuilder<AdminMenuDtoOutputCategoriesInner>? _categories;
  ListBuilder<AdminMenuDtoOutputCategoriesInner> get categories =>
      _$this._categories ??= ListBuilder<AdminMenuDtoOutputCategoriesInner>();
  set categories(ListBuilder<AdminMenuDtoOutputCategoriesInner>? categories) =>
      _$this._categories = categories;

  AdminMenuDtoOutputBuilder() {
    AdminMenuDtoOutput._defaults(this);
  }

  AdminMenuDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accountStatus = $v.accountStatus;
      _editable = $v.editable;
      _nameMax = $v.nameMax;
      _descriptionMax = $v.descriptionMax;
      _codeMax = $v.codeMax;
      _categories = $v.categories.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuDtoOutput other) {
    _$v = other as _$AdminMenuDtoOutput;
  }

  @override
  void update(void Function(AdminMenuDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuDtoOutput build() => _build();

  _$AdminMenuDtoOutput _build() {
    _$AdminMenuDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminMenuDtoOutput._(
            accountStatus: BuiltValueNullFieldError.checkNotNull(
              accountStatus,
              r'AdminMenuDtoOutput',
              'accountStatus',
            ),
            editable: BuiltValueNullFieldError.checkNotNull(
              editable,
              r'AdminMenuDtoOutput',
              'editable',
            ),
            nameMax: BuiltValueNullFieldError.checkNotNull(
              nameMax,
              r'AdminMenuDtoOutput',
              'nameMax',
            ),
            descriptionMax: BuiltValueNullFieldError.checkNotNull(
              descriptionMax,
              r'AdminMenuDtoOutput',
              'descriptionMax',
            ),
            codeMax: BuiltValueNullFieldError.checkNotNull(
              codeMax,
              r'AdminMenuDtoOutput',
              'codeMax',
            ),
            categories: categories.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'categories';
        categories.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminMenuDtoOutput',
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
