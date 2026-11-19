//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_captain_list_dto_output_captains_inner_custody_closed_due.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_profile_dto_output_app.g.dart';

/// AdminCaptainProfileDtoOutputApp
///
/// Properties:
/// * [maxPickup]
/// * [maxPickupAnswered]
/// * [carriedCurrencies]
/// * [expiredInRow] - The latest answered offers that expired in a row.
@BuiltValue()
abstract class AdminCaptainProfileDtoOutputApp
    implements
        Built<
          AdminCaptainProfileDtoOutputApp,
          AdminCaptainProfileDtoOutputAppBuilder
        > {
  @BuiltValueField(wireName: r'maxPickup')
  AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue? get maxPickup;

  @BuiltValueField(wireName: r'maxPickupAnswered')
  bool get maxPickupAnswered;

  @BuiltValueField(wireName: r'carriedCurrencies')
  BuiltList<String> get carriedCurrencies;

  /// The latest answered offers that expired in a row.
  @BuiltValueField(wireName: r'expiredInRow')
  int get expiredInRow;

  AdminCaptainProfileDtoOutputApp._();

  factory AdminCaptainProfileDtoOutputApp([
    void updates(AdminCaptainProfileDtoOutputAppBuilder b),
  ]) = _$AdminCaptainProfileDtoOutputApp;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainProfileDtoOutputAppBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainProfileDtoOutputApp> get serializer =>
      _$AdminCaptainProfileDtoOutputAppSerializer();
}

class _$AdminCaptainProfileDtoOutputAppSerializer
    implements PrimitiveSerializer<AdminCaptainProfileDtoOutputApp> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainProfileDtoOutputApp,
    _$AdminCaptainProfileDtoOutputApp,
  ];

  @override
  final String wireName = r'AdminCaptainProfileDtoOutputApp';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainProfileDtoOutputApp object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'maxPickup';
    yield object.maxPickup == null
        ? null
        : serializers.serialize(
            object.maxPickup,
            specifiedType: const FullType.nullable(
              AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue,
            ),
          );
    yield r'maxPickupAnswered';
    yield serializers.serialize(
      object.maxPickupAnswered,
      specifiedType: const FullType(bool),
    );
    yield r'carriedCurrencies';
    yield serializers.serialize(
      object.carriedCurrencies,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'expiredInRow';
    yield serializers.serialize(
      object.expiredInRow,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainProfileDtoOutputApp object, {
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
    required AdminCaptainProfileDtoOutputAppBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'maxPickup':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue,
                    ),
                  )
                  as AdminCaptainListDtoOutputCaptainsInnerCustodyClosedDue?;
          if (valueDes == null) continue;
          result.maxPickup.replace(valueDes);
          break;
        case r'maxPickupAnswered':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.maxPickupAnswered = valueDes;
          break;
        case r'carriedCurrencies':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.carriedCurrencies.replace(valueDes);
          break;
        case r'expiredInRow':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.expiredInRow = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainProfileDtoOutputApp deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainProfileDtoOutputAppBuilder();
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
