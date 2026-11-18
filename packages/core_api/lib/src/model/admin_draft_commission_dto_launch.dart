//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_draft_commission_dto_launch.g.dart';

/// AdminDraftCommissionDtoLaunch
///
/// Properties:
/// * [rateBp]
/// * [until]
@BuiltValue()
abstract class AdminDraftCommissionDtoLaunch
    implements
        Built<
          AdminDraftCommissionDtoLaunch,
          AdminDraftCommissionDtoLaunchBuilder
        > {
  @BuiltValueField(wireName: r'rateBp')
  int get rateBp;

  @BuiltValueField(wireName: r'until')
  DateTime get until;

  AdminDraftCommissionDtoLaunch._();

  factory AdminDraftCommissionDtoLaunch([
    void updates(AdminDraftCommissionDtoLaunchBuilder b),
  ]) = _$AdminDraftCommissionDtoLaunch;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDraftCommissionDtoLaunchBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDraftCommissionDtoLaunch> get serializer =>
      _$AdminDraftCommissionDtoLaunchSerializer();
}

class _$AdminDraftCommissionDtoLaunchSerializer
    implements PrimitiveSerializer<AdminDraftCommissionDtoLaunch> {
  @override
  final Iterable<Type> types = const [
    AdminDraftCommissionDtoLaunch,
    _$AdminDraftCommissionDtoLaunch,
  ];

  @override
  final String wireName = r'AdminDraftCommissionDtoLaunch';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDraftCommissionDtoLaunch object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'rateBp';
    yield serializers.serialize(
      object.rateBp,
      specifiedType: const FullType(int),
    );
    yield r'until';
    yield serializers.serialize(
      object.until,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDraftCommissionDtoLaunch object, {
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
    required AdminDraftCommissionDtoLaunchBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'rateBp':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.rateBp = valueDes;
          break;
        case r'until':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.until = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDraftCommissionDtoLaunch deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDraftCommissionDtoLaunchBuilder();
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
