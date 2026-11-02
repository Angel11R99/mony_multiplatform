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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $PaymentMethodsTable paymentMethods = $PaymentMethodsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $SavingsGoalsTable savingsGoals = $SavingsGoalsTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $BudgetCyclesTable budgetCycles = $BudgetCyclesTable(this);
  late final Index paymentMethodsSingleDefault = Index(
    'payment_methods_single_default',
    'CREATE UNIQUE INDEX payment_methods_single_default ON payment_methods (is_default) WHERE is_default = 1',
  );
  late final Index transactionsDateIdx = Index(
    'transactions_date_idx',
    'CREATE INDEX transactions_date_idx ON transactions (date_epoch_day)',
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
    paymentMethodsSingleDefault,
    transactionsDateIdx,
    transactionsCategoryIdx,
    transactionsPaymentMethodIdx,
    transactionsFixedEntryIdx,
    transactionsSavingsGoalIdx,
    savingsGoalsCompletedIdx,
    budgetCyclesStartEndIdx,
  ];
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
          PrefetchHooks Function({bool transactionsRefs})
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
          prefetchHooksCallback: ({transactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (transactionsRefs) db.transactions],
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
      PrefetchHooks Function({bool transactionsRefs})
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
          PrefetchHooks Function({bool transactionsRefs})
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
          prefetchHooksCallback: ({transactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (transactionsRefs) db.transactions],
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
      PrefetchHooks Function({bool transactionsRefs})
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
          PrefetchHooks Function({bool categoryId, bool paymentMethodId})
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
                    return [];
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
      PrefetchHooks Function({bool categoryId, bool paymentMethodId})
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
}
