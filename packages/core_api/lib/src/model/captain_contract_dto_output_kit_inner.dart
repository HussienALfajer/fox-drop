//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_contract_dto_output_kit_inner.g.dart';

/// CaptainContractDtoOutputKitInner
///
/// Properties:
/// * [label]
/// * [size]
/// * [quantity]
@BuiltValue()
abstract class CaptainContractDtoOutputKitInner
    implements
        Built<
          CaptainContractDtoOutputKitInner,
          CaptainContractDtoOutputKitInnerBuilder
        > {
  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'size')
  String? get size;

  @BuiltValueField(wireName: r'quantity')
  int get quantity;

  CaptainContractDtoOutputKitInner._();

  factory CaptainContractDtoOutputKitInner([
    void updates(CaptainContractDtoOutputKitInnerBuilder b),
  ]) = _$CaptainContractDtoOutputKitInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainContractDtoOutputKitInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainContractDtoOutputKitInner> get serializer =>
      _$CaptainContractDtoOutputKitInnerSerializer();
}

class _$CaptainContractDtoOutputKitInnerSerializer
    implements PrimitiveSerializer<CaptainContractDtoOutputKitInner> {
  @override
  final Iterable<Type> types = const [
    CaptainContractDtoOutputKitInner,
    _$CaptainContractDtoOutputKitInner,
  ];

  @override
  final String wireName = r'CaptainContractDtoOutputKitInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainContractDtoOutputKitInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'size';
    yield object.size == null
        ? null
        : serializers.serialize(
            object.size,
            specifiedType: const FullType.nullable(String),
          );
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainContractDtoOutputKitInner object, {
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
    required CaptainContractDtoOutputKitInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'label':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.label = valueDes;
          break;
        case r'size':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.size = valueDes;
          break;
        case r'quantity':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.quantity = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainContractDtoOutputKitInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainContractDtoOutputKitInnerBuilder();
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
