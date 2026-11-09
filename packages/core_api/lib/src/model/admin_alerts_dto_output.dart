//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_alerts_dto_output_alerts_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_alerts_dto_output.g.dart';

/// AdminAlertsDtoOutput
///
/// Properties:
/// * [alerts]
@BuiltValue()
abstract class AdminAlertsDtoOutput
    implements Built<AdminAlertsDtoOutput, AdminAlertsDtoOutputBuilder> {
  @BuiltValueField(wireName: r'alerts')
  BuiltList<AdminAlertsDtoOutputAlertsInner> get alerts;

  AdminAlertsDtoOutput._();

  factory AdminAlertsDtoOutput([void updates(AdminAlertsDtoOutputBuilder b)]) =
      _$AdminAlertsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminAlertsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminAlertsDtoOutput> get serializer =>
      _$AdminAlertsDtoOutputSerializer();
}

class _$AdminAlertsDtoOutputSerializer
    implements PrimitiveSerializer<AdminAlertsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminAlertsDtoOutput,
    _$AdminAlertsDtoOutput,
  ];

  @override
  final String wireName = r'AdminAlertsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminAlertsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'alerts';
    yield serializers.serialize(
      object.alerts,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminAlertsDtoOutputAlertsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminAlertsDtoOutput object, {
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
    required AdminAlertsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'alerts':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminAlertsDtoOutputAlertsInner),
                    ]),
                  )
                  as BuiltList<AdminAlertsDtoOutputAlertsInner>;
          result.alerts.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminAlertsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminAlertsDtoOutputBuilder();
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
