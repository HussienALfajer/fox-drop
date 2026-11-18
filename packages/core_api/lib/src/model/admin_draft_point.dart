//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_draft_point.g.dart';

/// AdminDraftPoint
///
/// Properties:
/// * [latitude]
/// * [longitude]
@BuiltValue()
abstract class AdminDraftPoint
    implements Built<AdminDraftPoint, AdminDraftPointBuilder> {
  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  AdminDraftPoint._();

  factory AdminDraftPoint([void updates(AdminDraftPointBuilder b)]) =
      _$AdminDraftPoint;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDraftPointBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDraftPoint> get serializer =>
      _$AdminDraftPointSerializer();
}

class _$AdminDraftPointSerializer
    implements PrimitiveSerializer<AdminDraftPoint> {
  @override
  final Iterable<Type> types = const [AdminDraftPoint, _$AdminDraftPoint];

  @override
  final String wireName = r'AdminDraftPoint';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDraftPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'latitude';
    yield serializers.serialize(
      object.latitude,
      specifiedType: const FullType(num),
    );
    yield r'longitude';
    yield serializers.serialize(
      object.longitude,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDraftPoint object, {
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
    required AdminDraftPointBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'latitude':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(num))
                  as num;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(num))
                  as num;
          result.longitude = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDraftPoint deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDraftPointBuilder();
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
