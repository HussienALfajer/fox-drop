//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_on_behalf_prep_time.g.dart';

/// «قبول نيابة عن المطعم»: the prep-time chooser of RA §8.5.
///
/// Properties:
/// * [options] - The chips (merchant.prep_time_options).
/// * [stepMin] 
/// * [floorMin] 
/// * [ceilingMin] 
/// * [defaultMin] - Preselected: the restaurant's default prep time plus busy mode's minutes while it is on.
@BuiltValue()
abstract class AdminOrderDtoOutputOrderOnBehalfPrepTime implements Built<AdminOrderDtoOutputOrderOnBehalfPrepTime, AdminOrderDtoOutputOrderOnBehalfPrepTimeBuilder> {
  /// The chips (merchant.prep_time_options).
  @BuiltValueField(wireName: r'options')
  BuiltList<int> get options;

  @BuiltValueField(wireName: r'stepMin')
  int get stepMin;

  @BuiltValueField(wireName: r'floorMin')
  int get floorMin;

  @BuiltValueField(wireName: r'ceilingMin')
  int get ceilingMin;

  /// Preselected: the restaurant's default prep time plus busy mode's minutes while it is on.
  @BuiltValueField(wireName: r'defaultMin')
  int get defaultMin;

  AdminOrderDtoOutputOrderOnBehalfPrepTime._();

  factory AdminOrderDtoOutputOrderOnBehalfPrepTime([void updates(AdminOrderDtoOutputOrderOnBehalfPrepTimeBuilder b)]) = _$AdminOrderDtoOutputOrderOnBehalfPrepTime;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderOnBehalfPrepTimeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderOnBehalfPrepTime> get serializer => _$AdminOrderDtoOutputOrderOnBehalfPrepTimeSerializer();
}

class _$AdminOrderDtoOutputOrderOnBehalfPrepTimeSerializer implements PrimitiveSerializer<AdminOrderDtoOutputOrderOnBehalfPrepTime> {
  @override
  final Iterable<Type> types = const [AdminOrderDtoOutputOrderOnBehalfPrepTime, _$AdminOrderDtoOutputOrderOnBehalfPrepTime];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderOnBehalfPrepTime';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderOnBehalfPrepTime object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'options';
    yield serializers.serialize(
      object.options,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    yield r'stepMin';
    yield serializers.serialize(
      object.stepMin,
      specifiedType: const FullType(int),
    );
    yield r'floorMin';
    yield serializers.serialize(
      object.floorMin,
      specifiedType: const FullType(int),
    );
    yield r'ceilingMin';
    yield serializers.serialize(
      object.ceilingMin,
      specifiedType: const FullType(int),
    );
    yield r'defaultMin';
    yield serializers.serialize(
      object.defaultMin,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderOnBehalfPrepTime object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOrderDtoOutputOrderOnBehalfPrepTimeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'options':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.options.replace(valueDes);
          break;
        case r'stepMin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.stepMin = valueDes;
          break;
        case r'floorMin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.floorMin = valueDes;
          break;
        case r'ceilingMin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ceilingMin = valueDes;
          break;
        case r'defaultMin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.defaultMin = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderOnBehalfPrepTime deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderOnBehalfPrepTimeBuilder();
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


