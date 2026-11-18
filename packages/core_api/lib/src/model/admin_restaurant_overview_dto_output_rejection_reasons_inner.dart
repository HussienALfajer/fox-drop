//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_overview_dto_output_rejection_reasons_inner.g.dart';

/// AdminRestaurantOverviewDtoOutputRejectionReasonsInner
///
/// Properties:
/// * [label]
/// * [count]
@BuiltValue()
abstract class AdminRestaurantOverviewDtoOutputRejectionReasonsInner
    implements
        Built<
          AdminRestaurantOverviewDtoOutputRejectionReasonsInner,
          AdminRestaurantOverviewDtoOutputRejectionReasonsInnerBuilder
        > {
  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'count')
  int get count;

  AdminRestaurantOverviewDtoOutputRejectionReasonsInner._();

  factory AdminRestaurantOverviewDtoOutputRejectionReasonsInner([
    void updates(
      AdminRestaurantOverviewDtoOutputRejectionReasonsInnerBuilder b,
    ),
  ]) = _$AdminRestaurantOverviewDtoOutputRejectionReasonsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminRestaurantOverviewDtoOutputRejectionReasonsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantOverviewDtoOutputRejectionReasonsInner>
  get serializer =>
      _$AdminRestaurantOverviewDtoOutputRejectionReasonsInnerSerializer();
}

class _$AdminRestaurantOverviewDtoOutputRejectionReasonsInnerSerializer
    implements
        PrimitiveSerializer<
          AdminRestaurantOverviewDtoOutputRejectionReasonsInner
        > {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantOverviewDtoOutputRejectionReasonsInner,
    _$AdminRestaurantOverviewDtoOutputRejectionReasonsInner,
  ];

  @override
  final String wireName =
      r'AdminRestaurantOverviewDtoOutputRejectionReasonsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantOverviewDtoOutputRejectionReasonsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantOverviewDtoOutputRejectionReasonsInner object, {
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
    required AdminRestaurantOverviewDtoOutputRejectionReasonsInnerBuilder
    result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'label':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.label = valueDes;
          break;
        case r'count':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.count = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantOverviewDtoOutputRejectionReasonsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        AdminRestaurantOverviewDtoOutputRejectionReasonsInnerBuilder();
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
