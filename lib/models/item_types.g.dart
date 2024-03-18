// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_types.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemTypesAdapter extends TypeAdapter<ItemTypes> {
  @override
  final int typeId = 6;

  @override
  ItemTypes read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ItemTypes.all;
      case 1:
        return ItemTypes.coffee;
      case 2:
        return ItemTypes.drink;
      case 3:
        return ItemTypes.food;
      default:
        return ItemTypes.all;
    }
  }

  @override
  void write(BinaryWriter writer, ItemTypes obj) {
    switch (obj) {
      case ItemTypes.all:
        writer.writeByte(0);
        break;
      case ItemTypes.coffee:
        writer.writeByte(1);
        break;
      case ItemTypes.drink:
        writer.writeByte(2);
        break;
      case ItemTypes.food:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemTypesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
