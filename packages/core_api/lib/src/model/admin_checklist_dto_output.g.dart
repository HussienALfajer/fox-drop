// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_checklist_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminChecklistDtoOutputAccountStatusEnum
_$adminChecklistDtoOutputAccountStatusEnum_draft =
    const AdminChecklistDtoOutputAccountStatusEnum._('draft');
const AdminChecklistDtoOutputAccountStatusEnum
_$adminChecklistDtoOutputAccountStatusEnum_test =
    const AdminChecklistDtoOutputAccountStatusEnum._('test');
const AdminChecklistDtoOutputAccountStatusEnum
_$adminChecklistDtoOutputAccountStatusEnum_active =
    const AdminChecklistDtoOutputAccountStatusEnum._('active');
const AdminChecklistDtoOutputAccountStatusEnum
_$adminChecklistDtoOutputAccountStatusEnum_suspended =
    const AdminChecklistDtoOutputAccountStatusEnum._('suspended');
const AdminChecklistDtoOutputAccountStatusEnum
_$adminChecklistDtoOutputAccountStatusEnum_terminated =
    const AdminChecklistDtoOutputAccountStatusEnum._('terminated');

AdminChecklistDtoOutputAccountStatusEnum
_$adminChecklistDtoOutputAccountStatusEnumValueOf(String name) {
  switch (name) {
    case 'draft':
      return _$adminChecklistDtoOutputAccountStatusEnum_draft;
    case 'test':
      return _$adminChecklistDtoOutputAccountStatusEnum_test;
    case 'active':
      return _$adminChecklistDtoOutputAccountStatusEnum_active;
    case 'suspended':
      return _$adminChecklistDtoOutputAccountStatusEnum_suspended;
    case 'terminated':
      return _$adminChecklistDtoOutputAccountStatusEnum_terminated;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminChecklistDtoOutputAccountStatusEnum>
_$adminChecklistDtoOutputAccountStatusEnumValues =
    BuiltSet<AdminChecklistDtoOutputAccountStatusEnum>(
      const <AdminChecklistDtoOutputAccountStatusEnum>[
        _$adminChecklistDtoOutputAccountStatusEnum_draft,
        _$adminChecklistDtoOutputAccountStatusEnum_test,
        _$adminChecklistDtoOutputAccountStatusEnum_active,
        _$adminChecklistDtoOutputAccountStatusEnum_suspended,
        _$adminChecklistDtoOutputAccountStatusEnum_terminated,
      ],
    );

Serializer<AdminChecklistDtoOutputAccountStatusEnum>
_$adminChecklistDtoOutputAccountStatusEnumSerializer =
    _$AdminChecklistDtoOutputAccountStatusEnumSerializer();

class _$AdminChecklistDtoOutputAccountStatusEnumSerializer
    implements PrimitiveSerializer<AdminChecklistDtoOutputAccountStatusEnum> {
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
    AdminChecklistDtoOutputAccountStatusEnum,
  ];
  @override
  final String wireName = 'AdminChecklistDtoOutputAccountStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminChecklistDtoOutputAccountStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminChecklistDtoOutputAccountStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminChecklistDtoOutputAccountStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminChecklistDtoOutput extends AdminChecklistDtoOutput {
  @override
  final AdminChecklistDtoOutputAccountStatusEnum accountStatus;
  @override
  final BuiltList<AdminChecklistDtoOutputItemsInner> items;
  @override
  final bool canStartTest;
  @override
  final bool canActivate;
  @override
  final AdminChecklistDtoOutputImages images;
  @override
  final AdminChecklistDtoOutputImagesWaiver? imagesWaiver;

  factory _$AdminChecklistDtoOutput([
    void Function(AdminChecklistDtoOutputBuilder)? updates,
  ]) => (AdminChecklistDtoOutputBuilder()..update(updates))._build();

  _$AdminChecklistDtoOutput._({
    required this.accountStatus,
    required this.items,
    required this.canStartTest,
    required this.canActivate,
    required this.images,
    this.imagesWaiver,
  }) : super._();
  @override
  AdminChecklistDtoOutput rebuild(
    void Function(AdminChecklistDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminChecklistDtoOutputBuilder toBuilder() =>
      AdminChecklistDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminChecklistDtoOutput &&
        accountStatus == other.accountStatus &&
        items == other.items &&
        canStartTest == other.canStartTest &&
        canActivate == other.canActivate &&
        images == other.images &&
        imagesWaiver == other.imagesWaiver;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accountStatus.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, canStartTest.hashCode);
    _$hash = $jc(_$hash, canActivate.hashCode);
    _$hash = $jc(_$hash, images.hashCode);
    _$hash = $jc(_$hash, imagesWaiver.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminChecklistDtoOutput')
          ..add('accountStatus', accountStatus)
          ..add('items', items)
          ..add('canStartTest', canStartTest)
          ..add('canActivate', canActivate)
          ..add('images', images)
          ..add('imagesWaiver', imagesWaiver))
        .toString();
  }
}

class AdminChecklistDtoOutputBuilder
    implements
        Builder<AdminChecklistDtoOutput, AdminChecklistDtoOutputBuilder> {
  _$AdminChecklistDtoOutput? _$v;

  AdminChecklistDtoOutputAccountStatusEnum? _accountStatus;
  AdminChecklistDtoOutputAccountStatusEnum? get accountStatus =>
      _$this._accountStatus;
  set accountStatus(AdminChecklistDtoOutputAccountStatusEnum? accountStatus) =>
      _$this._accountStatus = accountStatus;

  ListBuilder<AdminChecklistDtoOutputItemsInner>? _items;
  ListBuilder<AdminChecklistDtoOutputItemsInner> get items =>
      _$this._items ??= ListBuilder<AdminChecklistDtoOutputItemsInner>();
  set items(ListBuilder<AdminChecklistDtoOutputItemsInner>? items) =>
      _$this._items = items;

  bool? _canStartTest;
  bool? get canStartTest => _$this._canStartTest;
  set canStartTest(bool? canStartTest) => _$this._canStartTest = canStartTest;

  bool? _canActivate;
  bool? get canActivate => _$this._canActivate;
  set canActivate(bool? canActivate) => _$this._canActivate = canActivate;

  AdminChecklistDtoOutputImagesBuilder? _images;
  AdminChecklistDtoOutputImagesBuilder get images =>
      _$this._images ??= AdminChecklistDtoOutputImagesBuilder();
  set images(AdminChecklistDtoOutputImagesBuilder? images) =>
      _$this._images = images;

  AdminChecklistDtoOutputImagesWaiverBuilder? _imagesWaiver;
  AdminChecklistDtoOutputImagesWaiverBuilder get imagesWaiver =>
      _$this._imagesWaiver ??= AdminChecklistDtoOutputImagesWaiverBuilder();
  set imagesWaiver(AdminChecklistDtoOutputImagesWaiverBuilder? imagesWaiver) =>
      _$this._imagesWaiver = imagesWaiver;

  AdminChecklistDtoOutputBuilder() {
    AdminChecklistDtoOutput._defaults(this);
  }

  AdminChecklistDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accountStatus = $v.accountStatus;
      _items = $v.items.toBuilder();
      _canStartTest = $v.canStartTest;
      _canActivate = $v.canActivate;
      _images = $v.images.toBuilder();
      _imagesWaiver = $v.imagesWaiver?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminChecklistDtoOutput other) {
    _$v = other as _$AdminChecklistDtoOutput;
  }

  @override
  void update(void Function(AdminChecklistDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminChecklistDtoOutput build() => _build();

  _$AdminChecklistDtoOutput _build() {
    _$AdminChecklistDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminChecklistDtoOutput._(
            accountStatus: BuiltValueNullFieldError.checkNotNull(
              accountStatus,
              r'AdminChecklistDtoOutput',
              'accountStatus',
            ),
            items: items.build(),
            canStartTest: BuiltValueNullFieldError.checkNotNull(
              canStartTest,
              r'AdminChecklistDtoOutput',
              'canStartTest',
            ),
            canActivate: BuiltValueNullFieldError.checkNotNull(
              canActivate,
              r'AdminChecklistDtoOutput',
              'canActivate',
            ),
            images: images.build(),
            imagesWaiver: _imagesWaiver?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();

        _$failedField = 'images';
        images.build();
        _$failedField = 'imagesWaiver';
        _imagesWaiver?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminChecklistDtoOutput',
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
