//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_live_map_dto_output_captains_inner_custody_usage.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_live_map_dto_output_captains_inner_custody.g.dart';

/// The cash-limit usage, in base.
///
/// Properties:
/// * [usage]
/// * [limit]
@BuiltValue()
abstract class AdminLiveMapDtoOutputCaptainsInnerCustody
    implements
        Built<
          AdminLiveMapDtoOutputCaptainsInnerCustody,
          AdminLiveMapDtoOutputCaptainsInnerCustodyBuilder
        > {
  @BuiltValueField(wireName: r'usage')
  AdminLiveMapDtoOutputCaptainsInnerCustodyUsage get usage;

  @BuiltValueField(wireName: r'limit')
  AdminLiveMapDtoOutputCaptainsInnerCustodyUsage get limit;

  AdminLiveMapDtoOutputCaptainsInnerCustody._();

  factory AdminLiveMapDtoOutputCaptainsInnerCustody([
    void updates(AdminLiveMapDtoOutputCaptainsInnerCustodyBuilder b),
  ]) = _$AdminLiveMapDtoOutputCaptainsInnerCustody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminLiveMapDtoOutputCaptainsInnerCustodyBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminLiveMapDtoOutputCaptainsInnerCustody> get serializer =>
      _$AdminLiveMapDtoOutputCaptainsInnerCustodySerializer();
}

class _$AdminLiveMapDtoOutputCaptainsInnerCustodySerializer
    implements PrimitiveSerializer<AdminLiveMapDtoOutputCaptainsInnerCustody> {
  @override
  final Iterable<Type> types = const [
    AdminLiveMapDtoOutputCaptainsInnerCustody,
    _$AdminLiveMapDtoOutputCaptainsInnerCustody,
  ];

  @override
  final String wireName = r'AdminLiveMapDtoOutputCaptainsInnerCustody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminLiveMapDtoOutputCaptainsInnerCustody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'usage';
    yield serializers.serialize(
      object.usage,
      specifiedType: const FullType(
        AdminLiveMapDtoOutputCaptainsInnerCustodyUsage,
      ),
    );
    yield r'limit';
    yield serializers.serialize(
      object.limit,
      specifiedType: const FullType(
        AdminLiveMapDtoOutputCaptainsInnerCustodyUsage,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminLiveMapDtoOutputCaptainsInnerCustody object, {
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
    required AdminLiveMapDtoOutputCaptainsInnerCustodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'usage':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminLiveMapDtoOutputCaptainsInnerCustodyUsage,
                    ),
                  )
                  as AdminLiveMapDtoOutputCaptainsInnerCustodyUsage;
          result.usage.replace(valueDes);
          break;
        case r'limit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminLiveMapDtoOutputCaptainsInnerCustodyUsage,
                    ),
                  )
                  as AdminLiveMapDtoOutputCaptainsInnerCustodyUsage;
          result.limit.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminLiveMapDtoOutputCaptainsInnerCustody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminLiveMapDtoOutputCaptainsInnerCustodyBuilder();
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
