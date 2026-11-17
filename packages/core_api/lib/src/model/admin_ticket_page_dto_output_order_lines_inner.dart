//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_page_dto_output_order_lines_inner.g.dart';

/// AdminTicketPageDtoOutputOrderLinesInner
///
/// Properties:
/// * [position]
/// * [name]
/// * [quantity]
/// * [unitPrice]
/// * [lineTotal]
@BuiltValue()
abstract class AdminTicketPageDtoOutputOrderLinesInner
    implements
        Built<
          AdminTicketPageDtoOutputOrderLinesInner,
          AdminTicketPageDtoOutputOrderLinesInnerBuilder
        > {
  @BuiltValueField(wireName: r'position')
  int get position;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'quantity')
  int get quantity;

  @BuiltValueField(wireName: r'unitPrice')
  String get unitPrice;

  @BuiltValueField(wireName: r'lineTotal')
  String get lineTotal;

  AdminTicketPageDtoOutputOrderLinesInner._();

  factory AdminTicketPageDtoOutputOrderLinesInner([
    void updates(AdminTicketPageDtoOutputOrderLinesInnerBuilder b),
  ]) = _$AdminTicketPageDtoOutputOrderLinesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTicketPageDtoOutputOrderLinesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketPageDtoOutputOrderLinesInner> get serializer =>
      _$AdminTicketPageDtoOutputOrderLinesInnerSerializer();
}

class _$AdminTicketPageDtoOutputOrderLinesInnerSerializer
    implements PrimitiveSerializer<AdminTicketPageDtoOutputOrderLinesInner> {
  @override
  final Iterable<Type> types = const [
    AdminTicketPageDtoOutputOrderLinesInner,
    _$AdminTicketPageDtoOutputOrderLinesInner,
  ];

  @override
  final String wireName = r'AdminTicketPageDtoOutputOrderLinesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketPageDtoOutputOrderLinesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'position';
    yield serializers.serialize(
      object.position,
      specifiedType: const FullType(int),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(int),
    );
    yield r'unitPrice';
    yield serializers.serialize(
      object.unitPrice,
      specifiedType: const FullType(String),
    );
    yield r'lineTotal';
    yield serializers.serialize(
      object.lineTotal,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketPageDtoOutputOrderLinesInner object, {
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
    required AdminTicketPageDtoOutputOrderLinesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'position':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.position = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'quantity':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.quantity = valueDes;
          break;
        case r'unitPrice':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.unitPrice = valueDes;
          break;
        case r'lineTotal':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.lineTotal = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTicketPageDtoOutputOrderLinesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketPageDtoOutputOrderLinesInnerBuilder();
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
