// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_database.dart';

// ignore_for_file: type=lint
class $TaxRecordsTable extends TaxRecords
    with TableInfo<$TaxRecordsTable, TaxRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaxRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _annualIncomeMeta =
      const VerificationMeta('annualIncome');
  @override
  late final GeneratedColumn<double> annualIncome = GeneratedColumn<double>(
      'annual_income', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _personalExpenseMeta =
      const VerificationMeta('personalExpense');
  @override
  late final GeneratedColumn<double> personalExpense = GeneratedColumn<double>(
      'personal_expense', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _personalDeductionMeta =
      const VerificationMeta('personalDeduction');
  @override
  late final GeneratedColumn<double> personalDeduction =
      GeneratedColumn<double>('personal_deduction', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _providentFundMeta =
      const VerificationMeta('providentFund');
  @override
  late final GeneratedColumn<double> providentFund = GeneratedColumn<double>(
      'provident_fund', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _socialSecurityMeta =
      const VerificationMeta('socialSecurity');
  @override
  late final GeneratedColumn<double> socialSecurity = GeneratedColumn<double>(
      'social_security', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _lifeInsuranceMeta =
      const VerificationMeta('lifeInsurance');
  @override
  late final GeneratedColumn<double> lifeInsurance = GeneratedColumn<double>(
      'life_insurance', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _healthInsuranceMeta =
      const VerificationMeta('healthInsurance');
  @override
  late final GeneratedColumn<double> healthInsurance = GeneratedColumn<double>(
      'health_insurance', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _doubleDonationMeta =
      const VerificationMeta('doubleDonation');
  @override
  late final GeneratedColumn<double> doubleDonation = GeneratedColumn<double>(
      'double_donation', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _normalDonationMeta =
      const VerificationMeta('normalDonation');
  @override
  late final GeneratedColumn<double> normalDonation = GeneratedColumn<double>(
      'normal_donation', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _taxMeta = const VerificationMeta('tax');
  @override
  late final GeneratedColumn<double> tax = GeneratedColumn<double>(
      'tax', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        annualIncome,
        personalExpense,
        personalDeduction,
        providentFund,
        socialSecurity,
        lifeInsurance,
        healthInsurance,
        doubleDonation,
        normalDonation,
        tax,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tax_records';
  @override
  VerificationContext validateIntegrity(Insertable<TaxRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('annual_income')) {
      context.handle(
          _annualIncomeMeta,
          annualIncome.isAcceptableOrUnknown(
              data['annual_income']!, _annualIncomeMeta));
    } else if (isInserting) {
      context.missing(_annualIncomeMeta);
    }
    if (data.containsKey('personal_expense')) {
      context.handle(
          _personalExpenseMeta,
          personalExpense.isAcceptableOrUnknown(
              data['personal_expense']!, _personalExpenseMeta));
    } else if (isInserting) {
      context.missing(_personalExpenseMeta);
    }
    if (data.containsKey('personal_deduction')) {
      context.handle(
          _personalDeductionMeta,
          personalDeduction.isAcceptableOrUnknown(
              data['personal_deduction']!, _personalDeductionMeta));
    } else if (isInserting) {
      context.missing(_personalDeductionMeta);
    }
    if (data.containsKey('provident_fund')) {
      context.handle(
          _providentFundMeta,
          providentFund.isAcceptableOrUnknown(
              data['provident_fund']!, _providentFundMeta));
    } else if (isInserting) {
      context.missing(_providentFundMeta);
    }
    if (data.containsKey('social_security')) {
      context.handle(
          _socialSecurityMeta,
          socialSecurity.isAcceptableOrUnknown(
              data['social_security']!, _socialSecurityMeta));
    } else if (isInserting) {
      context.missing(_socialSecurityMeta);
    }
    if (data.containsKey('life_insurance')) {
      context.handle(
          _lifeInsuranceMeta,
          lifeInsurance.isAcceptableOrUnknown(
              data['life_insurance']!, _lifeInsuranceMeta));
    } else if (isInserting) {
      context.missing(_lifeInsuranceMeta);
    }
    if (data.containsKey('health_insurance')) {
      context.handle(
          _healthInsuranceMeta,
          healthInsurance.isAcceptableOrUnknown(
              data['health_insurance']!, _healthInsuranceMeta));
    } else if (isInserting) {
      context.missing(_healthInsuranceMeta);
    }
    if (data.containsKey('double_donation')) {
      context.handle(
          _doubleDonationMeta,
          doubleDonation.isAcceptableOrUnknown(
              data['double_donation']!, _doubleDonationMeta));
    } else if (isInserting) {
      context.missing(_doubleDonationMeta);
    }
    if (data.containsKey('normal_donation')) {
      context.handle(
          _normalDonationMeta,
          normalDonation.isAcceptableOrUnknown(
              data['normal_donation']!, _normalDonationMeta));
    } else if (isInserting) {
      context.missing(_normalDonationMeta);
    }
    if (data.containsKey('tax')) {
      context.handle(
          _taxMeta, tax.isAcceptableOrUnknown(data['tax']!, _taxMeta));
    } else if (isInserting) {
      context.missing(_taxMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaxRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaxRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      annualIncome: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}annual_income'])!,
      personalExpense: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}personal_expense'])!,
      personalDeduction: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}personal_deduction'])!,
      providentFund: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}provident_fund'])!,
      socialSecurity: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}social_security'])!,
      lifeInsurance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}life_insurance'])!,
      healthInsurance: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}health_insurance'])!,
      doubleDonation: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}double_donation'])!,
      normalDonation: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}normal_donation'])!,
      tax: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tax'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TaxRecordsTable createAlias(String alias) {
    return $TaxRecordsTable(attachedDatabase, alias);
  }
}

class TaxRecord extends DataClass implements Insertable<TaxRecord> {
  final int id;
  final double annualIncome;
  final double personalExpense;
  final double personalDeduction;
  final double providentFund;
  final double socialSecurity;
  final double lifeInsurance;
  final double healthInsurance;
  final double doubleDonation;
  final double normalDonation;
  final double tax;
  final DateTime createdAt;
  const TaxRecord(
      {required this.id,
      required this.annualIncome,
      required this.personalExpense,
      required this.personalDeduction,
      required this.providentFund,
      required this.socialSecurity,
      required this.lifeInsurance,
      required this.healthInsurance,
      required this.doubleDonation,
      required this.normalDonation,
      required this.tax,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['annual_income'] = Variable<double>(annualIncome);
    map['personal_expense'] = Variable<double>(personalExpense);
    map['personal_deduction'] = Variable<double>(personalDeduction);
    map['provident_fund'] = Variable<double>(providentFund);
    map['social_security'] = Variable<double>(socialSecurity);
    map['life_insurance'] = Variable<double>(lifeInsurance);
    map['health_insurance'] = Variable<double>(healthInsurance);
    map['double_donation'] = Variable<double>(doubleDonation);
    map['normal_donation'] = Variable<double>(normalDonation);
    map['tax'] = Variable<double>(tax);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TaxRecordsCompanion toCompanion(bool nullToAbsent) {
    return TaxRecordsCompanion(
      id: Value(id),
      annualIncome: Value(annualIncome),
      personalExpense: Value(personalExpense),
      personalDeduction: Value(personalDeduction),
      providentFund: Value(providentFund),
      socialSecurity: Value(socialSecurity),
      lifeInsurance: Value(lifeInsurance),
      healthInsurance: Value(healthInsurance),
      doubleDonation: Value(doubleDonation),
      normalDonation: Value(normalDonation),
      tax: Value(tax),
      createdAt: Value(createdAt),
    );
  }

  factory TaxRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaxRecord(
      id: serializer.fromJson<int>(json['id']),
      annualIncome: serializer.fromJson<double>(json['annualIncome']),
      personalExpense: serializer.fromJson<double>(json['personalExpense']),
      personalDeduction: serializer.fromJson<double>(json['personalDeduction']),
      providentFund: serializer.fromJson<double>(json['providentFund']),
      socialSecurity: serializer.fromJson<double>(json['socialSecurity']),
      lifeInsurance: serializer.fromJson<double>(json['lifeInsurance']),
      healthInsurance: serializer.fromJson<double>(json['healthInsurance']),
      doubleDonation: serializer.fromJson<double>(json['doubleDonation']),
      normalDonation: serializer.fromJson<double>(json['normalDonation']),
      tax: serializer.fromJson<double>(json['tax']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'annualIncome': serializer.toJson<double>(annualIncome),
      'personalExpense': serializer.toJson<double>(personalExpense),
      'personalDeduction': serializer.toJson<double>(personalDeduction),
      'providentFund': serializer.toJson<double>(providentFund),
      'socialSecurity': serializer.toJson<double>(socialSecurity),
      'lifeInsurance': serializer.toJson<double>(lifeInsurance),
      'healthInsurance': serializer.toJson<double>(healthInsurance),
      'doubleDonation': serializer.toJson<double>(doubleDonation),
      'normalDonation': serializer.toJson<double>(normalDonation),
      'tax': serializer.toJson<double>(tax),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TaxRecord copyWith(
          {int? id,
          double? annualIncome,
          double? personalExpense,
          double? personalDeduction,
          double? providentFund,
          double? socialSecurity,
          double? lifeInsurance,
          double? healthInsurance,
          double? doubleDonation,
          double? normalDonation,
          double? tax,
          DateTime? createdAt}) =>
      TaxRecord(
        id: id ?? this.id,
        annualIncome: annualIncome ?? this.annualIncome,
        personalExpense: personalExpense ?? this.personalExpense,
        personalDeduction: personalDeduction ?? this.personalDeduction,
        providentFund: providentFund ?? this.providentFund,
        socialSecurity: socialSecurity ?? this.socialSecurity,
        lifeInsurance: lifeInsurance ?? this.lifeInsurance,
        healthInsurance: healthInsurance ?? this.healthInsurance,
        doubleDonation: doubleDonation ?? this.doubleDonation,
        normalDonation: normalDonation ?? this.normalDonation,
        tax: tax ?? this.tax,
        createdAt: createdAt ?? this.createdAt,
      );
  TaxRecord copyWithCompanion(TaxRecordsCompanion data) {
    return TaxRecord(
      id: data.id.present ? data.id.value : this.id,
      annualIncome: data.annualIncome.present
          ? data.annualIncome.value
          : this.annualIncome,
      personalExpense: data.personalExpense.present
          ? data.personalExpense.value
          : this.personalExpense,
      personalDeduction: data.personalDeduction.present
          ? data.personalDeduction.value
          : this.personalDeduction,
      providentFund: data.providentFund.present
          ? data.providentFund.value
          : this.providentFund,
      socialSecurity: data.socialSecurity.present
          ? data.socialSecurity.value
          : this.socialSecurity,
      lifeInsurance: data.lifeInsurance.present
          ? data.lifeInsurance.value
          : this.lifeInsurance,
      healthInsurance: data.healthInsurance.present
          ? data.healthInsurance.value
          : this.healthInsurance,
      doubleDonation: data.doubleDonation.present
          ? data.doubleDonation.value
          : this.doubleDonation,
      normalDonation: data.normalDonation.present
          ? data.normalDonation.value
          : this.normalDonation,
      tax: data.tax.present ? data.tax.value : this.tax,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaxRecord(')
          ..write('id: $id, ')
          ..write('annualIncome: $annualIncome, ')
          ..write('personalExpense: $personalExpense, ')
          ..write('personalDeduction: $personalDeduction, ')
          ..write('providentFund: $providentFund, ')
          ..write('socialSecurity: $socialSecurity, ')
          ..write('lifeInsurance: $lifeInsurance, ')
          ..write('healthInsurance: $healthInsurance, ')
          ..write('doubleDonation: $doubleDonation, ')
          ..write('normalDonation: $normalDonation, ')
          ..write('tax: $tax, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      annualIncome,
      personalExpense,
      personalDeduction,
      providentFund,
      socialSecurity,
      lifeInsurance,
      healthInsurance,
      doubleDonation,
      normalDonation,
      tax,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaxRecord &&
          other.id == this.id &&
          other.annualIncome == this.annualIncome &&
          other.personalExpense == this.personalExpense &&
          other.personalDeduction == this.personalDeduction &&
          other.providentFund == this.providentFund &&
          other.socialSecurity == this.socialSecurity &&
          other.lifeInsurance == this.lifeInsurance &&
          other.healthInsurance == this.healthInsurance &&
          other.doubleDonation == this.doubleDonation &&
          other.normalDonation == this.normalDonation &&
          other.tax == this.tax &&
          other.createdAt == this.createdAt);
}

class TaxRecordsCompanion extends UpdateCompanion<TaxRecord> {
  final Value<int> id;
  final Value<double> annualIncome;
  final Value<double> personalExpense;
  final Value<double> personalDeduction;
  final Value<double> providentFund;
  final Value<double> socialSecurity;
  final Value<double> lifeInsurance;
  final Value<double> healthInsurance;
  final Value<double> doubleDonation;
  final Value<double> normalDonation;
  final Value<double> tax;
  final Value<DateTime> createdAt;
  const TaxRecordsCompanion({
    this.id = const Value.absent(),
    this.annualIncome = const Value.absent(),
    this.personalExpense = const Value.absent(),
    this.personalDeduction = const Value.absent(),
    this.providentFund = const Value.absent(),
    this.socialSecurity = const Value.absent(),
    this.lifeInsurance = const Value.absent(),
    this.healthInsurance = const Value.absent(),
    this.doubleDonation = const Value.absent(),
    this.normalDonation = const Value.absent(),
    this.tax = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TaxRecordsCompanion.insert({
    this.id = const Value.absent(),
    required double annualIncome,
    required double personalExpense,
    required double personalDeduction,
    required double providentFund,
    required double socialSecurity,
    required double lifeInsurance,
    required double healthInsurance,
    required double doubleDonation,
    required double normalDonation,
    required double tax,
    this.createdAt = const Value.absent(),
  })  : annualIncome = Value(annualIncome),
        personalExpense = Value(personalExpense),
        personalDeduction = Value(personalDeduction),
        providentFund = Value(providentFund),
        socialSecurity = Value(socialSecurity),
        lifeInsurance = Value(lifeInsurance),
        healthInsurance = Value(healthInsurance),
        doubleDonation = Value(doubleDonation),
        normalDonation = Value(normalDonation),
        tax = Value(tax);
  static Insertable<TaxRecord> custom({
    Expression<int>? id,
    Expression<double>? annualIncome,
    Expression<double>? personalExpense,
    Expression<double>? personalDeduction,
    Expression<double>? providentFund,
    Expression<double>? socialSecurity,
    Expression<double>? lifeInsurance,
    Expression<double>? healthInsurance,
    Expression<double>? doubleDonation,
    Expression<double>? normalDonation,
    Expression<double>? tax,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (annualIncome != null) 'annual_income': annualIncome,
      if (personalExpense != null) 'personal_expense': personalExpense,
      if (personalDeduction != null) 'personal_deduction': personalDeduction,
      if (providentFund != null) 'provident_fund': providentFund,
      if (socialSecurity != null) 'social_security': socialSecurity,
      if (lifeInsurance != null) 'life_insurance': lifeInsurance,
      if (healthInsurance != null) 'health_insurance': healthInsurance,
      if (doubleDonation != null) 'double_donation': doubleDonation,
      if (normalDonation != null) 'normal_donation': normalDonation,
      if (tax != null) 'tax': tax,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TaxRecordsCompanion copyWith(
      {Value<int>? id,
      Value<double>? annualIncome,
      Value<double>? personalExpense,
      Value<double>? personalDeduction,
      Value<double>? providentFund,
      Value<double>? socialSecurity,
      Value<double>? lifeInsurance,
      Value<double>? healthInsurance,
      Value<double>? doubleDonation,
      Value<double>? normalDonation,
      Value<double>? tax,
      Value<DateTime>? createdAt}) {
    return TaxRecordsCompanion(
      id: id ?? this.id,
      annualIncome: annualIncome ?? this.annualIncome,
      personalExpense: personalExpense ?? this.personalExpense,
      personalDeduction: personalDeduction ?? this.personalDeduction,
      providentFund: providentFund ?? this.providentFund,
      socialSecurity: socialSecurity ?? this.socialSecurity,
      lifeInsurance: lifeInsurance ?? this.lifeInsurance,
      healthInsurance: healthInsurance ?? this.healthInsurance,
      doubleDonation: doubleDonation ?? this.doubleDonation,
      normalDonation: normalDonation ?? this.normalDonation,
      tax: tax ?? this.tax,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (annualIncome.present) {
      map['annual_income'] = Variable<double>(annualIncome.value);
    }
    if (personalExpense.present) {
      map['personal_expense'] = Variable<double>(personalExpense.value);
    }
    if (personalDeduction.present) {
      map['personal_deduction'] = Variable<double>(personalDeduction.value);
    }
    if (providentFund.present) {
      map['provident_fund'] = Variable<double>(providentFund.value);
    }
    if (socialSecurity.present) {
      map['social_security'] = Variable<double>(socialSecurity.value);
    }
    if (lifeInsurance.present) {
      map['life_insurance'] = Variable<double>(lifeInsurance.value);
    }
    if (healthInsurance.present) {
      map['health_insurance'] = Variable<double>(healthInsurance.value);
    }
    if (doubleDonation.present) {
      map['double_donation'] = Variable<double>(doubleDonation.value);
    }
    if (normalDonation.present) {
      map['normal_donation'] = Variable<double>(normalDonation.value);
    }
    if (tax.present) {
      map['tax'] = Variable<double>(tax.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaxRecordsCompanion(')
          ..write('id: $id, ')
          ..write('annualIncome: $annualIncome, ')
          ..write('personalExpense: $personalExpense, ')
          ..write('personalDeduction: $personalDeduction, ')
          ..write('providentFund: $providentFund, ')
          ..write('socialSecurity: $socialSecurity, ')
          ..write('lifeInsurance: $lifeInsurance, ')
          ..write('healthInsurance: $healthInsurance, ')
          ..write('doubleDonation: $doubleDonation, ')
          ..write('normalDonation: $normalDonation, ')
          ..write('tax: $tax, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$TaxDatabase extends GeneratedDatabase {
  _$TaxDatabase(QueryExecutor e) : super(e);
  $TaxDatabaseManager get managers => $TaxDatabaseManager(this);
  late final $TaxRecordsTable taxRecords = $TaxRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [taxRecords];
}

typedef $$TaxRecordsTableCreateCompanionBuilder = TaxRecordsCompanion Function({
  Value<int> id,
  required double annualIncome,
  required double personalExpense,
  required double personalDeduction,
  required double providentFund,
  required double socialSecurity,
  required double lifeInsurance,
  required double healthInsurance,
  required double doubleDonation,
  required double normalDonation,
  required double tax,
  Value<DateTime> createdAt,
});
typedef $$TaxRecordsTableUpdateCompanionBuilder = TaxRecordsCompanion Function({
  Value<int> id,
  Value<double> annualIncome,
  Value<double> personalExpense,
  Value<double> personalDeduction,
  Value<double> providentFund,
  Value<double> socialSecurity,
  Value<double> lifeInsurance,
  Value<double> healthInsurance,
  Value<double> doubleDonation,
  Value<double> normalDonation,
  Value<double> tax,
  Value<DateTime> createdAt,
});

class $$TaxRecordsTableFilterComposer
    extends Composer<_$TaxDatabase, $TaxRecordsTable> {
  $$TaxRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get annualIncome => $composableBuilder(
      column: $table.annualIncome, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get personalExpense => $composableBuilder(
      column: $table.personalExpense,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get personalDeduction => $composableBuilder(
      column: $table.personalDeduction,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get providentFund => $composableBuilder(
      column: $table.providentFund, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get socialSecurity => $composableBuilder(
      column: $table.socialSecurity,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lifeInsurance => $composableBuilder(
      column: $table.lifeInsurance, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get healthInsurance => $composableBuilder(
      column: $table.healthInsurance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get doubleDonation => $composableBuilder(
      column: $table.doubleDonation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get normalDonation => $composableBuilder(
      column: $table.normalDonation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tax => $composableBuilder(
      column: $table.tax, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$TaxRecordsTableOrderingComposer
    extends Composer<_$TaxDatabase, $TaxRecordsTable> {
  $$TaxRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get annualIncome => $composableBuilder(
      column: $table.annualIncome,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get personalExpense => $composableBuilder(
      column: $table.personalExpense,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get personalDeduction => $composableBuilder(
      column: $table.personalDeduction,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get providentFund => $composableBuilder(
      column: $table.providentFund,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get socialSecurity => $composableBuilder(
      column: $table.socialSecurity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lifeInsurance => $composableBuilder(
      column: $table.lifeInsurance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get healthInsurance => $composableBuilder(
      column: $table.healthInsurance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get doubleDonation => $composableBuilder(
      column: $table.doubleDonation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get normalDonation => $composableBuilder(
      column: $table.normalDonation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tax => $composableBuilder(
      column: $table.tax, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$TaxRecordsTableAnnotationComposer
    extends Composer<_$TaxDatabase, $TaxRecordsTable> {
  $$TaxRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get annualIncome => $composableBuilder(
      column: $table.annualIncome, builder: (column) => column);

  GeneratedColumn<double> get personalExpense => $composableBuilder(
      column: $table.personalExpense, builder: (column) => column);

  GeneratedColumn<double> get personalDeduction => $composableBuilder(
      column: $table.personalDeduction, builder: (column) => column);

  GeneratedColumn<double> get providentFund => $composableBuilder(
      column: $table.providentFund, builder: (column) => column);

  GeneratedColumn<double> get socialSecurity => $composableBuilder(
      column: $table.socialSecurity, builder: (column) => column);

  GeneratedColumn<double> get lifeInsurance => $composableBuilder(
      column: $table.lifeInsurance, builder: (column) => column);

  GeneratedColumn<double> get healthInsurance => $composableBuilder(
      column: $table.healthInsurance, builder: (column) => column);

  GeneratedColumn<double> get doubleDonation => $composableBuilder(
      column: $table.doubleDonation, builder: (column) => column);

  GeneratedColumn<double> get normalDonation => $composableBuilder(
      column: $table.normalDonation, builder: (column) => column);

  GeneratedColumn<double> get tax =>
      $composableBuilder(column: $table.tax, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TaxRecordsTableTableManager extends RootTableManager<
    _$TaxDatabase,
    $TaxRecordsTable,
    TaxRecord,
    $$TaxRecordsTableFilterComposer,
    $$TaxRecordsTableOrderingComposer,
    $$TaxRecordsTableAnnotationComposer,
    $$TaxRecordsTableCreateCompanionBuilder,
    $$TaxRecordsTableUpdateCompanionBuilder,
    (TaxRecord, BaseReferences<_$TaxDatabase, $TaxRecordsTable, TaxRecord>),
    TaxRecord,
    PrefetchHooks Function()> {
  $$TaxRecordsTableTableManager(_$TaxDatabase db, $TaxRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaxRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaxRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaxRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> annualIncome = const Value.absent(),
            Value<double> personalExpense = const Value.absent(),
            Value<double> personalDeduction = const Value.absent(),
            Value<double> providentFund = const Value.absent(),
            Value<double> socialSecurity = const Value.absent(),
            Value<double> lifeInsurance = const Value.absent(),
            Value<double> healthInsurance = const Value.absent(),
            Value<double> doubleDonation = const Value.absent(),
            Value<double> normalDonation = const Value.absent(),
            Value<double> tax = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              TaxRecordsCompanion(
            id: id,
            annualIncome: annualIncome,
            personalExpense: personalExpense,
            personalDeduction: personalDeduction,
            providentFund: providentFund,
            socialSecurity: socialSecurity,
            lifeInsurance: lifeInsurance,
            healthInsurance: healthInsurance,
            doubleDonation: doubleDonation,
            normalDonation: normalDonation,
            tax: tax,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required double annualIncome,
            required double personalExpense,
            required double personalDeduction,
            required double providentFund,
            required double socialSecurity,
            required double lifeInsurance,
            required double healthInsurance,
            required double doubleDonation,
            required double normalDonation,
            required double tax,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              TaxRecordsCompanion.insert(
            id: id,
            annualIncome: annualIncome,
            personalExpense: personalExpense,
            personalDeduction: personalDeduction,
            providentFund: providentFund,
            socialSecurity: socialSecurity,
            lifeInsurance: lifeInsurance,
            healthInsurance: healthInsurance,
            doubleDonation: doubleDonation,
            normalDonation: normalDonation,
            tax: tax,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TaxRecordsTableProcessedTableManager = ProcessedTableManager<
    _$TaxDatabase,
    $TaxRecordsTable,
    TaxRecord,
    $$TaxRecordsTableFilterComposer,
    $$TaxRecordsTableOrderingComposer,
    $$TaxRecordsTableAnnotationComposer,
    $$TaxRecordsTableCreateCompanionBuilder,
    $$TaxRecordsTableUpdateCompanionBuilder,
    (TaxRecord, BaseReferences<_$TaxDatabase, $TaxRecordsTable, TaxRecord>),
    TaxRecord,
    PrefetchHooks Function()>;

class $TaxDatabaseManager {
  final _$TaxDatabase _db;
  $TaxDatabaseManager(this._db);
  $$TaxRecordsTableTableManager get taxRecords =>
      $$TaxRecordsTableTableManager(_db, _db.taxRecords);
}
