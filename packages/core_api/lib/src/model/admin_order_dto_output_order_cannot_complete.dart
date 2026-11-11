//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_cannot_complete.g.dart';

/// «بانتظار العمليات» (CA §9.11, slice 2.13b): the captain's open «لا أستطيع إكمال الطلب»; «سحب وإعادة تعيين» prefills «بخطأ من الكابتن» and «تسليم لكابتن آخر» asks the fault while it is open. Null without one.
///
/// Properties:
/// * [captainId]
/// * [reason] - The captain_cannot_complete code.
/// * [label] - The reason's label as the captain chose it.
/// * [note] - The text of «أخرى».
/// * [at]
@BuiltValue()
abstract class AdminOrderDtoOutputOrderCannotComplete
    implements
        Built<
          AdminOrderDtoOutputOrderCannotComplete,
          AdminOrderDtoOutputOrderCannotCompleteBuilder
        > {
  @BuiltValueField(wireName: r'captainId')
  String get captainId;

  /// The captain_cannot_complete code.
  @BuiltValueField(wireName: r'reason')
  String get reason;

  /// The reason's label as the captain chose it.
  @BuiltValueField(wireName: r'label')
  String get label;

  /// The text of «أخرى».
  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  AdminOrderDtoOutputOrderCannotComplete._();

  factory AdminOrderDtoOutputOrderCannotComplete([
    void updates(AdminOrderDtoOutputOrderCannotCompleteBuilder b),
  ]) = _$AdminOrderDtoOutputOrderCannotComplete;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderCannotCompleteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderCannotComplete> get serializer =>
      _$AdminOrderDtoOutputOrderCannotCompleteSerializer();
}

class _$AdminOrderDtoOutputOrderCannotCompleteSerializer
    implements PrimitiveSerializer<AdminOrderDtoOutputOrderCannotComplete> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderCannotComplete,
    _$AdminOrderDtoOutputOrderCannotComplete,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderCannotComplete';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderCannotComplete object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'captainId';
    yield serializers.serialize(
      object.captainId,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
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
    AdminOrderDtoOutputOrderCannotComplete object, {
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
    required AdminOrderDtoOutputOrderCannotCompleteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'captainId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.captainId = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        case r'label':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.label = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
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
  AdminOrderDtoOutputOrderCannotComplete deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderCannotCompleteBuilder();
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
