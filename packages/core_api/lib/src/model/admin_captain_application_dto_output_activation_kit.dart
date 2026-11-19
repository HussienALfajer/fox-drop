//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_captain_application_dto_output_activation_kit_items_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_application_dto_output_activation_kit.g.dart';

/// AdminCaptainApplicationDtoOutputActivationKit
///
/// Properties:
/// * [items]
/// * [issuedAt]
@BuiltValue()
abstract class AdminCaptainApplicationDtoOutputActivationKit
    implements
        Built<
          AdminCaptainApplicationDtoOutputActivationKit,
          AdminCaptainApplicationDtoOutputActivationKitBuilder
        > {
  @BuiltValueField(wireName: r'items')
  BuiltList<AdminCaptainApplicationDtoOutputActivationKitItemsInner> get items;

  @BuiltValueField(wireName: r'issuedAt')
  DateTime get issuedAt;

  AdminCaptainApplicationDtoOutputActivationKit._();

  factory AdminCaptainApplicationDtoOutputActivationKit([
    void updates(AdminCaptainApplicationDtoOutputActivationKitBuilder b),
  ]) = _$AdminCaptainApplicationDtoOutputActivationKit;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminCaptainApplicationDtoOutputActivationKitBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainApplicationDtoOutputActivationKit>
  get serializer => _$AdminCaptainApplicationDtoOutputActivationKitSerializer();
}

class _$AdminCaptainApplicationDtoOutputActivationKitSerializer
    implements
        PrimitiveSerializer<AdminCaptainApplicationDtoOutputActivationKit> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainApplicationDtoOutputActivationKit,
    _$AdminCaptainApplicationDtoOutputActivationKit,
  ];

  @override
  final String wireName = r'AdminCaptainApplicationDtoOutputActivationKit';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputActivationKit object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCaptainApplicationDtoOutputActivationKitItemsInner),
      ]),
    );
    yield r'issuedAt';
    yield serializers.serialize(
      object.issuedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputActivationKit object, {
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
    required AdminCaptainApplicationDtoOutputActivationKitBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminCaptainApplicationDtoOutputActivationKitItemsInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminCaptainApplicationDtoOutputActivationKitItemsInner
                  >;
          result.items.replace(valueDes);
          break;
        case r'issuedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.issuedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainApplicationDtoOutputActivationKit deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainApplicationDtoOutputActivationKitBuilder();
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
