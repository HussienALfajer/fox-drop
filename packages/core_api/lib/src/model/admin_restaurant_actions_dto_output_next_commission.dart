//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_actions_dto_output_next_commission.g.dart';

/// The next version, scheduled after now.
///
/// Properties:
/// * [rateBp]
/// * [from]
@BuiltValue()
abstract class AdminRestaurantActionsDtoOutputNextCommission
    implements
        Built<
          AdminRestaurantActionsDtoOutputNextCommission,
          AdminRestaurantActionsDtoOutputNextCommissionBuilder
        > {
  @BuiltValueField(wireName: r'rateBp')
  int get rateBp;

  @BuiltValueField(wireName: r'from')
  DateTime get from;

  AdminRestaurantActionsDtoOutputNextCommission._();

  factory AdminRestaurantActionsDtoOutputNextCommission([
    void updates(AdminRestaurantActionsDtoOutputNextCommissionBuilder b),
  ]) = _$AdminRestaurantActionsDtoOutputNextCommission;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminRestaurantActionsDtoOutputNextCommissionBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantActionsDtoOutputNextCommission>
  get serializer => _$AdminRestaurantActionsDtoOutputNextCommissionSerializer();
}

class _$AdminRestaurantActionsDtoOutputNextCommissionSerializer
    implements
        PrimitiveSerializer<AdminRestaurantActionsDtoOutputNextCommission> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantActionsDtoOutputNextCommission,
    _$AdminRestaurantActionsDtoOutputNextCommission,
  ];

  @override
  final String wireName = r'AdminRestaurantActionsDtoOutputNextCommission';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantActionsDtoOutputNextCommission object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'rateBp';
    yield serializers.serialize(
      object.rateBp,
      specifiedType: const FullType(int),
    );
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantActionsDtoOutputNextCommission object, {
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
    required AdminRestaurantActionsDtoOutputNextCommissionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'rateBp':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.rateBp = valueDes;
          break;
        case r'from':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.from = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantActionsDtoOutputNextCommission deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantActionsDtoOutputNextCommissionBuilder();
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
