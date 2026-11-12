//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_captain_balances_dto_output_captains_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_balances_dto_output.g.dart';

/// AdminCaptainBalancesDtoOutput
///
/// Properties:
/// * [captains]
@BuiltValue()
abstract class AdminCaptainBalancesDtoOutput
    implements
        Built<
          AdminCaptainBalancesDtoOutput,
          AdminCaptainBalancesDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'captains')
  BuiltList<AdminCaptainBalancesDtoOutputCaptainsInner> get captains;

  AdminCaptainBalancesDtoOutput._();

  factory AdminCaptainBalancesDtoOutput([
    void updates(AdminCaptainBalancesDtoOutputBuilder b),
  ]) = _$AdminCaptainBalancesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainBalancesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainBalancesDtoOutput> get serializer =>
      _$AdminCaptainBalancesDtoOutputSerializer();
}

class _$AdminCaptainBalancesDtoOutputSerializer
    implements PrimitiveSerializer<AdminCaptainBalancesDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainBalancesDtoOutput,
    _$AdminCaptainBalancesDtoOutput,
  ];

  @override
  final String wireName = r'AdminCaptainBalancesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainBalancesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'captains';
    yield serializers.serialize(
      object.captains,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCaptainBalancesDtoOutputCaptainsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainBalancesDtoOutput object, {
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
    required AdminCaptainBalancesDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'captains':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCaptainBalancesDtoOutputCaptainsInner),
                    ]),
                  )
                  as BuiltList<AdminCaptainBalancesDtoOutputCaptainsInner>;
          result.captains.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainBalancesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainBalancesDtoOutputBuilder();
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
