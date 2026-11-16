//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_order_compensations_dto_output_compensations_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_compensation_requests_dto_output.g.dart';

/// AdminCompensationRequestsDtoOutput
///
/// Properties:
/// * [requests] - Oldest first.
@BuiltValue()
abstract class AdminCompensationRequestsDtoOutput
    implements
        Built<
          AdminCompensationRequestsDtoOutput,
          AdminCompensationRequestsDtoOutputBuilder
        > {
  /// Oldest first.
  @BuiltValueField(wireName: r'requests')
  BuiltList<AdminOrderCompensationsDtoOutputCompensationsInner> get requests;

  AdminCompensationRequestsDtoOutput._();

  factory AdminCompensationRequestsDtoOutput([
    void updates(AdminCompensationRequestsDtoOutputBuilder b),
  ]) = _$AdminCompensationRequestsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCompensationRequestsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCompensationRequestsDtoOutput> get serializer =>
      _$AdminCompensationRequestsDtoOutputSerializer();
}

class _$AdminCompensationRequestsDtoOutputSerializer
    implements PrimitiveSerializer<AdminCompensationRequestsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminCompensationRequestsDtoOutput,
    _$AdminCompensationRequestsDtoOutput,
  ];

  @override
  final String wireName = r'AdminCompensationRequestsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCompensationRequestsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'requests';
    yield serializers.serialize(
      object.requests,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminOrderCompensationsDtoOutputCompensationsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCompensationRequestsDtoOutput object, {
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
    required AdminCompensationRequestsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'requests':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminOrderCompensationsDtoOutputCompensationsInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminOrderCompensationsDtoOutputCompensationsInner
                  >;
          result.requests.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCompensationRequestsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCompensationRequestsDtoOutputBuilder();
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
