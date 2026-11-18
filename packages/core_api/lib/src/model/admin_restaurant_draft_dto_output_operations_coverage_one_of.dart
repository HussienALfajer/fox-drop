//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_draft_dto_output_operations_coverage_one_of.g.dart';

/// AdminRestaurantDraftDtoOutputOperationsCoverageOneOf
///
/// Properties:
/// * [kind]
/// * [radiusMetres]
@BuiltValue()
abstract class AdminRestaurantDraftDtoOutputOperationsCoverageOneOf
    implements
        Built<
          AdminRestaurantDraftDtoOutputOperationsCoverageOneOf,
          AdminRestaurantDraftDtoOutputOperationsCoverageOneOfBuilder
        > {
  @BuiltValueField(wireName: r'kind')
  AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum get kind;
  // enum kindEnum {  radius,  };

  @BuiltValueField(wireName: r'radiusMetres')
  int get radiusMetres;

  AdminRestaurantDraftDtoOutputOperationsCoverageOneOf._();

  factory AdminRestaurantDraftDtoOutputOperationsCoverageOneOf([
    void updates(AdminRestaurantDraftDtoOutputOperationsCoverageOneOfBuilder b),
  ]) = _$AdminRestaurantDraftDtoOutputOperationsCoverageOneOf;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminRestaurantDraftDtoOutputOperationsCoverageOneOfBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantDraftDtoOutputOperationsCoverageOneOf>
  get serializer =>
      _$AdminRestaurantDraftDtoOutputOperationsCoverageOneOfSerializer();
}

class _$AdminRestaurantDraftDtoOutputOperationsCoverageOneOfSerializer
    implements
        PrimitiveSerializer<
          AdminRestaurantDraftDtoOutputOperationsCoverageOneOf
        > {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantDraftDtoOutputOperationsCoverageOneOf,
    _$AdminRestaurantDraftDtoOutputOperationsCoverageOneOf,
  ];

  @override
  final String wireName =
      r'AdminRestaurantDraftDtoOutputOperationsCoverageOneOf';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantDraftDtoOutputOperationsCoverageOneOf object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum,
      ),
    );
    yield r'radiusMetres';
    yield serializers.serialize(
      object.radiusMetres,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantDraftDtoOutputOperationsCoverageOneOf object, {
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
    required AdminRestaurantDraftDtoOutputOperationsCoverageOneOfBuilder result,
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
                      AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum,
                    ),
                  )
                  as AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum;
          result.kind = valueDes;
          break;
        case r'radiusMetres':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.radiusMetres = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantDraftDtoOutputOperationsCoverageOneOf deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        AdminRestaurantDraftDtoOutputOperationsCoverageOneOfBuilder();
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

class AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'radius')
  static const AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum
  radius =
      _$adminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum_radius;

  static Serializer<
    AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum
  >
  get serializer =>
      _$adminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnumSerializer;

  const AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum._(
    String name,
  ) : super(name);

  static BuiltSet<AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum>
  get values =>
      _$adminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnumValues;
  static AdminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnum valueOf(
    String name,
  ) => _$adminRestaurantDraftDtoOutputOperationsCoverageOneOfKindEnumValueOf(
    name,
  );
}
