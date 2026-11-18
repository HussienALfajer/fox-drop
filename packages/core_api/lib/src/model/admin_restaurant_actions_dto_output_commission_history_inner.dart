//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_actions_dto_output_commission_history_inner.g.dart';

/// AdminRestaurantActionsDtoOutputCommissionHistoryInner
///
/// Properties:
/// * [id]
/// * [rateBp]
/// * [from]
/// * [reason]
/// * [setAt]
/// * [byAdmin] - Set from the panel; false for the system or the seed.
@BuiltValue()
abstract class AdminRestaurantActionsDtoOutputCommissionHistoryInner
    implements
        Built<
          AdminRestaurantActionsDtoOutputCommissionHistoryInner,
          AdminRestaurantActionsDtoOutputCommissionHistoryInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'rateBp')
  int get rateBp;

  @BuiltValueField(wireName: r'from')
  DateTime get from;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'setAt')
  DateTime get setAt;

  /// Set from the panel; false for the system or the seed.
  @BuiltValueField(wireName: r'byAdmin')
  bool get byAdmin;

  AdminRestaurantActionsDtoOutputCommissionHistoryInner._();

  factory AdminRestaurantActionsDtoOutputCommissionHistoryInner([
    void updates(
      AdminRestaurantActionsDtoOutputCommissionHistoryInnerBuilder b,
    ),
  ]) = _$AdminRestaurantActionsDtoOutputCommissionHistoryInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminRestaurantActionsDtoOutputCommissionHistoryInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantActionsDtoOutputCommissionHistoryInner>
  get serializer =>
      _$AdminRestaurantActionsDtoOutputCommissionHistoryInnerSerializer();
}

class _$AdminRestaurantActionsDtoOutputCommissionHistoryInnerSerializer
    implements
        PrimitiveSerializer<
          AdminRestaurantActionsDtoOutputCommissionHistoryInner
        > {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantActionsDtoOutputCommissionHistoryInner,
    _$AdminRestaurantActionsDtoOutputCommissionHistoryInner,
  ];

  @override
  final String wireName =
      r'AdminRestaurantActionsDtoOutputCommissionHistoryInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantActionsDtoOutputCommissionHistoryInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
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
    yield r'reason';
    yield object.reason == null
        ? null
        : serializers.serialize(
            object.reason,
            specifiedType: const FullType.nullable(String),
          );
    yield r'setAt';
    yield serializers.serialize(
      object.setAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'byAdmin';
    yield serializers.serialize(
      object.byAdmin,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantActionsDtoOutputCommissionHistoryInner object, {
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
    required AdminRestaurantActionsDtoOutputCommissionHistoryInnerBuilder
    result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
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
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'setAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.setAt = valueDes;
          break;
        case r'byAdmin':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.byAdmin = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantActionsDtoOutputCommissionHistoryInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        AdminRestaurantActionsDtoOutputCommissionHistoryInnerBuilder();
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
