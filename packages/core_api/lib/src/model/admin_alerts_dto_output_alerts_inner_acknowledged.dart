//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_alerts_dto_output_alerts_inner_acknowledged.g.dart';

/// «استلام»: who took it, which every recipient sees.
///
/// Properties:
/// * [at]
/// * [byId]
/// * [byName]
@BuiltValue()
abstract class AdminAlertsDtoOutputAlertsInnerAcknowledged
    implements
        Built<
          AdminAlertsDtoOutputAlertsInnerAcknowledged,
          AdminAlertsDtoOutputAlertsInnerAcknowledgedBuilder
        > {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'byId')
  String get byId;

  @BuiltValueField(wireName: r'byName')
  String? get byName;

  AdminAlertsDtoOutputAlertsInnerAcknowledged._();

  factory AdminAlertsDtoOutputAlertsInnerAcknowledged([
    void updates(AdminAlertsDtoOutputAlertsInnerAcknowledgedBuilder b),
  ]) = _$AdminAlertsDtoOutputAlertsInnerAcknowledged;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminAlertsDtoOutputAlertsInnerAcknowledgedBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminAlertsDtoOutputAlertsInnerAcknowledged>
  get serializer => _$AdminAlertsDtoOutputAlertsInnerAcknowledgedSerializer();
}

class _$AdminAlertsDtoOutputAlertsInnerAcknowledgedSerializer
    implements
        PrimitiveSerializer<AdminAlertsDtoOutputAlertsInnerAcknowledged> {
  @override
  final Iterable<Type> types = const [
    AdminAlertsDtoOutputAlertsInnerAcknowledged,
    _$AdminAlertsDtoOutputAlertsInnerAcknowledged,
  ];

  @override
  final String wireName = r'AdminAlertsDtoOutputAlertsInnerAcknowledged';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminAlertsDtoOutputAlertsInnerAcknowledged object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'byId';
    yield serializers.serialize(
      object.byId,
      specifiedType: const FullType(String),
    );
    yield r'byName';
    yield object.byName == null
        ? null
        : serializers.serialize(
            object.byName,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminAlertsDtoOutputAlertsInnerAcknowledged object, {
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
    required AdminAlertsDtoOutputAlertsInnerAcknowledgedBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        case r'byId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.byId = valueDes;
          break;
        case r'byName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.byName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminAlertsDtoOutputAlertsInnerAcknowledged deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminAlertsDtoOutputAlertsInnerAcknowledgedBuilder();
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
