//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_order_card_dto_output_order_dispatch_manual.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_card_dto_output_order_dispatch.g.dart';

/// AP §9.2.1, §9.12.6 (slice 2.15c): how the order is being dispatched.
///
/// Properties:
/// * [mode] - The city’s dispatch.mode now.
/// * [manual]
/// * [autoOffers] - The automatic offers sent so far, the open one included: «العرض {ن}».
/// * [maxOffers] - «مختلط»: dispatch.max_offers_before_manual, «من {م}»; null otherwise.
@BuiltValue()
abstract class AdminOrderCardDtoOutputOrderDispatch
    implements
        Built<
          AdminOrderCardDtoOutputOrderDispatch,
          AdminOrderCardDtoOutputOrderDispatchBuilder
        > {
  /// The city’s dispatch.mode now.
  @BuiltValueField(wireName: r'mode')
  AdminOrderCardDtoOutputOrderDispatchModeEnum get mode;
  // enum modeEnum {  manual,  auto,  mixed,  };

  @BuiltValueField(wireName: r'manual')
  AdminOrderCardDtoOutputOrderDispatchManual? get manual;

  /// The automatic offers sent so far, the open one included: «العرض {ن}».
  @BuiltValueField(wireName: r'autoOffers')
  int get autoOffers;

  /// «مختلط»: dispatch.max_offers_before_manual, «من {م}»; null otherwise.
  @BuiltValueField(wireName: r'maxOffers')
  int? get maxOffers;

  AdminOrderCardDtoOutputOrderDispatch._();

  factory AdminOrderCardDtoOutputOrderDispatch([
    void updates(AdminOrderCardDtoOutputOrderDispatchBuilder b),
  ]) = _$AdminOrderCardDtoOutputOrderDispatch;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderCardDtoOutputOrderDispatchBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderCardDtoOutputOrderDispatch> get serializer =>
      _$AdminOrderCardDtoOutputOrderDispatchSerializer();
}

class _$AdminOrderCardDtoOutputOrderDispatchSerializer
    implements PrimitiveSerializer<AdminOrderCardDtoOutputOrderDispatch> {
  @override
  final Iterable<Type> types = const [
    AdminOrderCardDtoOutputOrderDispatch,
    _$AdminOrderCardDtoOutputOrderDispatch,
  ];

  @override
  final String wireName = r'AdminOrderCardDtoOutputOrderDispatch';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderCardDtoOutputOrderDispatch object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'mode';
    yield serializers.serialize(
      object.mode,
      specifiedType: const FullType(
        AdminOrderCardDtoOutputOrderDispatchModeEnum,
      ),
    );
    yield r'manual';
    yield object.manual == null
        ? null
        : serializers.serialize(
            object.manual,
            specifiedType: const FullType.nullable(
              AdminOrderCardDtoOutputOrderDispatchManual,
            ),
          );
    yield r'autoOffers';
    yield serializers.serialize(
      object.autoOffers,
      specifiedType: const FullType(int),
    );
    yield r'maxOffers';
    yield object.maxOffers == null
        ? null
        : serializers.serialize(
            object.maxOffers,
            specifiedType: const FullType.nullable(int),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderCardDtoOutputOrderDispatch object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(
      serializers,
      object,
      specifiedType: specifiedType,
    ).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOrderCardDtoOutputOrderDispatchBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'mode':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderCardDtoOutputOrderDispatchModeEnum,
                    ),
                  )
                  as AdminOrderCardDtoOutputOrderDispatchModeEnum;
          result.mode = valueDes;
          break;
        case r'manual':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderCardDtoOutputOrderDispatchManual,
                    ),
                  )
                  as AdminOrderCardDtoOutputOrderDispatchManual?;
          if (valueDes == null) continue;
          result.manual.replace(valueDes);
          break;
        case r'autoOffers':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.autoOffers = valueDes;
          break;
        case r'maxOffers':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.maxOffers = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderCardDtoOutputOrderDispatch deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderCardDtoOutputOrderDispatchBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

/// The city’s dispatch.mode now.
class AdminOrderCardDtoOutputOrderDispatchModeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'manual')
  static const AdminOrderCardDtoOutputOrderDispatchModeEnum manual =
      _$adminOrderCardDtoOutputOrderDispatchModeEnum_manual;
  @BuiltValueEnumConst(wireName: r'auto')
  static const AdminOrderCardDtoOutputOrderDispatchModeEnum auto =
      _$adminOrderCardDtoOutputOrderDispatchModeEnum_auto;
  @BuiltValueEnumConst(wireName: r'mixed')
  static const AdminOrderCardDtoOutputOrderDispatchModeEnum mixed =
      _$adminOrderCardDtoOutputOrderDispatchModeEnum_mixed;

  static Serializer<AdminOrderCardDtoOutputOrderDispatchModeEnum>
  get serializer => _$adminOrderCardDtoOutputOrderDispatchModeEnumSerializer;

  const AdminOrderCardDtoOutputOrderDispatchModeEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderCardDtoOutputOrderDispatchModeEnum> get values =>
      _$adminOrderCardDtoOutputOrderDispatchModeEnumValues;
  static AdminOrderCardDtoOutputOrderDispatchModeEnum valueOf(String name) =>
      _$adminOrderCardDtoOutputOrderDispatchModeEnumValueOf(name);
}
