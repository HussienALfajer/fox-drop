//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_order_preparation.g.dart';

/// CaptainActiveOrderDtoOutputOrderPreparation
///
/// Properties:
/// * [ready] - «جاهز».
/// * [readyAt]
/// * [prepDueAt] - «قيد التحضير — جاهز بعد {د} د» counts to it while not ready.
@BuiltValue()
abstract class CaptainActiveOrderDtoOutputOrderPreparation
    implements
        Built<
          CaptainActiveOrderDtoOutputOrderPreparation,
          CaptainActiveOrderDtoOutputOrderPreparationBuilder
        > {
  /// «جاهز».
  @BuiltValueField(wireName: r'ready')
  bool get ready;

  @BuiltValueField(wireName: r'readyAt')
  DateTime? get readyAt;

  /// «قيد التحضير — جاهز بعد {د} د» counts to it while not ready.
  @BuiltValueField(wireName: r'prepDueAt')
  DateTime get prepDueAt;

  CaptainActiveOrderDtoOutputOrderPreparation._();

  factory CaptainActiveOrderDtoOutputOrderPreparation([
    void updates(CaptainActiveOrderDtoOutputOrderPreparationBuilder b),
  ]) = _$CaptainActiveOrderDtoOutputOrderPreparation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainActiveOrderDtoOutputOrderPreparationBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputOrderPreparation>
  get serializer => _$CaptainActiveOrderDtoOutputOrderPreparationSerializer();
}

class _$CaptainActiveOrderDtoOutputOrderPreparationSerializer
    implements
        PrimitiveSerializer<CaptainActiveOrderDtoOutputOrderPreparation> {
  @override
  final Iterable<Type> types = const [
    CaptainActiveOrderDtoOutputOrderPreparation,
    _$CaptainActiveOrderDtoOutputOrderPreparation,
  ];

  @override
  final String wireName = r'CaptainActiveOrderDtoOutputOrderPreparation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderPreparation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ready';
    yield serializers.serialize(
      object.ready,
      specifiedType: const FullType(bool),
    );
    yield r'readyAt';
    yield object.readyAt == null
        ? null
        : serializers.serialize(
            object.readyAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'prepDueAt';
    yield serializers.serialize(
      object.prepDueAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderPreparation object, {
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
    required CaptainActiveOrderDtoOutputOrderPreparationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ready':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.ready = valueDes;
          break;
        case r'readyAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.readyAt = valueDes;
          break;
        case r'prepDueAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.prepDueAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainActiveOrderDtoOutputOrderPreparation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainActiveOrderDtoOutputOrderPreparationBuilder();
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
