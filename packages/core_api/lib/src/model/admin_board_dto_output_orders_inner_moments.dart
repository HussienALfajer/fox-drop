//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_board_dto_output_orders_inner_moments.g.dart';

/// The alerts' moments, so the panel raises each when it passes.
///
/// Properties:
/// * [acceptAlertAt]
/// * [prepLateAlertAt]
/// * [searchStartedAt]
/// * [searchAlertAt]
/// * [noCaptainAlertAt]
@BuiltValue()
abstract class AdminBoardDtoOutputOrdersInnerMoments
    implements
        Built<
          AdminBoardDtoOutputOrdersInnerMoments,
          AdminBoardDtoOutputOrdersInnerMomentsBuilder
        > {
  @BuiltValueField(wireName: r'acceptAlertAt')
  DateTime? get acceptAlertAt;

  @BuiltValueField(wireName: r'prepLateAlertAt')
  DateTime? get prepLateAlertAt;

  @BuiltValueField(wireName: r'searchStartedAt')
  DateTime? get searchStartedAt;

  @BuiltValueField(wireName: r'searchAlertAt')
  DateTime? get searchAlertAt;

  @BuiltValueField(wireName: r'noCaptainAlertAt')
  DateTime? get noCaptainAlertAt;

  AdminBoardDtoOutputOrdersInnerMoments._();

  factory AdminBoardDtoOutputOrdersInnerMoments([
    void updates(AdminBoardDtoOutputOrdersInnerMomentsBuilder b),
  ]) = _$AdminBoardDtoOutputOrdersInnerMoments;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminBoardDtoOutputOrdersInnerMomentsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminBoardDtoOutputOrdersInnerMoments> get serializer =>
      _$AdminBoardDtoOutputOrdersInnerMomentsSerializer();
}

class _$AdminBoardDtoOutputOrdersInnerMomentsSerializer
    implements PrimitiveSerializer<AdminBoardDtoOutputOrdersInnerMoments> {
  @override
  final Iterable<Type> types = const [
    AdminBoardDtoOutputOrdersInnerMoments,
    _$AdminBoardDtoOutputOrdersInnerMoments,
  ];

  @override
  final String wireName = r'AdminBoardDtoOutputOrdersInnerMoments';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminBoardDtoOutputOrdersInnerMoments object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'acceptAlertAt';
    yield object.acceptAlertAt == null
        ? null
        : serializers.serialize(
            object.acceptAlertAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'prepLateAlertAt';
    yield object.prepLateAlertAt == null
        ? null
        : serializers.serialize(
            object.prepLateAlertAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'searchStartedAt';
    yield object.searchStartedAt == null
        ? null
        : serializers.serialize(
            object.searchStartedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'searchAlertAt';
    yield object.searchAlertAt == null
        ? null
        : serializers.serialize(
            object.searchAlertAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'noCaptainAlertAt';
    yield object.noCaptainAlertAt == null
        ? null
        : serializers.serialize(
            object.noCaptainAlertAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminBoardDtoOutputOrdersInnerMoments object, {
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
    required AdminBoardDtoOutputOrdersInnerMomentsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'acceptAlertAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.acceptAlertAt = valueDes;
          break;
        case r'prepLateAlertAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.prepLateAlertAt = valueDes;
          break;
        case r'searchStartedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.searchStartedAt = valueDes;
          break;
        case r'searchAlertAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.searchAlertAt = valueDes;
          break;
        case r'noCaptainAlertAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.noCaptainAlertAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminBoardDtoOutputOrdersInnerMoments deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminBoardDtoOutputOrdersInnerMomentsBuilder();
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
