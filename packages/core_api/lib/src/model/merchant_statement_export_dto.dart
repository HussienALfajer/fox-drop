//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_statement_export_dto.g.dart';

/// MerchantStatementExportDto
///
/// Properties:
/// * [statementId]
@BuiltValue()
abstract class MerchantStatementExportDto
    implements
        Built<MerchantStatementExportDto, MerchantStatementExportDtoBuilder> {
  @BuiltValueField(wireName: r'statementId')
  String get statementId;

  MerchantStatementExportDto._();

  factory MerchantStatementExportDto([
    void updates(MerchantStatementExportDtoBuilder b),
  ]) = _$MerchantStatementExportDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantStatementExportDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantStatementExportDto> get serializer =>
      _$MerchantStatementExportDtoSerializer();
}

class _$MerchantStatementExportDtoSerializer
    implements PrimitiveSerializer<MerchantStatementExportDto> {
  @override
  final Iterable<Type> types = const [
    MerchantStatementExportDto,
    _$MerchantStatementExportDto,
  ];

  @override
  final String wireName = r'MerchantStatementExportDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantStatementExportDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'statementId';
    yield serializers.serialize(
      object.statementId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantStatementExportDto object, {
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
    required MerchantStatementExportDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'statementId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.statementId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantStatementExportDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantStatementExportDtoBuilder();
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
