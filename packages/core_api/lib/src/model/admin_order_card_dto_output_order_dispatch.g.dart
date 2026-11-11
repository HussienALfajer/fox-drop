// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_card_dto_output_order_dispatch.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOrderCardDtoOutputOrderDispatchModeEnum
_$adminOrderCardDtoOutputOrderDispatchModeEnum_manual =
    const AdminOrderCardDtoOutputOrderDispatchModeEnum._('manual');
const AdminOrderCardDtoOutputOrderDispatchModeEnum
_$adminOrderCardDtoOutputOrderDispatchModeEnum_auto =
    const AdminOrderCardDtoOutputOrderDispatchModeEnum._('auto');
const AdminOrderCardDtoOutputOrderDispatchModeEnum
_$adminOrderCardDtoOutputOrderDispatchModeEnum_mixed =
    const AdminOrderCardDtoOutputOrderDispatchModeEnum._('mixed');

AdminOrderCardDtoOutputOrderDispatchModeEnum
_$adminOrderCardDtoOutputOrderDispatchModeEnumValueOf(String name) {
  switch (name) {
    case 'manual':
      return _$adminOrderCardDtoOutputOrderDispatchModeEnum_manual;
    case 'auto':
      return _$adminOrderCardDtoOutputOrderDispatchModeEnum_auto;
    case 'mixed':
      return _$adminOrderCardDtoOutputOrderDispatchModeEnum_mixed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderCardDtoOutputOrderDispatchModeEnum>
_$adminOrderCardDtoOutputOrderDispatchModeEnumValues =
    BuiltSet<AdminOrderCardDtoOutputOrderDispatchModeEnum>(
      const <AdminOrderCardDtoOutputOrderDispatchModeEnum>[
        _$adminOrderCardDtoOutputOrderDispatchModeEnum_manual,
        _$adminOrderCardDtoOutputOrderDispatchModeEnum_auto,
        _$adminOrderCardDtoOutputOrderDispatchModeEnum_mixed,
      ],
    );

Serializer<AdminOrderCardDtoOutputOrderDispatchModeEnum>
_$adminOrderCardDtoOutputOrderDispatchModeEnumSerializer =
    _$AdminOrderCardDtoOutputOrderDispatchModeEnumSerializer();

class _$AdminOrderCardDtoOutputOrderDispatchModeEnumSerializer
    implements
        PrimitiveSerializer<AdminOrderCardDtoOutputOrderDispatchModeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'manual': 'manual',
    'auto': 'auto',
    'mixed': 'mixed',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'manual': 'manual',
    'auto': 'auto',
    'mixed': 'mixed',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminOrderCardDtoOutputOrderDispatchModeEnum,
  ];
  @override
  final String wireName = 'AdminOrderCardDtoOutputOrderDispatchModeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderCardDtoOutputOrderDispatchModeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderCardDtoOutputOrderDispatchModeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderCardDtoOutputOrderDispatchModeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderCardDtoOutputOrderDispatch
    extends AdminOrderCardDtoOutputOrderDispatch {
  @override
  final AdminOrderCardDtoOutputOrderDispatchModeEnum mode;
  @override
  final AdminOrderCardDtoOutputOrderDispatchManual? manual;
  @override
  final int autoOffers;
  @override
  final int? maxOffers;

  factory _$AdminOrderCardDtoOutputOrderDispatch([
    void Function(AdminOrderCardDtoOutputOrderDispatchBuilder)? updates,
  ]) =>
      (AdminOrderCardDtoOutputOrderDispatchBuilder()..update(updates))._build();

  _$AdminOrderCardDtoOutputOrderDispatch._({
    required this.mode,
    this.manual,
    required this.autoOffers,
    this.maxOffers,
  }) : super._();
  @override
  AdminOrderCardDtoOutputOrderDispatch rebuild(
    void Function(AdminOrderCardDtoOutputOrderDispatchBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderCardDtoOutputOrderDispatchBuilder toBuilder() =>
      AdminOrderCardDtoOutputOrderDispatchBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderCardDtoOutputOrderDispatch &&
        mode == other.mode &&
        manual == other.manual &&
        autoOffers == other.autoOffers &&
        maxOffers == other.maxOffers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, mode.hashCode);
    _$hash = $jc(_$hash, manual.hashCode);
    _$hash = $jc(_$hash, autoOffers.hashCode);
    _$hash = $jc(_$hash, maxOffers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOrderCardDtoOutputOrderDispatch')
          ..add('mode', mode)
          ..add('manual', manual)
          ..add('autoOffers', autoOffers)
          ..add('maxOffers', maxOffers))
        .toString();
  }
}

class AdminOrderCardDtoOutputOrderDispatchBuilder
    implements
        Builder<
          AdminOrderCardDtoOutputOrderDispatch,
          AdminOrderCardDtoOutputOrderDispatchBuilder
        > {
  _$AdminOrderCardDtoOutputOrderDispatch? _$v;

  AdminOrderCardDtoOutputOrderDispatchModeEnum? _mode;
  AdminOrderCardDtoOutputOrderDispatchModeEnum? get mode => _$this._mode;
  set mode(AdminOrderCardDtoOutputOrderDispatchModeEnum? mode) =>
      _$this._mode = mode;

  AdminOrderCardDtoOutputOrderDispatchManualBuilder? _manual;
  AdminOrderCardDtoOutputOrderDispatchManualBuilder get manual =>
      _$this._manual ??= AdminOrderCardDtoOutputOrderDispatchManualBuilder();
  set manual(AdminOrderCardDtoOutputOrderDispatchManualBuilder? manual) =>
      _$this._manual = manual;

  int? _autoOffers;
  int? get autoOffers => _$this._autoOffers;
  set autoOffers(int? autoOffers) => _$this._autoOffers = autoOffers;

  int? _maxOffers;
  int? get maxOffers => _$this._maxOffers;
  set maxOffers(int? maxOffers) => _$this._maxOffers = maxOffers;

  AdminOrderCardDtoOutputOrderDispatchBuilder() {
    AdminOrderCardDtoOutputOrderDispatch._defaults(this);
  }

  AdminOrderCardDtoOutputOrderDispatchBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _mode = $v.mode;
      _manual = $v.manual?.toBuilder();
      _autoOffers = $v.autoOffers;
      _maxOffers = $v.maxOffers;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderCardDtoOutputOrderDispatch other) {
    _$v = other as _$AdminOrderCardDtoOutputOrderDispatch;
  }

  @override
  void update(
    void Function(AdminOrderCardDtoOutputOrderDispatchBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderCardDtoOutputOrderDispatch build() => _build();

  _$AdminOrderCardDtoOutputOrderDispatch _build() {
    _$AdminOrderCardDtoOutputOrderDispatch _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderCardDtoOutputOrderDispatch._(
            mode: BuiltValueNullFieldError.checkNotNull(
              mode,
              r'AdminOrderCardDtoOutputOrderDispatch',
              'mode',
            ),
            manual: _manual?.build(),
            autoOffers: BuiltValueNullFieldError.checkNotNull(
              autoOffers,
              r'AdminOrderCardDtoOutputOrderDispatch',
              'autoOffers',
            ),
            maxOffers: maxOffers,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'manual';
        _manual?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderCardDtoOutputOrderDispatch',
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
