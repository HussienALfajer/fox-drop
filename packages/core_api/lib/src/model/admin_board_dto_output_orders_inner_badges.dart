//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_board_dto_output_orders_inner_badges.g.dart';

/// AdminBoardDtoOutputOrdersInnerBadges
///
/// Properties:
/// * [needsAssignment] - «بحاجة لتعيين» (AP §8.3).
/// * [note] - «ملاحظة».
/// * [newCustomer] - «زبون جديد»: no delivered order yet.
@BuiltValue()
abstract class AdminBoardDtoOutputOrdersInnerBadges
    implements
        Built<
          AdminBoardDtoOutputOrdersInnerBadges,
          AdminBoardDtoOutputOrdersInnerBadgesBuilder
        > {
  /// «بحاجة لتعيين» (AP §8.3).
  @BuiltValueField(wireName: r'needsAssignment')
  bool get needsAssignment;

  /// «ملاحظة».
  @BuiltValueField(wireName: r'note')
  bool get note;

  /// «زبون جديد»: no delivered order yet.
  @BuiltValueField(wireName: r'newCustomer')
  bool get newCustomer;

  AdminBoardDtoOutputOrdersInnerBadges._();

  factory AdminBoardDtoOutputOrdersInnerBadges([
    void updates(AdminBoardDtoOutputOrdersInnerBadgesBuilder b),
  ]) = _$AdminBoardDtoOutputOrdersInnerBadges;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminBoardDtoOutputOrdersInnerBadgesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminBoardDtoOutputOrdersInnerBadges> get serializer =>
      _$AdminBoardDtoOutputOrdersInnerBadgesSerializer();
}

class _$AdminBoardDtoOutputOrdersInnerBadgesSerializer
    implements PrimitiveSerializer<AdminBoardDtoOutputOrdersInnerBadges> {
  @override
  final Iterable<Type> types = const [
    AdminBoardDtoOutputOrdersInnerBadges,
    _$AdminBoardDtoOutputOrdersInnerBadges,
  ];

  @override
  final String wireName = r'AdminBoardDtoOutputOrdersInnerBadges';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminBoardDtoOutputOrdersInnerBadges object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'needsAssignment';
    yield serializers.serialize(
      object.needsAssignment,
      specifiedType: const FullType(bool),
    );
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(bool),
    );
    yield r'newCustomer';
    yield serializers.serialize(
      object.newCustomer,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminBoardDtoOutputOrdersInnerBadges object, {
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
    required AdminBoardDtoOutputOrdersInnerBadgesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'needsAssignment':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.needsAssignment = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.note = valueDes;
          break;
        case r'newCustomer':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.newCustomer = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminBoardDtoOutputOrdersInnerBadges deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminBoardDtoOutputOrdersInnerBadgesBuilder();
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
