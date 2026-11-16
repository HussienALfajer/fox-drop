//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_alerts_dto_output_alerts_inner_location.g.dart';

/// «طوارئ كابتن» (AP §9.1.3, CA §9.11): the location the captain sent, for «فتح الخريطة»; null for the others and an emergency without a fix.
///
/// Properties:
/// * [latitude]
/// * [longitude]
/// * [at]
@BuiltValue()
abstract class AdminAlertsDtoOutputAlertsInnerLocation
    implements
        Built<
          AdminAlertsDtoOutputAlertsInnerLocation,
          AdminAlertsDtoOutputAlertsInnerLocationBuilder
        > {
  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  AdminAlertsDtoOutputAlertsInnerLocation._();

  factory AdminAlertsDtoOutputAlertsInnerLocation([
    void updates(AdminAlertsDtoOutputAlertsInnerLocationBuilder b),
  ]) = _$AdminAlertsDtoOutputAlertsInnerLocation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminAlertsDtoOutputAlertsInnerLocationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminAlertsDtoOutputAlertsInnerLocation> get serializer =>
      _$AdminAlertsDtoOutputAlertsInnerLocationSerializer();
}

class _$AdminAlertsDtoOutputAlertsInnerLocationSerializer
    implements PrimitiveSerializer<AdminAlertsDtoOutputAlertsInnerLocation> {
  @override
  final Iterable<Type> types = const [
    AdminAlertsDtoOutputAlertsInnerLocation,
    _$AdminAlertsDtoOutputAlertsInnerLocation,
  ];

  @override
  final String wireName = r'AdminAlertsDtoOutputAlertsInnerLocation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminAlertsDtoOutputAlertsInnerLocation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'latitude';
    yield serializers.serialize(
      object.latitude,
      specifiedType: const FullType(num),
    );
    yield r'longitude';
    yield serializers.serialize(
      object.longitude,
      specifiedType: const FullType(num),
    );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminAlertsDtoOutputAlertsInnerLocation object, {
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
    required AdminAlertsDtoOutputAlertsInnerLocationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'latitude':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(num))
                  as num;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(num))
                  as num;
          result.longitude = valueDes;
          break;
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminAlertsDtoOutputAlertsInnerLocation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminAlertsDtoOutputAlertsInnerLocationBuilder();
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
