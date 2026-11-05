// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _normalizedNameMeta = const VerificationMeta(
    'normalizedName',
  );
  @override
  late final GeneratedColumn<String> normalizedName = GeneratedColumn<String>(
    'normalized_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorArgbMeta = const VerificationMeta(
    'colorArgb',
  );
  @override
  late final GeneratedColumn<int> colorArgb = GeneratedColumn<int>(
    'color_argb',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _budgetLimitInCentsMeta =
      const VerificationMeta('budgetLimitInCents');
  @override
  late final GeneratedColumn<int> budgetLimitInCents = GeneratedColumn<int>(
    'budget_limit_in_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    normalizedName,
    type,
    icon,
    colorArgb,
    isActive,
    createdAt,
    budgetLimitInCents,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('normalized_name')) {
      context.handle(
        _normalizedNameMeta,
        normalizedName.isAcceptableOrUnknown(
          data['normalized_name']!,
          _normalizedNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_normalizedNameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color_argb')) {
      context.handle(
        _colorArgbMeta,
        colorArgb.isAcceptableOrUnknown(data['color_argb']!, _colorArgbMeta),
      );
    } else if (isInserting) {
      context.missing(_colorArgbMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('budget_limit_in_cents')) {
      context.handle(
        _budgetLimitInCentsMeta,
        budgetLimitInCents.isAcceptableOrUnknown(
          data['budget_limit_in_cents']!,
          _budgetLimitInCentsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {type, normalizedName},
  ];
  @override
  CategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      normalizedName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      colorArgb: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_argb'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      budgetLimitInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}budget_limit_in_cents'],
      ),
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class CategoryRow extends DataClass implements Insertable<CategoryRow> {
  final int id;
  final String name;
  final String normalizedName;
  final String type;
  final String icon;
  final int colorArgb;
  final bool isActive;
  final DateTime createdAt;
  final int? budgetLimitInCents;
  const CategoryRow({
    required this.id,
    required this.name,
    required this.normalizedName,
    required this.type,
    required this.icon,
    required this.colorArgb,
    required this.isActive,
    required this.createdAt,
    this.budgetLimitInCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['normalized_name'] = Variable<String>(normalizedName);
    map['type'] = Variable<String>(type);
    map['icon'] = Variable<String>(icon);
    map['color_argb'] = Variable<int>(colorArgb);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || budgetLimitInCents != null) {
      map['budget_limit_in_cents'] = Variable<int>(budgetLimitInCents);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      normalizedName: Value(normalizedName),
      type: Value(type),
      icon: Value(icon),
      colorArgb: Value(colorArgb),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      budgetLimitInCents: budgetLimitInCents == null && nullToAbsent
          ? const Value.absent()
          : Value(budgetLimitInCents),
    );
  }

  factory CategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      normalizedName: serializer.fromJson<String>(json['normalizedName']),
      type: serializer.fromJson<String>(json['type']),
      icon: serializer.fromJson<String>(json['icon']),
      colorArgb: serializer.fromJson<int>(json['colorArgb']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      budgetLimitInCents: serializer.fromJson<int?>(json['budgetLimitInCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'normalizedName': serializer.toJson<String>(normalizedName),
      'type': serializer.toJson<String>(type),
      'icon': serializer.toJson<String>(icon),
      'colorArgb': serializer.toJson<int>(colorArgb),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'budgetLimitInCents': serializer.toJson<int?>(budgetLimitInCents),
    };
  }

  CategoryRow copyWith({
    int? id,
    String? name,
    String? normalizedName,
    String? type,
    String? icon,
    int? colorArgb,
    bool? isActive,
    DateTime? createdAt,
    Value<int?> budgetLimitInCents = const Value.absent(),
  }) => CategoryRow(
    id: id ?? this.id,
    name: name ?? this.name,
    normalizedName: normalizedName ?? this.normalizedName,
    type: type ?? this.type,
    icon: icon ?? this.icon,
    colorArgb: colorArgb ?? this.colorArgb,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    budgetLimitInCents: budgetLimitInCents.present
        ? budgetLimitInCents.value
        : this.budgetLimitInCents,
  );
  CategoryRow copyWithCompanion(CategoriesCompanion data) {
    return CategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      normalizedName: data.normalizedName.present
          ? data.normalizedName.value
          : this.normalizedName,
      type: data.type.present ? data.type.value : this.type,
      icon: data.icon.present ? data.icon.value : this.icon,
      colorArgb: data.colorArgb.present ? data.colorArgb.value : this.colorArgb,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      budgetLimitInCents: data.budgetLimitInCents.present
          ? data.budgetLimitInCents.value
          : this.budgetLimitInCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('normalizedName: $normalizedName, ')
          ..write('type: $type, ')
          ..write('icon: $icon, ')
          ..write('colorArgb: $colorArgb, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('budgetLimitInCents: $budgetLimitInCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    normalizedName,
    type,
    icon,
    colorArgb,
    isActive,
    createdAt,
    budgetLimitInCents,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.normalizedName == this.normalizedName &&
          other.type == this.type &&
          other.icon == this.icon &&
          other.colorArgb == this.colorArgb &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.budgetLimitInCents == this.budgetLimitInCents);
}

class CategoriesCompanion extends UpdateCompanion<CategoryRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> normalizedName;
  final Value<String> type;
  final Value<String> icon;
  final Value<int> colorArgb;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<int?> budgetLimitInCents;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.normalizedName = const Value.absent(),
    this.type = const Value.absent(),
    this.icon = const Value.absent(),
    this.colorArgb = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.budgetLimitInCents = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String normalizedName,
    required String type,
    required String icon,
    required int colorArgb,
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.budgetLimitInCents = const Value.absent(),
  }) : name = Value(name),
       normalizedName = Value(normalizedName),
       type = Value(type),
       icon = Value(icon),
       colorArgb = Value(colorArgb);
  static Insertable<CategoryRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? normalizedName,
    Expression<String>? type,
    Expression<String>? icon,
    Expression<int>? colorArgb,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<int>? budgetLimitInCents,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (normalizedName != null) 'normalized_name': normalizedName,
      if (type != null) 'type': type,
      if (icon != null) 'icon': icon,
      if (colorArgb != null) 'color_argb': colorArgb,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (budgetLimitInCents != null)
        'budget_limit_in_cents': budgetLimitInCents,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? normalizedName,
    Value<String>? type,
    Value<String>? icon,
    Value<int>? colorArgb,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<int?>? budgetLimitInCents,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      normalizedName: normalizedName ?? this.normalizedName,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      colorArgb: colorArgb ?? this.colorArgb,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      budgetLimitInCents: budgetLimitInCents ?? this.budgetLimitInCents,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (normalizedName.present) {
      map['normalized_name'] = Variable<String>(normalizedName.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (colorArgb.present) {
      map['color_argb'] = Variable<int>(colorArgb.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (budgetLimitInCents.present) {
      map['budget_limit_in_cents'] = Variable<int>(budgetLimitInCents.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('normalizedName: $normalizedName, ')
          ..write('type: $type, ')
          ..write('icon: $icon, ')
          ..write('colorArgb: $colorArgb, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('budgetLimitInCents: $budgetLimitInCents')
          ..write(')'))
        .toString();
  }
}

class $PaymentMethodsTable extends PaymentMethods
    with TableInfo<$PaymentMethodsTable, PaymentMethodRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentMethodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _normalizedNameMeta = const VerificationMeta(
    'normalizedName',
  );
  @override
  late final GeneratedColumn<String> normalizedName = GeneratedColumn<String>(
    'normalized_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorArgbMeta = const VerificationMeta(
    'colorArgb',
  );
  @override
  late final GeneratedColumn<int> colorArgb = GeneratedColumn<int>(
    'color_argb',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    normalizedName,
    icon,
    colorArgb,
    isActive,
    isDefault,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_methods';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentMethodRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('normalized_name')) {
      context.handle(
        _normalizedNameMeta,
        normalizedName.isAcceptableOrUnknown(
          data['normalized_name']!,
          _normalizedNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_normalizedNameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color_argb')) {
      context.handle(
        _colorArgbMeta,
        colorArgb.isAcceptableOrUnknown(data['color_argb']!, _colorArgbMeta),
      );
    } else if (isInserting) {
      context.missing(_colorArgbMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {normalizedName},
  ];
  @override
  PaymentMethodRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentMethodRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      normalizedName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      colorArgb: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_argb'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PaymentMethodsTable createAlias(String alias) {
    return $PaymentMethodsTable(attachedDatabase, alias);
  }
}

class PaymentMethodRow extends DataClass
    implements Insertable<PaymentMethodRow> {
  final int id;
  final String name;
  final String normalizedName;
  final String icon;
  final int colorArgb;
  final bool isActive;
  final bool isDefault;
  final DateTime createdAt;
  const PaymentMethodRow({
    required this.id,
    required this.name,
    required this.normalizedName,
    required this.icon,
    required this.colorArgb,
    required this.isActive,
    required this.isDefault,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['normalized_name'] = Variable<String>(normalizedName);
    map['icon'] = Variable<String>(icon);
    map['color_argb'] = Variable<int>(colorArgb);
    map['is_active'] = Variable<bool>(isActive);
    map['is_default'] = Variable<bool>(isDefault);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PaymentMethodsCompanion toCompanion(bool nullToAbsent) {
    return PaymentMethodsCompanion(
      id: Value(id),
      name: Value(name),
      normalizedName: Value(normalizedName),
      icon: Value(icon),
      colorArgb: Value(colorArgb),
      isActive: Value(isActive),
      isDefault: Value(isDefault),
      createdAt: Value(createdAt),
    );
  }

  factory PaymentMethodRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentMethodRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      normalizedName: serializer.fromJson<String>(json['normalizedName']),
      icon: serializer.fromJson<String>(json['icon']),
      colorArgb: serializer.fromJson<int>(json['colorArgb']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'normalizedName': serializer.toJson<String>(normalizedName),
      'icon': serializer.toJson<String>(icon),
      'colorArgb': serializer.toJson<int>(colorArgb),
      'isActive': serializer.toJson<bool>(isActive),
      'isDefault': serializer.toJson<bool>(isDefault),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PaymentMethodRow copyWith({
    int? id,
    String? name,
    String? normalizedName,
    String? icon,
    int? colorArgb,
    bool? isActive,
    bool? isDefault,
    DateTime? createdAt,
  }) => PaymentMethodRow(
    id: id ?? this.id,
    name: name ?? this.name,
    normalizedName: normalizedName ?? this.normalizedName,
    icon: icon ?? this.icon,
    colorArgb: colorArgb ?? this.colorArgb,
    isActive: isActive ?? this.isActive,
    isDefault: isDefault ?? this.isDefault,
    createdAt: createdAt ?? this.createdAt,
  );
  PaymentMethodRow copyWithCompanion(PaymentMethodsCompanion data) {
    return PaymentMethodRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      normalizedName: data.normalizedName.present
          ? data.normalizedName.value
          : this.normalizedName,
      icon: data.icon.present ? data.icon.value : this.icon,
      colorArgb: data.colorArgb.present ? data.colorArgb.value : this.colorArgb,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentMethodRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('normalizedName: $normalizedName, ')
          ..write('icon: $icon, ')
          ..write('colorArgb: $colorArgb, ')
          ..write('isActive: $isActive, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    normalizedName,
    icon,
    colorArgb,
    isActive,
    isDefault,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentMethodRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.normalizedName == this.normalizedName &&
          other.icon == this.icon &&
          other.colorArgb == this.colorArgb &&
          other.isActive == this.isActive &&
          other.isDefault == this.isDefault &&
          other.createdAt == this.createdAt);
}

class PaymentMethodsCompanion extends UpdateCompanion<PaymentMethodRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> normalizedName;
  final Value<String> icon;
  final Value<int> colorArgb;
  final Value<bool> isActive;
  final Value<bool> isDefault;
  final Value<DateTime> createdAt;
  const PaymentMethodsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.normalizedName = const Value.absent(),
    this.icon = const Value.absent(),
    this.colorArgb = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PaymentMethodsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String normalizedName,
    required String icon,
    required int colorArgb,
    this.isActive = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       normalizedName = Value(normalizedName),
       icon = Value(icon),
       colorArgb = Value(colorArgb);
  static Insertable<PaymentMethodRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? normalizedName,
    Expression<String>? icon,
    Expression<int>? colorArgb,
    Expression<bool>? isActive,
    Expression<bool>? isDefault,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (normalizedName != null) 'normalized_name': normalizedName,
      if (icon != null) 'icon': icon,
      if (colorArgb != null) 'color_argb': colorArgb,
      if (isActive != null) 'is_active': isActive,
      if (isDefault != null) 'is_default': isDefault,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PaymentMethodsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? normalizedName,
    Value<String>? icon,
    Value<int>? colorArgb,
    Value<bool>? isActive,
    Value<bool>? isDefault,
    Value<DateTime>? createdAt,
  }) {
    return PaymentMethodsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      normalizedName: normalizedName ?? this.normalizedName,
      icon: icon ?? this.icon,
      colorArgb: colorArgb ?? this.colorArgb,
      isActive: isActive ?? this.isActive,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (normalizedName.present) {
      map['normalized_name'] = Variable<String>(normalizedName.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (colorArgb.present) {
      map['color_argb'] = Variable<int>(colorArgb.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentMethodsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('normalizedName: $normalizedName, ')
          ..write('icon: $icon, ')
          ..write('colorArgb: $colorArgb, ')
          ..write('isActive: $isActive, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, FinanceTransactionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _amountInCentsMeta = const VerificationMeta(
    'amountInCents',
  );
  @override
  late final GeneratedColumn<int> amountInCents = GeneratedColumn<int>(
    'amount_in_cents',
    aliasedName,
    false,
    check: () => ComparableExpr(amountInCents).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _paymentMethodIdMeta = const VerificationMeta(
    'paymentMethodId',
  );
  @override
  late final GeneratedColumn<int> paymentMethodId = GeneratedColumn<int>(
    'payment_method_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES payment_methods (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateEpochDayMeta = const VerificationMeta(
    'dateEpochDay',
  );
  @override
  late final GeneratedColumn<int> dateEpochDay = GeneratedColumn<int>(
    'date_epoch_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _fixedEntryIdMeta = const VerificationMeta(
    'fixedEntryId',
  );
  @override
  late final GeneratedColumn<int> fixedEntryId = GeneratedColumn<int>(
    'fixed_entry_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _savingsGoalIdMeta = const VerificationMeta(
    'savingsGoalId',
  );
  @override
  late final GeneratedColumn<int> savingsGoalId = GeneratedColumn<int>(
    'savings_goal_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amountInCents,
    type,
    categoryId,
    paymentMethodId,
    description,
    dateEpochDay,
    createdAt,
    updatedAt,
    fixedEntryId,
    savingsGoalId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FinanceTransactionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount_in_cents')) {
      context.handle(
        _amountInCentsMeta,
        amountInCents.isAcceptableOrUnknown(
          data['amount_in_cents']!,
          _amountInCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountInCentsMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('payment_method_id')) {
      context.handle(
        _paymentMethodIdMeta,
        paymentMethodId.isAcceptableOrUnknown(
          data['payment_method_id']!,
          _paymentMethodIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentMethodIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('date_epoch_day')) {
      context.handle(
        _dateEpochDayMeta,
        dateEpochDay.isAcceptableOrUnknown(
          data['date_epoch_day']!,
          _dateEpochDayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateEpochDayMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('fixed_entry_id')) {
      context.handle(
        _fixedEntryIdMeta,
        fixedEntryId.isAcceptableOrUnknown(
          data['fixed_entry_id']!,
          _fixedEntryIdMeta,
        ),
      );
    }
    if (data.containsKey('savings_goal_id')) {
      context.handle(
        _savingsGoalIdMeta,
        savingsGoalId.isAcceptableOrUnknown(
          data['savings_goal_id']!,
          _savingsGoalIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinanceTransactionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinanceTransactionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      amountInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_in_cents'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      paymentMethodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payment_method_id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      dateEpochDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date_epoch_day'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      fixedEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fixed_entry_id'],
      ),
      savingsGoalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}savings_goal_id'],
      ),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class FinanceTransactionRow extends DataClass
    implements Insertable<FinanceTransactionRow> {
  final int id;
  final int amountInCents;
  final String type;
  final int categoryId;
  final int paymentMethodId;
  final String? description;
  final int dateEpochDay;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? fixedEntryId;
  final int? savingsGoalId;
  const FinanceTransactionRow({
    required this.id,
    required this.amountInCents,
    required this.type,
    required this.categoryId,
    required this.paymentMethodId,
    this.description,
    required this.dateEpochDay,
    required this.createdAt,
    required this.updatedAt,
    this.fixedEntryId,
    this.savingsGoalId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount_in_cents'] = Variable<int>(amountInCents);
    map['type'] = Variable<String>(type);
    map['category_id'] = Variable<int>(categoryId);
    map['payment_method_id'] = Variable<int>(paymentMethodId);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['date_epoch_day'] = Variable<int>(dateEpochDay);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || fixedEntryId != null) {
      map['fixed_entry_id'] = Variable<int>(fixedEntryId);
    }
    if (!nullToAbsent || savingsGoalId != null) {
      map['savings_goal_id'] = Variable<int>(savingsGoalId);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      amountInCents: Value(amountInCents),
      type: Value(type),
      categoryId: Value(categoryId),
      paymentMethodId: Value(paymentMethodId),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      dateEpochDay: Value(dateEpochDay),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      fixedEntryId: fixedEntryId == null && nullToAbsent
          ? const Value.absent()
          : Value(fixedEntryId),
      savingsGoalId: savingsGoalId == null && nullToAbsent
          ? const Value.absent()
          : Value(savingsGoalId),
    );
  }

  factory FinanceTransactionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinanceTransactionRow(
      id: serializer.fromJson<int>(json['id']),
      amountInCents: serializer.fromJson<int>(json['amountInCents']),
      type: serializer.fromJson<String>(json['type']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      paymentMethodId: serializer.fromJson<int>(json['paymentMethodId']),
      description: serializer.fromJson<String?>(json['description']),
      dateEpochDay: serializer.fromJson<int>(json['dateEpochDay']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      fixedEntryId: serializer.fromJson<int?>(json['fixedEntryId']),
      savingsGoalId: serializer.fromJson<int?>(json['savingsGoalId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amountInCents': serializer.toJson<int>(amountInCents),
      'type': serializer.toJson<String>(type),
      'categoryId': serializer.toJson<int>(categoryId),
      'paymentMethodId': serializer.toJson<int>(paymentMethodId),
      'description': serializer.toJson<String?>(description),
      'dateEpochDay': serializer.toJson<int>(dateEpochDay),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'fixedEntryId': serializer.toJson<int?>(fixedEntryId),
      'savingsGoalId': serializer.toJson<int?>(savingsGoalId),
    };
  }

  FinanceTransactionRow copyWith({
    int? id,
    int? amountInCents,
    String? type,
    int? categoryId,
    int? paymentMethodId,
    Value<String?> description = const Value.absent(),
    int? dateEpochDay,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<int?> fixedEntryId = const Value.absent(),
    Value<int?> savingsGoalId = const Value.absent(),
  }) => FinanceTransactionRow(
    id: id ?? this.id,
    amountInCents: amountInCents ?? this.amountInCents,
    type: type ?? this.type,
    categoryId: categoryId ?? this.categoryId,
    paymentMethodId: paymentMethodId ?? this.paymentMethodId,
    description: description.present ? description.value : this.description,
    dateEpochDay: dateEpochDay ?? this.dateEpochDay,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    fixedEntryId: fixedEntryId.present ? fixedEntryId.value : this.fixedEntryId,
    savingsGoalId: savingsGoalId.present
        ? savingsGoalId.value
        : this.savingsGoalId,
  );
  FinanceTransactionRow copyWithCompanion(TransactionsCompanion data) {
    return FinanceTransactionRow(
      id: data.id.present ? data.id.value : this.id,
      amountInCents: data.amountInCents.present
          ? data.amountInCents.value
          : this.amountInCents,
      type: data.type.present ? data.type.value : this.type,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      paymentMethodId: data.paymentMethodId.present
          ? data.paymentMethodId.value
          : this.paymentMethodId,
      description: data.description.present
          ? data.description.value
          : this.description,
      dateEpochDay: data.dateEpochDay.present
          ? data.dateEpochDay.value
          : this.dateEpochDay,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      fixedEntryId: data.fixedEntryId.present
          ? data.fixedEntryId.value
          : this.fixedEntryId,
      savingsGoalId: data.savingsGoalId.present
          ? data.savingsGoalId.value
          : this.savingsGoalId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinanceTransactionRow(')
          ..write('id: $id, ')
          ..write('amountInCents: $amountInCents, ')
          ..write('type: $type, ')
          ..write('categoryId: $categoryId, ')
          ..write('paymentMethodId: $paymentMethodId, ')
          ..write('description: $description, ')
          ..write('dateEpochDay: $dateEpochDay, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('fixedEntryId: $fixedEntryId, ')
          ..write('savingsGoalId: $savingsGoalId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    amountInCents,
    type,
    categoryId,
    paymentMethodId,
    description,
    dateEpochDay,
    createdAt,
    updatedAt,
    fixedEntryId,
    savingsGoalId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinanceTransactionRow &&
          other.id == this.id &&
          other.amountInCents == this.amountInCents &&
          other.type == this.type &&
          other.categoryId == this.categoryId &&
          other.paymentMethodId == this.paymentMethodId &&
          other.description == this.description &&
          other.dateEpochDay == this.dateEpochDay &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.fixedEntryId == this.fixedEntryId &&
          other.savingsGoalId == this.savingsGoalId);
}

class TransactionsCompanion extends UpdateCompanion<FinanceTransactionRow> {
  final Value<int> id;
  final Value<int> amountInCents;
  final Value<String> type;
  final Value<int> categoryId;
  final Value<int> paymentMethodId;
  final Value<String?> description;
  final Value<int> dateEpochDay;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int?> fixedEntryId;
  final Value<int?> savingsGoalId;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.amountInCents = const Value.absent(),
    this.type = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.paymentMethodId = const Value.absent(),
    this.description = const Value.absent(),
    this.dateEpochDay = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.fixedEntryId = const Value.absent(),
    this.savingsGoalId = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required int amountInCents,
    required String type,
    required int categoryId,
    required int paymentMethodId,
    this.description = const Value.absent(),
    required int dateEpochDay,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.fixedEntryId = const Value.absent(),
    this.savingsGoalId = const Value.absent(),
  }) : amountInCents = Value(amountInCents),
       type = Value(type),
       categoryId = Value(categoryId),
       paymentMethodId = Value(paymentMethodId),
       dateEpochDay = Value(dateEpochDay);
  static Insertable<FinanceTransactionRow> custom({
    Expression<int>? id,
    Expression<int>? amountInCents,
    Expression<String>? type,
    Expression<int>? categoryId,
    Expression<int>? paymentMethodId,
    Expression<String>? description,
    Expression<int>? dateEpochDay,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? fixedEntryId,
    Expression<int>? savingsGoalId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amountInCents != null) 'amount_in_cents': amountInCents,
      if (type != null) 'type': type,
      if (categoryId != null) 'category_id': categoryId,
      if (paymentMethodId != null) 'payment_method_id': paymentMethodId,
      if (description != null) 'description': description,
      if (dateEpochDay != null) 'date_epoch_day': dateEpochDay,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (fixedEntryId != null) 'fixed_entry_id': fixedEntryId,
      if (savingsGoalId != null) 'savings_goal_id': savingsGoalId,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? id,
    Value<int>? amountInCents,
    Value<String>? type,
    Value<int>? categoryId,
    Value<int>? paymentMethodId,
    Value<String?>? description,
    Value<int>? dateEpochDay,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int?>? fixedEntryId,
    Value<int?>? savingsGoalId,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      amountInCents: amountInCents ?? this.amountInCents,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      description: description ?? this.description,
      dateEpochDay: dateEpochDay ?? this.dateEpochDay,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fixedEntryId: fixedEntryId ?? this.fixedEntryId,
      savingsGoalId: savingsGoalId ?? this.savingsGoalId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amountInCents.present) {
      map['amount_in_cents'] = Variable<int>(amountInCents.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (paymentMethodId.present) {
      map['payment_method_id'] = Variable<int>(paymentMethodId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dateEpochDay.present) {
      map['date_epoch_day'] = Variable<int>(dateEpochDay.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (fixedEntryId.present) {
      map['fixed_entry_id'] = Variable<int>(fixedEntryId.value);
    }
    if (savingsGoalId.present) {
      map['savings_goal_id'] = Variable<int>(savingsGoalId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('amountInCents: $amountInCents, ')
          ..write('type: $type, ')
          ..write('categoryId: $categoryId, ')
          ..write('paymentMethodId: $paymentMethodId, ')
          ..write('description: $description, ')
          ..write('dateEpochDay: $dateEpochDay, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('fixedEntryId: $fixedEntryId, ')
          ..write('savingsGoalId: $savingsGoalId')
          ..write(')'))
        .toString();
  }
}

class $SavingsGoalsTable extends SavingsGoals
    with TableInfo<$SavingsGoalsTable, SavingsGoalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetAmountInCentsMeta =
      const VerificationMeta('targetAmountInCents');
  @override
  late final GeneratedColumn<int> targetAmountInCents = GeneratedColumn<int>(
    'target_amount_in_cents',
    aliasedName,
    false,
    check: () => ComparableExpr(targetAmountInCents).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    targetAmountInCents,
    createdAt,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingsGoalRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_amount_in_cents')) {
      context.handle(
        _targetAmountInCentsMeta,
        targetAmountInCents.isAcceptableOrUnknown(
          data['target_amount_in_cents']!,
          _targetAmountInCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetAmountInCentsMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsGoalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsGoalRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      targetAmountInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_amount_in_cents'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $SavingsGoalsTable createAlias(String alias) {
    return $SavingsGoalsTable(attachedDatabase, alias);
  }
}

class SavingsGoalRow extends DataClass implements Insertable<SavingsGoalRow> {
  final int id;
  final String name;
  final int targetAmountInCents;
  final DateTime createdAt;
  final DateTime? completedAt;
  const SavingsGoalRow({
    required this.id,
    required this.name,
    required this.targetAmountInCents,
    required this.createdAt,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['target_amount_in_cents'] = Variable<int>(targetAmountInCents);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  SavingsGoalsCompanion toCompanion(bool nullToAbsent) {
    return SavingsGoalsCompanion(
      id: Value(id),
      name: Value(name),
      targetAmountInCents: Value(targetAmountInCents),
      createdAt: Value(createdAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory SavingsGoalRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsGoalRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      targetAmountInCents: serializer.fromJson<int>(
        json['targetAmountInCents'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'targetAmountInCents': serializer.toJson<int>(targetAmountInCents),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  SavingsGoalRow copyWith({
    int? id,
    String? name,
    int? targetAmountInCents,
    DateTime? createdAt,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => SavingsGoalRow(
    id: id ?? this.id,
    name: name ?? this.name,
    targetAmountInCents: targetAmountInCents ?? this.targetAmountInCents,
    createdAt: createdAt ?? this.createdAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  SavingsGoalRow copyWithCompanion(SavingsGoalsCompanion data) {
    return SavingsGoalRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      targetAmountInCents: data.targetAmountInCents.present
          ? data.targetAmountInCents.value
          : this.targetAmountInCents,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoalRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetAmountInCents: $targetAmountInCents, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, targetAmountInCents, createdAt, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsGoalRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.targetAmountInCents == this.targetAmountInCents &&
          other.createdAt == this.createdAt &&
          other.completedAt == this.completedAt);
}

class SavingsGoalsCompanion extends UpdateCompanion<SavingsGoalRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> targetAmountInCents;
  final Value<DateTime> createdAt;
  final Value<DateTime?> completedAt;
  const SavingsGoalsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.targetAmountInCents = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  SavingsGoalsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int targetAmountInCents,
    this.createdAt = const Value.absent(),
    this.completedAt = const Value.absent(),
  }) : name = Value(name),
       targetAmountInCents = Value(targetAmountInCents);
  static Insertable<SavingsGoalRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? targetAmountInCents,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (targetAmountInCents != null)
        'target_amount_in_cents': targetAmountInCents,
      if (createdAt != null) 'created_at': createdAt,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  SavingsGoalsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? targetAmountInCents,
    Value<DateTime>? createdAt,
    Value<DateTime?>? completedAt,
  }) {
    return SavingsGoalsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmountInCents: targetAmountInCents ?? this.targetAmountInCents,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetAmountInCents.present) {
      map['target_amount_in_cents'] = Variable<int>(targetAmountInCents.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoalsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetAmountInCents: $targetAmountInCents, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets
    with TableInfo<$BudgetsTable, BudgetConfigRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountInCentsMeta = const VerificationMeta(
    'amountInCents',
  );
  @override
  late final GeneratedColumn<int> amountInCents = GeneratedColumn<int>(
    'amount_in_cents',
    aliasedName,
    false,
    check: () => ComparableExpr(amountInCents).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
    'period',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cycleStartEpochDayMeta =
      const VerificationMeta('cycleStartEpochDay');
  @override
  late final GeneratedColumn<int> cycleStartEpochDay = GeneratedColumn<int>(
    'cycle_start_epoch_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cycleStartedAtMeta = const VerificationMeta(
    'cycleStartedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cycleStartedAt =
      GeneratedColumn<DateTime>(
        'cycle_started_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _incomeTransactionIdMeta =
      const VerificationMeta('incomeTransactionId');
  @override
  late final GeneratedColumn<int> incomeTransactionId = GeneratedColumn<int>(
    'income_transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cycleSchedulesJsonMeta =
      const VerificationMeta('cycleSchedulesJson');
  @override
  late final GeneratedColumn<String> cycleSchedulesJson =
      GeneratedColumn<String>(
        'cycle_schedules_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _autoCloseEnabledMeta = const VerificationMeta(
    'autoCloseEnabled',
  );
  @override
  late final GeneratedColumn<bool> autoCloseEnabled = GeneratedColumn<bool>(
    'auto_close_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_close_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _autoCloseMinuteOfDayMeta =
      const VerificationMeta('autoCloseMinuteOfDay');
  @override
  late final GeneratedColumn<int> autoCloseMinuteOfDay = GeneratedColumn<int>(
    'auto_close_minute_of_day',
    aliasedName,
    false,
    check: () => ComparableExpr(autoCloseMinuteOfDay).isBetweenValues(0, 1439),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1260),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amountInCents,
    period,
    cycleStartEpochDay,
    cycleStartedAt,
    incomeTransactionId,
    cycleSchedulesJson,
    autoCloseEnabled,
    autoCloseMinuteOfDay,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetConfigRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount_in_cents')) {
      context.handle(
        _amountInCentsMeta,
        amountInCents.isAcceptableOrUnknown(
          data['amount_in_cents']!,
          _amountInCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountInCentsMeta);
    }
    if (data.containsKey('period')) {
      context.handle(
        _periodMeta,
        period.isAcceptableOrUnknown(data['period']!, _periodMeta),
      );
    } else if (isInserting) {
      context.missing(_periodMeta);
    }
    if (data.containsKey('cycle_start_epoch_day')) {
      context.handle(
        _cycleStartEpochDayMeta,
        cycleStartEpochDay.isAcceptableOrUnknown(
          data['cycle_start_epoch_day']!,
          _cycleStartEpochDayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cycleStartEpochDayMeta);
    }
    if (data.containsKey('cycle_started_at')) {
      context.handle(
        _cycleStartedAtMeta,
        cycleStartedAt.isAcceptableOrUnknown(
          data['cycle_started_at']!,
          _cycleStartedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cycleStartedAtMeta);
    }
    if (data.containsKey('income_transaction_id')) {
      context.handle(
        _incomeTransactionIdMeta,
        incomeTransactionId.isAcceptableOrUnknown(
          data['income_transaction_id']!,
          _incomeTransactionIdMeta,
        ),
      );
    }
    if (data.containsKey('cycle_schedules_json')) {
      context.handle(
        _cycleSchedulesJsonMeta,
        cycleSchedulesJson.isAcceptableOrUnknown(
          data['cycle_schedules_json']!,
          _cycleSchedulesJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cycleSchedulesJsonMeta);
    }
    if (data.containsKey('auto_close_enabled')) {
      context.handle(
        _autoCloseEnabledMeta,
        autoCloseEnabled.isAcceptableOrUnknown(
          data['auto_close_enabled']!,
          _autoCloseEnabledMeta,
        ),
      );
    }
    if (data.containsKey('auto_close_minute_of_day')) {
      context.handle(
        _autoCloseMinuteOfDayMeta,
        autoCloseMinuteOfDay.isAcceptableOrUnknown(
          data['auto_close_minute_of_day']!,
          _autoCloseMinuteOfDayMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetConfigRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetConfigRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      amountInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_in_cents'],
      )!,
      period: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period'],
      )!,
      cycleStartEpochDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_start_epoch_day'],
      )!,
      cycleStartedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cycle_started_at'],
      )!,
      incomeTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}income_transaction_id'],
      ),
      cycleSchedulesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cycle_schedules_json'],
      )!,
      autoCloseEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_close_enabled'],
      )!,
      autoCloseMinuteOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}auto_close_minute_of_day'],
      )!,
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }
}

class BudgetConfigRow extends DataClass implements Insertable<BudgetConfigRow> {
  final int id;
  final int amountInCents;
  final String period;
  final int cycleStartEpochDay;
  final DateTime cycleStartedAt;
  final int? incomeTransactionId;
  final String cycleSchedulesJson;
  final bool autoCloseEnabled;
  final int autoCloseMinuteOfDay;
  const BudgetConfigRow({
    required this.id,
    required this.amountInCents,
    required this.period,
    required this.cycleStartEpochDay,
    required this.cycleStartedAt,
    this.incomeTransactionId,
    required this.cycleSchedulesJson,
    required this.autoCloseEnabled,
    required this.autoCloseMinuteOfDay,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount_in_cents'] = Variable<int>(amountInCents);
    map['period'] = Variable<String>(period);
    map['cycle_start_epoch_day'] = Variable<int>(cycleStartEpochDay);
    map['cycle_started_at'] = Variable<DateTime>(cycleStartedAt);
    if (!nullToAbsent || incomeTransactionId != null) {
      map['income_transaction_id'] = Variable<int>(incomeTransactionId);
    }
    map['cycle_schedules_json'] = Variable<String>(cycleSchedulesJson);
    map['auto_close_enabled'] = Variable<bool>(autoCloseEnabled);
    map['auto_close_minute_of_day'] = Variable<int>(autoCloseMinuteOfDay);
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: Value(id),
      amountInCents: Value(amountInCents),
      period: Value(period),
      cycleStartEpochDay: Value(cycleStartEpochDay),
      cycleStartedAt: Value(cycleStartedAt),
      incomeTransactionId: incomeTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(incomeTransactionId),
      cycleSchedulesJson: Value(cycleSchedulesJson),
      autoCloseEnabled: Value(autoCloseEnabled),
      autoCloseMinuteOfDay: Value(autoCloseMinuteOfDay),
    );
  }

  factory BudgetConfigRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetConfigRow(
      id: serializer.fromJson<int>(json['id']),
      amountInCents: serializer.fromJson<int>(json['amountInCents']),
      period: serializer.fromJson<String>(json['period']),
      cycleStartEpochDay: serializer.fromJson<int>(json['cycleStartEpochDay']),
      cycleStartedAt: serializer.fromJson<DateTime>(json['cycleStartedAt']),
      incomeTransactionId: serializer.fromJson<int?>(
        json['incomeTransactionId'],
      ),
      cycleSchedulesJson: serializer.fromJson<String>(
        json['cycleSchedulesJson'],
      ),
      autoCloseEnabled: serializer.fromJson<bool>(json['autoCloseEnabled']),
      autoCloseMinuteOfDay: serializer.fromJson<int>(
        json['autoCloseMinuteOfDay'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amountInCents': serializer.toJson<int>(amountInCents),
      'period': serializer.toJson<String>(period),
      'cycleStartEpochDay': serializer.toJson<int>(cycleStartEpochDay),
      'cycleStartedAt': serializer.toJson<DateTime>(cycleStartedAt),
      'incomeTransactionId': serializer.toJson<int?>(incomeTransactionId),
      'cycleSchedulesJson': serializer.toJson<String>(cycleSchedulesJson),
      'autoCloseEnabled': serializer.toJson<bool>(autoCloseEnabled),
      'autoCloseMinuteOfDay': serializer.toJson<int>(autoCloseMinuteOfDay),
    };
  }

  BudgetConfigRow copyWith({
    int? id,
    int? amountInCents,
    String? period,
    int? cycleStartEpochDay,
    DateTime? cycleStartedAt,
    Value<int?> incomeTransactionId = const Value.absent(),
    String? cycleSchedulesJson,
    bool? autoCloseEnabled,
    int? autoCloseMinuteOfDay,
  }) => BudgetConfigRow(
    id: id ?? this.id,
    amountInCents: amountInCents ?? this.amountInCents,
    period: period ?? this.period,
    cycleStartEpochDay: cycleStartEpochDay ?? this.cycleStartEpochDay,
    cycleStartedAt: cycleStartedAt ?? this.cycleStartedAt,
    incomeTransactionId: incomeTransactionId.present
        ? incomeTransactionId.value
        : this.incomeTransactionId,
    cycleSchedulesJson: cycleSchedulesJson ?? this.cycleSchedulesJson,
    autoCloseEnabled: autoCloseEnabled ?? this.autoCloseEnabled,
    autoCloseMinuteOfDay: autoCloseMinuteOfDay ?? this.autoCloseMinuteOfDay,
  );
  BudgetConfigRow copyWithCompanion(BudgetsCompanion data) {
    return BudgetConfigRow(
      id: data.id.present ? data.id.value : this.id,
      amountInCents: data.amountInCents.present
          ? data.amountInCents.value
          : this.amountInCents,
      period: data.period.present ? data.period.value : this.period,
      cycleStartEpochDay: data.cycleStartEpochDay.present
          ? data.cycleStartEpochDay.value
          : this.cycleStartEpochDay,
      cycleStartedAt: data.cycleStartedAt.present
          ? data.cycleStartedAt.value
          : this.cycleStartedAt,
      incomeTransactionId: data.incomeTransactionId.present
          ? data.incomeTransactionId.value
          : this.incomeTransactionId,
      cycleSchedulesJson: data.cycleSchedulesJson.present
          ? data.cycleSchedulesJson.value
          : this.cycleSchedulesJson,
      autoCloseEnabled: data.autoCloseEnabled.present
          ? data.autoCloseEnabled.value
          : this.autoCloseEnabled,
      autoCloseMinuteOfDay: data.autoCloseMinuteOfDay.present
          ? data.autoCloseMinuteOfDay.value
          : this.autoCloseMinuteOfDay,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetConfigRow(')
          ..write('id: $id, ')
          ..write('amountInCents: $amountInCents, ')
          ..write('period: $period, ')
          ..write('cycleStartEpochDay: $cycleStartEpochDay, ')
          ..write('cycleStartedAt: $cycleStartedAt, ')
          ..write('incomeTransactionId: $incomeTransactionId, ')
          ..write('cycleSchedulesJson: $cycleSchedulesJson, ')
          ..write('autoCloseEnabled: $autoCloseEnabled, ')
          ..write('autoCloseMinuteOfDay: $autoCloseMinuteOfDay')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    amountInCents,
    period,
    cycleStartEpochDay,
    cycleStartedAt,
    incomeTransactionId,
    cycleSchedulesJson,
    autoCloseEnabled,
    autoCloseMinuteOfDay,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetConfigRow &&
          other.id == this.id &&
          other.amountInCents == this.amountInCents &&
          other.period == this.period &&
          other.cycleStartEpochDay == this.cycleStartEpochDay &&
          other.cycleStartedAt == this.cycleStartedAt &&
          other.incomeTransactionId == this.incomeTransactionId &&
          other.cycleSchedulesJson == this.cycleSchedulesJson &&
          other.autoCloseEnabled == this.autoCloseEnabled &&
          other.autoCloseMinuteOfDay == this.autoCloseMinuteOfDay);
}

class BudgetsCompanion extends UpdateCompanion<BudgetConfigRow> {
  final Value<int> id;
  final Value<int> amountInCents;
  final Value<String> period;
  final Value<int> cycleStartEpochDay;
  final Value<DateTime> cycleStartedAt;
  final Value<int?> incomeTransactionId;
  final Value<String> cycleSchedulesJson;
  final Value<bool> autoCloseEnabled;
  final Value<int> autoCloseMinuteOfDay;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.amountInCents = const Value.absent(),
    this.period = const Value.absent(),
    this.cycleStartEpochDay = const Value.absent(),
    this.cycleStartedAt = const Value.absent(),
    this.incomeTransactionId = const Value.absent(),
    this.cycleSchedulesJson = const Value.absent(),
    this.autoCloseEnabled = const Value.absent(),
    this.autoCloseMinuteOfDay = const Value.absent(),
  });
  BudgetsCompanion.insert({
    this.id = const Value.absent(),
    required int amountInCents,
    required String period,
    required int cycleStartEpochDay,
    required DateTime cycleStartedAt,
    this.incomeTransactionId = const Value.absent(),
    required String cycleSchedulesJson,
    this.autoCloseEnabled = const Value.absent(),
    this.autoCloseMinuteOfDay = const Value.absent(),
  }) : amountInCents = Value(amountInCents),
       period = Value(period),
       cycleStartEpochDay = Value(cycleStartEpochDay),
       cycleStartedAt = Value(cycleStartedAt),
       cycleSchedulesJson = Value(cycleSchedulesJson);
  static Insertable<BudgetConfigRow> custom({
    Expression<int>? id,
    Expression<int>? amountInCents,
    Expression<String>? period,
    Expression<int>? cycleStartEpochDay,
    Expression<DateTime>? cycleStartedAt,
    Expression<int>? incomeTransactionId,
    Expression<String>? cycleSchedulesJson,
    Expression<bool>? autoCloseEnabled,
    Expression<int>? autoCloseMinuteOfDay,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amountInCents != null) 'amount_in_cents': amountInCents,
      if (period != null) 'period': period,
      if (cycleStartEpochDay != null)
        'cycle_start_epoch_day': cycleStartEpochDay,
      if (cycleStartedAt != null) 'cycle_started_at': cycleStartedAt,
      if (incomeTransactionId != null)
        'income_transaction_id': incomeTransactionId,
      if (cycleSchedulesJson != null)
        'cycle_schedules_json': cycleSchedulesJson,
      if (autoCloseEnabled != null) 'auto_close_enabled': autoCloseEnabled,
      if (autoCloseMinuteOfDay != null)
        'auto_close_minute_of_day': autoCloseMinuteOfDay,
    });
  }

  BudgetsCompanion copyWith({
    Value<int>? id,
    Value<int>? amountInCents,
    Value<String>? period,
    Value<int>? cycleStartEpochDay,
    Value<DateTime>? cycleStartedAt,
    Value<int?>? incomeTransactionId,
    Value<String>? cycleSchedulesJson,
    Value<bool>? autoCloseEnabled,
    Value<int>? autoCloseMinuteOfDay,
  }) {
    return BudgetsCompanion(
      id: id ?? this.id,
      amountInCents: amountInCents ?? this.amountInCents,
      period: period ?? this.period,
      cycleStartEpochDay: cycleStartEpochDay ?? this.cycleStartEpochDay,
      cycleStartedAt: cycleStartedAt ?? this.cycleStartedAt,
      incomeTransactionId: incomeTransactionId ?? this.incomeTransactionId,
      cycleSchedulesJson: cycleSchedulesJson ?? this.cycleSchedulesJson,
      autoCloseEnabled: autoCloseEnabled ?? this.autoCloseEnabled,
      autoCloseMinuteOfDay: autoCloseMinuteOfDay ?? this.autoCloseMinuteOfDay,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amountInCents.present) {
      map['amount_in_cents'] = Variable<int>(amountInCents.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (cycleStartEpochDay.present) {
      map['cycle_start_epoch_day'] = Variable<int>(cycleStartEpochDay.value);
    }
    if (cycleStartedAt.present) {
      map['cycle_started_at'] = Variable<DateTime>(cycleStartedAt.value);
    }
    if (incomeTransactionId.present) {
      map['income_transaction_id'] = Variable<int>(incomeTransactionId.value);
    }
    if (cycleSchedulesJson.present) {
      map['cycle_schedules_json'] = Variable<String>(cycleSchedulesJson.value);
    }
    if (autoCloseEnabled.present) {
      map['auto_close_enabled'] = Variable<bool>(autoCloseEnabled.value);
    }
    if (autoCloseMinuteOfDay.present) {
      map['auto_close_minute_of_day'] = Variable<int>(
        autoCloseMinuteOfDay.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('amountInCents: $amountInCents, ')
          ..write('period: $period, ')
          ..write('cycleStartEpochDay: $cycleStartEpochDay, ')
          ..write('cycleStartedAt: $cycleStartedAt, ')
          ..write('incomeTransactionId: $incomeTransactionId, ')
          ..write('cycleSchedulesJson: $cycleSchedulesJson, ')
          ..write('autoCloseEnabled: $autoCloseEnabled, ')
          ..write('autoCloseMinuteOfDay: $autoCloseMinuteOfDay')
          ..write(')'))
        .toString();
  }
}

class $BudgetCyclesTable extends BudgetCycles
    with TableInfo<$BudgetCyclesTable, BudgetCycleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetCyclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
    'period',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetAmountInCentsMeta =
      const VerificationMeta('budgetAmountInCents');
  @override
  late final GeneratedColumn<int> budgetAmountInCents = GeneratedColumn<int>(
    'budget_amount_in_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _incomeInCentsMeta = const VerificationMeta(
    'incomeInCents',
  );
  @override
  late final GeneratedColumn<int> incomeInCents = GeneratedColumn<int>(
    'income_in_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expenseInCentsMeta = const VerificationMeta(
    'expenseInCents',
  );
  @override
  late final GeneratedColumn<int> expenseInCents = GeneratedColumn<int>(
    'expense_in_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateEpochDayMeta = const VerificationMeta(
    'startDateEpochDay',
  );
  @override
  late final GeneratedColumn<int> startDateEpochDay = GeneratedColumn<int>(
    'start_date_epoch_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateEpochDayMeta = const VerificationMeta(
    'endDateEpochDay',
  );
  @override
  late final GeneratedColumn<int> endDateEpochDay = GeneratedColumn<int>(
    'end_date_epoch_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _closedAtMeta = const VerificationMeta(
    'closedAt',
  );
  @override
  late final GeneratedColumn<DateTime> closedAt = GeneratedColumn<DateTime>(
    'closed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    period,
    budgetAmountInCents,
    incomeInCents,
    expenseInCents,
    startDateEpochDay,
    endDateEpochDay,
    closedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_cycles';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetCycleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('period')) {
      context.handle(
        _periodMeta,
        period.isAcceptableOrUnknown(data['period']!, _periodMeta),
      );
    } else if (isInserting) {
      context.missing(_periodMeta);
    }
    if (data.containsKey('budget_amount_in_cents')) {
      context.handle(
        _budgetAmountInCentsMeta,
        budgetAmountInCents.isAcceptableOrUnknown(
          data['budget_amount_in_cents']!,
          _budgetAmountInCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_budgetAmountInCentsMeta);
    }
    if (data.containsKey('income_in_cents')) {
      context.handle(
        _incomeInCentsMeta,
        incomeInCents.isAcceptableOrUnknown(
          data['income_in_cents']!,
          _incomeInCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_incomeInCentsMeta);
    }
    if (data.containsKey('expense_in_cents')) {
      context.handle(
        _expenseInCentsMeta,
        expenseInCents.isAcceptableOrUnknown(
          data['expense_in_cents']!,
          _expenseInCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_expenseInCentsMeta);
    }
    if (data.containsKey('start_date_epoch_day')) {
      context.handle(
        _startDateEpochDayMeta,
        startDateEpochDay.isAcceptableOrUnknown(
          data['start_date_epoch_day']!,
          _startDateEpochDayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startDateEpochDayMeta);
    }
    if (data.containsKey('end_date_epoch_day')) {
      context.handle(
        _endDateEpochDayMeta,
        endDateEpochDay.isAcceptableOrUnknown(
          data['end_date_epoch_day']!,
          _endDateEpochDayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_endDateEpochDayMeta);
    }
    if (data.containsKey('closed_at')) {
      context.handle(
        _closedAtMeta,
        closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_closedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetCycleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetCycleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      period: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period'],
      )!,
      budgetAmountInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}budget_amount_in_cents'],
      )!,
      incomeInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}income_in_cents'],
      )!,
      expenseInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expense_in_cents'],
      )!,
      startDateEpochDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_date_epoch_day'],
      )!,
      endDateEpochDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_date_epoch_day'],
      )!,
      closedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}closed_at'],
      )!,
    );
  }

  @override
  $BudgetCyclesTable createAlias(String alias) {
    return $BudgetCyclesTable(attachedDatabase, alias);
  }
}

class BudgetCycleRow extends DataClass implements Insertable<BudgetCycleRow> {
  final int id;
  final String period;
  final int budgetAmountInCents;
  final int incomeInCents;
  final int expenseInCents;
  final int startDateEpochDay;
  final int endDateEpochDay;
  final DateTime closedAt;
  const BudgetCycleRow({
    required this.id,
    required this.period,
    required this.budgetAmountInCents,
    required this.incomeInCents,
    required this.expenseInCents,
    required this.startDateEpochDay,
    required this.endDateEpochDay,
    required this.closedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['period'] = Variable<String>(period);
    map['budget_amount_in_cents'] = Variable<int>(budgetAmountInCents);
    map['income_in_cents'] = Variable<int>(incomeInCents);
    map['expense_in_cents'] = Variable<int>(expenseInCents);
    map['start_date_epoch_day'] = Variable<int>(startDateEpochDay);
    map['end_date_epoch_day'] = Variable<int>(endDateEpochDay);
    map['closed_at'] = Variable<DateTime>(closedAt);
    return map;
  }

  BudgetCyclesCompanion toCompanion(bool nullToAbsent) {
    return BudgetCyclesCompanion(
      id: Value(id),
      period: Value(period),
      budgetAmountInCents: Value(budgetAmountInCents),
      incomeInCents: Value(incomeInCents),
      expenseInCents: Value(expenseInCents),
      startDateEpochDay: Value(startDateEpochDay),
      endDateEpochDay: Value(endDateEpochDay),
      closedAt: Value(closedAt),
    );
  }

  factory BudgetCycleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetCycleRow(
      id: serializer.fromJson<int>(json['id']),
      period: serializer.fromJson<String>(json['period']),
      budgetAmountInCents: serializer.fromJson<int>(
        json['budgetAmountInCents'],
      ),
      incomeInCents: serializer.fromJson<int>(json['incomeInCents']),
      expenseInCents: serializer.fromJson<int>(json['expenseInCents']),
      startDateEpochDay: serializer.fromJson<int>(json['startDateEpochDay']),
      endDateEpochDay: serializer.fromJson<int>(json['endDateEpochDay']),
      closedAt: serializer.fromJson<DateTime>(json['closedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'period': serializer.toJson<String>(period),
      'budgetAmountInCents': serializer.toJson<int>(budgetAmountInCents),
      'incomeInCents': serializer.toJson<int>(incomeInCents),
      'expenseInCents': serializer.toJson<int>(expenseInCents),
      'startDateEpochDay': serializer.toJson<int>(startDateEpochDay),
      'endDateEpochDay': serializer.toJson<int>(endDateEpochDay),
      'closedAt': serializer.toJson<DateTime>(closedAt),
    };
  }

  BudgetCycleRow copyWith({
    int? id,
    String? period,
    int? budgetAmountInCents,
    int? incomeInCents,
    int? expenseInCents,
    int? startDateEpochDay,
    int? endDateEpochDay,
    DateTime? closedAt,
  }) => BudgetCycleRow(
    id: id ?? this.id,
    period: period ?? this.period,
    budgetAmountInCents: budgetAmountInCents ?? this.budgetAmountInCents,
    incomeInCents: incomeInCents ?? this.incomeInCents,
    expenseInCents: expenseInCents ?? this.expenseInCents,
    startDateEpochDay: startDateEpochDay ?? this.startDateEpochDay,
    endDateEpochDay: endDateEpochDay ?? this.endDateEpochDay,
    closedAt: closedAt ?? this.closedAt,
  );
  BudgetCycleRow copyWithCompanion(BudgetCyclesCompanion data) {
    return BudgetCycleRow(
      id: data.id.present ? data.id.value : this.id,
      period: data.period.present ? data.period.value : this.period,
      budgetAmountInCents: data.budgetAmountInCents.present
          ? data.budgetAmountInCents.value
          : this.budgetAmountInCents,
      incomeInCents: data.incomeInCents.present
          ? data.incomeInCents.value
          : this.incomeInCents,
      expenseInCents: data.expenseInCents.present
          ? data.expenseInCents.value
          : this.expenseInCents,
      startDateEpochDay: data.startDateEpochDay.present
          ? data.startDateEpochDay.value
          : this.startDateEpochDay,
      endDateEpochDay: data.endDateEpochDay.present
          ? data.endDateEpochDay.value
          : this.endDateEpochDay,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetCycleRow(')
          ..write('id: $id, ')
          ..write('period: $period, ')
          ..write('budgetAmountInCents: $budgetAmountInCents, ')
          ..write('incomeInCents: $incomeInCents, ')
          ..write('expenseInCents: $expenseInCents, ')
          ..write('startDateEpochDay: $startDateEpochDay, ')
          ..write('endDateEpochDay: $endDateEpochDay, ')
          ..write('closedAt: $closedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    period,
    budgetAmountInCents,
    incomeInCents,
    expenseInCents,
    startDateEpochDay,
    endDateEpochDay,
    closedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetCycleRow &&
          other.id == this.id &&
          other.period == this.period &&
          other.budgetAmountInCents == this.budgetAmountInCents &&
          other.incomeInCents == this.incomeInCents &&
          other.expenseInCents == this.expenseInCents &&
          other.startDateEpochDay == this.startDateEpochDay &&
          other.endDateEpochDay == this.endDateEpochDay &&
          other.closedAt == this.closedAt);
}

class BudgetCyclesCompanion extends UpdateCompanion<BudgetCycleRow> {
  final Value<int> id;
  final Value<String> period;
  final Value<int> budgetAmountInCents;
  final Value<int> incomeInCents;
  final Value<int> expenseInCents;
  final Value<int> startDateEpochDay;
  final Value<int> endDateEpochDay;
  final Value<DateTime> closedAt;
  const BudgetCyclesCompanion({
    this.id = const Value.absent(),
    this.period = const Value.absent(),
    this.budgetAmountInCents = const Value.absent(),
    this.incomeInCents = const Value.absent(),
    this.expenseInCents = const Value.absent(),
    this.startDateEpochDay = const Value.absent(),
    this.endDateEpochDay = const Value.absent(),
    this.closedAt = const Value.absent(),
  });
  BudgetCyclesCompanion.insert({
    this.id = const Value.absent(),
    required String period,
    required int budgetAmountInCents,
    required int incomeInCents,
    required int expenseInCents,
    required int startDateEpochDay,
    required int endDateEpochDay,
    required DateTime closedAt,
  }) : period = Value(period),
       budgetAmountInCents = Value(budgetAmountInCents),
       incomeInCents = Value(incomeInCents),
       expenseInCents = Value(expenseInCents),
       startDateEpochDay = Value(startDateEpochDay),
       endDateEpochDay = Value(endDateEpochDay),
       closedAt = Value(closedAt);
  static Insertable<BudgetCycleRow> custom({
    Expression<int>? id,
    Expression<String>? period,
    Expression<int>? budgetAmountInCents,
    Expression<int>? incomeInCents,
    Expression<int>? expenseInCents,
    Expression<int>? startDateEpochDay,
    Expression<int>? endDateEpochDay,
    Expression<DateTime>? closedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (period != null) 'period': period,
      if (budgetAmountInCents != null)
        'budget_amount_in_cents': budgetAmountInCents,
      if (incomeInCents != null) 'income_in_cents': incomeInCents,
      if (expenseInCents != null) 'expense_in_cents': expenseInCents,
      if (startDateEpochDay != null) 'start_date_epoch_day': startDateEpochDay,
      if (endDateEpochDay != null) 'end_date_epoch_day': endDateEpochDay,
      if (closedAt != null) 'closed_at': closedAt,
    });
  }

  BudgetCyclesCompanion copyWith({
    Value<int>? id,
    Value<String>? period,
    Value<int>? budgetAmountInCents,
    Value<int>? incomeInCents,
    Value<int>? expenseInCents,
    Value<int>? startDateEpochDay,
    Value<int>? endDateEpochDay,
    Value<DateTime>? closedAt,
  }) {
    return BudgetCyclesCompanion(
      id: id ?? this.id,
      period: period ?? this.period,
      budgetAmountInCents: budgetAmountInCents ?? this.budgetAmountInCents,
      incomeInCents: incomeInCents ?? this.incomeInCents,
      expenseInCents: expenseInCents ?? this.expenseInCents,
      startDateEpochDay: startDateEpochDay ?? this.startDateEpochDay,
      endDateEpochDay: endDateEpochDay ?? this.endDateEpochDay,
      closedAt: closedAt ?? this.closedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (budgetAmountInCents.present) {
      map['budget_amount_in_cents'] = Variable<int>(budgetAmountInCents.value);
    }
    if (incomeInCents.present) {
      map['income_in_cents'] = Variable<int>(incomeInCents.value);
    }
    if (expenseInCents.present) {
      map['expense_in_cents'] = Variable<int>(expenseInCents.value);
    }
    if (startDateEpochDay.present) {
      map['start_date_epoch_day'] = Variable<int>(startDateEpochDay.value);
    }
    if (endDateEpochDay.present) {
      map['end_date_epoch_day'] = Variable<int>(endDateEpochDay.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<DateTime>(closedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetCyclesCompanion(')
          ..write('id: $id, ')
          ..write('period: $period, ')
          ..write('budgetAmountInCents: $budgetAmountInCents, ')
          ..write('incomeInCents: $incomeInCents, ')
          ..write('expenseInCents: $expenseInCents, ')
          ..write('startDateEpochDay: $startDateEpochDay, ')
          ..write('endDateEpochDay: $endDateEpochDay, ')
          ..write('closedAt: $closedAt')
          ..write(')'))
        .toString();
  }
}

class $ShoppingListsTable extends ShoppingLists
    with TableInfo<$ShoppingListsTable, ShoppingListRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingListsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetInCentsMeta = const VerificationMeta(
    'budgetInCents',
  );
  @override
  late final GeneratedColumn<int> budgetInCents = GeneratedColumn<int>(
    'budget_in_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expenseTransactionIdMeta =
      const VerificationMeta('expenseTransactionId');
  @override
  late final GeneratedColumn<int> expenseTransactionId = GeneratedColumn<int>(
    'expense_transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _payableIdMeta = const VerificationMeta(
    'payableId',
  );
  @override
  late final GeneratedColumn<int> payableId = GeneratedColumn<int>(
    'payable_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purchaseDateEpochDayMeta =
      const VerificationMeta('purchaseDateEpochDay');
  @override
  late final GeneratedColumn<int> purchaseDateEpochDay = GeneratedColumn<int>(
    'purchase_date_epoch_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paymentMethodIdMeta = const VerificationMeta(
    'paymentMethodId',
  );
  @override
  late final GeneratedColumn<int> paymentMethodId = GeneratedColumn<int>(
    'payment_method_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES payment_methods (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _expenseCategoryIdMeta = const VerificationMeta(
    'expenseCategoryId',
  );
  @override
  late final GeneratedColumn<int> expenseCategoryId = GeneratedColumn<int>(
    'expense_category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    status,
    budgetInCents,
    expenseTransactionId,
    payableId,
    purchaseDateEpochDay,
    paymentMethodId,
    expenseCategoryId,
    createdAt,
    updatedAt,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_lists';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShoppingListRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('budget_in_cents')) {
      context.handle(
        _budgetInCentsMeta,
        budgetInCents.isAcceptableOrUnknown(
          data['budget_in_cents']!,
          _budgetInCentsMeta,
        ),
      );
    }
    if (data.containsKey('expense_transaction_id')) {
      context.handle(
        _expenseTransactionIdMeta,
        expenseTransactionId.isAcceptableOrUnknown(
          data['expense_transaction_id']!,
          _expenseTransactionIdMeta,
        ),
      );
    }
    if (data.containsKey('payable_id')) {
      context.handle(
        _payableIdMeta,
        payableId.isAcceptableOrUnknown(data['payable_id']!, _payableIdMeta),
      );
    }
    if (data.containsKey('purchase_date_epoch_day')) {
      context.handle(
        _purchaseDateEpochDayMeta,
        purchaseDateEpochDay.isAcceptableOrUnknown(
          data['purchase_date_epoch_day']!,
          _purchaseDateEpochDayMeta,
        ),
      );
    }
    if (data.containsKey('payment_method_id')) {
      context.handle(
        _paymentMethodIdMeta,
        paymentMethodId.isAcceptableOrUnknown(
          data['payment_method_id']!,
          _paymentMethodIdMeta,
        ),
      );
    }
    if (data.containsKey('expense_category_id')) {
      context.handle(
        _expenseCategoryIdMeta,
        expenseCategoryId.isAcceptableOrUnknown(
          data['expense_category_id']!,
          _expenseCategoryIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingListRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingListRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      budgetInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}budget_in_cents'],
      ),
      expenseTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expense_transaction_id'],
      ),
      payableId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payable_id'],
      ),
      purchaseDateEpochDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purchase_date_epoch_day'],
      ),
      paymentMethodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payment_method_id'],
      ),
      expenseCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expense_category_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $ShoppingListsTable createAlias(String alias) {
    return $ShoppingListsTable(attachedDatabase, alias);
  }
}

class ShoppingListRow extends DataClass implements Insertable<ShoppingListRow> {
  final int id;
  final String name;
  final String status;
  final int? budgetInCents;
  final int? expenseTransactionId;
  final int? payableId;
  final int? purchaseDateEpochDay;
  final int? paymentMethodId;
  final int? expenseCategoryId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;
  const ShoppingListRow({
    required this.id,
    required this.name,
    required this.status,
    this.budgetInCents,
    this.expenseTransactionId,
    this.payableId,
    this.purchaseDateEpochDay,
    this.paymentMethodId,
    this.expenseCategoryId,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || budgetInCents != null) {
      map['budget_in_cents'] = Variable<int>(budgetInCents);
    }
    if (!nullToAbsent || expenseTransactionId != null) {
      map['expense_transaction_id'] = Variable<int>(expenseTransactionId);
    }
    if (!nullToAbsent || payableId != null) {
      map['payable_id'] = Variable<int>(payableId);
    }
    if (!nullToAbsent || purchaseDateEpochDay != null) {
      map['purchase_date_epoch_day'] = Variable<int>(purchaseDateEpochDay);
    }
    if (!nullToAbsent || paymentMethodId != null) {
      map['payment_method_id'] = Variable<int>(paymentMethodId);
    }
    if (!nullToAbsent || expenseCategoryId != null) {
      map['expense_category_id'] = Variable<int>(expenseCategoryId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  ShoppingListsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingListsCompanion(
      id: Value(id),
      name: Value(name),
      status: Value(status),
      budgetInCents: budgetInCents == null && nullToAbsent
          ? const Value.absent()
          : Value(budgetInCents),
      expenseTransactionId: expenseTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(expenseTransactionId),
      payableId: payableId == null && nullToAbsent
          ? const Value.absent()
          : Value(payableId),
      purchaseDateEpochDay: purchaseDateEpochDay == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseDateEpochDay),
      paymentMethodId: paymentMethodId == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethodId),
      expenseCategoryId: expenseCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(expenseCategoryId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory ShoppingListRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingListRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      status: serializer.fromJson<String>(json['status']),
      budgetInCents: serializer.fromJson<int?>(json['budgetInCents']),
      expenseTransactionId: serializer.fromJson<int?>(
        json['expenseTransactionId'],
      ),
      payableId: serializer.fromJson<int?>(json['payableId']),
      purchaseDateEpochDay: serializer.fromJson<int?>(
        json['purchaseDateEpochDay'],
      ),
      paymentMethodId: serializer.fromJson<int?>(json['paymentMethodId']),
      expenseCategoryId: serializer.fromJson<int?>(json['expenseCategoryId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'status': serializer.toJson<String>(status),
      'budgetInCents': serializer.toJson<int?>(budgetInCents),
      'expenseTransactionId': serializer.toJson<int?>(expenseTransactionId),
      'payableId': serializer.toJson<int?>(payableId),
      'purchaseDateEpochDay': serializer.toJson<int?>(purchaseDateEpochDay),
      'paymentMethodId': serializer.toJson<int?>(paymentMethodId),
      'expenseCategoryId': serializer.toJson<int?>(expenseCategoryId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  ShoppingListRow copyWith({
    int? id,
    String? name,
    String? status,
    Value<int?> budgetInCents = const Value.absent(),
    Value<int?> expenseTransactionId = const Value.absent(),
    Value<int?> payableId = const Value.absent(),
    Value<int?> purchaseDateEpochDay = const Value.absent(),
    Value<int?> paymentMethodId = const Value.absent(),
    Value<int?> expenseCategoryId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => ShoppingListRow(
    id: id ?? this.id,
    name: name ?? this.name,
    status: status ?? this.status,
    budgetInCents: budgetInCents.present
        ? budgetInCents.value
        : this.budgetInCents,
    expenseTransactionId: expenseTransactionId.present
        ? expenseTransactionId.value
        : this.expenseTransactionId,
    payableId: payableId.present ? payableId.value : this.payableId,
    purchaseDateEpochDay: purchaseDateEpochDay.present
        ? purchaseDateEpochDay.value
        : this.purchaseDateEpochDay,
    paymentMethodId: paymentMethodId.present
        ? paymentMethodId.value
        : this.paymentMethodId,
    expenseCategoryId: expenseCategoryId.present
        ? expenseCategoryId.value
        : this.expenseCategoryId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  ShoppingListRow copyWithCompanion(ShoppingListsCompanion data) {
    return ShoppingListRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      status: data.status.present ? data.status.value : this.status,
      budgetInCents: data.budgetInCents.present
          ? data.budgetInCents.value
          : this.budgetInCents,
      expenseTransactionId: data.expenseTransactionId.present
          ? data.expenseTransactionId.value
          : this.expenseTransactionId,
      payableId: data.payableId.present ? data.payableId.value : this.payableId,
      purchaseDateEpochDay: data.purchaseDateEpochDay.present
          ? data.purchaseDateEpochDay.value
          : this.purchaseDateEpochDay,
      paymentMethodId: data.paymentMethodId.present
          ? data.paymentMethodId.value
          : this.paymentMethodId,
      expenseCategoryId: data.expenseCategoryId.present
          ? data.expenseCategoryId.value
          : this.expenseCategoryId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('budgetInCents: $budgetInCents, ')
          ..write('expenseTransactionId: $expenseTransactionId, ')
          ..write('payableId: $payableId, ')
          ..write('purchaseDateEpochDay: $purchaseDateEpochDay, ')
          ..write('paymentMethodId: $paymentMethodId, ')
          ..write('expenseCategoryId: $expenseCategoryId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    status,
    budgetInCents,
    expenseTransactionId,
    payableId,
    purchaseDateEpochDay,
    paymentMethodId,
    expenseCategoryId,
    createdAt,
    updatedAt,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingListRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.status == this.status &&
          other.budgetInCents == this.budgetInCents &&
          other.expenseTransactionId == this.expenseTransactionId &&
          other.payableId == this.payableId &&
          other.purchaseDateEpochDay == this.purchaseDateEpochDay &&
          other.paymentMethodId == this.paymentMethodId &&
          other.expenseCategoryId == this.expenseCategoryId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.completedAt == this.completedAt);
}

class ShoppingListsCompanion extends UpdateCompanion<ShoppingListRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> status;
  final Value<int?> budgetInCents;
  final Value<int?> expenseTransactionId;
  final Value<int?> payableId;
  final Value<int?> purchaseDateEpochDay;
  final Value<int?> paymentMethodId;
  final Value<int?> expenseCategoryId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> completedAt;
  const ShoppingListsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.status = const Value.absent(),
    this.budgetInCents = const Value.absent(),
    this.expenseTransactionId = const Value.absent(),
    this.payableId = const Value.absent(),
    this.purchaseDateEpochDay = const Value.absent(),
    this.paymentMethodId = const Value.absent(),
    this.expenseCategoryId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  ShoppingListsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String status,
    this.budgetInCents = const Value.absent(),
    this.expenseTransactionId = const Value.absent(),
    this.payableId = const Value.absent(),
    this.purchaseDateEpochDay = const Value.absent(),
    this.paymentMethodId = const Value.absent(),
    this.expenseCategoryId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
  }) : name = Value(name),
       status = Value(status);
  static Insertable<ShoppingListRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? status,
    Expression<int>? budgetInCents,
    Expression<int>? expenseTransactionId,
    Expression<int>? payableId,
    Expression<int>? purchaseDateEpochDay,
    Expression<int>? paymentMethodId,
    Expression<int>? expenseCategoryId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (status != null) 'status': status,
      if (budgetInCents != null) 'budget_in_cents': budgetInCents,
      if (expenseTransactionId != null)
        'expense_transaction_id': expenseTransactionId,
      if (payableId != null) 'payable_id': payableId,
      if (purchaseDateEpochDay != null)
        'purchase_date_epoch_day': purchaseDateEpochDay,
      if (paymentMethodId != null) 'payment_method_id': paymentMethodId,
      if (expenseCategoryId != null) 'expense_category_id': expenseCategoryId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  ShoppingListsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? status,
    Value<int?>? budgetInCents,
    Value<int?>? expenseTransactionId,
    Value<int?>? payableId,
    Value<int?>? purchaseDateEpochDay,
    Value<int?>? paymentMethodId,
    Value<int?>? expenseCategoryId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? completedAt,
  }) {
    return ShoppingListsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      budgetInCents: budgetInCents ?? this.budgetInCents,
      expenseTransactionId: expenseTransactionId ?? this.expenseTransactionId,
      payableId: payableId ?? this.payableId,
      purchaseDateEpochDay: purchaseDateEpochDay ?? this.purchaseDateEpochDay,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      expenseCategoryId: expenseCategoryId ?? this.expenseCategoryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (budgetInCents.present) {
      map['budget_in_cents'] = Variable<int>(budgetInCents.value);
    }
    if (expenseTransactionId.present) {
      map['expense_transaction_id'] = Variable<int>(expenseTransactionId.value);
    }
    if (payableId.present) {
      map['payable_id'] = Variable<int>(payableId.value);
    }
    if (purchaseDateEpochDay.present) {
      map['purchase_date_epoch_day'] = Variable<int>(
        purchaseDateEpochDay.value,
      );
    }
    if (paymentMethodId.present) {
      map['payment_method_id'] = Variable<int>(paymentMethodId.value);
    }
    if (expenseCategoryId.present) {
      map['expense_category_id'] = Variable<int>(expenseCategoryId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('budgetInCents: $budgetInCents, ')
          ..write('expenseTransactionId: $expenseTransactionId, ')
          ..write('payableId: $payableId, ')
          ..write('purchaseDateEpochDay: $purchaseDateEpochDay, ')
          ..write('paymentMethodId: $paymentMethodId, ')
          ..write('expenseCategoryId: $expenseCategoryId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $ShoppingListItemsTable extends ShoppingListItems
    with TableInfo<$ShoppingListItemsTable, ShoppingListItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingListItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _shoppingListIdMeta = const VerificationMeta(
    'shoppingListId',
  );
  @override
  late final GeneratedColumn<int> shoppingListId = GeneratedColumn<int>(
    'shopping_list_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shopping_lists (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    check: () => ComparableExpr(quantity).isBiggerOrEqualValue(1),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedUnitPriceInCentsMeta =
      const VerificationMeta('estimatedUnitPriceInCents');
  @override
  late final GeneratedColumn<int> estimatedUnitPriceInCents =
      GeneratedColumn<int>(
        'estimated_unit_price_in_cents',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _actualUnitPriceInCentsMeta =
      const VerificationMeta('actualUnitPriceInCents');
  @override
  late final GeneratedColumn<int> actualUnitPriceInCents = GeneratedColumn<int>(
    'actual_unit_price_in_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPurchasedMeta = const VerificationMeta(
    'isPurchased',
  );
  @override
  late final GeneratedColumn<bool> isPurchased = GeneratedColumn<bool>(
    'is_purchased',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_purchased" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    shoppingListId,
    name,
    quantity,
    estimatedUnitPriceInCents,
    actualUnitPriceInCents,
    isPurchased,
    notes,
    barcode,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_list_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShoppingListItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('shopping_list_id')) {
      context.handle(
        _shoppingListIdMeta,
        shoppingListId.isAcceptableOrUnknown(
          data['shopping_list_id']!,
          _shoppingListIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_shoppingListIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('estimated_unit_price_in_cents')) {
      context.handle(
        _estimatedUnitPriceInCentsMeta,
        estimatedUnitPriceInCents.isAcceptableOrUnknown(
          data['estimated_unit_price_in_cents']!,
          _estimatedUnitPriceInCentsMeta,
        ),
      );
    }
    if (data.containsKey('actual_unit_price_in_cents')) {
      context.handle(
        _actualUnitPriceInCentsMeta,
        actualUnitPriceInCents.isAcceptableOrUnknown(
          data['actual_unit_price_in_cents']!,
          _actualUnitPriceInCentsMeta,
        ),
      );
    }
    if (data.containsKey('is_purchased')) {
      context.handle(
        _isPurchasedMeta,
        isPurchased.isAcceptableOrUnknown(
          data['is_purchased']!,
          _isPurchasedMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingListItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingListItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      shoppingListId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shopping_list_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      estimatedUnitPriceInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_unit_price_in_cents'],
      ),
      actualUnitPriceInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_unit_price_in_cents'],
      ),
      isPurchased: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_purchased'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ShoppingListItemsTable createAlias(String alias) {
    return $ShoppingListItemsTable(attachedDatabase, alias);
  }
}

class ShoppingListItemRow extends DataClass
    implements Insertable<ShoppingListItemRow> {
  final int id;
  final int shoppingListId;
  final String name;
  final int quantity;
  final int? estimatedUnitPriceInCents;
  final int? actualUnitPriceInCents;
  final bool isPurchased;
  final String? notes;
  final String? barcode;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ShoppingListItemRow({
    required this.id,
    required this.shoppingListId,
    required this.name,
    required this.quantity,
    this.estimatedUnitPriceInCents,
    this.actualUnitPriceInCents,
    required this.isPurchased,
    this.notes,
    this.barcode,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['shopping_list_id'] = Variable<int>(shoppingListId);
    map['name'] = Variable<String>(name);
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || estimatedUnitPriceInCents != null) {
      map['estimated_unit_price_in_cents'] = Variable<int>(
        estimatedUnitPriceInCents,
      );
    }
    if (!nullToAbsent || actualUnitPriceInCents != null) {
      map['actual_unit_price_in_cents'] = Variable<int>(actualUnitPriceInCents);
    }
    map['is_purchased'] = Variable<bool>(isPurchased);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ShoppingListItemsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingListItemsCompanion(
      id: Value(id),
      shoppingListId: Value(shoppingListId),
      name: Value(name),
      quantity: Value(quantity),
      estimatedUnitPriceInCents:
          estimatedUnitPriceInCents == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedUnitPriceInCents),
      actualUnitPriceInCents: actualUnitPriceInCents == null && nullToAbsent
          ? const Value.absent()
          : Value(actualUnitPriceInCents),
      isPurchased: Value(isPurchased),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ShoppingListItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingListItemRow(
      id: serializer.fromJson<int>(json['id']),
      shoppingListId: serializer.fromJson<int>(json['shoppingListId']),
      name: serializer.fromJson<String>(json['name']),
      quantity: serializer.fromJson<int>(json['quantity']),
      estimatedUnitPriceInCents: serializer.fromJson<int?>(
        json['estimatedUnitPriceInCents'],
      ),
      actualUnitPriceInCents: serializer.fromJson<int?>(
        json['actualUnitPriceInCents'],
      ),
      isPurchased: serializer.fromJson<bool>(json['isPurchased']),
      notes: serializer.fromJson<String?>(json['notes']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'shoppingListId': serializer.toJson<int>(shoppingListId),
      'name': serializer.toJson<String>(name),
      'quantity': serializer.toJson<int>(quantity),
      'estimatedUnitPriceInCents': serializer.toJson<int?>(
        estimatedUnitPriceInCents,
      ),
      'actualUnitPriceInCents': serializer.toJson<int?>(actualUnitPriceInCents),
      'isPurchased': serializer.toJson<bool>(isPurchased),
      'notes': serializer.toJson<String?>(notes),
      'barcode': serializer.toJson<String?>(barcode),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ShoppingListItemRow copyWith({
    int? id,
    int? shoppingListId,
    String? name,
    int? quantity,
    Value<int?> estimatedUnitPriceInCents = const Value.absent(),
    Value<int?> actualUnitPriceInCents = const Value.absent(),
    bool? isPurchased,
    Value<String?> notes = const Value.absent(),
    Value<String?> barcode = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ShoppingListItemRow(
    id: id ?? this.id,
    shoppingListId: shoppingListId ?? this.shoppingListId,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    estimatedUnitPriceInCents: estimatedUnitPriceInCents.present
        ? estimatedUnitPriceInCents.value
        : this.estimatedUnitPriceInCents,
    actualUnitPriceInCents: actualUnitPriceInCents.present
        ? actualUnitPriceInCents.value
        : this.actualUnitPriceInCents,
    isPurchased: isPurchased ?? this.isPurchased,
    notes: notes.present ? notes.value : this.notes,
    barcode: barcode.present ? barcode.value : this.barcode,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ShoppingListItemRow copyWithCompanion(ShoppingListItemsCompanion data) {
    return ShoppingListItemRow(
      id: data.id.present ? data.id.value : this.id,
      shoppingListId: data.shoppingListId.present
          ? data.shoppingListId.value
          : this.shoppingListId,
      name: data.name.present ? data.name.value : this.name,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      estimatedUnitPriceInCents: data.estimatedUnitPriceInCents.present
          ? data.estimatedUnitPriceInCents.value
          : this.estimatedUnitPriceInCents,
      actualUnitPriceInCents: data.actualUnitPriceInCents.present
          ? data.actualUnitPriceInCents.value
          : this.actualUnitPriceInCents,
      isPurchased: data.isPurchased.present
          ? data.isPurchased.value
          : this.isPurchased,
      notes: data.notes.present ? data.notes.value : this.notes,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListItemRow(')
          ..write('id: $id, ')
          ..write('shoppingListId: $shoppingListId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('estimatedUnitPriceInCents: $estimatedUnitPriceInCents, ')
          ..write('actualUnitPriceInCents: $actualUnitPriceInCents, ')
          ..write('isPurchased: $isPurchased, ')
          ..write('notes: $notes, ')
          ..write('barcode: $barcode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    shoppingListId,
    name,
    quantity,
    estimatedUnitPriceInCents,
    actualUnitPriceInCents,
    isPurchased,
    notes,
    barcode,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingListItemRow &&
          other.id == this.id &&
          other.shoppingListId == this.shoppingListId &&
          other.name == this.name &&
          other.quantity == this.quantity &&
          other.estimatedUnitPriceInCents == this.estimatedUnitPriceInCents &&
          other.actualUnitPriceInCents == this.actualUnitPriceInCents &&
          other.isPurchased == this.isPurchased &&
          other.notes == this.notes &&
          other.barcode == this.barcode &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ShoppingListItemsCompanion extends UpdateCompanion<ShoppingListItemRow> {
  final Value<int> id;
  final Value<int> shoppingListId;
  final Value<String> name;
  final Value<int> quantity;
  final Value<int?> estimatedUnitPriceInCents;
  final Value<int?> actualUnitPriceInCents;
  final Value<bool> isPurchased;
  final Value<String?> notes;
  final Value<String?> barcode;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ShoppingListItemsCompanion({
    this.id = const Value.absent(),
    this.shoppingListId = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.estimatedUnitPriceInCents = const Value.absent(),
    this.actualUnitPriceInCents = const Value.absent(),
    this.isPurchased = const Value.absent(),
    this.notes = const Value.absent(),
    this.barcode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ShoppingListItemsCompanion.insert({
    this.id = const Value.absent(),
    required int shoppingListId,
    required String name,
    required int quantity,
    this.estimatedUnitPriceInCents = const Value.absent(),
    this.actualUnitPriceInCents = const Value.absent(),
    this.isPurchased = const Value.absent(),
    this.notes = const Value.absent(),
    this.barcode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : shoppingListId = Value(shoppingListId),
       name = Value(name),
       quantity = Value(quantity);
  static Insertable<ShoppingListItemRow> custom({
    Expression<int>? id,
    Expression<int>? shoppingListId,
    Expression<String>? name,
    Expression<int>? quantity,
    Expression<int>? estimatedUnitPriceInCents,
    Expression<int>? actualUnitPriceInCents,
    Expression<bool>? isPurchased,
    Expression<String>? notes,
    Expression<String>? barcode,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shoppingListId != null) 'shopping_list_id': shoppingListId,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (estimatedUnitPriceInCents != null)
        'estimated_unit_price_in_cents': estimatedUnitPriceInCents,
      if (actualUnitPriceInCents != null)
        'actual_unit_price_in_cents': actualUnitPriceInCents,
      if (isPurchased != null) 'is_purchased': isPurchased,
      if (notes != null) 'notes': notes,
      if (barcode != null) 'barcode': barcode,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ShoppingListItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? shoppingListId,
    Value<String>? name,
    Value<int>? quantity,
    Value<int?>? estimatedUnitPriceInCents,
    Value<int?>? actualUnitPriceInCents,
    Value<bool>? isPurchased,
    Value<String?>? notes,
    Value<String?>? barcode,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ShoppingListItemsCompanion(
      id: id ?? this.id,
      shoppingListId: shoppingListId ?? this.shoppingListId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      estimatedUnitPriceInCents:
          estimatedUnitPriceInCents ?? this.estimatedUnitPriceInCents,
      actualUnitPriceInCents:
          actualUnitPriceInCents ?? this.actualUnitPriceInCents,
      isPurchased: isPurchased ?? this.isPurchased,
      notes: notes ?? this.notes,
      barcode: barcode ?? this.barcode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (shoppingListId.present) {
      map['shopping_list_id'] = Variable<int>(shoppingListId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (estimatedUnitPriceInCents.present) {
      map['estimated_unit_price_in_cents'] = Variable<int>(
        estimatedUnitPriceInCents.value,
      );
    }
    if (actualUnitPriceInCents.present) {
      map['actual_unit_price_in_cents'] = Variable<int>(
        actualUnitPriceInCents.value,
      );
    }
    if (isPurchased.present) {
      map['is_purchased'] = Variable<bool>(isPurchased.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListItemsCompanion(')
          ..write('id: $id, ')
          ..write('shoppingListId: $shoppingListId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('estimatedUnitPriceInCents: $estimatedUnitPriceInCents, ')
          ..write('actualUnitPriceInCents: $actualUnitPriceInCents, ')
          ..write('isPurchased: $isPurchased, ')
          ..write('notes: $notes, ')
          ..write('barcode: $barcode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ShoppingAdjustmentsTable extends ShoppingAdjustments
    with TableInfo<$ShoppingAdjustmentsTable, ShoppingAdjustmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingAdjustmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _shoppingListIdMeta = const VerificationMeta(
    'shoppingListId',
  );
  @override
  late final GeneratedColumn<int> shoppingListId = GeneratedColumn<int>(
    'shopping_list_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shopping_lists (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPositiveMeta = const VerificationMeta(
    'isPositive',
  );
  @override
  late final GeneratedColumn<bool> isPositive = GeneratedColumn<bool>(
    'is_positive',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_positive" IN (0, 1))',
    ),
  );
  static const VerificationMeta _amountInCentsMeta = const VerificationMeta(
    'amountInCents',
  );
  @override
  late final GeneratedColumn<int> amountInCents = GeneratedColumn<int>(
    'amount_in_cents',
    aliasedName,
    false,
    check: () => ComparableExpr(amountInCents).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    shoppingListId,
    name,
    isPositive,
    amountInCents,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_adjustments';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShoppingAdjustmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('shopping_list_id')) {
      context.handle(
        _shoppingListIdMeta,
        shoppingListId.isAcceptableOrUnknown(
          data['shopping_list_id']!,
          _shoppingListIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_shoppingListIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_positive')) {
      context.handle(
        _isPositiveMeta,
        isPositive.isAcceptableOrUnknown(data['is_positive']!, _isPositiveMeta),
      );
    } else if (isInserting) {
      context.missing(_isPositiveMeta);
    }
    if (data.containsKey('amount_in_cents')) {
      context.handle(
        _amountInCentsMeta,
        amountInCents.isAcceptableOrUnknown(
          data['amount_in_cents']!,
          _amountInCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountInCentsMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingAdjustmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingAdjustmentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      shoppingListId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shopping_list_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isPositive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_positive'],
      )!,
      amountInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_in_cents'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ShoppingAdjustmentsTable createAlias(String alias) {
    return $ShoppingAdjustmentsTable(attachedDatabase, alias);
  }
}

class ShoppingAdjustmentRow extends DataClass
    implements Insertable<ShoppingAdjustmentRow> {
  final int id;
  final int shoppingListId;
  final String name;
  final bool isPositive;
  final int amountInCents;
  final DateTime createdAt;
  const ShoppingAdjustmentRow({
    required this.id,
    required this.shoppingListId,
    required this.name,
    required this.isPositive,
    required this.amountInCents,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['shopping_list_id'] = Variable<int>(shoppingListId);
    map['name'] = Variable<String>(name);
    map['is_positive'] = Variable<bool>(isPositive);
    map['amount_in_cents'] = Variable<int>(amountInCents);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ShoppingAdjustmentsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingAdjustmentsCompanion(
      id: Value(id),
      shoppingListId: Value(shoppingListId),
      name: Value(name),
      isPositive: Value(isPositive),
      amountInCents: Value(amountInCents),
      createdAt: Value(createdAt),
    );
  }

  factory ShoppingAdjustmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingAdjustmentRow(
      id: serializer.fromJson<int>(json['id']),
      shoppingListId: serializer.fromJson<int>(json['shoppingListId']),
      name: serializer.fromJson<String>(json['name']),
      isPositive: serializer.fromJson<bool>(json['isPositive']),
      amountInCents: serializer.fromJson<int>(json['amountInCents']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'shoppingListId': serializer.toJson<int>(shoppingListId),
      'name': serializer.toJson<String>(name),
      'isPositive': serializer.toJson<bool>(isPositive),
      'amountInCents': serializer.toJson<int>(amountInCents),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ShoppingAdjustmentRow copyWith({
    int? id,
    int? shoppingListId,
    String? name,
    bool? isPositive,
    int? amountInCents,
    DateTime? createdAt,
  }) => ShoppingAdjustmentRow(
    id: id ?? this.id,
    shoppingListId: shoppingListId ?? this.shoppingListId,
    name: name ?? this.name,
    isPositive: isPositive ?? this.isPositive,
    amountInCents: amountInCents ?? this.amountInCents,
    createdAt: createdAt ?? this.createdAt,
  );
  ShoppingAdjustmentRow copyWithCompanion(ShoppingAdjustmentsCompanion data) {
    return ShoppingAdjustmentRow(
      id: data.id.present ? data.id.value : this.id,
      shoppingListId: data.shoppingListId.present
          ? data.shoppingListId.value
          : this.shoppingListId,
      name: data.name.present ? data.name.value : this.name,
      isPositive: data.isPositive.present
          ? data.isPositive.value
          : this.isPositive,
      amountInCents: data.amountInCents.present
          ? data.amountInCents.value
          : this.amountInCents,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingAdjustmentRow(')
          ..write('id: $id, ')
          ..write('shoppingListId: $shoppingListId, ')
          ..write('name: $name, ')
          ..write('isPositive: $isPositive, ')
          ..write('amountInCents: $amountInCents, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    shoppingListId,
    name,
    isPositive,
    amountInCents,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingAdjustmentRow &&
          other.id == this.id &&
          other.shoppingListId == this.shoppingListId &&
          other.name == this.name &&
          other.isPositive == this.isPositive &&
          other.amountInCents == this.amountInCents &&
          other.createdAt == this.createdAt);
}

class ShoppingAdjustmentsCompanion
    extends UpdateCompanion<ShoppingAdjustmentRow> {
  final Value<int> id;
  final Value<int> shoppingListId;
  final Value<String> name;
  final Value<bool> isPositive;
  final Value<int> amountInCents;
  final Value<DateTime> createdAt;
  const ShoppingAdjustmentsCompanion({
    this.id = const Value.absent(),
    this.shoppingListId = const Value.absent(),
    this.name = const Value.absent(),
    this.isPositive = const Value.absent(),
    this.amountInCents = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ShoppingAdjustmentsCompanion.insert({
    this.id = const Value.absent(),
    required int shoppingListId,
    required String name,
    required bool isPositive,
    required int amountInCents,
    this.createdAt = const Value.absent(),
  }) : shoppingListId = Value(shoppingListId),
       name = Value(name),
       isPositive = Value(isPositive),
       amountInCents = Value(amountInCents);
  static Insertable<ShoppingAdjustmentRow> custom({
    Expression<int>? id,
    Expression<int>? shoppingListId,
    Expression<String>? name,
    Expression<bool>? isPositive,
    Expression<int>? amountInCents,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shoppingListId != null) 'shopping_list_id': shoppingListId,
      if (name != null) 'name': name,
      if (isPositive != null) 'is_positive': isPositive,
      if (amountInCents != null) 'amount_in_cents': amountInCents,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ShoppingAdjustmentsCompanion copyWith({
    Value<int>? id,
    Value<int>? shoppingListId,
    Value<String>? name,
    Value<bool>? isPositive,
    Value<int>? amountInCents,
    Value<DateTime>? createdAt,
  }) {
    return ShoppingAdjustmentsCompanion(
      id: id ?? this.id,
      shoppingListId: shoppingListId ?? this.shoppingListId,
      name: name ?? this.name,
      isPositive: isPositive ?? this.isPositive,
      amountInCents: amountInCents ?? this.amountInCents,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (shoppingListId.present) {
      map['shopping_list_id'] = Variable<int>(shoppingListId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isPositive.present) {
      map['is_positive'] = Variable<bool>(isPositive.value);
    }
    if (amountInCents.present) {
      map['amount_in_cents'] = Variable<int>(amountInCents.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingAdjustmentsCompanion(')
          ..write('id: $id, ')
          ..write('shoppingListId: $shoppingListId, ')
          ..write('name: $name, ')
          ..write('isPositive: $isPositive, ')
          ..write('amountInCents: $amountInCents, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ShoppingPayablesTable extends ShoppingPayables
    with TableInfo<$ShoppingPayablesTable, ShoppingPayableRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingPayablesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _shoppingListIdMeta = const VerificationMeta(
    'shoppingListId',
  );
  @override
  late final GeneratedColumn<int> shoppingListId = GeneratedColumn<int>(
    'shopping_list_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES shopping_lists (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _amountInCentsMeta = const VerificationMeta(
    'amountInCents',
  );
  @override
  late final GeneratedColumn<int> amountInCents = GeneratedColumn<int>(
    'amount_in_cents',
    aliasedName,
    false,
    check: () => ComparableExpr(amountInCents).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _paymentMethodIdMeta = const VerificationMeta(
    'paymentMethodId',
  );
  @override
  late final GeneratedColumn<int> paymentMethodId = GeneratedColumn<int>(
    'payment_method_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES payment_methods (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _dateEpochDayMeta = const VerificationMeta(
    'dateEpochDay',
  );
  @override
  late final GeneratedColumn<int> dateEpochDay = GeneratedColumn<int>(
    'date_epoch_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 160,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSettledMeta = const VerificationMeta(
    'isSettled',
  );
  @override
  late final GeneratedColumn<bool> isSettled = GeneratedColumn<bool>(
    'is_settled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_settled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
    'transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    shoppingListId,
    amountInCents,
    categoryId,
    paymentMethodId,
    dateEpochDay,
    description,
    isSettled,
    transactionId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_payables';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShoppingPayableRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('shopping_list_id')) {
      context.handle(
        _shoppingListIdMeta,
        shoppingListId.isAcceptableOrUnknown(
          data['shopping_list_id']!,
          _shoppingListIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_shoppingListIdMeta);
    }
    if (data.containsKey('amount_in_cents')) {
      context.handle(
        _amountInCentsMeta,
        amountInCents.isAcceptableOrUnknown(
          data['amount_in_cents']!,
          _amountInCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountInCentsMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('payment_method_id')) {
      context.handle(
        _paymentMethodIdMeta,
        paymentMethodId.isAcceptableOrUnknown(
          data['payment_method_id']!,
          _paymentMethodIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentMethodIdMeta);
    }
    if (data.containsKey('date_epoch_day')) {
      context.handle(
        _dateEpochDayMeta,
        dateEpochDay.isAcceptableOrUnknown(
          data['date_epoch_day']!,
          _dateEpochDayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateEpochDayMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('is_settled')) {
      context.handle(
        _isSettledMeta,
        isSettled.isAcceptableOrUnknown(data['is_settled']!, _isSettledMeta),
      );
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingPayableRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingPayableRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      shoppingListId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shopping_list_id'],
      )!,
      amountInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_in_cents'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      paymentMethodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payment_method_id'],
      )!,
      dateEpochDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date_epoch_day'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      isSettled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_settled'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transaction_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ShoppingPayablesTable createAlias(String alias) {
    return $ShoppingPayablesTable(attachedDatabase, alias);
  }
}

class ShoppingPayableRow extends DataClass
    implements Insertable<ShoppingPayableRow> {
  final int id;
  final int shoppingListId;
  final int amountInCents;
  final int categoryId;
  final int paymentMethodId;
  final int dateEpochDay;
  final String description;
  final bool isSettled;
  final int? transactionId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ShoppingPayableRow({
    required this.id,
    required this.shoppingListId,
    required this.amountInCents,
    required this.categoryId,
    required this.paymentMethodId,
    required this.dateEpochDay,
    required this.description,
    required this.isSettled,
    this.transactionId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['shopping_list_id'] = Variable<int>(shoppingListId);
    map['amount_in_cents'] = Variable<int>(amountInCents);
    map['category_id'] = Variable<int>(categoryId);
    map['payment_method_id'] = Variable<int>(paymentMethodId);
    map['date_epoch_day'] = Variable<int>(dateEpochDay);
    map['description'] = Variable<String>(description);
    map['is_settled'] = Variable<bool>(isSettled);
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<int>(transactionId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ShoppingPayablesCompanion toCompanion(bool nullToAbsent) {
    return ShoppingPayablesCompanion(
      id: Value(id),
      shoppingListId: Value(shoppingListId),
      amountInCents: Value(amountInCents),
      categoryId: Value(categoryId),
      paymentMethodId: Value(paymentMethodId),
      dateEpochDay: Value(dateEpochDay),
      description: Value(description),
      isSettled: Value(isSettled),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ShoppingPayableRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingPayableRow(
      id: serializer.fromJson<int>(json['id']),
      shoppingListId: serializer.fromJson<int>(json['shoppingListId']),
      amountInCents: serializer.fromJson<int>(json['amountInCents']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      paymentMethodId: serializer.fromJson<int>(json['paymentMethodId']),
      dateEpochDay: serializer.fromJson<int>(json['dateEpochDay']),
      description: serializer.fromJson<String>(json['description']),
      isSettled: serializer.fromJson<bool>(json['isSettled']),
      transactionId: serializer.fromJson<int?>(json['transactionId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'shoppingListId': serializer.toJson<int>(shoppingListId),
      'amountInCents': serializer.toJson<int>(amountInCents),
      'categoryId': serializer.toJson<int>(categoryId),
      'paymentMethodId': serializer.toJson<int>(paymentMethodId),
      'dateEpochDay': serializer.toJson<int>(dateEpochDay),
      'description': serializer.toJson<String>(description),
      'isSettled': serializer.toJson<bool>(isSettled),
      'transactionId': serializer.toJson<int?>(transactionId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ShoppingPayableRow copyWith({
    int? id,
    int? shoppingListId,
    int? amountInCents,
    int? categoryId,
    int? paymentMethodId,
    int? dateEpochDay,
    String? description,
    bool? isSettled,
    Value<int?> transactionId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ShoppingPayableRow(
    id: id ?? this.id,
    shoppingListId: shoppingListId ?? this.shoppingListId,
    amountInCents: amountInCents ?? this.amountInCents,
    categoryId: categoryId ?? this.categoryId,
    paymentMethodId: paymentMethodId ?? this.paymentMethodId,
    dateEpochDay: dateEpochDay ?? this.dateEpochDay,
    description: description ?? this.description,
    isSettled: isSettled ?? this.isSettled,
    transactionId: transactionId.present
        ? transactionId.value
        : this.transactionId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ShoppingPayableRow copyWithCompanion(ShoppingPayablesCompanion data) {
    return ShoppingPayableRow(
      id: data.id.present ? data.id.value : this.id,
      shoppingListId: data.shoppingListId.present
          ? data.shoppingListId.value
          : this.shoppingListId,
      amountInCents: data.amountInCents.present
          ? data.amountInCents.value
          : this.amountInCents,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      paymentMethodId: data.paymentMethodId.present
          ? data.paymentMethodId.value
          : this.paymentMethodId,
      dateEpochDay: data.dateEpochDay.present
          ? data.dateEpochDay.value
          : this.dateEpochDay,
      description: data.description.present
          ? data.description.value
          : this.description,
      isSettled: data.isSettled.present ? data.isSettled.value : this.isSettled,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingPayableRow(')
          ..write('id: $id, ')
          ..write('shoppingListId: $shoppingListId, ')
          ..write('amountInCents: $amountInCents, ')
          ..write('categoryId: $categoryId, ')
          ..write('paymentMethodId: $paymentMethodId, ')
          ..write('dateEpochDay: $dateEpochDay, ')
          ..write('description: $description, ')
          ..write('isSettled: $isSettled, ')
          ..write('transactionId: $transactionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    shoppingListId,
    amountInCents,
    categoryId,
    paymentMethodId,
    dateEpochDay,
    description,
    isSettled,
    transactionId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingPayableRow &&
          other.id == this.id &&
          other.shoppingListId == this.shoppingListId &&
          other.amountInCents == this.amountInCents &&
          other.categoryId == this.categoryId &&
          other.paymentMethodId == this.paymentMethodId &&
          other.dateEpochDay == this.dateEpochDay &&
          other.description == this.description &&
          other.isSettled == this.isSettled &&
          other.transactionId == this.transactionId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ShoppingPayablesCompanion extends UpdateCompanion<ShoppingPayableRow> {
  final Value<int> id;
  final Value<int> shoppingListId;
  final Value<int> amountInCents;
  final Value<int> categoryId;
  final Value<int> paymentMethodId;
  final Value<int> dateEpochDay;
  final Value<String> description;
  final Value<bool> isSettled;
  final Value<int?> transactionId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ShoppingPayablesCompanion({
    this.id = const Value.absent(),
    this.shoppingListId = const Value.absent(),
    this.amountInCents = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.paymentMethodId = const Value.absent(),
    this.dateEpochDay = const Value.absent(),
    this.description = const Value.absent(),
    this.isSettled = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ShoppingPayablesCompanion.insert({
    this.id = const Value.absent(),
    required int shoppingListId,
    required int amountInCents,
    required int categoryId,
    required int paymentMethodId,
    required int dateEpochDay,
    required String description,
    this.isSettled = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : shoppingListId = Value(shoppingListId),
       amountInCents = Value(amountInCents),
       categoryId = Value(categoryId),
       paymentMethodId = Value(paymentMethodId),
       dateEpochDay = Value(dateEpochDay),
       description = Value(description);
  static Insertable<ShoppingPayableRow> custom({
    Expression<int>? id,
    Expression<int>? shoppingListId,
    Expression<int>? amountInCents,
    Expression<int>? categoryId,
    Expression<int>? paymentMethodId,
    Expression<int>? dateEpochDay,
    Expression<String>? description,
    Expression<bool>? isSettled,
    Expression<int>? transactionId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shoppingListId != null) 'shopping_list_id': shoppingListId,
      if (amountInCents != null) 'amount_in_cents': amountInCents,
      if (categoryId != null) 'category_id': categoryId,
      if (paymentMethodId != null) 'payment_method_id': paymentMethodId,
      if (dateEpochDay != null) 'date_epoch_day': dateEpochDay,
      if (description != null) 'description': description,
      if (isSettled != null) 'is_settled': isSettled,
      if (transactionId != null) 'transaction_id': transactionId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ShoppingPayablesCompanion copyWith({
    Value<int>? id,
    Value<int>? shoppingListId,
    Value<int>? amountInCents,
    Value<int>? categoryId,
    Value<int>? paymentMethodId,
    Value<int>? dateEpochDay,
    Value<String>? description,
    Value<bool>? isSettled,
    Value<int?>? transactionId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ShoppingPayablesCompanion(
      id: id ?? this.id,
      shoppingListId: shoppingListId ?? this.shoppingListId,
      amountInCents: amountInCents ?? this.amountInCents,
      categoryId: categoryId ?? this.categoryId,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      dateEpochDay: dateEpochDay ?? this.dateEpochDay,
      description: description ?? this.description,
      isSettled: isSettled ?? this.isSettled,
      transactionId: transactionId ?? this.transactionId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (shoppingListId.present) {
      map['shopping_list_id'] = Variable<int>(shoppingListId.value);
    }
    if (amountInCents.present) {
      map['amount_in_cents'] = Variable<int>(amountInCents.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (paymentMethodId.present) {
      map['payment_method_id'] = Variable<int>(paymentMethodId.value);
    }
    if (dateEpochDay.present) {
      map['date_epoch_day'] = Variable<int>(dateEpochDay.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isSettled.present) {
      map['is_settled'] = Variable<bool>(isSettled.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingPayablesCompanion(')
          ..write('id: $id, ')
          ..write('shoppingListId: $shoppingListId, ')
          ..write('amountInCents: $amountInCents, ')
          ..write('categoryId: $categoryId, ')
          ..write('paymentMethodId: $paymentMethodId, ')
          ..write('dateEpochDay: $dateEpochDay, ')
          ..write('description: $description, ')
          ..write('isSettled: $isSettled, ')
          ..write('transactionId: $transactionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ObligationsTable extends Obligations
    with TableInfo<$ObligationsTable, ObligationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ObligationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _directionMeta = const VerificationMeta(
    'direction',
  );
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
    'direction',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 12,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _counterpartyMeta = const VerificationMeta(
    'counterparty',
  );
  @override
  late final GeneratedColumn<String> counterparty = GeneratedColumn<String>(
    'counterparty',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountInCentsMeta = const VerificationMeta(
    'amountInCents',
  );
  @override
  late final GeneratedColumn<int> amountInCents = GeneratedColumn<int>(
    'amount_in_cents',
    aliasedName,
    false,
    check: () => ComparableExpr(amountInCents).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateEpochDayMeta = const VerificationMeta(
    'dueDateEpochDay',
  );
  @override
  late final GeneratedColumn<int> dueDateEpochDay = GeneratedColumn<int>(
    'due_date_epoch_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _defaultPaymentMethodIdMeta =
      const VerificationMeta('defaultPaymentMethodId');
  @override
  late final GeneratedColumn<int> defaultPaymentMethodId = GeneratedColumn<int>(
    'default_payment_method_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES payment_methods (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _sourceShoppingListIdMeta =
      const VerificationMeta('sourceShoppingListId');
  @override
  late final GeneratedColumn<int> sourceShoppingListId = GeneratedColumn<int>(
    'source_shopping_list_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES shopping_lists (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _isCancelledMeta = const VerificationMeta(
    'isCancelled',
  );
  @override
  late final GeneratedColumn<bool> isCancelled = GeneratedColumn<bool>(
    'is_cancelled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_cancelled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    direction,
    title,
    counterparty,
    amountInCents,
    dueDateEpochDay,
    categoryId,
    defaultPaymentMethodId,
    sourceShoppingListId,
    isCancelled,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'obligations';
  @override
  VerificationContext validateIntegrity(
    Insertable<ObligationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('direction')) {
      context.handle(
        _directionMeta,
        direction.isAcceptableOrUnknown(data['direction']!, _directionMeta),
      );
    } else if (isInserting) {
      context.missing(_directionMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('counterparty')) {
      context.handle(
        _counterpartyMeta,
        counterparty.isAcceptableOrUnknown(
          data['counterparty']!,
          _counterpartyMeta,
        ),
      );
    }
    if (data.containsKey('amount_in_cents')) {
      context.handle(
        _amountInCentsMeta,
        amountInCents.isAcceptableOrUnknown(
          data['amount_in_cents']!,
          _amountInCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountInCentsMeta);
    }
    if (data.containsKey('due_date_epoch_day')) {
      context.handle(
        _dueDateEpochDayMeta,
        dueDateEpochDay.isAcceptableOrUnknown(
          data['due_date_epoch_day']!,
          _dueDateEpochDayMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('default_payment_method_id')) {
      context.handle(
        _defaultPaymentMethodIdMeta,
        defaultPaymentMethodId.isAcceptableOrUnknown(
          data['default_payment_method_id']!,
          _defaultPaymentMethodIdMeta,
        ),
      );
    }
    if (data.containsKey('source_shopping_list_id')) {
      context.handle(
        _sourceShoppingListIdMeta,
        sourceShoppingListId.isAcceptableOrUnknown(
          data['source_shopping_list_id']!,
          _sourceShoppingListIdMeta,
        ),
      );
    }
    if (data.containsKey('is_cancelled')) {
      context.handle(
        _isCancelledMeta,
        isCancelled.isAcceptableOrUnknown(
          data['is_cancelled']!,
          _isCancelledMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ObligationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ObligationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      direction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direction'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      counterparty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}counterparty'],
      ),
      amountInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_in_cents'],
      )!,
      dueDateEpochDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_date_epoch_day'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      defaultPaymentMethodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_payment_method_id'],
      ),
      sourceShoppingListId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_shopping_list_id'],
      ),
      isCancelled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_cancelled'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ObligationsTable createAlias(String alias) {
    return $ObligationsTable(attachedDatabase, alias);
  }
}

class ObligationRow extends DataClass implements Insertable<ObligationRow> {
  final int id;
  final String direction;
  final String title;
  final String? counterparty;
  final int amountInCents;
  final int? dueDateEpochDay;
  final int categoryId;
  final int? defaultPaymentMethodId;
  final int? sourceShoppingListId;
  final bool isCancelled;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ObligationRow({
    required this.id,
    required this.direction,
    required this.title,
    this.counterparty,
    required this.amountInCents,
    this.dueDateEpochDay,
    required this.categoryId,
    this.defaultPaymentMethodId,
    this.sourceShoppingListId,
    required this.isCancelled,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['direction'] = Variable<String>(direction);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || counterparty != null) {
      map['counterparty'] = Variable<String>(counterparty);
    }
    map['amount_in_cents'] = Variable<int>(amountInCents);
    if (!nullToAbsent || dueDateEpochDay != null) {
      map['due_date_epoch_day'] = Variable<int>(dueDateEpochDay);
    }
    map['category_id'] = Variable<int>(categoryId);
    if (!nullToAbsent || defaultPaymentMethodId != null) {
      map['default_payment_method_id'] = Variable<int>(defaultPaymentMethodId);
    }
    if (!nullToAbsent || sourceShoppingListId != null) {
      map['source_shopping_list_id'] = Variable<int>(sourceShoppingListId);
    }
    map['is_cancelled'] = Variable<bool>(isCancelled);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ObligationsCompanion toCompanion(bool nullToAbsent) {
    return ObligationsCompanion(
      id: Value(id),
      direction: Value(direction),
      title: Value(title),
      counterparty: counterparty == null && nullToAbsent
          ? const Value.absent()
          : Value(counterparty),
      amountInCents: Value(amountInCents),
      dueDateEpochDay: dueDateEpochDay == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDateEpochDay),
      categoryId: Value(categoryId),
      defaultPaymentMethodId: defaultPaymentMethodId == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultPaymentMethodId),
      sourceShoppingListId: sourceShoppingListId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceShoppingListId),
      isCancelled: Value(isCancelled),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ObligationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ObligationRow(
      id: serializer.fromJson<int>(json['id']),
      direction: serializer.fromJson<String>(json['direction']),
      title: serializer.fromJson<String>(json['title']),
      counterparty: serializer.fromJson<String?>(json['counterparty']),
      amountInCents: serializer.fromJson<int>(json['amountInCents']),
      dueDateEpochDay: serializer.fromJson<int?>(json['dueDateEpochDay']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      defaultPaymentMethodId: serializer.fromJson<int?>(
        json['defaultPaymentMethodId'],
      ),
      sourceShoppingListId: serializer.fromJson<int?>(
        json['sourceShoppingListId'],
      ),
      isCancelled: serializer.fromJson<bool>(json['isCancelled']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'direction': serializer.toJson<String>(direction),
      'title': serializer.toJson<String>(title),
      'counterparty': serializer.toJson<String?>(counterparty),
      'amountInCents': serializer.toJson<int>(amountInCents),
      'dueDateEpochDay': serializer.toJson<int?>(dueDateEpochDay),
      'categoryId': serializer.toJson<int>(categoryId),
      'defaultPaymentMethodId': serializer.toJson<int?>(defaultPaymentMethodId),
      'sourceShoppingListId': serializer.toJson<int?>(sourceShoppingListId),
      'isCancelled': serializer.toJson<bool>(isCancelled),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ObligationRow copyWith({
    int? id,
    String? direction,
    String? title,
    Value<String?> counterparty = const Value.absent(),
    int? amountInCents,
    Value<int?> dueDateEpochDay = const Value.absent(),
    int? categoryId,
    Value<int?> defaultPaymentMethodId = const Value.absent(),
    Value<int?> sourceShoppingListId = const Value.absent(),
    bool? isCancelled,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ObligationRow(
    id: id ?? this.id,
    direction: direction ?? this.direction,
    title: title ?? this.title,
    counterparty: counterparty.present ? counterparty.value : this.counterparty,
    amountInCents: amountInCents ?? this.amountInCents,
    dueDateEpochDay: dueDateEpochDay.present
        ? dueDateEpochDay.value
        : this.dueDateEpochDay,
    categoryId: categoryId ?? this.categoryId,
    defaultPaymentMethodId: defaultPaymentMethodId.present
        ? defaultPaymentMethodId.value
        : this.defaultPaymentMethodId,
    sourceShoppingListId: sourceShoppingListId.present
        ? sourceShoppingListId.value
        : this.sourceShoppingListId,
    isCancelled: isCancelled ?? this.isCancelled,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ObligationRow copyWithCompanion(ObligationsCompanion data) {
    return ObligationRow(
      id: data.id.present ? data.id.value : this.id,
      direction: data.direction.present ? data.direction.value : this.direction,
      title: data.title.present ? data.title.value : this.title,
      counterparty: data.counterparty.present
          ? data.counterparty.value
          : this.counterparty,
      amountInCents: data.amountInCents.present
          ? data.amountInCents.value
          : this.amountInCents,
      dueDateEpochDay: data.dueDateEpochDay.present
          ? data.dueDateEpochDay.value
          : this.dueDateEpochDay,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      defaultPaymentMethodId: data.defaultPaymentMethodId.present
          ? data.defaultPaymentMethodId.value
          : this.defaultPaymentMethodId,
      sourceShoppingListId: data.sourceShoppingListId.present
          ? data.sourceShoppingListId.value
          : this.sourceShoppingListId,
      isCancelled: data.isCancelled.present
          ? data.isCancelled.value
          : this.isCancelled,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ObligationRow(')
          ..write('id: $id, ')
          ..write('direction: $direction, ')
          ..write('title: $title, ')
          ..write('counterparty: $counterparty, ')
          ..write('amountInCents: $amountInCents, ')
          ..write('dueDateEpochDay: $dueDateEpochDay, ')
          ..write('categoryId: $categoryId, ')
          ..write('defaultPaymentMethodId: $defaultPaymentMethodId, ')
          ..write('sourceShoppingListId: $sourceShoppingListId, ')
          ..write('isCancelled: $isCancelled, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    direction,
    title,
    counterparty,
    amountInCents,
    dueDateEpochDay,
    categoryId,
    defaultPaymentMethodId,
    sourceShoppingListId,
    isCancelled,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ObligationRow &&
          other.id == this.id &&
          other.direction == this.direction &&
          other.title == this.title &&
          other.counterparty == this.counterparty &&
          other.amountInCents == this.amountInCents &&
          other.dueDateEpochDay == this.dueDateEpochDay &&
          other.categoryId == this.categoryId &&
          other.defaultPaymentMethodId == this.defaultPaymentMethodId &&
          other.sourceShoppingListId == this.sourceShoppingListId &&
          other.isCancelled == this.isCancelled &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ObligationsCompanion extends UpdateCompanion<ObligationRow> {
  final Value<int> id;
  final Value<String> direction;
  final Value<String> title;
  final Value<String?> counterparty;
  final Value<int> amountInCents;
  final Value<int?> dueDateEpochDay;
  final Value<int> categoryId;
  final Value<int?> defaultPaymentMethodId;
  final Value<int?> sourceShoppingListId;
  final Value<bool> isCancelled;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ObligationsCompanion({
    this.id = const Value.absent(),
    this.direction = const Value.absent(),
    this.title = const Value.absent(),
    this.counterparty = const Value.absent(),
    this.amountInCents = const Value.absent(),
    this.dueDateEpochDay = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.defaultPaymentMethodId = const Value.absent(),
    this.sourceShoppingListId = const Value.absent(),
    this.isCancelled = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ObligationsCompanion.insert({
    this.id = const Value.absent(),
    required String direction,
    required String title,
    this.counterparty = const Value.absent(),
    required int amountInCents,
    this.dueDateEpochDay = const Value.absent(),
    required int categoryId,
    this.defaultPaymentMethodId = const Value.absent(),
    this.sourceShoppingListId = const Value.absent(),
    this.isCancelled = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : direction = Value(direction),
       title = Value(title),
       amountInCents = Value(amountInCents),
       categoryId = Value(categoryId);
  static Insertable<ObligationRow> custom({
    Expression<int>? id,
    Expression<String>? direction,
    Expression<String>? title,
    Expression<String>? counterparty,
    Expression<int>? amountInCents,
    Expression<int>? dueDateEpochDay,
    Expression<int>? categoryId,
    Expression<int>? defaultPaymentMethodId,
    Expression<int>? sourceShoppingListId,
    Expression<bool>? isCancelled,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (direction != null) 'direction': direction,
      if (title != null) 'title': title,
      if (counterparty != null) 'counterparty': counterparty,
      if (amountInCents != null) 'amount_in_cents': amountInCents,
      if (dueDateEpochDay != null) 'due_date_epoch_day': dueDateEpochDay,
      if (categoryId != null) 'category_id': categoryId,
      if (defaultPaymentMethodId != null)
        'default_payment_method_id': defaultPaymentMethodId,
      if (sourceShoppingListId != null)
        'source_shopping_list_id': sourceShoppingListId,
      if (isCancelled != null) 'is_cancelled': isCancelled,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ObligationsCompanion copyWith({
    Value<int>? id,
    Value<String>? direction,
    Value<String>? title,
    Value<String?>? counterparty,
    Value<int>? amountInCents,
    Value<int?>? dueDateEpochDay,
    Value<int>? categoryId,
    Value<int?>? defaultPaymentMethodId,
    Value<int?>? sourceShoppingListId,
    Value<bool>? isCancelled,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ObligationsCompanion(
      id: id ?? this.id,
      direction: direction ?? this.direction,
      title: title ?? this.title,
      counterparty: counterparty ?? this.counterparty,
      amountInCents: amountInCents ?? this.amountInCents,
      dueDateEpochDay: dueDateEpochDay ?? this.dueDateEpochDay,
      categoryId: categoryId ?? this.categoryId,
      defaultPaymentMethodId:
          defaultPaymentMethodId ?? this.defaultPaymentMethodId,
      sourceShoppingListId: sourceShoppingListId ?? this.sourceShoppingListId,
      isCancelled: isCancelled ?? this.isCancelled,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (counterparty.present) {
      map['counterparty'] = Variable<String>(counterparty.value);
    }
    if (amountInCents.present) {
      map['amount_in_cents'] = Variable<int>(amountInCents.value);
    }
    if (dueDateEpochDay.present) {
      map['due_date_epoch_day'] = Variable<int>(dueDateEpochDay.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (defaultPaymentMethodId.present) {
      map['default_payment_method_id'] = Variable<int>(
        defaultPaymentMethodId.value,
      );
    }
    if (sourceShoppingListId.present) {
      map['source_shopping_list_id'] = Variable<int>(
        sourceShoppingListId.value,
      );
    }
    if (isCancelled.present) {
      map['is_cancelled'] = Variable<bool>(isCancelled.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ObligationsCompanion(')
          ..write('id: $id, ')
          ..write('direction: $direction, ')
          ..write('title: $title, ')
          ..write('counterparty: $counterparty, ')
          ..write('amountInCents: $amountInCents, ')
          ..write('dueDateEpochDay: $dueDateEpochDay, ')
          ..write('categoryId: $categoryId, ')
          ..write('defaultPaymentMethodId: $defaultPaymentMethodId, ')
          ..write('sourceShoppingListId: $sourceShoppingListId, ')
          ..write('isCancelled: $isCancelled, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ObligationPaymentsTable extends ObligationPayments
    with TableInfo<$ObligationPaymentsTable, ObligationPaymentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ObligationPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _obligationIdMeta = const VerificationMeta(
    'obligationId',
  );
  @override
  late final GeneratedColumn<int> obligationId = GeneratedColumn<int>(
    'obligation_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES obligations (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _amountInCentsMeta = const VerificationMeta(
    'amountInCents',
  );
  @override
  late final GeneratedColumn<int> amountInCents = GeneratedColumn<int>(
    'amount_in_cents',
    aliasedName,
    false,
    check: () => ComparableExpr(amountInCents).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateEpochDayMeta = const VerificationMeta(
    'dateEpochDay',
  );
  @override
  late final GeneratedColumn<int> dateEpochDay = GeneratedColumn<int>(
    'date_epoch_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentMethodIdMeta = const VerificationMeta(
    'paymentMethodId',
  );
  @override
  late final GeneratedColumn<int> paymentMethodId = GeneratedColumn<int>(
    'payment_method_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES payment_methods (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
    'transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES transactions (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 120),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    obligationId,
    amountInCents,
    dateEpochDay,
    paymentMethodId,
    transactionId,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'obligation_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<ObligationPaymentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('obligation_id')) {
      context.handle(
        _obligationIdMeta,
        obligationId.isAcceptableOrUnknown(
          data['obligation_id']!,
          _obligationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_obligationIdMeta);
    }
    if (data.containsKey('amount_in_cents')) {
      context.handle(
        _amountInCentsMeta,
        amountInCents.isAcceptableOrUnknown(
          data['amount_in_cents']!,
          _amountInCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountInCentsMeta);
    }
    if (data.containsKey('date_epoch_day')) {
      context.handle(
        _dateEpochDayMeta,
        dateEpochDay.isAcceptableOrUnknown(
          data['date_epoch_day']!,
          _dateEpochDayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateEpochDayMeta);
    }
    if (data.containsKey('payment_method_id')) {
      context.handle(
        _paymentMethodIdMeta,
        paymentMethodId.isAcceptableOrUnknown(
          data['payment_method_id']!,
          _paymentMethodIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentMethodIdMeta);
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ObligationPaymentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ObligationPaymentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      obligationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}obligation_id'],
      )!,
      amountInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_in_cents'],
      )!,
      dateEpochDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date_epoch_day'],
      )!,
      paymentMethodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payment_method_id'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transaction_id'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ObligationPaymentsTable createAlias(String alias) {
    return $ObligationPaymentsTable(attachedDatabase, alias);
  }
}

class ObligationPaymentRow extends DataClass
    implements Insertable<ObligationPaymentRow> {
  final int id;
  final int obligationId;
  final int amountInCents;
  final int dateEpochDay;
  final int paymentMethodId;
  final int? transactionId;
  final String? note;
  final DateTime createdAt;
  const ObligationPaymentRow({
    required this.id,
    required this.obligationId,
    required this.amountInCents,
    required this.dateEpochDay,
    required this.paymentMethodId,
    this.transactionId,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['obligation_id'] = Variable<int>(obligationId);
    map['amount_in_cents'] = Variable<int>(amountInCents);
    map['date_epoch_day'] = Variable<int>(dateEpochDay);
    map['payment_method_id'] = Variable<int>(paymentMethodId);
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<int>(transactionId);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ObligationPaymentsCompanion toCompanion(bool nullToAbsent) {
    return ObligationPaymentsCompanion(
      id: Value(id),
      obligationId: Value(obligationId),
      amountInCents: Value(amountInCents),
      dateEpochDay: Value(dateEpochDay),
      paymentMethodId: Value(paymentMethodId),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory ObligationPaymentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ObligationPaymentRow(
      id: serializer.fromJson<int>(json['id']),
      obligationId: serializer.fromJson<int>(json['obligationId']),
      amountInCents: serializer.fromJson<int>(json['amountInCents']),
      dateEpochDay: serializer.fromJson<int>(json['dateEpochDay']),
      paymentMethodId: serializer.fromJson<int>(json['paymentMethodId']),
      transactionId: serializer.fromJson<int?>(json['transactionId']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'obligationId': serializer.toJson<int>(obligationId),
      'amountInCents': serializer.toJson<int>(amountInCents),
      'dateEpochDay': serializer.toJson<int>(dateEpochDay),
      'paymentMethodId': serializer.toJson<int>(paymentMethodId),
      'transactionId': serializer.toJson<int?>(transactionId),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ObligationPaymentRow copyWith({
    int? id,
    int? obligationId,
    int? amountInCents,
    int? dateEpochDay,
    int? paymentMethodId,
    Value<int?> transactionId = const Value.absent(),
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => ObligationPaymentRow(
    id: id ?? this.id,
    obligationId: obligationId ?? this.obligationId,
    amountInCents: amountInCents ?? this.amountInCents,
    dateEpochDay: dateEpochDay ?? this.dateEpochDay,
    paymentMethodId: paymentMethodId ?? this.paymentMethodId,
    transactionId: transactionId.present
        ? transactionId.value
        : this.transactionId,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  ObligationPaymentRow copyWithCompanion(ObligationPaymentsCompanion data) {
    return ObligationPaymentRow(
      id: data.id.present ? data.id.value : this.id,
      obligationId: data.obligationId.present
          ? data.obligationId.value
          : this.obligationId,
      amountInCents: data.amountInCents.present
          ? data.amountInCents.value
          : this.amountInCents,
      dateEpochDay: data.dateEpochDay.present
          ? data.dateEpochDay.value
          : this.dateEpochDay,
      paymentMethodId: data.paymentMethodId.present
          ? data.paymentMethodId.value
          : this.paymentMethodId,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ObligationPaymentRow(')
          ..write('id: $id, ')
          ..write('obligationId: $obligationId, ')
          ..write('amountInCents: $amountInCents, ')
          ..write('dateEpochDay: $dateEpochDay, ')
          ..write('paymentMethodId: $paymentMethodId, ')
          ..write('transactionId: $transactionId, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    obligationId,
    amountInCents,
    dateEpochDay,
    paymentMethodId,
    transactionId,
    note,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ObligationPaymentRow &&
          other.id == this.id &&
          other.obligationId == this.obligationId &&
          other.amountInCents == this.amountInCents &&
          other.dateEpochDay == this.dateEpochDay &&
          other.paymentMethodId == this.paymentMethodId &&
          other.transactionId == this.transactionId &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class ObligationPaymentsCompanion
    extends UpdateCompanion<ObligationPaymentRow> {
  final Value<int> id;
  final Value<int> obligationId;
  final Value<int> amountInCents;
  final Value<int> dateEpochDay;
  final Value<int> paymentMethodId;
  final Value<int?> transactionId;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const ObligationPaymentsCompanion({
    this.id = const Value.absent(),
    this.obligationId = const Value.absent(),
    this.amountInCents = const Value.absent(),
    this.dateEpochDay = const Value.absent(),
    this.paymentMethodId = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ObligationPaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int obligationId,
    required int amountInCents,
    required int dateEpochDay,
    required int paymentMethodId,
    this.transactionId = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : obligationId = Value(obligationId),
       amountInCents = Value(amountInCents),
       dateEpochDay = Value(dateEpochDay),
       paymentMethodId = Value(paymentMethodId);
  static Insertable<ObligationPaymentRow> custom({
    Expression<int>? id,
    Expression<int>? obligationId,
    Expression<int>? amountInCents,
    Expression<int>? dateEpochDay,
    Expression<int>? paymentMethodId,
    Expression<int>? transactionId,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (obligationId != null) 'obligation_id': obligationId,
      if (amountInCents != null) 'amount_in_cents': amountInCents,
      if (dateEpochDay != null) 'date_epoch_day': dateEpochDay,
      if (paymentMethodId != null) 'payment_method_id': paymentMethodId,
      if (transactionId != null) 'transaction_id': transactionId,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ObligationPaymentsCompanion copyWith({
    Value<int>? id,
    Value<int>? obligationId,
    Value<int>? amountInCents,
    Value<int>? dateEpochDay,
    Value<int>? paymentMethodId,
    Value<int?>? transactionId,
    Value<String?>? note,
    Value<DateTime>? createdAt,
  }) {
    return ObligationPaymentsCompanion(
      id: id ?? this.id,
      obligationId: obligationId ?? this.obligationId,
      amountInCents: amountInCents ?? this.amountInCents,
      dateEpochDay: dateEpochDay ?? this.dateEpochDay,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      transactionId: transactionId ?? this.transactionId,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (obligationId.present) {
      map['obligation_id'] = Variable<int>(obligationId.value);
    }
    if (amountInCents.present) {
      map['amount_in_cents'] = Variable<int>(amountInCents.value);
    }
    if (dateEpochDay.present) {
      map['date_epoch_day'] = Variable<int>(dateEpochDay.value);
    }
    if (paymentMethodId.present) {
      map['payment_method_id'] = Variable<int>(paymentMethodId.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ObligationPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('obligationId: $obligationId, ')
          ..write('amountInCents: $amountInCents, ')
          ..write('dateEpochDay: $dateEpochDay, ')
          ..write('paymentMethodId: $paymentMethodId, ')
          ..write('transactionId: $transactionId, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $RecurringEntriesTable extends RecurringEntries
    with TableInfo<$RecurringEntriesTable, RecurringEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountInCentsMeta = const VerificationMeta(
    'amountInCents',
  );
  @override
  late final GeneratedColumn<int> amountInCents = GeneratedColumn<int>(
    'amount_in_cents',
    aliasedName,
    false,
    check: () => ComparableExpr(amountInCents).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _paymentMethodIdMeta = const VerificationMeta(
    'paymentMethodId',
  );
  @override
  late final GeneratedColumn<int> paymentMethodId = GeneratedColumn<int>(
    'payment_method_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES payment_methods (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intervalMeta = const VerificationMeta(
    'interval',
  );
  @override
  late final GeneratedColumn<int> interval = GeneratedColumn<int>(
    'interval',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _startDateEpochDayMeta = const VerificationMeta(
    'startDateEpochDay',
  );
  @override
  late final GeneratedColumn<int> startDateEpochDay = GeneratedColumn<int>(
    'start_date_epoch_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextDateEpochDayMeta = const VerificationMeta(
    'nextDateEpochDay',
  );
  @override
  late final GeneratedColumn<int> nextDateEpochDay = GeneratedColumn<int>(
    'next_date_epoch_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateEpochDayMeta = const VerificationMeta(
    'endDateEpochDay',
  );
  @override
  late final GeneratedColumn<int> endDateEpochDay = GeneratedColumn<int>(
    'end_date_epoch_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    amountInCents,
    type,
    categoryId,
    paymentMethodId,
    frequency,
    interval,
    startDateEpochDay,
    nextDateEpochDay,
    endDateEpochDay,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecurringEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount_in_cents')) {
      context.handle(
        _amountInCentsMeta,
        amountInCents.isAcceptableOrUnknown(
          data['amount_in_cents']!,
          _amountInCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountInCentsMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('payment_method_id')) {
      context.handle(
        _paymentMethodIdMeta,
        paymentMethodId.isAcceptableOrUnknown(
          data['payment_method_id']!,
          _paymentMethodIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentMethodIdMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('interval')) {
      context.handle(
        _intervalMeta,
        interval.isAcceptableOrUnknown(data['interval']!, _intervalMeta),
      );
    }
    if (data.containsKey('start_date_epoch_day')) {
      context.handle(
        _startDateEpochDayMeta,
        startDateEpochDay.isAcceptableOrUnknown(
          data['start_date_epoch_day']!,
          _startDateEpochDayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startDateEpochDayMeta);
    }
    if (data.containsKey('next_date_epoch_day')) {
      context.handle(
        _nextDateEpochDayMeta,
        nextDateEpochDay.isAcceptableOrUnknown(
          data['next_date_epoch_day']!,
          _nextDateEpochDayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextDateEpochDayMeta);
    }
    if (data.containsKey('end_date_epoch_day')) {
      context.handle(
        _endDateEpochDayMeta,
        endDateEpochDay.isAcceptableOrUnknown(
          data['end_date_epoch_day']!,
          _endDateEpochDayMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      amountInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_in_cents'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      paymentMethodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payment_method_id'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      interval: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval'],
      )!,
      startDateEpochDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_date_epoch_day'],
      )!,
      nextDateEpochDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}next_date_epoch_day'],
      )!,
      endDateEpochDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_date_epoch_day'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RecurringEntriesTable createAlias(String alias) {
    return $RecurringEntriesTable(attachedDatabase, alias);
  }
}

class RecurringEntryRow extends DataClass
    implements Insertable<RecurringEntryRow> {
  final int id;
  final String title;
  final int amountInCents;
  final String type;
  final int categoryId;
  final int paymentMethodId;
  final String frequency;
  final int interval;
  final int startDateEpochDay;
  final int nextDateEpochDay;
  final int? endDateEpochDay;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RecurringEntryRow({
    required this.id,
    required this.title,
    required this.amountInCents,
    required this.type,
    required this.categoryId,
    required this.paymentMethodId,
    required this.frequency,
    required this.interval,
    required this.startDateEpochDay,
    required this.nextDateEpochDay,
    this.endDateEpochDay,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['amount_in_cents'] = Variable<int>(amountInCents);
    map['type'] = Variable<String>(type);
    map['category_id'] = Variable<int>(categoryId);
    map['payment_method_id'] = Variable<int>(paymentMethodId);
    map['frequency'] = Variable<String>(frequency);
    map['interval'] = Variable<int>(interval);
    map['start_date_epoch_day'] = Variable<int>(startDateEpochDay);
    map['next_date_epoch_day'] = Variable<int>(nextDateEpochDay);
    if (!nullToAbsent || endDateEpochDay != null) {
      map['end_date_epoch_day'] = Variable<int>(endDateEpochDay);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RecurringEntriesCompanion toCompanion(bool nullToAbsent) {
    return RecurringEntriesCompanion(
      id: Value(id),
      title: Value(title),
      amountInCents: Value(amountInCents),
      type: Value(type),
      categoryId: Value(categoryId),
      paymentMethodId: Value(paymentMethodId),
      frequency: Value(frequency),
      interval: Value(interval),
      startDateEpochDay: Value(startDateEpochDay),
      nextDateEpochDay: Value(nextDateEpochDay),
      endDateEpochDay: endDateEpochDay == null && nullToAbsent
          ? const Value.absent()
          : Value(endDateEpochDay),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RecurringEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringEntryRow(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      amountInCents: serializer.fromJson<int>(json['amountInCents']),
      type: serializer.fromJson<String>(json['type']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      paymentMethodId: serializer.fromJson<int>(json['paymentMethodId']),
      frequency: serializer.fromJson<String>(json['frequency']),
      interval: serializer.fromJson<int>(json['interval']),
      startDateEpochDay: serializer.fromJson<int>(json['startDateEpochDay']),
      nextDateEpochDay: serializer.fromJson<int>(json['nextDateEpochDay']),
      endDateEpochDay: serializer.fromJson<int?>(json['endDateEpochDay']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'amountInCents': serializer.toJson<int>(amountInCents),
      'type': serializer.toJson<String>(type),
      'categoryId': serializer.toJson<int>(categoryId),
      'paymentMethodId': serializer.toJson<int>(paymentMethodId),
      'frequency': serializer.toJson<String>(frequency),
      'interval': serializer.toJson<int>(interval),
      'startDateEpochDay': serializer.toJson<int>(startDateEpochDay),
      'nextDateEpochDay': serializer.toJson<int>(nextDateEpochDay),
      'endDateEpochDay': serializer.toJson<int?>(endDateEpochDay),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RecurringEntryRow copyWith({
    int? id,
    String? title,
    int? amountInCents,
    String? type,
    int? categoryId,
    int? paymentMethodId,
    String? frequency,
    int? interval,
    int? startDateEpochDay,
    int? nextDateEpochDay,
    Value<int?> endDateEpochDay = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RecurringEntryRow(
    id: id ?? this.id,
    title: title ?? this.title,
    amountInCents: amountInCents ?? this.amountInCents,
    type: type ?? this.type,
    categoryId: categoryId ?? this.categoryId,
    paymentMethodId: paymentMethodId ?? this.paymentMethodId,
    frequency: frequency ?? this.frequency,
    interval: interval ?? this.interval,
    startDateEpochDay: startDateEpochDay ?? this.startDateEpochDay,
    nextDateEpochDay: nextDateEpochDay ?? this.nextDateEpochDay,
    endDateEpochDay: endDateEpochDay.present
        ? endDateEpochDay.value
        : this.endDateEpochDay,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RecurringEntryRow copyWithCompanion(RecurringEntriesCompanion data) {
    return RecurringEntryRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      amountInCents: data.amountInCents.present
          ? data.amountInCents.value
          : this.amountInCents,
      type: data.type.present ? data.type.value : this.type,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      paymentMethodId: data.paymentMethodId.present
          ? data.paymentMethodId.value
          : this.paymentMethodId,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      interval: data.interval.present ? data.interval.value : this.interval,
      startDateEpochDay: data.startDateEpochDay.present
          ? data.startDateEpochDay.value
          : this.startDateEpochDay,
      nextDateEpochDay: data.nextDateEpochDay.present
          ? data.nextDateEpochDay.value
          : this.nextDateEpochDay,
      endDateEpochDay: data.endDateEpochDay.present
          ? data.endDateEpochDay.value
          : this.endDateEpochDay,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringEntryRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amountInCents: $amountInCents, ')
          ..write('type: $type, ')
          ..write('categoryId: $categoryId, ')
          ..write('paymentMethodId: $paymentMethodId, ')
          ..write('frequency: $frequency, ')
          ..write('interval: $interval, ')
          ..write('startDateEpochDay: $startDateEpochDay, ')
          ..write('nextDateEpochDay: $nextDateEpochDay, ')
          ..write('endDateEpochDay: $endDateEpochDay, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    amountInCents,
    type,
    categoryId,
    paymentMethodId,
    frequency,
    interval,
    startDateEpochDay,
    nextDateEpochDay,
    endDateEpochDay,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringEntryRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.amountInCents == this.amountInCents &&
          other.type == this.type &&
          other.categoryId == this.categoryId &&
          other.paymentMethodId == this.paymentMethodId &&
          other.frequency == this.frequency &&
          other.interval == this.interval &&
          other.startDateEpochDay == this.startDateEpochDay &&
          other.nextDateEpochDay == this.nextDateEpochDay &&
          other.endDateEpochDay == this.endDateEpochDay &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RecurringEntriesCompanion extends UpdateCompanion<RecurringEntryRow> {
  final Value<int> id;
  final Value<String> title;
  final Value<int> amountInCents;
  final Value<String> type;
  final Value<int> categoryId;
  final Value<int> paymentMethodId;
  final Value<String> frequency;
  final Value<int> interval;
  final Value<int> startDateEpochDay;
  final Value<int> nextDateEpochDay;
  final Value<int?> endDateEpochDay;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const RecurringEntriesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.amountInCents = const Value.absent(),
    this.type = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.paymentMethodId = const Value.absent(),
    this.frequency = const Value.absent(),
    this.interval = const Value.absent(),
    this.startDateEpochDay = const Value.absent(),
    this.nextDateEpochDay = const Value.absent(),
    this.endDateEpochDay = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  RecurringEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required int amountInCents,
    required String type,
    required int categoryId,
    required int paymentMethodId,
    required String frequency,
    this.interval = const Value.absent(),
    required int startDateEpochDay,
    required int nextDateEpochDay,
    this.endDateEpochDay = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : title = Value(title),
       amountInCents = Value(amountInCents),
       type = Value(type),
       categoryId = Value(categoryId),
       paymentMethodId = Value(paymentMethodId),
       frequency = Value(frequency),
       startDateEpochDay = Value(startDateEpochDay),
       nextDateEpochDay = Value(nextDateEpochDay);
  static Insertable<RecurringEntryRow> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<int>? amountInCents,
    Expression<String>? type,
    Expression<int>? categoryId,
    Expression<int>? paymentMethodId,
    Expression<String>? frequency,
    Expression<int>? interval,
    Expression<int>? startDateEpochDay,
    Expression<int>? nextDateEpochDay,
    Expression<int>? endDateEpochDay,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (amountInCents != null) 'amount_in_cents': amountInCents,
      if (type != null) 'type': type,
      if (categoryId != null) 'category_id': categoryId,
      if (paymentMethodId != null) 'payment_method_id': paymentMethodId,
      if (frequency != null) 'frequency': frequency,
      if (interval != null) 'interval': interval,
      if (startDateEpochDay != null) 'start_date_epoch_day': startDateEpochDay,
      if (nextDateEpochDay != null) 'next_date_epoch_day': nextDateEpochDay,
      if (endDateEpochDay != null) 'end_date_epoch_day': endDateEpochDay,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  RecurringEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<int>? amountInCents,
    Value<String>? type,
    Value<int>? categoryId,
    Value<int>? paymentMethodId,
    Value<String>? frequency,
    Value<int>? interval,
    Value<int>? startDateEpochDay,
    Value<int>? nextDateEpochDay,
    Value<int?>? endDateEpochDay,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return RecurringEntriesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      amountInCents: amountInCents ?? this.amountInCents,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      frequency: frequency ?? this.frequency,
      interval: interval ?? this.interval,
      startDateEpochDay: startDateEpochDay ?? this.startDateEpochDay,
      nextDateEpochDay: nextDateEpochDay ?? this.nextDateEpochDay,
      endDateEpochDay: endDateEpochDay ?? this.endDateEpochDay,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amountInCents.present) {
      map['amount_in_cents'] = Variable<int>(amountInCents.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (paymentMethodId.present) {
      map['payment_method_id'] = Variable<int>(paymentMethodId.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (interval.present) {
      map['interval'] = Variable<int>(interval.value);
    }
    if (startDateEpochDay.present) {
      map['start_date_epoch_day'] = Variable<int>(startDateEpochDay.value);
    }
    if (nextDateEpochDay.present) {
      map['next_date_epoch_day'] = Variable<int>(nextDateEpochDay.value);
    }
    if (endDateEpochDay.present) {
      map['end_date_epoch_day'] = Variable<int>(endDateEpochDay.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringEntriesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amountInCents: $amountInCents, ')
          ..write('type: $type, ')
          ..write('categoryId: $categoryId, ')
          ..write('paymentMethodId: $paymentMethodId, ')
          ..write('frequency: $frequency, ')
          ..write('interval: $interval, ')
          ..write('startDateEpochDay: $startDateEpochDay, ')
          ..write('nextDateEpochDay: $nextDateEpochDay, ')
          ..write('endDateEpochDay: $endDateEpochDay, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $PaymentMethodsTable paymentMethods = $PaymentMethodsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $SavingsGoalsTable savingsGoals = $SavingsGoalsTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $BudgetCyclesTable budgetCycles = $BudgetCyclesTable(this);
  late final $ShoppingListsTable shoppingLists = $ShoppingListsTable(this);
  late final $ShoppingListItemsTable shoppingListItems =
      $ShoppingListItemsTable(this);
  late final $ShoppingAdjustmentsTable shoppingAdjustments =
      $ShoppingAdjustmentsTable(this);
  late final $ShoppingPayablesTable shoppingPayables = $ShoppingPayablesTable(
    this,
  );
  late final $ObligationsTable obligations = $ObligationsTable(this);
  late final $ObligationPaymentsTable obligationPayments =
      $ObligationPaymentsTable(this);
  late final $RecurringEntriesTable recurringEntries = $RecurringEntriesTable(
    this,
  );
  late final Index paymentMethodsSingleDefault = Index(
    'payment_methods_single_default',
    'CREATE UNIQUE INDEX payment_methods_single_default ON payment_methods (is_default) WHERE is_default = 1',
  );
  late final Index transactionsDateCreatedIdx = Index(
    'transactions_date_created_idx',
    'CREATE INDEX transactions_date_created_idx ON transactions (date_epoch_day, created_at, id)',
  );
  late final Index transactionsCategoryIdx = Index(
    'transactions_category_idx',
    'CREATE INDEX transactions_category_idx ON transactions (category_id)',
  );
  late final Index transactionsPaymentMethodIdx = Index(
    'transactions_payment_method_idx',
    'CREATE INDEX transactions_payment_method_idx ON transactions (payment_method_id)',
  );
  late final Index transactionsFixedEntryIdx = Index(
    'transactions_fixed_entry_idx',
    'CREATE INDEX transactions_fixed_entry_idx ON transactions (fixed_entry_id)',
  );
  late final Index transactionsRecurringDateUnique = Index(
    'transactions_recurring_date_unique',
    'CREATE UNIQUE INDEX transactions_recurring_date_unique ON transactions (fixed_entry_id, date_epoch_day)',
  );
  late final Index transactionsSavingsGoalIdx = Index(
    'transactions_savings_goal_idx',
    'CREATE INDEX transactions_savings_goal_idx ON transactions (savings_goal_id)',
  );
  late final Index savingsGoalsCompletedIdx = Index(
    'savings_goals_completed_idx',
    'CREATE INDEX savings_goals_completed_idx ON savings_goals (completed_at)',
  );
  late final Index budgetCyclesStartEndIdx = Index(
    'budget_cycles_start_end_idx',
    'CREATE INDEX budget_cycles_start_end_idx ON budget_cycles (start_date_epoch_day, end_date_epoch_day)',
  );
  late final Index shoppingListsExpenseIdx = Index(
    'shopping_lists_expense_idx',
    'CREATE UNIQUE INDEX shopping_lists_expense_idx ON shopping_lists (expense_transaction_id) WHERE expense_transaction_id IS NOT NULL',
  );
  late final Index shoppingListItemsListIdx = Index(
    'shopping_list_items_list_idx',
    'CREATE INDEX shopping_list_items_list_idx ON shopping_list_items (shopping_list_id)',
  );
  late final Index shoppingAdjustmentsListIdx = Index(
    'shopping_adjustments_list_idx',
    'CREATE INDEX shopping_adjustments_list_idx ON shopping_adjustments (shopping_list_id)',
  );
  late final Index obligationPaymentsObligationIdx = Index(
    'obligation_payments_obligation_idx',
    'CREATE INDEX obligation_payments_obligation_idx ON obligation_payments (obligation_id)',
  );
  late final Index recurringEntriesActiveNextIdx = Index(
    'recurring_entries_active_next_idx',
    'CREATE INDEX recurring_entries_active_next_idx ON recurring_entries (is_active, next_date_epoch_day)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categories,
    paymentMethods,
    transactions,
    savingsGoals,
    budgets,
    budgetCycles,
    shoppingLists,
    shoppingListItems,
    shoppingAdjustments,
    shoppingPayables,
    obligations,
    obligationPayments,
    recurringEntries,
    paymentMethodsSingleDefault,
    transactionsDateCreatedIdx,
    transactionsCategoryIdx,
    transactionsPaymentMethodIdx,
    transactionsFixedEntryIdx,
    transactionsRecurringDateUnique,
    transactionsSavingsGoalIdx,
    savingsGoalsCompletedIdx,
    budgetCyclesStartEndIdx,
    shoppingListsExpenseIdx,
    shoppingListItemsListIdx,
    shoppingAdjustmentsListIdx,
    obligationPaymentsObligationIdx,
    recurringEntriesActiveNextIdx,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'transactions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('shopping_lists', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'payment_methods',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('shopping_lists', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('shopping_lists', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'shopping_lists',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('shopping_list_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'shopping_lists',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('shopping_adjustments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'shopping_lists',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('shopping_payables', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'transactions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('shopping_payables', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'payment_methods',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('obligations', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'shopping_lists',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('obligations', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'obligations',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('obligation_payments', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      required String name,
      required String normalizedName,
      required String type,
      required String icon,
      required int colorArgb,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<int?> budgetLimitInCents,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> normalizedName,
      Value<String> type,
      Value<String> icon,
      Value<int> colorArgb,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<int?> budgetLimitInCents,
    });

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, CategoryRow> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<FinanceTransactionRow>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'categories__id__transactions__category_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ShoppingListsTable, List<ShoppingListRow>>
  _shoppingListsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.shoppingLists,
    aliasName: 'categories__id__shopping_lists__expense_category_id',
  );

  $$ShoppingListsTableProcessedTableManager get shoppingListsRefs {
    final manager = $$ShoppingListsTableTableManager(
      $_db,
      $_db.shoppingLists,
    ).filter((f) => f.expenseCategoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_shoppingListsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ShoppingPayablesTable, List<ShoppingPayableRow>>
  _shoppingPayablesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.shoppingPayables,
    aliasName: 'categories__id__shopping_payables__category_id',
  );

  $$ShoppingPayablesTableProcessedTableManager get shoppingPayablesRefs {
    final manager = $$ShoppingPayablesTableTableManager(
      $_db,
      $_db.shoppingPayables,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _shoppingPayablesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ObligationsTable, List<ObligationRow>>
  _obligationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.obligations,
    aliasName: 'categories__id__obligations__category_id',
  );

  $$ObligationsTableProcessedTableManager get obligationsRefs {
    final manager = $$ObligationsTableTableManager(
      $_db,
      $_db.obligations,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_obligationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecurringEntriesTable, List<RecurringEntryRow>>
  _recurringEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recurringEntries,
    aliasName: 'categories__id__recurring_entries__category_id',
  );

  $$RecurringEntriesTableProcessedTableManager get recurringEntriesRefs {
    final manager = $$RecurringEntriesTableTableManager(
      $_db,
      $_db.recurringEntries,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recurringEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalizedName => $composableBuilder(
    column: $table.normalizedName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorArgb => $composableBuilder(
    column: $table.colorArgb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get budgetLimitInCents => $composableBuilder(
    column: $table.budgetLimitInCents,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> shoppingListsRefs(
    Expression<bool> Function($$ShoppingListsTableFilterComposer f) f,
  ) {
    final $$ShoppingListsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.expenseCategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableFilterComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> shoppingPayablesRefs(
    Expression<bool> Function($$ShoppingPayablesTableFilterComposer f) f,
  ) {
    final $$ShoppingPayablesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingPayables,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingPayablesTableFilterComposer(
            $db: $db,
            $table: $db.shoppingPayables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> obligationsRefs(
    Expression<bool> Function($$ObligationsTableFilterComposer f) f,
  ) {
    final $$ObligationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.obligations,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObligationsTableFilterComposer(
            $db: $db,
            $table: $db.obligations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recurringEntriesRefs(
    Expression<bool> Function($$RecurringEntriesTableFilterComposer f) f,
  ) {
    final $$RecurringEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurringEntries,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringEntriesTableFilterComposer(
            $db: $db,
            $table: $db.recurringEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalizedName => $composableBuilder(
    column: $table.normalizedName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorArgb => $composableBuilder(
    column: $table.colorArgb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get budgetLimitInCents => $composableBuilder(
    column: $table.budgetLimitInCents,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get normalizedName => $composableBuilder(
    column: $table.normalizedName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get colorArgb =>
      $composableBuilder(column: $table.colorArgb, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get budgetLimitInCents => $composableBuilder(
    column: $table.budgetLimitInCents,
    builder: (column) => column,
  );

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> shoppingListsRefs<T extends Object>(
    Expression<T> Function($$ShoppingListsTableAnnotationComposer a) f,
  ) {
    final $$ShoppingListsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.expenseCategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableAnnotationComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> shoppingPayablesRefs<T extends Object>(
    Expression<T> Function($$ShoppingPayablesTableAnnotationComposer a) f,
  ) {
    final $$ShoppingPayablesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingPayables,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingPayablesTableAnnotationComposer(
            $db: $db,
            $table: $db.shoppingPayables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> obligationsRefs<T extends Object>(
    Expression<T> Function($$ObligationsTableAnnotationComposer a) f,
  ) {
    final $$ObligationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.obligations,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObligationsTableAnnotationComposer(
            $db: $db,
            $table: $db.obligations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recurringEntriesRefs<T extends Object>(
    Expression<T> Function($$RecurringEntriesTableAnnotationComposer a) f,
  ) {
    final $$RecurringEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurringEntries,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.recurringEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          CategoryRow,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (CategoryRow, $$CategoriesTableReferences),
          CategoryRow,
          PrefetchHooks Function({
            bool transactionsRefs,
            bool shoppingListsRefs,
            bool shoppingPayablesRefs,
            bool obligationsRefs,
            bool recurringEntriesRefs,
          })
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> normalizedName = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> colorArgb = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int?> budgetLimitInCents = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                normalizedName: normalizedName,
                type: type,
                icon: icon,
                colorArgb: colorArgb,
                isActive: isActive,
                createdAt: createdAt,
                budgetLimitInCents: budgetLimitInCents,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String normalizedName,
                required String type,
                required String icon,
                required int colorArgb,
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int?> budgetLimitInCents = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                normalizedName: normalizedName,
                type: type,
                icon: icon,
                colorArgb: colorArgb,
                isActive: isActive,
                createdAt: createdAt,
                budgetLimitInCents: budgetLimitInCents,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, CategoryRow>(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                transactionsRefs = false,
                shoppingListsRefs = false,
                shoppingPayablesRefs = false,
                obligationsRefs = false,
                recurringEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionsRefs) db.transactions,
                    if (shoppingListsRefs) db.shoppingLists,
                    if (shoppingPayablesRefs) db.shoppingPayables,
                    if (obligationsRefs) db.obligations,
                    if (recurringEntriesRefs) db.recurringEntries,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionsRefs)
                        await $_getPrefetchedDataByColumns<
                          CategoryRow,
                          $CategoriesTable,
                          FinanceTransactionRow,
                          $TransactionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'category_id',
                          typedResults: items,
                        ),
                      if (shoppingListsRefs)
                        await $_getPrefetchedDataByColumns<
                          CategoryRow,
                          $CategoriesTable,
                          ShoppingListRow,
                          $ShoppingListsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._shoppingListsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).shoppingListsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'expense_category_id',
                          typedResults: items,
                        ),
                      if (shoppingPayablesRefs)
                        await $_getPrefetchedDataByColumns<
                          CategoryRow,
                          $CategoriesTable,
                          ShoppingPayableRow,
                          $ShoppingPayablesTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._shoppingPayablesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).shoppingPayablesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'category_id',
                          typedResults: items,
                        ),
                      if (obligationsRefs)
                        await $_getPrefetchedDataByColumns<
                          CategoryRow,
                          $CategoriesTable,
                          ObligationRow,
                          $ObligationsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._obligationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).obligationsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'category_id',
                          typedResults: items,
                        ),
                      if (recurringEntriesRefs)
                        await $_getPrefetchedDataByColumns<
                          CategoryRow,
                          $CategoriesTable,
                          RecurringEntryRow,
                          $RecurringEntriesTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._recurringEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).recurringEntriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'category_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      CategoryRow,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (CategoryRow, $$CategoriesTableReferences),
      CategoryRow,
      PrefetchHooks Function({
        bool transactionsRefs,
        bool shoppingListsRefs,
        bool shoppingPayablesRefs,
        bool obligationsRefs,
        bool recurringEntriesRefs,
      })
    >;
typedef $$PaymentMethodsTableCreateCompanionBuilder =
    PaymentMethodsCompanion Function({
      Value<int> id,
      required String name,
      required String normalizedName,
      required String icon,
      required int colorArgb,
      Value<bool> isActive,
      Value<bool> isDefault,
      Value<DateTime> createdAt,
    });
typedef $$PaymentMethodsTableUpdateCompanionBuilder =
    PaymentMethodsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> normalizedName,
      Value<String> icon,
      Value<int> colorArgb,
      Value<bool> isActive,
      Value<bool> isDefault,
      Value<DateTime> createdAt,
    });

final class $$PaymentMethodsTableReferences
    extends
        BaseReferences<_$AppDatabase, $PaymentMethodsTable, PaymentMethodRow> {
  $$PaymentMethodsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$TransactionsTable, List<FinanceTransactionRow>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'payment_methods__id__transactions__payment_method_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.paymentMethodId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ShoppingListsTable, List<ShoppingListRow>>
  _shoppingListsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.shoppingLists,
    aliasName: 'payment_methods__id__shopping_lists__payment_method_id',
  );

  $$ShoppingListsTableProcessedTableManager get shoppingListsRefs {
    final manager = $$ShoppingListsTableTableManager(
      $_db,
      $_db.shoppingLists,
    ).filter((f) => f.paymentMethodId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_shoppingListsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ShoppingPayablesTable, List<ShoppingPayableRow>>
  _shoppingPayablesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.shoppingPayables,
    aliasName: 'payment_methods__id__shopping_payables__payment_method_id',
  );

  $$ShoppingPayablesTableProcessedTableManager get shoppingPayablesRefs {
    final manager = $$ShoppingPayablesTableTableManager(
      $_db,
      $_db.shoppingPayables,
    ).filter((f) => f.paymentMethodId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _shoppingPayablesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ObligationsTable, List<ObligationRow>>
  _obligationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.obligations,
    aliasName: 'payment_methods__id__obligations__default_payment_method_id',
  );

  $$ObligationsTableProcessedTableManager get obligationsRefs {
    final manager = $$ObligationsTableTableManager($_db, $_db.obligations)
        .filter(
          (f) =>
              f.defaultPaymentMethodId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_obligationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ObligationPaymentsTable,
    List<ObligationPaymentRow>
  >
  _obligationPaymentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.obligationPayments,
        aliasName:
            'payment_methods__id__obligation_payments__payment_method_id',
      );

  $$ObligationPaymentsTableProcessedTableManager get obligationPaymentsRefs {
    final manager = $$ObligationPaymentsTableTableManager(
      $_db,
      $_db.obligationPayments,
    ).filter((f) => f.paymentMethodId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _obligationPaymentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecurringEntriesTable, List<RecurringEntryRow>>
  _recurringEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recurringEntries,
    aliasName: 'payment_methods__id__recurring_entries__payment_method_id',
  );

  $$RecurringEntriesTableProcessedTableManager get recurringEntriesRefs {
    final manager = $$RecurringEntriesTableTableManager(
      $_db,
      $_db.recurringEntries,
    ).filter((f) => f.paymentMethodId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recurringEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PaymentMethodsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentMethodsTable> {
  $$PaymentMethodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalizedName => $composableBuilder(
    column: $table.normalizedName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorArgb => $composableBuilder(
    column: $table.colorArgb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.paymentMethodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> shoppingListsRefs(
    Expression<bool> Function($$ShoppingListsTableFilterComposer f) f,
  ) {
    final $$ShoppingListsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.paymentMethodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableFilterComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> shoppingPayablesRefs(
    Expression<bool> Function($$ShoppingPayablesTableFilterComposer f) f,
  ) {
    final $$ShoppingPayablesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingPayables,
      getReferencedColumn: (t) => t.paymentMethodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingPayablesTableFilterComposer(
            $db: $db,
            $table: $db.shoppingPayables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> obligationsRefs(
    Expression<bool> Function($$ObligationsTableFilterComposer f) f,
  ) {
    final $$ObligationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.obligations,
      getReferencedColumn: (t) => t.defaultPaymentMethodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObligationsTableFilterComposer(
            $db: $db,
            $table: $db.obligations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> obligationPaymentsRefs(
    Expression<bool> Function($$ObligationPaymentsTableFilterComposer f) f,
  ) {
    final $$ObligationPaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.obligationPayments,
      getReferencedColumn: (t) => t.paymentMethodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObligationPaymentsTableFilterComposer(
            $db: $db,
            $table: $db.obligationPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recurringEntriesRefs(
    Expression<bool> Function($$RecurringEntriesTableFilterComposer f) f,
  ) {
    final $$RecurringEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurringEntries,
      getReferencedColumn: (t) => t.paymentMethodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringEntriesTableFilterComposer(
            $db: $db,
            $table: $db.recurringEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PaymentMethodsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentMethodsTable> {
  $$PaymentMethodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalizedName => $composableBuilder(
    column: $table.normalizedName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorArgb => $composableBuilder(
    column: $table.colorArgb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaymentMethodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentMethodsTable> {
  $$PaymentMethodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get normalizedName => $composableBuilder(
    column: $table.normalizedName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get colorArgb =>
      $composableBuilder(column: $table.colorArgb, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.paymentMethodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> shoppingListsRefs<T extends Object>(
    Expression<T> Function($$ShoppingListsTableAnnotationComposer a) f,
  ) {
    final $$ShoppingListsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.paymentMethodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableAnnotationComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> shoppingPayablesRefs<T extends Object>(
    Expression<T> Function($$ShoppingPayablesTableAnnotationComposer a) f,
  ) {
    final $$ShoppingPayablesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingPayables,
      getReferencedColumn: (t) => t.paymentMethodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingPayablesTableAnnotationComposer(
            $db: $db,
            $table: $db.shoppingPayables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> obligationsRefs<T extends Object>(
    Expression<T> Function($$ObligationsTableAnnotationComposer a) f,
  ) {
    final $$ObligationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.obligations,
      getReferencedColumn: (t) => t.defaultPaymentMethodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObligationsTableAnnotationComposer(
            $db: $db,
            $table: $db.obligations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> obligationPaymentsRefs<T extends Object>(
    Expression<T> Function($$ObligationPaymentsTableAnnotationComposer a) f,
  ) {
    final $$ObligationPaymentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.obligationPayments,
          getReferencedColumn: (t) => t.paymentMethodId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ObligationPaymentsTableAnnotationComposer(
                $db: $db,
                $table: $db.obligationPayments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> recurringEntriesRefs<T extends Object>(
    Expression<T> Function($$RecurringEntriesTableAnnotationComposer a) f,
  ) {
    final $$RecurringEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurringEntries,
      getReferencedColumn: (t) => t.paymentMethodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.recurringEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PaymentMethodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentMethodsTable,
          PaymentMethodRow,
          $$PaymentMethodsTableFilterComposer,
          $$PaymentMethodsTableOrderingComposer,
          $$PaymentMethodsTableAnnotationComposer,
          $$PaymentMethodsTableCreateCompanionBuilder,
          $$PaymentMethodsTableUpdateCompanionBuilder,
          (PaymentMethodRow, $$PaymentMethodsTableReferences),
          PaymentMethodRow,
          PrefetchHooks Function({
            bool transactionsRefs,
            bool shoppingListsRefs,
            bool shoppingPayablesRefs,
            bool obligationsRefs,
            bool obligationPaymentsRefs,
            bool recurringEntriesRefs,
          })
        > {
  $$PaymentMethodsTableTableManager(
    _$AppDatabase db,
    $PaymentMethodsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentMethodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentMethodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentMethodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> normalizedName = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> colorArgb = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PaymentMethodsCompanion(
                id: id,
                name: name,
                normalizedName: normalizedName,
                icon: icon,
                colorArgb: colorArgb,
                isActive: isActive,
                isDefault: isDefault,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String normalizedName,
                required String icon,
                required int colorArgb,
                Value<bool> isActive = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PaymentMethodsCompanion.insert(
                id: id,
                name: name,
                normalizedName: normalizedName,
                icon: icon,
                colorArgb: colorArgb,
                isActive: isActive,
                isDefault: isDefault,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PaymentMethodsTable, PaymentMethodRow>(table),
                  $$PaymentMethodsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                transactionsRefs = false,
                shoppingListsRefs = false,
                shoppingPayablesRefs = false,
                obligationsRefs = false,
                obligationPaymentsRefs = false,
                recurringEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionsRefs) db.transactions,
                    if (shoppingListsRefs) db.shoppingLists,
                    if (shoppingPayablesRefs) db.shoppingPayables,
                    if (obligationsRefs) db.obligations,
                    if (obligationPaymentsRefs) db.obligationPayments,
                    if (recurringEntriesRefs) db.recurringEntries,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionsRefs)
                        await $_getPrefetchedDataByColumns<
                          PaymentMethodRow,
                          $PaymentMethodsTable,
                          FinanceTransactionRow,
                          $TransactionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$PaymentMethodsTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PaymentMethodsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'payment_method_id',
                          typedResults: items,
                        ),
                      if (shoppingListsRefs)
                        await $_getPrefetchedDataByColumns<
                          PaymentMethodRow,
                          $PaymentMethodsTable,
                          ShoppingListRow,
                          $ShoppingListsTable
                        >(
                          currentTable: table,
                          referencedTable: $$PaymentMethodsTableReferences
                              ._shoppingListsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PaymentMethodsTableReferences(
                                db,
                                table,
                                p0,
                              ).shoppingListsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'payment_method_id',
                          typedResults: items,
                        ),
                      if (shoppingPayablesRefs)
                        await $_getPrefetchedDataByColumns<
                          PaymentMethodRow,
                          $PaymentMethodsTable,
                          ShoppingPayableRow,
                          $ShoppingPayablesTable
                        >(
                          currentTable: table,
                          referencedTable: $$PaymentMethodsTableReferences
                              ._shoppingPayablesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PaymentMethodsTableReferences(
                                db,
                                table,
                                p0,
                              ).shoppingPayablesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'payment_method_id',
                          typedResults: items,
                        ),
                      if (obligationsRefs)
                        await $_getPrefetchedDataByColumns<
                          PaymentMethodRow,
                          $PaymentMethodsTable,
                          ObligationRow,
                          $ObligationsTable
                        >(
                          currentTable: table,
                          referencedTable: $$PaymentMethodsTableReferences
                              ._obligationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PaymentMethodsTableReferences(
                                db,
                                table,
                                p0,
                              ).obligationsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'default_payment_method_id',
                          typedResults: items,
                        ),
                      if (obligationPaymentsRefs)
                        await $_getPrefetchedDataByColumns<
                          PaymentMethodRow,
                          $PaymentMethodsTable,
                          ObligationPaymentRow,
                          $ObligationPaymentsTable
                        >(
                          currentTable: table,
                          referencedTable: $$PaymentMethodsTableReferences
                              ._obligationPaymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PaymentMethodsTableReferences(
                                db,
                                table,
                                p0,
                              ).obligationPaymentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'payment_method_id',
                          typedResults: items,
                        ),
                      if (recurringEntriesRefs)
                        await $_getPrefetchedDataByColumns<
                          PaymentMethodRow,
                          $PaymentMethodsTable,
                          RecurringEntryRow,
                          $RecurringEntriesTable
                        >(
                          currentTable: table,
                          referencedTable: $$PaymentMethodsTableReferences
                              ._recurringEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PaymentMethodsTableReferences(
                                db,
                                table,
                                p0,
                              ).recurringEntriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'payment_method_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PaymentMethodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentMethodsTable,
      PaymentMethodRow,
      $$PaymentMethodsTableFilterComposer,
      $$PaymentMethodsTableOrderingComposer,
      $$PaymentMethodsTableAnnotationComposer,
      $$PaymentMethodsTableCreateCompanionBuilder,
      $$PaymentMethodsTableUpdateCompanionBuilder,
      (PaymentMethodRow, $$PaymentMethodsTableReferences),
      PaymentMethodRow,
      PrefetchHooks Function({
        bool transactionsRefs,
        bool shoppingListsRefs,
        bool shoppingPayablesRefs,
        bool obligationsRefs,
        bool obligationPaymentsRefs,
        bool recurringEntriesRefs,
      })
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      required int amountInCents,
      required String type,
      required int categoryId,
      required int paymentMethodId,
      Value<String?> description,
      required int dateEpochDay,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int?> fixedEntryId,
      Value<int?> savingsGoalId,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      Value<int> amountInCents,
      Value<String> type,
      Value<int> categoryId,
      Value<int> paymentMethodId,
      Value<String?> description,
      Value<int> dateEpochDay,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int?> fixedEntryId,
      Value<int?> savingsGoalId,
    });

final class $$TransactionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TransactionsTable,
          FinanceTransactionRow
        > {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('transactions__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PaymentMethodsTable _paymentMethodIdTable(_$AppDatabase db) => db
      .paymentMethods
      .createAlias('transactions__payment_method_id__payment_methods__id');

  $$PaymentMethodsTableProcessedTableManager get paymentMethodId {
    final $_column = $_itemColumn<int>('payment_method_id')!;

    final manager = $$PaymentMethodsTableTableManager(
      $_db,
      $_db.paymentMethods,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_paymentMethodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ShoppingListsTable, List<ShoppingListRow>>
  _shoppingListsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.shoppingLists,
    aliasName: 'transactions__id__shopping_lists__expense_transaction_id',
  );

  $$ShoppingListsTableProcessedTableManager get shoppingListsRefs {
    final manager = $$ShoppingListsTableTableManager($_db, $_db.shoppingLists)
        .filter(
          (f) => f.expenseTransactionId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_shoppingListsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ShoppingPayablesTable, List<ShoppingPayableRow>>
  _shoppingPayablesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.shoppingPayables,
    aliasName: 'transactions__id__shopping_payables__transaction_id',
  );

  $$ShoppingPayablesTableProcessedTableManager get shoppingPayablesRefs {
    final manager = $$ShoppingPayablesTableTableManager(
      $_db,
      $_db.shoppingPayables,
    ).filter((f) => f.transactionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _shoppingPayablesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ObligationPaymentsTable,
    List<ObligationPaymentRow>
  >
  _obligationPaymentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.obligationPayments,
        aliasName: 'transactions__id__obligation_payments__transaction_id',
      );

  $$ObligationPaymentsTableProcessedTableManager get obligationPaymentsRefs {
    final manager = $$ObligationPaymentsTableTableManager(
      $_db,
      $_db.obligationPayments,
    ).filter((f) => f.transactionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _obligationPaymentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dateEpochDay => $composableBuilder(
    column: $table.dateEpochDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fixedEntryId => $composableBuilder(
    column: $table.fixedEntryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get savingsGoalId => $composableBuilder(
    column: $table.savingsGoalId,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaymentMethodsTableFilterComposer get paymentMethodId {
    final $$PaymentMethodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentMethodId,
      referencedTable: $db.paymentMethods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMethodsTableFilterComposer(
            $db: $db,
            $table: $db.paymentMethods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> shoppingListsRefs(
    Expression<bool> Function($$ShoppingListsTableFilterComposer f) f,
  ) {
    final $$ShoppingListsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.expenseTransactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableFilterComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> shoppingPayablesRefs(
    Expression<bool> Function($$ShoppingPayablesTableFilterComposer f) f,
  ) {
    final $$ShoppingPayablesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingPayables,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingPayablesTableFilterComposer(
            $db: $db,
            $table: $db.shoppingPayables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> obligationPaymentsRefs(
    Expression<bool> Function($$ObligationPaymentsTableFilterComposer f) f,
  ) {
    final $$ObligationPaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.obligationPayments,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObligationPaymentsTableFilterComposer(
            $db: $db,
            $table: $db.obligationPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dateEpochDay => $composableBuilder(
    column: $table.dateEpochDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fixedEntryId => $composableBuilder(
    column: $table.fixedEntryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get savingsGoalId => $composableBuilder(
    column: $table.savingsGoalId,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaymentMethodsTableOrderingComposer get paymentMethodId {
    final $$PaymentMethodsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentMethodId,
      referencedTable: $db.paymentMethods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMethodsTableOrderingComposer(
            $db: $db,
            $table: $db.paymentMethods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dateEpochDay => $composableBuilder(
    column: $table.dateEpochDay,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get fixedEntryId => $composableBuilder(
    column: $table.fixedEntryId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get savingsGoalId => $composableBuilder(
    column: $table.savingsGoalId,
    builder: (column) => column,
  );

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaymentMethodsTableAnnotationComposer get paymentMethodId {
    final $$PaymentMethodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentMethodId,
      referencedTable: $db.paymentMethods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMethodsTableAnnotationComposer(
            $db: $db,
            $table: $db.paymentMethods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> shoppingListsRefs<T extends Object>(
    Expression<T> Function($$ShoppingListsTableAnnotationComposer a) f,
  ) {
    final $$ShoppingListsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.expenseTransactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableAnnotationComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> shoppingPayablesRefs<T extends Object>(
    Expression<T> Function($$ShoppingPayablesTableAnnotationComposer a) f,
  ) {
    final $$ShoppingPayablesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingPayables,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingPayablesTableAnnotationComposer(
            $db: $db,
            $table: $db.shoppingPayables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> obligationPaymentsRefs<T extends Object>(
    Expression<T> Function($$ObligationPaymentsTableAnnotationComposer a) f,
  ) {
    final $$ObligationPaymentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.obligationPayments,
          getReferencedColumn: (t) => t.transactionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ObligationPaymentsTableAnnotationComposer(
                $db: $db,
                $table: $db.obligationPayments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          FinanceTransactionRow,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (FinanceTransactionRow, $$TransactionsTableReferences),
          FinanceTransactionRow,
          PrefetchHooks Function({
            bool categoryId,
            bool paymentMethodId,
            bool shoppingListsRefs,
            bool shoppingPayablesRefs,
            bool obligationPaymentsRefs,
          })
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> amountInCents = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int> paymentMethodId = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> dateEpochDay = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int?> fixedEntryId = const Value.absent(),
                Value<int?> savingsGoalId = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                amountInCents: amountInCents,
                type: type,
                categoryId: categoryId,
                paymentMethodId: paymentMethodId,
                description: description,
                dateEpochDay: dateEpochDay,
                createdAt: createdAt,
                updatedAt: updatedAt,
                fixedEntryId: fixedEntryId,
                savingsGoalId: savingsGoalId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int amountInCents,
                required String type,
                required int categoryId,
                required int paymentMethodId,
                Value<String?> description = const Value.absent(),
                required int dateEpochDay,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int?> fixedEntryId = const Value.absent(),
                Value<int?> savingsGoalId = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                amountInCents: amountInCents,
                type: type,
                categoryId: categoryId,
                paymentMethodId: paymentMethodId,
                description: description,
                dateEpochDay: dateEpochDay,
                createdAt: createdAt,
                updatedAt: updatedAt,
                fixedEntryId: fixedEntryId,
                savingsGoalId: savingsGoalId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransactionsTable, FinanceTransactionRow>(table),
                  $$TransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                paymentMethodId = false,
                shoppingListsRefs = false,
                shoppingPayablesRefs = false,
                obligationPaymentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (shoppingListsRefs) db.shoppingLists,
                    if (shoppingPayablesRefs) db.shoppingPayables,
                    if (obligationPaymentsRefs) db.obligationPayments,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable:
                                        $$TransactionsTableReferences
                                            ._categoryIdTable(db),
                                    referencedColumn:
                                        $$TransactionsTableReferences
                                            ._categoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (paymentMethodId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.paymentMethodId,
                                    referencedTable:
                                        $$TransactionsTableReferences
                                            ._paymentMethodIdTable(db),
                                    referencedColumn:
                                        $$TransactionsTableReferences
                                            ._paymentMethodIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (shoppingListsRefs)
                        await $_getPrefetchedDataByColumns<
                          FinanceTransactionRow,
                          $TransactionsTable,
                          ShoppingListRow,
                          $ShoppingListsTable
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableReferences
                              ._shoppingListsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).shoppingListsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'expense_transaction_id',
                          typedResults: items,
                        ),
                      if (shoppingPayablesRefs)
                        await $_getPrefetchedDataByColumns<
                          FinanceTransactionRow,
                          $TransactionsTable,
                          ShoppingPayableRow,
                          $ShoppingPayablesTable
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableReferences
                              ._shoppingPayablesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).shoppingPayablesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'transaction_id',
                          typedResults: items,
                        ),
                      if (obligationPaymentsRefs)
                        await $_getPrefetchedDataByColumns<
                          FinanceTransactionRow,
                          $TransactionsTable,
                          ObligationPaymentRow,
                          $ObligationPaymentsTable
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableReferences
                              ._obligationPaymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).obligationPaymentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'transaction_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      FinanceTransactionRow,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (FinanceTransactionRow, $$TransactionsTableReferences),
      FinanceTransactionRow,
      PrefetchHooks Function({
        bool categoryId,
        bool paymentMethodId,
        bool shoppingListsRefs,
        bool shoppingPayablesRefs,
        bool obligationPaymentsRefs,
      })
    >;
typedef $$SavingsGoalsTableCreateCompanionBuilder =
    SavingsGoalsCompanion Function({
      Value<int> id,
      required String name,
      required int targetAmountInCents,
      Value<DateTime> createdAt,
      Value<DateTime?> completedAt,
    });
typedef $$SavingsGoalsTableUpdateCompanionBuilder =
    SavingsGoalsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> targetAmountInCents,
      Value<DateTime> createdAt,
      Value<DateTime?> completedAt,
    });

class $$SavingsGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetAmountInCents => $composableBuilder(
    column: $table.targetAmountInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavingsGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetAmountInCents => $composableBuilder(
    column: $table.targetAmountInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavingsGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get targetAmountInCents => $composableBuilder(
    column: $table.targetAmountInCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$SavingsGoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavingsGoalsTable,
          SavingsGoalRow,
          $$SavingsGoalsTableFilterComposer,
          $$SavingsGoalsTableOrderingComposer,
          $$SavingsGoalsTableAnnotationComposer,
          $$SavingsGoalsTableCreateCompanionBuilder,
          $$SavingsGoalsTableUpdateCompanionBuilder,
          (
            SavingsGoalRow,
            BaseReferences<_$AppDatabase, $SavingsGoalsTable, SavingsGoalRow>,
          ),
          SavingsGoalRow,
          PrefetchHooks Function()
        > {
  $$SavingsGoalsTableTableManager(_$AppDatabase db, $SavingsGoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavingsGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> targetAmountInCents = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => SavingsGoalsCompanion(
                id: id,
                name: name,
                targetAmountInCents: targetAmountInCents,
                createdAt: createdAt,
                completedAt: completedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int targetAmountInCents,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => SavingsGoalsCompanion.insert(
                id: id,
                name: name,
                targetAmountInCents: targetAmountInCents,
                createdAt: createdAt,
                completedAt: completedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SavingsGoalsTable, SavingsGoalRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SavingsGoalsTable,
                    SavingsGoalRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavingsGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavingsGoalsTable,
      SavingsGoalRow,
      $$SavingsGoalsTableFilterComposer,
      $$SavingsGoalsTableOrderingComposer,
      $$SavingsGoalsTableAnnotationComposer,
      $$SavingsGoalsTableCreateCompanionBuilder,
      $$SavingsGoalsTableUpdateCompanionBuilder,
      (
        SavingsGoalRow,
        BaseReferences<_$AppDatabase, $SavingsGoalsTable, SavingsGoalRow>,
      ),
      SavingsGoalRow,
      PrefetchHooks Function()
    >;
typedef $$BudgetsTableCreateCompanionBuilder =
    BudgetsCompanion Function({
      Value<int> id,
      required int amountInCents,
      required String period,
      required int cycleStartEpochDay,
      required DateTime cycleStartedAt,
      Value<int?> incomeTransactionId,
      required String cycleSchedulesJson,
      Value<bool> autoCloseEnabled,
      Value<int> autoCloseMinuteOfDay,
    });
typedef $$BudgetsTableUpdateCompanionBuilder =
    BudgetsCompanion Function({
      Value<int> id,
      Value<int> amountInCents,
      Value<String> period,
      Value<int> cycleStartEpochDay,
      Value<DateTime> cycleStartedAt,
      Value<int?> incomeTransactionId,
      Value<String> cycleSchedulesJson,
      Value<bool> autoCloseEnabled,
      Value<int> autoCloseMinuteOfDay,
    });

class $$BudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cycleStartEpochDay => $composableBuilder(
    column: $table.cycleStartEpochDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cycleStartedAt => $composableBuilder(
    column: $table.cycleStartedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get incomeTransactionId => $composableBuilder(
    column: $table.incomeTransactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cycleSchedulesJson => $composableBuilder(
    column: $table.cycleSchedulesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoCloseEnabled => $composableBuilder(
    column: $table.autoCloseEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get autoCloseMinuteOfDay => $composableBuilder(
    column: $table.autoCloseMinuteOfDay,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cycleStartEpochDay => $composableBuilder(
    column: $table.cycleStartEpochDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cycleStartedAt => $composableBuilder(
    column: $table.cycleStartedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get incomeTransactionId => $composableBuilder(
    column: $table.incomeTransactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cycleSchedulesJson => $composableBuilder(
    column: $table.cycleSchedulesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoCloseEnabled => $composableBuilder(
    column: $table.autoCloseEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get autoCloseMinuteOfDay => $composableBuilder(
    column: $table.autoCloseMinuteOfDay,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<int> get cycleStartEpochDay => $composableBuilder(
    column: $table.cycleStartEpochDay,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cycleStartedAt => $composableBuilder(
    column: $table.cycleStartedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get incomeTransactionId => $composableBuilder(
    column: $table.incomeTransactionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cycleSchedulesJson => $composableBuilder(
    column: $table.cycleSchedulesJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoCloseEnabled => $composableBuilder(
    column: $table.autoCloseEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get autoCloseMinuteOfDay => $composableBuilder(
    column: $table.autoCloseMinuteOfDay,
    builder: (column) => column,
  );
}

class $$BudgetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetsTable,
          BudgetConfigRow,
          $$BudgetsTableFilterComposer,
          $$BudgetsTableOrderingComposer,
          $$BudgetsTableAnnotationComposer,
          $$BudgetsTableCreateCompanionBuilder,
          $$BudgetsTableUpdateCompanionBuilder,
          (
            BudgetConfigRow,
            BaseReferences<_$AppDatabase, $BudgetsTable, BudgetConfigRow>,
          ),
          BudgetConfigRow,
          PrefetchHooks Function()
        > {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> amountInCents = const Value.absent(),
                Value<String> period = const Value.absent(),
                Value<int> cycleStartEpochDay = const Value.absent(),
                Value<DateTime> cycleStartedAt = const Value.absent(),
                Value<int?> incomeTransactionId = const Value.absent(),
                Value<String> cycleSchedulesJson = const Value.absent(),
                Value<bool> autoCloseEnabled = const Value.absent(),
                Value<int> autoCloseMinuteOfDay = const Value.absent(),
              }) => BudgetsCompanion(
                id: id,
                amountInCents: amountInCents,
                period: period,
                cycleStartEpochDay: cycleStartEpochDay,
                cycleStartedAt: cycleStartedAt,
                incomeTransactionId: incomeTransactionId,
                cycleSchedulesJson: cycleSchedulesJson,
                autoCloseEnabled: autoCloseEnabled,
                autoCloseMinuteOfDay: autoCloseMinuteOfDay,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int amountInCents,
                required String period,
                required int cycleStartEpochDay,
                required DateTime cycleStartedAt,
                Value<int?> incomeTransactionId = const Value.absent(),
                required String cycleSchedulesJson,
                Value<bool> autoCloseEnabled = const Value.absent(),
                Value<int> autoCloseMinuteOfDay = const Value.absent(),
              }) => BudgetsCompanion.insert(
                id: id,
                amountInCents: amountInCents,
                period: period,
                cycleStartEpochDay: cycleStartEpochDay,
                cycleStartedAt: cycleStartedAt,
                incomeTransactionId: incomeTransactionId,
                cycleSchedulesJson: cycleSchedulesJson,
                autoCloseEnabled: autoCloseEnabled,
                autoCloseMinuteOfDay: autoCloseMinuteOfDay,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BudgetsTable, BudgetConfigRow>(table),
                  BaseReferences<_$AppDatabase, $BudgetsTable, BudgetConfigRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetsTable,
      BudgetConfigRow,
      $$BudgetsTableFilterComposer,
      $$BudgetsTableOrderingComposer,
      $$BudgetsTableAnnotationComposer,
      $$BudgetsTableCreateCompanionBuilder,
      $$BudgetsTableUpdateCompanionBuilder,
      (
        BudgetConfigRow,
        BaseReferences<_$AppDatabase, $BudgetsTable, BudgetConfigRow>,
      ),
      BudgetConfigRow,
      PrefetchHooks Function()
    >;
typedef $$BudgetCyclesTableCreateCompanionBuilder =
    BudgetCyclesCompanion Function({
      Value<int> id,
      required String period,
      required int budgetAmountInCents,
      required int incomeInCents,
      required int expenseInCents,
      required int startDateEpochDay,
      required int endDateEpochDay,
      required DateTime closedAt,
    });
typedef $$BudgetCyclesTableUpdateCompanionBuilder =
    BudgetCyclesCompanion Function({
      Value<int> id,
      Value<String> period,
      Value<int> budgetAmountInCents,
      Value<int> incomeInCents,
      Value<int> expenseInCents,
      Value<int> startDateEpochDay,
      Value<int> endDateEpochDay,
      Value<DateTime> closedAt,
    });

class $$BudgetCyclesTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetCyclesTable> {
  $$BudgetCyclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get budgetAmountInCents => $composableBuilder(
    column: $table.budgetAmountInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get incomeInCents => $composableBuilder(
    column: $table.incomeInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expenseInCents => $composableBuilder(
    column: $table.expenseInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startDateEpochDay => $composableBuilder(
    column: $table.startDateEpochDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endDateEpochDay => $composableBuilder(
    column: $table.endDateEpochDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BudgetCyclesTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetCyclesTable> {
  $$BudgetCyclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get budgetAmountInCents => $composableBuilder(
    column: $table.budgetAmountInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get incomeInCents => $composableBuilder(
    column: $table.incomeInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expenseInCents => $composableBuilder(
    column: $table.expenseInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startDateEpochDay => $composableBuilder(
    column: $table.startDateEpochDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endDateEpochDay => $composableBuilder(
    column: $table.endDateEpochDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetCyclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetCyclesTable> {
  $$BudgetCyclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<int> get budgetAmountInCents => $composableBuilder(
    column: $table.budgetAmountInCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get incomeInCents => $composableBuilder(
    column: $table.incomeInCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get expenseInCents => $composableBuilder(
    column: $table.expenseInCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startDateEpochDay => $composableBuilder(
    column: $table.startDateEpochDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endDateEpochDay => $composableBuilder(
    column: $table.endDateEpochDay,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);
}

class $$BudgetCyclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetCyclesTable,
          BudgetCycleRow,
          $$BudgetCyclesTableFilterComposer,
          $$BudgetCyclesTableOrderingComposer,
          $$BudgetCyclesTableAnnotationComposer,
          $$BudgetCyclesTableCreateCompanionBuilder,
          $$BudgetCyclesTableUpdateCompanionBuilder,
          (
            BudgetCycleRow,
            BaseReferences<_$AppDatabase, $BudgetCyclesTable, BudgetCycleRow>,
          ),
          BudgetCycleRow,
          PrefetchHooks Function()
        > {
  $$BudgetCyclesTableTableManager(_$AppDatabase db, $BudgetCyclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetCyclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetCyclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetCyclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> period = const Value.absent(),
                Value<int> budgetAmountInCents = const Value.absent(),
                Value<int> incomeInCents = const Value.absent(),
                Value<int> expenseInCents = const Value.absent(),
                Value<int> startDateEpochDay = const Value.absent(),
                Value<int> endDateEpochDay = const Value.absent(),
                Value<DateTime> closedAt = const Value.absent(),
              }) => BudgetCyclesCompanion(
                id: id,
                period: period,
                budgetAmountInCents: budgetAmountInCents,
                incomeInCents: incomeInCents,
                expenseInCents: expenseInCents,
                startDateEpochDay: startDateEpochDay,
                endDateEpochDay: endDateEpochDay,
                closedAt: closedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String period,
                required int budgetAmountInCents,
                required int incomeInCents,
                required int expenseInCents,
                required int startDateEpochDay,
                required int endDateEpochDay,
                required DateTime closedAt,
              }) => BudgetCyclesCompanion.insert(
                id: id,
                period: period,
                budgetAmountInCents: budgetAmountInCents,
                incomeInCents: incomeInCents,
                expenseInCents: expenseInCents,
                startDateEpochDay: startDateEpochDay,
                endDateEpochDay: endDateEpochDay,
                closedAt: closedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BudgetCyclesTable, BudgetCycleRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $BudgetCyclesTable,
                    BudgetCycleRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetCyclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetCyclesTable,
      BudgetCycleRow,
      $$BudgetCyclesTableFilterComposer,
      $$BudgetCyclesTableOrderingComposer,
      $$BudgetCyclesTableAnnotationComposer,
      $$BudgetCyclesTableCreateCompanionBuilder,
      $$BudgetCyclesTableUpdateCompanionBuilder,
      (
        BudgetCycleRow,
        BaseReferences<_$AppDatabase, $BudgetCyclesTable, BudgetCycleRow>,
      ),
      BudgetCycleRow,
      PrefetchHooks Function()
    >;
typedef $$ShoppingListsTableCreateCompanionBuilder =
    ShoppingListsCompanion Function({
      Value<int> id,
      required String name,
      required String status,
      Value<int?> budgetInCents,
      Value<int?> expenseTransactionId,
      Value<int?> payableId,
      Value<int?> purchaseDateEpochDay,
      Value<int?> paymentMethodId,
      Value<int?> expenseCategoryId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> completedAt,
    });
typedef $$ShoppingListsTableUpdateCompanionBuilder =
    ShoppingListsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> status,
      Value<int?> budgetInCents,
      Value<int?> expenseTransactionId,
      Value<int?> payableId,
      Value<int?> purchaseDateEpochDay,
      Value<int?> paymentMethodId,
      Value<int?> expenseCategoryId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> completedAt,
    });

final class $$ShoppingListsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ShoppingListsTable, ShoppingListRow> {
  $$ShoppingListsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TransactionsTable _expenseTransactionIdTable(_$AppDatabase db) => db
      .transactions
      .createAlias('shopping_lists__expense_transaction_id__transactions__id');

  $$TransactionsTableProcessedTableManager? get expenseTransactionId {
    final $_column = $_itemColumn<int>('expense_transaction_id');
    if ($_column == null) return null;
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _expenseTransactionIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PaymentMethodsTable _paymentMethodIdTable(_$AppDatabase db) => db
      .paymentMethods
      .createAlias('shopping_lists__payment_method_id__payment_methods__id');

  $$PaymentMethodsTableProcessedTableManager? get paymentMethodId {
    final $_column = $_itemColumn<int>('payment_method_id');
    if ($_column == null) return null;
    final manager = $$PaymentMethodsTableTableManager(
      $_db,
      $_db.paymentMethods,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_paymentMethodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _expenseCategoryIdTable(_$AppDatabase db) => db
      .categories
      .createAlias('shopping_lists__expense_category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get expenseCategoryId {
    final $_column = $_itemColumn<int>('expense_category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_expenseCategoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ShoppingListItemsTable, List<ShoppingListItemRow>>
  _shoppingListItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.shoppingListItems,
        aliasName: 'shopping_lists__id__shopping_list_items__shopping_list_id',
      );

  $$ShoppingListItemsTableProcessedTableManager get shoppingListItemsRefs {
    final manager = $$ShoppingListItemsTableTableManager(
      $_db,
      $_db.shoppingListItems,
    ).filter((f) => f.shoppingListId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _shoppingListItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ShoppingAdjustmentsTable,
    List<ShoppingAdjustmentRow>
  >
  _shoppingAdjustmentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.shoppingAdjustments,
        aliasName: 'shopping_lists__id__shopping_adjustments__shopping_list_id',
      );

  $$ShoppingAdjustmentsTableProcessedTableManager get shoppingAdjustmentsRefs {
    final manager = $$ShoppingAdjustmentsTableTableManager(
      $_db,
      $_db.shoppingAdjustments,
    ).filter((f) => f.shoppingListId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _shoppingAdjustmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ShoppingPayablesTable, List<ShoppingPayableRow>>
  _shoppingPayablesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.shoppingPayables,
    aliasName: 'shopping_lists__id__shopping_payables__shopping_list_id',
  );

  $$ShoppingPayablesTableProcessedTableManager get shoppingPayablesRefs {
    final manager = $$ShoppingPayablesTableTableManager(
      $_db,
      $_db.shoppingPayables,
    ).filter((f) => f.shoppingListId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _shoppingPayablesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ObligationsTable, List<ObligationRow>>
  _obligationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.obligations,
    aliasName: 'shopping_lists__id__obligations__source_shopping_list_id',
  );

  $$ObligationsTableProcessedTableManager get obligationsRefs {
    final manager = $$ObligationsTableTableManager($_db, $_db.obligations)
        .filter(
          (f) => f.sourceShoppingListId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_obligationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ShoppingListsTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingListsTable> {
  $$ShoppingListsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get budgetInCents => $composableBuilder(
    column: $table.budgetInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get payableId => $composableBuilder(
    column: $table.payableId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get purchaseDateEpochDay => $composableBuilder(
    column: $table.purchaseDateEpochDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TransactionsTableFilterComposer get expenseTransactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseTransactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaymentMethodsTableFilterComposer get paymentMethodId {
    final $$PaymentMethodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentMethodId,
      referencedTable: $db.paymentMethods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMethodsTableFilterComposer(
            $db: $db,
            $table: $db.paymentMethods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get expenseCategoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseCategoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> shoppingListItemsRefs(
    Expression<bool> Function($$ShoppingListItemsTableFilterComposer f) f,
  ) {
    final $$ShoppingListItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingListItems,
      getReferencedColumn: (t) => t.shoppingListId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListItemsTableFilterComposer(
            $db: $db,
            $table: $db.shoppingListItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> shoppingAdjustmentsRefs(
    Expression<bool> Function($$ShoppingAdjustmentsTableFilterComposer f) f,
  ) {
    final $$ShoppingAdjustmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingAdjustments,
      getReferencedColumn: (t) => t.shoppingListId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingAdjustmentsTableFilterComposer(
            $db: $db,
            $table: $db.shoppingAdjustments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> shoppingPayablesRefs(
    Expression<bool> Function($$ShoppingPayablesTableFilterComposer f) f,
  ) {
    final $$ShoppingPayablesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingPayables,
      getReferencedColumn: (t) => t.shoppingListId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingPayablesTableFilterComposer(
            $db: $db,
            $table: $db.shoppingPayables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> obligationsRefs(
    Expression<bool> Function($$ObligationsTableFilterComposer f) f,
  ) {
    final $$ObligationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.obligations,
      getReferencedColumn: (t) => t.sourceShoppingListId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObligationsTableFilterComposer(
            $db: $db,
            $table: $db.obligations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShoppingListsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingListsTable> {
  $$ShoppingListsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get budgetInCents => $composableBuilder(
    column: $table.budgetInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get payableId => $composableBuilder(
    column: $table.payableId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get purchaseDateEpochDay => $composableBuilder(
    column: $table.purchaseDateEpochDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TransactionsTableOrderingComposer get expenseTransactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseTransactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaymentMethodsTableOrderingComposer get paymentMethodId {
    final $$PaymentMethodsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentMethodId,
      referencedTable: $db.paymentMethods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMethodsTableOrderingComposer(
            $db: $db,
            $table: $db.paymentMethods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get expenseCategoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseCategoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShoppingListsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingListsTable> {
  $$ShoppingListsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get budgetInCents => $composableBuilder(
    column: $table.budgetInCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get payableId =>
      $composableBuilder(column: $table.payableId, builder: (column) => column);

  GeneratedColumn<int> get purchaseDateEpochDay => $composableBuilder(
    column: $table.purchaseDateEpochDay,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  $$TransactionsTableAnnotationComposer get expenseTransactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseTransactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaymentMethodsTableAnnotationComposer get paymentMethodId {
    final $$PaymentMethodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentMethodId,
      referencedTable: $db.paymentMethods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMethodsTableAnnotationComposer(
            $db: $db,
            $table: $db.paymentMethods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get expenseCategoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseCategoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> shoppingListItemsRefs<T extends Object>(
    Expression<T> Function($$ShoppingListItemsTableAnnotationComposer a) f,
  ) {
    final $$ShoppingListItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shoppingListItems,
          getReferencedColumn: (t) => t.shoppingListId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShoppingListItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.shoppingListItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> shoppingAdjustmentsRefs<T extends Object>(
    Expression<T> Function($$ShoppingAdjustmentsTableAnnotationComposer a) f,
  ) {
    final $$ShoppingAdjustmentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shoppingAdjustments,
          getReferencedColumn: (t) => t.shoppingListId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShoppingAdjustmentsTableAnnotationComposer(
                $db: $db,
                $table: $db.shoppingAdjustments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> shoppingPayablesRefs<T extends Object>(
    Expression<T> Function($$ShoppingPayablesTableAnnotationComposer a) f,
  ) {
    final $$ShoppingPayablesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingPayables,
      getReferencedColumn: (t) => t.shoppingListId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingPayablesTableAnnotationComposer(
            $db: $db,
            $table: $db.shoppingPayables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> obligationsRefs<T extends Object>(
    Expression<T> Function($$ObligationsTableAnnotationComposer a) f,
  ) {
    final $$ObligationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.obligations,
      getReferencedColumn: (t) => t.sourceShoppingListId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObligationsTableAnnotationComposer(
            $db: $db,
            $table: $db.obligations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShoppingListsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShoppingListsTable,
          ShoppingListRow,
          $$ShoppingListsTableFilterComposer,
          $$ShoppingListsTableOrderingComposer,
          $$ShoppingListsTableAnnotationComposer,
          $$ShoppingListsTableCreateCompanionBuilder,
          $$ShoppingListsTableUpdateCompanionBuilder,
          (ShoppingListRow, $$ShoppingListsTableReferences),
          ShoppingListRow,
          PrefetchHooks Function({
            bool expenseTransactionId,
            bool paymentMethodId,
            bool expenseCategoryId,
            bool shoppingListItemsRefs,
            bool shoppingAdjustmentsRefs,
            bool shoppingPayablesRefs,
            bool obligationsRefs,
          })
        > {
  $$ShoppingListsTableTableManager(_$AppDatabase db, $ShoppingListsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingListsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingListsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingListsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> budgetInCents = const Value.absent(),
                Value<int?> expenseTransactionId = const Value.absent(),
                Value<int?> payableId = const Value.absent(),
                Value<int?> purchaseDateEpochDay = const Value.absent(),
                Value<int?> paymentMethodId = const Value.absent(),
                Value<int?> expenseCategoryId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => ShoppingListsCompanion(
                id: id,
                name: name,
                status: status,
                budgetInCents: budgetInCents,
                expenseTransactionId: expenseTransactionId,
                payableId: payableId,
                purchaseDateEpochDay: purchaseDateEpochDay,
                paymentMethodId: paymentMethodId,
                expenseCategoryId: expenseCategoryId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                completedAt: completedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String status,
                Value<int?> budgetInCents = const Value.absent(),
                Value<int?> expenseTransactionId = const Value.absent(),
                Value<int?> payableId = const Value.absent(),
                Value<int?> purchaseDateEpochDay = const Value.absent(),
                Value<int?> paymentMethodId = const Value.absent(),
                Value<int?> expenseCategoryId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => ShoppingListsCompanion.insert(
                id: id,
                name: name,
                status: status,
                budgetInCents: budgetInCents,
                expenseTransactionId: expenseTransactionId,
                payableId: payableId,
                purchaseDateEpochDay: purchaseDateEpochDay,
                paymentMethodId: paymentMethodId,
                expenseCategoryId: expenseCategoryId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                completedAt: completedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ShoppingListsTable, ShoppingListRow>(table),
                  $$ShoppingListsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                expenseTransactionId = false,
                paymentMethodId = false,
                expenseCategoryId = false,
                shoppingListItemsRefs = false,
                shoppingAdjustmentsRefs = false,
                shoppingPayablesRefs = false,
                obligationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (shoppingListItemsRefs) db.shoppingListItems,
                    if (shoppingAdjustmentsRefs) db.shoppingAdjustments,
                    if (shoppingPayablesRefs) db.shoppingPayables,
                    if (obligationsRefs) db.obligations,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (expenseTransactionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.expenseTransactionId,
                                    referencedTable:
                                        $$ShoppingListsTableReferences
                                            ._expenseTransactionIdTable(db),
                                    referencedColumn:
                                        $$ShoppingListsTableReferences
                                            ._expenseTransactionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (paymentMethodId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.paymentMethodId,
                                    referencedTable:
                                        $$ShoppingListsTableReferences
                                            ._paymentMethodIdTable(db),
                                    referencedColumn:
                                        $$ShoppingListsTableReferences
                                            ._paymentMethodIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (expenseCategoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.expenseCategoryId,
                                    referencedTable:
                                        $$ShoppingListsTableReferences
                                            ._expenseCategoryIdTable(db),
                                    referencedColumn:
                                        $$ShoppingListsTableReferences
                                            ._expenseCategoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (shoppingListItemsRefs)
                        await $_getPrefetchedDataByColumns<
                          ShoppingListRow,
                          $ShoppingListsTable,
                          ShoppingListItemRow,
                          $ShoppingListItemsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ShoppingListsTableReferences
                              ._shoppingListItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShoppingListsTableReferences(
                                db,
                                table,
                                p0,
                              ).shoppingListItemsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'shopping_list_id',
                          typedResults: items,
                        ),
                      if (shoppingAdjustmentsRefs)
                        await $_getPrefetchedDataByColumns<
                          ShoppingListRow,
                          $ShoppingListsTable,
                          ShoppingAdjustmentRow,
                          $ShoppingAdjustmentsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ShoppingListsTableReferences
                              ._shoppingAdjustmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShoppingListsTableReferences(
                                db,
                                table,
                                p0,
                              ).shoppingAdjustmentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'shopping_list_id',
                          typedResults: items,
                        ),
                      if (shoppingPayablesRefs)
                        await $_getPrefetchedDataByColumns<
                          ShoppingListRow,
                          $ShoppingListsTable,
                          ShoppingPayableRow,
                          $ShoppingPayablesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ShoppingListsTableReferences
                              ._shoppingPayablesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShoppingListsTableReferences(
                                db,
                                table,
                                p0,
                              ).shoppingPayablesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'shopping_list_id',
                          typedResults: items,
                        ),
                      if (obligationsRefs)
                        await $_getPrefetchedDataByColumns<
                          ShoppingListRow,
                          $ShoppingListsTable,
                          ObligationRow,
                          $ObligationsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ShoppingListsTableReferences
                              ._obligationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShoppingListsTableReferences(
                                db,
                                table,
                                p0,
                              ).obligationsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'source_shopping_list_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ShoppingListsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShoppingListsTable,
      ShoppingListRow,
      $$ShoppingListsTableFilterComposer,
      $$ShoppingListsTableOrderingComposer,
      $$ShoppingListsTableAnnotationComposer,
      $$ShoppingListsTableCreateCompanionBuilder,
      $$ShoppingListsTableUpdateCompanionBuilder,
      (ShoppingListRow, $$ShoppingListsTableReferences),
      ShoppingListRow,
      PrefetchHooks Function({
        bool expenseTransactionId,
        bool paymentMethodId,
        bool expenseCategoryId,
        bool shoppingListItemsRefs,
        bool shoppingAdjustmentsRefs,
        bool shoppingPayablesRefs,
        bool obligationsRefs,
      })
    >;
typedef $$ShoppingListItemsTableCreateCompanionBuilder =
    ShoppingListItemsCompanion Function({
      Value<int> id,
      required int shoppingListId,
      required String name,
      required int quantity,
      Value<int?> estimatedUnitPriceInCents,
      Value<int?> actualUnitPriceInCents,
      Value<bool> isPurchased,
      Value<String?> notes,
      Value<String?> barcode,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$ShoppingListItemsTableUpdateCompanionBuilder =
    ShoppingListItemsCompanion Function({
      Value<int> id,
      Value<int> shoppingListId,
      Value<String> name,
      Value<int> quantity,
      Value<int?> estimatedUnitPriceInCents,
      Value<int?> actualUnitPriceInCents,
      Value<bool> isPurchased,
      Value<String?> notes,
      Value<String?> barcode,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$ShoppingListItemsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ShoppingListItemsTable,
          ShoppingListItemRow
        > {
  $$ShoppingListItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ShoppingListsTable _shoppingListIdTable(_$AppDatabase db) => db
      .shoppingLists
      .createAlias('shopping_list_items__shopping_list_id__shopping_lists__id');

  $$ShoppingListsTableProcessedTableManager get shoppingListId {
    final $_column = $_itemColumn<int>('shopping_list_id')!;

    final manager = $$ShoppingListsTableTableManager(
      $_db,
      $_db.shoppingLists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shoppingListIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ShoppingListItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingListItemsTable> {
  $$ShoppingListItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedUnitPriceInCents => $composableBuilder(
    column: $table.estimatedUnitPriceInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualUnitPriceInCents => $composableBuilder(
    column: $table.actualUnitPriceInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPurchased => $composableBuilder(
    column: $table.isPurchased,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ShoppingListsTableFilterComposer get shoppingListId {
    final $$ShoppingListsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shoppingListId,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableFilterComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShoppingListItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingListItemsTable> {
  $$ShoppingListItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedUnitPriceInCents => $composableBuilder(
    column: $table.estimatedUnitPriceInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualUnitPriceInCents => $composableBuilder(
    column: $table.actualUnitPriceInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPurchased => $composableBuilder(
    column: $table.isPurchased,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShoppingListsTableOrderingComposer get shoppingListId {
    final $$ShoppingListsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shoppingListId,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableOrderingComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShoppingListItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingListItemsTable> {
  $$ShoppingListItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get estimatedUnitPriceInCents => $composableBuilder(
    column: $table.estimatedUnitPriceInCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get actualUnitPriceInCents => $composableBuilder(
    column: $table.actualUnitPriceInCents,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPurchased => $composableBuilder(
    column: $table.isPurchased,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ShoppingListsTableAnnotationComposer get shoppingListId {
    final $$ShoppingListsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shoppingListId,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableAnnotationComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShoppingListItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShoppingListItemsTable,
          ShoppingListItemRow,
          $$ShoppingListItemsTableFilterComposer,
          $$ShoppingListItemsTableOrderingComposer,
          $$ShoppingListItemsTableAnnotationComposer,
          $$ShoppingListItemsTableCreateCompanionBuilder,
          $$ShoppingListItemsTableUpdateCompanionBuilder,
          (ShoppingListItemRow, $$ShoppingListItemsTableReferences),
          ShoppingListItemRow,
          PrefetchHooks Function({bool shoppingListId})
        > {
  $$ShoppingListItemsTableTableManager(
    _$AppDatabase db,
    $ShoppingListItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingListItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingListItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingListItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> shoppingListId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int?> estimatedUnitPriceInCents = const Value.absent(),
                Value<int?> actualUnitPriceInCents = const Value.absent(),
                Value<bool> isPurchased = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ShoppingListItemsCompanion(
                id: id,
                shoppingListId: shoppingListId,
                name: name,
                quantity: quantity,
                estimatedUnitPriceInCents: estimatedUnitPriceInCents,
                actualUnitPriceInCents: actualUnitPriceInCents,
                isPurchased: isPurchased,
                notes: notes,
                barcode: barcode,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int shoppingListId,
                required String name,
                required int quantity,
                Value<int?> estimatedUnitPriceInCents = const Value.absent(),
                Value<int?> actualUnitPriceInCents = const Value.absent(),
                Value<bool> isPurchased = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ShoppingListItemsCompanion.insert(
                id: id,
                shoppingListId: shoppingListId,
                name: name,
                quantity: quantity,
                estimatedUnitPriceInCents: estimatedUnitPriceInCents,
                actualUnitPriceInCents: actualUnitPriceInCents,
                isPurchased: isPurchased,
                notes: notes,
                barcode: barcode,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ShoppingListItemsTable, ShoppingListItemRow>(
                    table,
                  ),
                  $$ShoppingListItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({shoppingListId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (shoppingListId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.shoppingListId,
                                referencedTable:
                                    $$ShoppingListItemsTableReferences
                                        ._shoppingListIdTable(db),
                                referencedColumn:
                                    $$ShoppingListItemsTableReferences
                                        ._shoppingListIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ShoppingListItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShoppingListItemsTable,
      ShoppingListItemRow,
      $$ShoppingListItemsTableFilterComposer,
      $$ShoppingListItemsTableOrderingComposer,
      $$ShoppingListItemsTableAnnotationComposer,
      $$ShoppingListItemsTableCreateCompanionBuilder,
      $$ShoppingListItemsTableUpdateCompanionBuilder,
      (ShoppingListItemRow, $$ShoppingListItemsTableReferences),
      ShoppingListItemRow,
      PrefetchHooks Function({bool shoppingListId})
    >;
typedef $$ShoppingAdjustmentsTableCreateCompanionBuilder =
    ShoppingAdjustmentsCompanion Function({
      Value<int> id,
      required int shoppingListId,
      required String name,
      required bool isPositive,
      required int amountInCents,
      Value<DateTime> createdAt,
    });
typedef $$ShoppingAdjustmentsTableUpdateCompanionBuilder =
    ShoppingAdjustmentsCompanion Function({
      Value<int> id,
      Value<int> shoppingListId,
      Value<String> name,
      Value<bool> isPositive,
      Value<int> amountInCents,
      Value<DateTime> createdAt,
    });

final class $$ShoppingAdjustmentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ShoppingAdjustmentsTable,
          ShoppingAdjustmentRow
        > {
  $$ShoppingAdjustmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ShoppingListsTable _shoppingListIdTable(_$AppDatabase db) =>
      db.shoppingLists.createAlias(
        'shopping_adjustments__shopping_list_id__shopping_lists__id',
      );

  $$ShoppingListsTableProcessedTableManager get shoppingListId {
    final $_column = $_itemColumn<int>('shopping_list_id')!;

    final manager = $$ShoppingListsTableTableManager(
      $_db,
      $_db.shoppingLists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shoppingListIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ShoppingAdjustmentsTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingAdjustmentsTable> {
  $$ShoppingAdjustmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPositive => $composableBuilder(
    column: $table.isPositive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ShoppingListsTableFilterComposer get shoppingListId {
    final $$ShoppingListsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shoppingListId,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableFilterComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShoppingAdjustmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingAdjustmentsTable> {
  $$ShoppingAdjustmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPositive => $composableBuilder(
    column: $table.isPositive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShoppingListsTableOrderingComposer get shoppingListId {
    final $$ShoppingListsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shoppingListId,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableOrderingComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShoppingAdjustmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingAdjustmentsTable> {
  $$ShoppingAdjustmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isPositive => $composableBuilder(
    column: $table.isPositive,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ShoppingListsTableAnnotationComposer get shoppingListId {
    final $$ShoppingListsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shoppingListId,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableAnnotationComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShoppingAdjustmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShoppingAdjustmentsTable,
          ShoppingAdjustmentRow,
          $$ShoppingAdjustmentsTableFilterComposer,
          $$ShoppingAdjustmentsTableOrderingComposer,
          $$ShoppingAdjustmentsTableAnnotationComposer,
          $$ShoppingAdjustmentsTableCreateCompanionBuilder,
          $$ShoppingAdjustmentsTableUpdateCompanionBuilder,
          (ShoppingAdjustmentRow, $$ShoppingAdjustmentsTableReferences),
          ShoppingAdjustmentRow,
          PrefetchHooks Function({bool shoppingListId})
        > {
  $$ShoppingAdjustmentsTableTableManager(
    _$AppDatabase db,
    $ShoppingAdjustmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingAdjustmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingAdjustmentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ShoppingAdjustmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> shoppingListId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isPositive = const Value.absent(),
                Value<int> amountInCents = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ShoppingAdjustmentsCompanion(
                id: id,
                shoppingListId: shoppingListId,
                name: name,
                isPositive: isPositive,
                amountInCents: amountInCents,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int shoppingListId,
                required String name,
                required bool isPositive,
                required int amountInCents,
                Value<DateTime> createdAt = const Value.absent(),
              }) => ShoppingAdjustmentsCompanion.insert(
                id: id,
                shoppingListId: shoppingListId,
                name: name,
                isPositive: isPositive,
                amountInCents: amountInCents,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ShoppingAdjustmentsTable, ShoppingAdjustmentRow>(
                    table,
                  ),
                  $$ShoppingAdjustmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({shoppingListId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (shoppingListId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.shoppingListId,
                                referencedTable:
                                    $$ShoppingAdjustmentsTableReferences
                                        ._shoppingListIdTable(db),
                                referencedColumn:
                                    $$ShoppingAdjustmentsTableReferences
                                        ._shoppingListIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ShoppingAdjustmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShoppingAdjustmentsTable,
      ShoppingAdjustmentRow,
      $$ShoppingAdjustmentsTableFilterComposer,
      $$ShoppingAdjustmentsTableOrderingComposer,
      $$ShoppingAdjustmentsTableAnnotationComposer,
      $$ShoppingAdjustmentsTableCreateCompanionBuilder,
      $$ShoppingAdjustmentsTableUpdateCompanionBuilder,
      (ShoppingAdjustmentRow, $$ShoppingAdjustmentsTableReferences),
      ShoppingAdjustmentRow,
      PrefetchHooks Function({bool shoppingListId})
    >;
typedef $$ShoppingPayablesTableCreateCompanionBuilder =
    ShoppingPayablesCompanion Function({
      Value<int> id,
      required int shoppingListId,
      required int amountInCents,
      required int categoryId,
      required int paymentMethodId,
      required int dateEpochDay,
      required String description,
      Value<bool> isSettled,
      Value<int?> transactionId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$ShoppingPayablesTableUpdateCompanionBuilder =
    ShoppingPayablesCompanion Function({
      Value<int> id,
      Value<int> shoppingListId,
      Value<int> amountInCents,
      Value<int> categoryId,
      Value<int> paymentMethodId,
      Value<int> dateEpochDay,
      Value<String> description,
      Value<bool> isSettled,
      Value<int?> transactionId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$ShoppingPayablesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ShoppingPayablesTable,
          ShoppingPayableRow
        > {
  $$ShoppingPayablesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ShoppingListsTable _shoppingListIdTable(_$AppDatabase db) => db
      .shoppingLists
      .createAlias('shopping_payables__shopping_list_id__shopping_lists__id');

  $$ShoppingListsTableProcessedTableManager get shoppingListId {
    final $_column = $_itemColumn<int>('shopping_list_id')!;

    final manager = $$ShoppingListsTableTableManager(
      $_db,
      $_db.shoppingLists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shoppingListIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) => db.categories
      .createAlias('shopping_payables__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PaymentMethodsTable _paymentMethodIdTable(_$AppDatabase db) => db
      .paymentMethods
      .createAlias('shopping_payables__payment_method_id__payment_methods__id');

  $$PaymentMethodsTableProcessedTableManager get paymentMethodId {
    final $_column = $_itemColumn<int>('payment_method_id')!;

    final manager = $$PaymentMethodsTableTableManager(
      $_db,
      $_db.paymentMethods,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_paymentMethodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TransactionsTable _transactionIdTable(_$AppDatabase db) => db
      .transactions
      .createAlias('shopping_payables__transaction_id__transactions__id');

  $$TransactionsTableProcessedTableManager? get transactionId {
    final $_column = $_itemColumn<int>('transaction_id');
    if ($_column == null) return null;
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ShoppingPayablesTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingPayablesTable> {
  $$ShoppingPayablesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dateEpochDay => $composableBuilder(
    column: $table.dateEpochDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSettled => $composableBuilder(
    column: $table.isSettled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ShoppingListsTableFilterComposer get shoppingListId {
    final $$ShoppingListsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shoppingListId,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableFilterComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaymentMethodsTableFilterComposer get paymentMethodId {
    final $$PaymentMethodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentMethodId,
      referencedTable: $db.paymentMethods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMethodsTableFilterComposer(
            $db: $db,
            $table: $db.paymentMethods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShoppingPayablesTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingPayablesTable> {
  $$ShoppingPayablesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dateEpochDay => $composableBuilder(
    column: $table.dateEpochDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSettled => $composableBuilder(
    column: $table.isSettled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShoppingListsTableOrderingComposer get shoppingListId {
    final $$ShoppingListsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shoppingListId,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableOrderingComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaymentMethodsTableOrderingComposer get paymentMethodId {
    final $$PaymentMethodsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentMethodId,
      referencedTable: $db.paymentMethods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMethodsTableOrderingComposer(
            $db: $db,
            $table: $db.paymentMethods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShoppingPayablesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingPayablesTable> {
  $$ShoppingPayablesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dateEpochDay => $composableBuilder(
    column: $table.dateEpochDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSettled =>
      $composableBuilder(column: $table.isSettled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ShoppingListsTableAnnotationComposer get shoppingListId {
    final $$ShoppingListsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shoppingListId,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableAnnotationComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaymentMethodsTableAnnotationComposer get paymentMethodId {
    final $$PaymentMethodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentMethodId,
      referencedTable: $db.paymentMethods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMethodsTableAnnotationComposer(
            $db: $db,
            $table: $db.paymentMethods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShoppingPayablesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShoppingPayablesTable,
          ShoppingPayableRow,
          $$ShoppingPayablesTableFilterComposer,
          $$ShoppingPayablesTableOrderingComposer,
          $$ShoppingPayablesTableAnnotationComposer,
          $$ShoppingPayablesTableCreateCompanionBuilder,
          $$ShoppingPayablesTableUpdateCompanionBuilder,
          (ShoppingPayableRow, $$ShoppingPayablesTableReferences),
          ShoppingPayableRow,
          PrefetchHooks Function({
            bool shoppingListId,
            bool categoryId,
            bool paymentMethodId,
            bool transactionId,
          })
        > {
  $$ShoppingPayablesTableTableManager(
    _$AppDatabase db,
    $ShoppingPayablesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingPayablesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingPayablesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingPayablesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> shoppingListId = const Value.absent(),
                Value<int> amountInCents = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int> paymentMethodId = const Value.absent(),
                Value<int> dateEpochDay = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<bool> isSettled = const Value.absent(),
                Value<int?> transactionId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ShoppingPayablesCompanion(
                id: id,
                shoppingListId: shoppingListId,
                amountInCents: amountInCents,
                categoryId: categoryId,
                paymentMethodId: paymentMethodId,
                dateEpochDay: dateEpochDay,
                description: description,
                isSettled: isSettled,
                transactionId: transactionId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int shoppingListId,
                required int amountInCents,
                required int categoryId,
                required int paymentMethodId,
                required int dateEpochDay,
                required String description,
                Value<bool> isSettled = const Value.absent(),
                Value<int?> transactionId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ShoppingPayablesCompanion.insert(
                id: id,
                shoppingListId: shoppingListId,
                amountInCents: amountInCents,
                categoryId: categoryId,
                paymentMethodId: paymentMethodId,
                dateEpochDay: dateEpochDay,
                description: description,
                isSettled: isSettled,
                transactionId: transactionId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ShoppingPayablesTable, ShoppingPayableRow>(
                    table,
                  ),
                  $$ShoppingPayablesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                shoppingListId = false,
                categoryId = false,
                paymentMethodId = false,
                transactionId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (shoppingListId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.shoppingListId,
                                    referencedTable:
                                        $$ShoppingPayablesTableReferences
                                            ._shoppingListIdTable(db),
                                    referencedColumn:
                                        $$ShoppingPayablesTableReferences
                                            ._shoppingListIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable:
                                        $$ShoppingPayablesTableReferences
                                            ._categoryIdTable(db),
                                    referencedColumn:
                                        $$ShoppingPayablesTableReferences
                                            ._categoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (paymentMethodId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.paymentMethodId,
                                    referencedTable:
                                        $$ShoppingPayablesTableReferences
                                            ._paymentMethodIdTable(db),
                                    referencedColumn:
                                        $$ShoppingPayablesTableReferences
                                            ._paymentMethodIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (transactionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.transactionId,
                                    referencedTable:
                                        $$ShoppingPayablesTableReferences
                                            ._transactionIdTable(db),
                                    referencedColumn:
                                        $$ShoppingPayablesTableReferences
                                            ._transactionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$ShoppingPayablesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShoppingPayablesTable,
      ShoppingPayableRow,
      $$ShoppingPayablesTableFilterComposer,
      $$ShoppingPayablesTableOrderingComposer,
      $$ShoppingPayablesTableAnnotationComposer,
      $$ShoppingPayablesTableCreateCompanionBuilder,
      $$ShoppingPayablesTableUpdateCompanionBuilder,
      (ShoppingPayableRow, $$ShoppingPayablesTableReferences),
      ShoppingPayableRow,
      PrefetchHooks Function({
        bool shoppingListId,
        bool categoryId,
        bool paymentMethodId,
        bool transactionId,
      })
    >;
typedef $$ObligationsTableCreateCompanionBuilder =
    ObligationsCompanion Function({
      Value<int> id,
      required String direction,
      required String title,
      Value<String?> counterparty,
      required int amountInCents,
      Value<int?> dueDateEpochDay,
      required int categoryId,
      Value<int?> defaultPaymentMethodId,
      Value<int?> sourceShoppingListId,
      Value<bool> isCancelled,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$ObligationsTableUpdateCompanionBuilder =
    ObligationsCompanion Function({
      Value<int> id,
      Value<String> direction,
      Value<String> title,
      Value<String?> counterparty,
      Value<int> amountInCents,
      Value<int?> dueDateEpochDay,
      Value<int> categoryId,
      Value<int?> defaultPaymentMethodId,
      Value<int?> sourceShoppingListId,
      Value<bool> isCancelled,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$ObligationsTableReferences
    extends BaseReferences<_$AppDatabase, $ObligationsTable, ObligationRow> {
  $$ObligationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('obligations__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PaymentMethodsTable _defaultPaymentMethodIdTable(_$AppDatabase db) =>
      db.paymentMethods.createAlias(
        'obligations__default_payment_method_id__payment_methods__id',
      );

  $$PaymentMethodsTableProcessedTableManager? get defaultPaymentMethodId {
    final $_column = $_itemColumn<int>('default_payment_method_id');
    if ($_column == null) return null;
    final manager = $$PaymentMethodsTableTableManager(
      $_db,
      $_db.paymentMethods,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _defaultPaymentMethodIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ShoppingListsTable _sourceShoppingListIdTable(_$AppDatabase db) => db
      .shoppingLists
      .createAlias('obligations__source_shopping_list_id__shopping_lists__id');

  $$ShoppingListsTableProcessedTableManager? get sourceShoppingListId {
    final $_column = $_itemColumn<int>('source_shopping_list_id');
    if ($_column == null) return null;
    final manager = $$ShoppingListsTableTableManager(
      $_db,
      $_db.shoppingLists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _sourceShoppingListIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $ObligationPaymentsTable,
    List<ObligationPaymentRow>
  >
  _obligationPaymentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.obligationPayments,
        aliasName: 'obligations__id__obligation_payments__obligation_id',
      );

  $$ObligationPaymentsTableProcessedTableManager get obligationPaymentsRefs {
    final manager = $$ObligationPaymentsTableTableManager(
      $_db,
      $_db.obligationPayments,
    ).filter((f) => f.obligationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _obligationPaymentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ObligationsTableFilterComposer
    extends Composer<_$AppDatabase, $ObligationsTable> {
  $$ObligationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get counterparty => $composableBuilder(
    column: $table.counterparty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueDateEpochDay => $composableBuilder(
    column: $table.dueDateEpochDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCancelled => $composableBuilder(
    column: $table.isCancelled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaymentMethodsTableFilterComposer get defaultPaymentMethodId {
    final $$PaymentMethodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.defaultPaymentMethodId,
      referencedTable: $db.paymentMethods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMethodsTableFilterComposer(
            $db: $db,
            $table: $db.paymentMethods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ShoppingListsTableFilterComposer get sourceShoppingListId {
    final $$ShoppingListsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceShoppingListId,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableFilterComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> obligationPaymentsRefs(
    Expression<bool> Function($$ObligationPaymentsTableFilterComposer f) f,
  ) {
    final $$ObligationPaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.obligationPayments,
      getReferencedColumn: (t) => t.obligationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObligationPaymentsTableFilterComposer(
            $db: $db,
            $table: $db.obligationPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ObligationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ObligationsTable> {
  $$ObligationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get counterparty => $composableBuilder(
    column: $table.counterparty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueDateEpochDay => $composableBuilder(
    column: $table.dueDateEpochDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCancelled => $composableBuilder(
    column: $table.isCancelled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaymentMethodsTableOrderingComposer get defaultPaymentMethodId {
    final $$PaymentMethodsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.defaultPaymentMethodId,
      referencedTable: $db.paymentMethods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMethodsTableOrderingComposer(
            $db: $db,
            $table: $db.paymentMethods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ShoppingListsTableOrderingComposer get sourceShoppingListId {
    final $$ShoppingListsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceShoppingListId,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableOrderingComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ObligationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ObligationsTable> {
  $$ObligationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get counterparty => $composableBuilder(
    column: $table.counterparty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dueDateEpochDay => $composableBuilder(
    column: $table.dueDateEpochDay,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCancelled => $composableBuilder(
    column: $table.isCancelled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaymentMethodsTableAnnotationComposer get defaultPaymentMethodId {
    final $$PaymentMethodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.defaultPaymentMethodId,
      referencedTable: $db.paymentMethods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMethodsTableAnnotationComposer(
            $db: $db,
            $table: $db.paymentMethods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ShoppingListsTableAnnotationComposer get sourceShoppingListId {
    final $$ShoppingListsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceShoppingListId,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableAnnotationComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> obligationPaymentsRefs<T extends Object>(
    Expression<T> Function($$ObligationPaymentsTableAnnotationComposer a) f,
  ) {
    final $$ObligationPaymentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.obligationPayments,
          getReferencedColumn: (t) => t.obligationId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ObligationPaymentsTableAnnotationComposer(
                $db: $db,
                $table: $db.obligationPayments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ObligationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ObligationsTable,
          ObligationRow,
          $$ObligationsTableFilterComposer,
          $$ObligationsTableOrderingComposer,
          $$ObligationsTableAnnotationComposer,
          $$ObligationsTableCreateCompanionBuilder,
          $$ObligationsTableUpdateCompanionBuilder,
          (ObligationRow, $$ObligationsTableReferences),
          ObligationRow,
          PrefetchHooks Function({
            bool categoryId,
            bool defaultPaymentMethodId,
            bool sourceShoppingListId,
            bool obligationPaymentsRefs,
          })
        > {
  $$ObligationsTableTableManager(_$AppDatabase db, $ObligationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ObligationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ObligationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ObligationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> direction = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> counterparty = const Value.absent(),
                Value<int> amountInCents = const Value.absent(),
                Value<int?> dueDateEpochDay = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int?> defaultPaymentMethodId = const Value.absent(),
                Value<int?> sourceShoppingListId = const Value.absent(),
                Value<bool> isCancelled = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ObligationsCompanion(
                id: id,
                direction: direction,
                title: title,
                counterparty: counterparty,
                amountInCents: amountInCents,
                dueDateEpochDay: dueDateEpochDay,
                categoryId: categoryId,
                defaultPaymentMethodId: defaultPaymentMethodId,
                sourceShoppingListId: sourceShoppingListId,
                isCancelled: isCancelled,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String direction,
                required String title,
                Value<String?> counterparty = const Value.absent(),
                required int amountInCents,
                Value<int?> dueDateEpochDay = const Value.absent(),
                required int categoryId,
                Value<int?> defaultPaymentMethodId = const Value.absent(),
                Value<int?> sourceShoppingListId = const Value.absent(),
                Value<bool> isCancelled = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ObligationsCompanion.insert(
                id: id,
                direction: direction,
                title: title,
                counterparty: counterparty,
                amountInCents: amountInCents,
                dueDateEpochDay: dueDateEpochDay,
                categoryId: categoryId,
                defaultPaymentMethodId: defaultPaymentMethodId,
                sourceShoppingListId: sourceShoppingListId,
                isCancelled: isCancelled,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ObligationsTable, ObligationRow>(table),
                  $$ObligationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                defaultPaymentMethodId = false,
                sourceShoppingListId = false,
                obligationPaymentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (obligationPaymentsRefs) db.obligationPayments,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable:
                                        $$ObligationsTableReferences
                                            ._categoryIdTable(db),
                                    referencedColumn:
                                        $$ObligationsTableReferences
                                            ._categoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (defaultPaymentMethodId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.defaultPaymentMethodId,
                                    referencedTable:
                                        $$ObligationsTableReferences
                                            ._defaultPaymentMethodIdTable(db),
                                    referencedColumn:
                                        $$ObligationsTableReferences
                                            ._defaultPaymentMethodIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (sourceShoppingListId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sourceShoppingListId,
                                    referencedTable:
                                        $$ObligationsTableReferences
                                            ._sourceShoppingListIdTable(db),
                                    referencedColumn:
                                        $$ObligationsTableReferences
                                            ._sourceShoppingListIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (obligationPaymentsRefs)
                        await $_getPrefetchedDataByColumns<
                          ObligationRow,
                          $ObligationsTable,
                          ObligationPaymentRow,
                          $ObligationPaymentsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ObligationsTableReferences
                              ._obligationPaymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ObligationsTableReferences(
                                db,
                                table,
                                p0,
                              ).obligationPaymentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'obligation_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ObligationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ObligationsTable,
      ObligationRow,
      $$ObligationsTableFilterComposer,
      $$ObligationsTableOrderingComposer,
      $$ObligationsTableAnnotationComposer,
      $$ObligationsTableCreateCompanionBuilder,
      $$ObligationsTableUpdateCompanionBuilder,
      (ObligationRow, $$ObligationsTableReferences),
      ObligationRow,
      PrefetchHooks Function({
        bool categoryId,
        bool defaultPaymentMethodId,
        bool sourceShoppingListId,
        bool obligationPaymentsRefs,
      })
    >;
typedef $$ObligationPaymentsTableCreateCompanionBuilder =
    ObligationPaymentsCompanion Function({
      Value<int> id,
      required int obligationId,
      required int amountInCents,
      required int dateEpochDay,
      required int paymentMethodId,
      Value<int?> transactionId,
      Value<String?> note,
      Value<DateTime> createdAt,
    });
typedef $$ObligationPaymentsTableUpdateCompanionBuilder =
    ObligationPaymentsCompanion Function({
      Value<int> id,
      Value<int> obligationId,
      Value<int> amountInCents,
      Value<int> dateEpochDay,
      Value<int> paymentMethodId,
      Value<int?> transactionId,
      Value<String?> note,
      Value<DateTime> createdAt,
    });

final class $$ObligationPaymentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ObligationPaymentsTable,
          ObligationPaymentRow
        > {
  $$ObligationPaymentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ObligationsTable _obligationIdTable(_$AppDatabase db) => db
      .obligations
      .createAlias('obligation_payments__obligation_id__obligations__id');

  $$ObligationsTableProcessedTableManager get obligationId {
    final $_column = $_itemColumn<int>('obligation_id')!;

    final manager = $$ObligationsTableTableManager(
      $_db,
      $_db.obligations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_obligationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PaymentMethodsTable _paymentMethodIdTable(_$AppDatabase db) =>
      db.paymentMethods.createAlias(
        'obligation_payments__payment_method_id__payment_methods__id',
      );

  $$PaymentMethodsTableProcessedTableManager get paymentMethodId {
    final $_column = $_itemColumn<int>('payment_method_id')!;

    final manager = $$PaymentMethodsTableTableManager(
      $_db,
      $_db.paymentMethods,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_paymentMethodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TransactionsTable _transactionIdTable(_$AppDatabase db) => db
      .transactions
      .createAlias('obligation_payments__transaction_id__transactions__id');

  $$TransactionsTableProcessedTableManager? get transactionId {
    final $_column = $_itemColumn<int>('transaction_id');
    if ($_column == null) return null;
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ObligationPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $ObligationPaymentsTable> {
  $$ObligationPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dateEpochDay => $composableBuilder(
    column: $table.dateEpochDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ObligationsTableFilterComposer get obligationId {
    final $$ObligationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.obligationId,
      referencedTable: $db.obligations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObligationsTableFilterComposer(
            $db: $db,
            $table: $db.obligations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaymentMethodsTableFilterComposer get paymentMethodId {
    final $$PaymentMethodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentMethodId,
      referencedTable: $db.paymentMethods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMethodsTableFilterComposer(
            $db: $db,
            $table: $db.paymentMethods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ObligationPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ObligationPaymentsTable> {
  $$ObligationPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dateEpochDay => $composableBuilder(
    column: $table.dateEpochDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ObligationsTableOrderingComposer get obligationId {
    final $$ObligationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.obligationId,
      referencedTable: $db.obligations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObligationsTableOrderingComposer(
            $db: $db,
            $table: $db.obligations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaymentMethodsTableOrderingComposer get paymentMethodId {
    final $$PaymentMethodsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentMethodId,
      referencedTable: $db.paymentMethods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMethodsTableOrderingComposer(
            $db: $db,
            $table: $db.paymentMethods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ObligationPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ObligationPaymentsTable> {
  $$ObligationPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dateEpochDay => $composableBuilder(
    column: $table.dateEpochDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ObligationsTableAnnotationComposer get obligationId {
    final $$ObligationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.obligationId,
      referencedTable: $db.obligations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ObligationsTableAnnotationComposer(
            $db: $db,
            $table: $db.obligations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaymentMethodsTableAnnotationComposer get paymentMethodId {
    final $$PaymentMethodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentMethodId,
      referencedTable: $db.paymentMethods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMethodsTableAnnotationComposer(
            $db: $db,
            $table: $db.paymentMethods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ObligationPaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ObligationPaymentsTable,
          ObligationPaymentRow,
          $$ObligationPaymentsTableFilterComposer,
          $$ObligationPaymentsTableOrderingComposer,
          $$ObligationPaymentsTableAnnotationComposer,
          $$ObligationPaymentsTableCreateCompanionBuilder,
          $$ObligationPaymentsTableUpdateCompanionBuilder,
          (ObligationPaymentRow, $$ObligationPaymentsTableReferences),
          ObligationPaymentRow,
          PrefetchHooks Function({
            bool obligationId,
            bool paymentMethodId,
            bool transactionId,
          })
        > {
  $$ObligationPaymentsTableTableManager(
    _$AppDatabase db,
    $ObligationPaymentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ObligationPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ObligationPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ObligationPaymentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> obligationId = const Value.absent(),
                Value<int> amountInCents = const Value.absent(),
                Value<int> dateEpochDay = const Value.absent(),
                Value<int> paymentMethodId = const Value.absent(),
                Value<int?> transactionId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ObligationPaymentsCompanion(
                id: id,
                obligationId: obligationId,
                amountInCents: amountInCents,
                dateEpochDay: dateEpochDay,
                paymentMethodId: paymentMethodId,
                transactionId: transactionId,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int obligationId,
                required int amountInCents,
                required int dateEpochDay,
                required int paymentMethodId,
                Value<int?> transactionId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ObligationPaymentsCompanion.insert(
                id: id,
                obligationId: obligationId,
                amountInCents: amountInCents,
                dateEpochDay: dateEpochDay,
                paymentMethodId: paymentMethodId,
                transactionId: transactionId,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ObligationPaymentsTable, ObligationPaymentRow>(
                    table,
                  ),
                  $$ObligationPaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                obligationId = false,
                paymentMethodId = false,
                transactionId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (obligationId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.obligationId,
                                    referencedTable:
                                        $$ObligationPaymentsTableReferences
                                            ._obligationIdTable(db),
                                    referencedColumn:
                                        $$ObligationPaymentsTableReferences
                                            ._obligationIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (paymentMethodId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.paymentMethodId,
                                    referencedTable:
                                        $$ObligationPaymentsTableReferences
                                            ._paymentMethodIdTable(db),
                                    referencedColumn:
                                        $$ObligationPaymentsTableReferences
                                            ._paymentMethodIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (transactionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.transactionId,
                                    referencedTable:
                                        $$ObligationPaymentsTableReferences
                                            ._transactionIdTable(db),
                                    referencedColumn:
                                        $$ObligationPaymentsTableReferences
                                            ._transactionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$ObligationPaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ObligationPaymentsTable,
      ObligationPaymentRow,
      $$ObligationPaymentsTableFilterComposer,
      $$ObligationPaymentsTableOrderingComposer,
      $$ObligationPaymentsTableAnnotationComposer,
      $$ObligationPaymentsTableCreateCompanionBuilder,
      $$ObligationPaymentsTableUpdateCompanionBuilder,
      (ObligationPaymentRow, $$ObligationPaymentsTableReferences),
      ObligationPaymentRow,
      PrefetchHooks Function({
        bool obligationId,
        bool paymentMethodId,
        bool transactionId,
      })
    >;
typedef $$RecurringEntriesTableCreateCompanionBuilder =
    RecurringEntriesCompanion Function({
      Value<int> id,
      required String title,
      required int amountInCents,
      required String type,
      required int categoryId,
      required int paymentMethodId,
      required String frequency,
      Value<int> interval,
      required int startDateEpochDay,
      required int nextDateEpochDay,
      Value<int?> endDateEpochDay,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$RecurringEntriesTableUpdateCompanionBuilder =
    RecurringEntriesCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<int> amountInCents,
      Value<String> type,
      Value<int> categoryId,
      Value<int> paymentMethodId,
      Value<String> frequency,
      Value<int> interval,
      Value<int> startDateEpochDay,
      Value<int> nextDateEpochDay,
      Value<int?> endDateEpochDay,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$RecurringEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RecurringEntriesTable,
          RecurringEntryRow
        > {
  $$RecurringEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) => db.categories
      .createAlias('recurring_entries__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PaymentMethodsTable _paymentMethodIdTable(_$AppDatabase db) => db
      .paymentMethods
      .createAlias('recurring_entries__payment_method_id__payment_methods__id');

  $$PaymentMethodsTableProcessedTableManager get paymentMethodId {
    final $_column = $_itemColumn<int>('payment_method_id')!;

    final manager = $$PaymentMethodsTableTableManager(
      $_db,
      $_db.paymentMethods,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_paymentMethodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecurringEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringEntriesTable> {
  $$RecurringEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get interval => $composableBuilder(
    column: $table.interval,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startDateEpochDay => $composableBuilder(
    column: $table.startDateEpochDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nextDateEpochDay => $composableBuilder(
    column: $table.nextDateEpochDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endDateEpochDay => $composableBuilder(
    column: $table.endDateEpochDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaymentMethodsTableFilterComposer get paymentMethodId {
    final $$PaymentMethodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentMethodId,
      referencedTable: $db.paymentMethods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMethodsTableFilterComposer(
            $db: $db,
            $table: $db.paymentMethods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurringEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringEntriesTable> {
  $$RecurringEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get interval => $composableBuilder(
    column: $table.interval,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startDateEpochDay => $composableBuilder(
    column: $table.startDateEpochDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nextDateEpochDay => $composableBuilder(
    column: $table.nextDateEpochDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endDateEpochDay => $composableBuilder(
    column: $table.endDateEpochDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaymentMethodsTableOrderingComposer get paymentMethodId {
    final $$PaymentMethodsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentMethodId,
      referencedTable: $db.paymentMethods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMethodsTableOrderingComposer(
            $db: $db,
            $table: $db.paymentMethods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurringEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringEntriesTable> {
  $$RecurringEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<int> get interval =>
      $composableBuilder(column: $table.interval, builder: (column) => column);

  GeneratedColumn<int> get startDateEpochDay => $composableBuilder(
    column: $table.startDateEpochDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nextDateEpochDay => $composableBuilder(
    column: $table.nextDateEpochDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endDateEpochDay => $composableBuilder(
    column: $table.endDateEpochDay,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaymentMethodsTableAnnotationComposer get paymentMethodId {
    final $$PaymentMethodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentMethodId,
      referencedTable: $db.paymentMethods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMethodsTableAnnotationComposer(
            $db: $db,
            $table: $db.paymentMethods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurringEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecurringEntriesTable,
          RecurringEntryRow,
          $$RecurringEntriesTableFilterComposer,
          $$RecurringEntriesTableOrderingComposer,
          $$RecurringEntriesTableAnnotationComposer,
          $$RecurringEntriesTableCreateCompanionBuilder,
          $$RecurringEntriesTableUpdateCompanionBuilder,
          (RecurringEntryRow, $$RecurringEntriesTableReferences),
          RecurringEntryRow,
          PrefetchHooks Function({bool categoryId, bool paymentMethodId})
        > {
  $$RecurringEntriesTableTableManager(
    _$AppDatabase db,
    $RecurringEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurringEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurringEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> amountInCents = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int> paymentMethodId = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<int> interval = const Value.absent(),
                Value<int> startDateEpochDay = const Value.absent(),
                Value<int> nextDateEpochDay = const Value.absent(),
                Value<int?> endDateEpochDay = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => RecurringEntriesCompanion(
                id: id,
                title: title,
                amountInCents: amountInCents,
                type: type,
                categoryId: categoryId,
                paymentMethodId: paymentMethodId,
                frequency: frequency,
                interval: interval,
                startDateEpochDay: startDateEpochDay,
                nextDateEpochDay: nextDateEpochDay,
                endDateEpochDay: endDateEpochDay,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required int amountInCents,
                required String type,
                required int categoryId,
                required int paymentMethodId,
                required String frequency,
                Value<int> interval = const Value.absent(),
                required int startDateEpochDay,
                required int nextDateEpochDay,
                Value<int?> endDateEpochDay = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => RecurringEntriesCompanion.insert(
                id: id,
                title: title,
                amountInCents: amountInCents,
                type: type,
                categoryId: categoryId,
                paymentMethodId: paymentMethodId,
                frequency: frequency,
                interval: interval,
                startDateEpochDay: startDateEpochDay,
                nextDateEpochDay: nextDateEpochDay,
                endDateEpochDay: endDateEpochDay,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecurringEntriesTable, RecurringEntryRow>(table),
                  $$RecurringEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({categoryId = false, paymentMethodId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable:
                                        $$RecurringEntriesTableReferences
                                            ._categoryIdTable(db),
                                    referencedColumn:
                                        $$RecurringEntriesTableReferences
                                            ._categoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (paymentMethodId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.paymentMethodId,
                                    referencedTable:
                                        $$RecurringEntriesTableReferences
                                            ._paymentMethodIdTable(db),
                                    referencedColumn:
                                        $$RecurringEntriesTableReferences
                                            ._paymentMethodIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$RecurringEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecurringEntriesTable,
      RecurringEntryRow,
      $$RecurringEntriesTableFilterComposer,
      $$RecurringEntriesTableOrderingComposer,
      $$RecurringEntriesTableAnnotationComposer,
      $$RecurringEntriesTableCreateCompanionBuilder,
      $$RecurringEntriesTableUpdateCompanionBuilder,
      (RecurringEntryRow, $$RecurringEntriesTableReferences),
      RecurringEntryRow,
      PrefetchHooks Function({bool categoryId, bool paymentMethodId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$PaymentMethodsTableTableManager get paymentMethods =>
      $$PaymentMethodsTableTableManager(_db, _db.paymentMethods);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$SavingsGoalsTableTableManager get savingsGoals =>
      $$SavingsGoalsTableTableManager(_db, _db.savingsGoals);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$BudgetCyclesTableTableManager get budgetCycles =>
      $$BudgetCyclesTableTableManager(_db, _db.budgetCycles);
  $$ShoppingListsTableTableManager get shoppingLists =>
      $$ShoppingListsTableTableManager(_db, _db.shoppingLists);
  $$ShoppingListItemsTableTableManager get shoppingListItems =>
      $$ShoppingListItemsTableTableManager(_db, _db.shoppingListItems);
  $$ShoppingAdjustmentsTableTableManager get shoppingAdjustments =>
      $$ShoppingAdjustmentsTableTableManager(_db, _db.shoppingAdjustments);
  $$ShoppingPayablesTableTableManager get shoppingPayables =>
      $$ShoppingPayablesTableTableManager(_db, _db.shoppingPayables);
  $$ObligationsTableTableManager get obligations =>
      $$ObligationsTableTableManager(_db, _db.obligations);
  $$ObligationPaymentsTableTableManager get obligationPayments =>
      $$ObligationPaymentsTableTableManager(_db, _db.obligationPayments);
  $$RecurringEntriesTableTableManager get recurringEntries =>
      $$RecurringEntriesTableTableManager(_db, _db.recurringEntries);
}
