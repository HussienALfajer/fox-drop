//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_draft_dto_output_operations_coverage_one_of1.g.dart';

/// AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1
///
/// Properties:
/// * [kind]
/// * [zoneIds]
@BuiltValue()
abstract class AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1
    implements
        Built<
          AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1,
          AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1Builder
        > {
  @BuiltValueField(wireName: r'kind')
  AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum get kind;
  // enum kindEnum {  zones,  };

  @BuiltValueField(wireName: r'zoneIds')
  BuiltList<String> get zoneIds;

  AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1._();

  factory AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1([
    void updates(
      AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1Builder b,
    ),
  ]) = _$AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1Builder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1>
  get serializer =>
      _$AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1Serializer();
}

class _$AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1Serializer
    implements
        PrimitiveSerializer<
          AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1
        > {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1,
    _$AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1,
  ];

  @override
  final String wireName =
      r'AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum,
      ),
    );
    yield r'zoneIds';
    yield serializers.serialize(
      object.zoneIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1 object, {
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
    required AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1Builder
    result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum,
                    ),
                  )
                  as AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum;
          result.kind = valueDes;
          break;
        case r'zoneIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.zoneIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1Builder();
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

class AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'zones')
  static const AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum
  zones = _$adminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum_zones;

  static Serializer<
    AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum
  >
  get serializer =>
      _$adminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnumSerializer;

  const AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum._(
    String name,
  ) : super(name);

  static BuiltSet<AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum>
  get values =>
      _$adminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnumValues;
  static AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnum valueOf(
    String name,
  ) => _$adminRestaurantDraftDtoOutputOperationsCoverageOneOf1KindEnumValueOf(
    name,
  );
}
