//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_list_dto_output_captains_inner_acceptance.g.dart';

/// Of the last captain.acceptance_window_offers answered; null without one.
///
/// Properties:
/// * [accepted]
/// * [answered]
@BuiltValue()
abstract class AdminCaptainListDtoOutputCaptainsInnerAcceptance
    implements
        Built<
          AdminCaptainListDtoOutputCaptainsInnerAcceptance,
          AdminCaptainListDtoOutputCaptainsInnerAcceptanceBuilder
        > {
  @BuiltValueField(wireName: r'accepted')
  int get accepted;

  @BuiltValueField(wireName: r'answered')
  int get answered;

  AdminCaptainListDtoOutputCaptainsInnerAcceptance._();

  factory AdminCaptainListDtoOutputCaptainsInnerAcceptance([
    void updates(AdminCaptainListDtoOutputCaptainsInnerAcceptanceBuilder b),
  ]) = _$AdminCaptainListDtoOutputCaptainsInnerAcceptance;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminCaptainListDtoOutputCaptainsInnerAcceptanceBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainListDtoOutputCaptainsInnerAcceptance>
  get serializer =>
      _$AdminCaptainListDtoOutputCaptainsInnerAcceptanceSerializer();
}

class _$AdminCaptainListDtoOutputCaptainsInnerAcceptanceSerializer
    implements
        PrimitiveSerializer<AdminCaptainListDtoOutputCaptainsInnerAcceptance> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainListDtoOutputCaptainsInnerAcceptance,
    _$AdminCaptainListDtoOutputCaptainsInnerAcceptance,
  ];

  @override
  final String wireName = r'AdminCaptainListDtoOutputCaptainsInnerAcceptance';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainListDtoOutputCaptainsInnerAcceptance object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accepted';
    yield serializers.serialize(
      object.accepted,
      specifiedType: const FullType(int),
    );
    yield r'answered';
    yield serializers.serialize(
      object.answered,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainListDtoOutputCaptainsInnerAcceptance object, {
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
    required AdminCaptainListDtoOutputCaptainsInnerAcceptanceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accepted':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.accepted = valueDes;
          break;
        case r'answered':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.answered = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainListDtoOutputCaptainsInnerAcceptance deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainListDtoOutputCaptainsInnerAcceptanceBuilder();
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
