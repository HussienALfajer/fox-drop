//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_restaurant_accounts_dto_output_accounts_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_accounts_dto_output.g.dart';

/// AdminRestaurantAccountsDtoOutput
///
/// Properties:
/// * [accounts] - Owners first, then cashiers, oldest first.
@BuiltValue()
abstract class AdminRestaurantAccountsDtoOutput
    implements
        Built<
          AdminRestaurantAccountsDtoOutput,
          AdminRestaurantAccountsDtoOutputBuilder
        > {
  /// Owners first, then cashiers, oldest first.
  @BuiltValueField(wireName: r'accounts')
  BuiltList<AdminRestaurantAccountsDtoOutputAccountsInner> get accounts;

  AdminRestaurantAccountsDtoOutput._();

  factory AdminRestaurantAccountsDtoOutput([
    void updates(AdminRestaurantAccountsDtoOutputBuilder b),
  ]) = _$AdminRestaurantAccountsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantAccountsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantAccountsDtoOutput> get serializer =>
      _$AdminRestaurantAccountsDtoOutputSerializer();
}

class _$AdminRestaurantAccountsDtoOutputSerializer
    implements PrimitiveSerializer<AdminRestaurantAccountsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantAccountsDtoOutput,
    _$AdminRestaurantAccountsDtoOutput,
  ];

  @override
  final String wireName = r'AdminRestaurantAccountsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantAccountsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accounts';
    yield serializers.serialize(
      object.accounts,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminRestaurantAccountsDtoOutputAccountsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantAccountsDtoOutput object, {
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
    required AdminRestaurantAccountsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accounts':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminRestaurantAccountsDtoOutputAccountsInner),
                    ]),
                  )
                  as BuiltList<AdminRestaurantAccountsDtoOutputAccountsInner>;
          result.accounts.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantAccountsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantAccountsDtoOutputBuilder();
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
