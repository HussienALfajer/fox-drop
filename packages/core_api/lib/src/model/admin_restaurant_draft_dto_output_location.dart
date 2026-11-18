//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_draft_point_output.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_draft_dto_output_location.g.dart';

/// AdminRestaurantDraftDtoOutputLocation
///
/// Properties:
/// * [location]
/// * [address]
/// * [phone]
/// * [ownerName]
@BuiltValue()
abstract class AdminRestaurantDraftDtoOutputLocation
    implements
        Built<
          AdminRestaurantDraftDtoOutputLocation,
          AdminRestaurantDraftDtoOutputLocationBuilder
        > {
  @BuiltValueField(wireName: r'location')
  AdminDraftPointOutput? get location;

  @BuiltValueField(wireName: r'address')
  String? get address;

  @BuiltValueField(wireName: r'phone')
  String? get phone;

  @BuiltValueField(wireName: r'ownerName')
  String? get ownerName;

  AdminRestaurantDraftDtoOutputLocation._();

  factory AdminRestaurantDraftDtoOutputLocation([
    void updates(AdminRestaurantDraftDtoOutputLocationBuilder b),
  ]) = _$AdminRestaurantDraftDtoOutputLocation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantDraftDtoOutputLocationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantDraftDtoOutputLocation> get serializer =>
      _$AdminRestaurantDraftDtoOutputLocationSerializer();
}

class _$AdminRestaurantDraftDtoOutputLocationSerializer
    implements PrimitiveSerializer<AdminRestaurantDraftDtoOutputLocation> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantDraftDtoOutputLocation,
    _$AdminRestaurantDraftDtoOutputLocation,
  ];

  @override
  final String wireName = r'AdminRestaurantDraftDtoOutputLocation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantDraftDtoOutputLocation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'location';
    yield object.location == null
        ? null
        : serializers.serialize(
            object.location,
            specifiedType: const FullType.nullable(AdminDraftPointOutput),
          );
    yield r'address';
    yield object.address == null
        ? null
        : serializers.serialize(
            object.address,
            specifiedType: const FullType.nullable(String),
          );
    yield r'phone';
    yield object.phone == null
        ? null
        : serializers.serialize(
            object.phone,
            specifiedType: const FullType.nullable(String),
          );
    yield r'ownerName';
    yield object.ownerName == null
        ? null
        : serializers.serialize(
            object.ownerName,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantDraftDtoOutputLocation object, {
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
    required AdminRestaurantDraftDtoOutputLocationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'location':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminDraftPointOutput,
                    ),
                  )
                  as AdminDraftPointOutput?;
          if (valueDes == null) continue;
          result.location.replace(valueDes);
          break;
        case r'address':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.address = valueDes;
          break;
        case r'phone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.phone = valueDes;
          break;
        case r'ownerName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.ownerName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantDraftDtoOutputLocation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantDraftDtoOutputLocationBuilder();
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
