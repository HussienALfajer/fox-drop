//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_statement_list_dto_output_statements_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_statement_list_dto_output.g.dart';

/// CaptainStatementListDtoOutput
///
/// Properties:
/// * [statements] - Newest first.
@BuiltValue()
abstract class CaptainStatementListDtoOutput
    implements
        Built<
          CaptainStatementListDtoOutput,
          CaptainStatementListDtoOutputBuilder
        > {
  /// Newest first.
  @BuiltValueField(wireName: r'statements')
  BuiltList<CaptainStatementListDtoOutputStatementsInner> get statements;

  CaptainStatementListDtoOutput._();

  factory CaptainStatementListDtoOutput([
    void updates(CaptainStatementListDtoOutputBuilder b),
  ]) = _$CaptainStatementListDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainStatementListDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainStatementListDtoOutput> get serializer =>
      _$CaptainStatementListDtoOutputSerializer();
}

class _$CaptainStatementListDtoOutputSerializer
    implements PrimitiveSerializer<CaptainStatementListDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainStatementListDtoOutput,
    _$CaptainStatementListDtoOutput,
  ];

  @override
  final String wireName = r'CaptainStatementListDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainStatementListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'statements';
    yield serializers.serialize(
      object.statements,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainStatementListDtoOutputStatementsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainStatementListDtoOutput object, {
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
    required CaptainStatementListDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'statements':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainStatementListDtoOutputStatementsInner),
                    ]),
                  )
                  as BuiltList<CaptainStatementListDtoOutputStatementsInner>;
          result.statements.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainStatementListDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainStatementListDtoOutputBuilder();
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
