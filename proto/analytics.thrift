include "base.thrift"

namespace java com.rbkmoney.damsel.analytics
namespace erlang analytics

/**
 * Сервис для выдачи данных для построения графиков
 *
 * см. графики
 * https://projects.invisionapp.com/share/YKOFERE9NC7#/screens/323916505
 **/

typedef map<string, i64> DataPair // колонка + значение колонки, либо имя графика + значение графика в точке

typedef i64 Count

/**
 * В каком разбиении сервис отдаёт данные.
 **/
enum AggregationType {
    HOURLY
    DAILY
    MONTHLY
    YEARLY
}

/**
 * Структура для описания точки на оси даты на графике PeriodStatistics
 **/
struct Moment {
    1: required base.Year year
    2: required base.Month month
    3: required base.DayOfMonth day
    4: required i8 hour
}

/**
 * Структура для линейных/столбчатых графиков
 **/
struct PeriodStatistics {
    1: required AggregationType type
    2: required list<MomentData> data
}


/**
 * Кусок данных для линейных/столбчатых графиков
 **/
struct MomentData {
    1: required Moment moment
    2: required list<DataPair> data_set
}

/**
 * Статистика табличного вида
 **/
typedef list<RowStatistics> TableStatistics

/**
 * Имя строки и колонки со значениями
 **/
struct RowStatistics {
    1: required string category
    2: required list<DataPair> column_data_set
}

/**
 * Статистика сегментного вида (Pie Chart)
 **/
typedef list<DataPair> SegmentStatistics

/**
 * Предикат по мерчанту и его магазинам
 **/
struct PartyPredicate {
    1: required string party_id
    2: optional list<string> party_shops
}

/**
 * Предикат по дате
 **/
struct DatePredicate {
    1: required Moment from_date
    2: required Moment to_date
}

/**
 * Предикат по странам или городам платежей
 **/
union RegionPredicate {
    1: list<string> cities
    2: list<string> countries
}

/**
 * Общий предикат для запросов
 **/
struct Predicate {
    1: required PartyPredicate party_predicate
    2: required DatePredicate date_predicate
    3: optional RegionPredicate region_predicate
}

/**
 * Список городов или стран
 **/
union Regions {
    1: list<string> cities
    2: list<string> countries
}

union RegionsMode {
    1: bool top_regions
    2: bool top_cities
    3: bool top_countries
    4: bool all_countries
    5: bool all_cities
}

union PeriodStatisticsMode {
    1: bool revenues_and_refunds // график "Оборот и Возвраты" (см. шапку трифта)
    //any name of new analytics
}

union SegmentStatisticsMode {
    1: bool payment_tools // график "Иструменты платежей" (см. шапку трифта)
    //any name of new analytics
}

union TableStatisticsMode {
    1: bool users_statuses // график "Статусы по пользователям" (см. шапку трифта)
    //any name of new analytics
}

union SimpleCountMode {
    1: bool revenue // чиселка "Оборот за период" (см. шапку трифта)
    //any name of new analytics
}
/**
 * Сервис для работы с аналитикой
 **/
service AnalyticsService {

    /**
     * Получение данных для линейных/столбчатых графиков
     **/
    PeriodStatistics getPeriodStatistics(1: PeriodStatisticsMode mode, 2: Predicate predicate) // [ {момент времени + [{Название сегмента + цифра}...]} ... ]

    /**
     * Получение данных для графика по сегментам (Pie Chart)
     **/
    SegmentStatistics getSegmentStatistics(1: SegmentStatisticsMode mode, 2: Predicate predicate) // [ {Название сегмента + цифра} ... ]

    /**
     * Получение данных для таблицы
     **/
    TableStatistics getTableStatistics(1: TableStatisticsMode mode, 2: Predicate predicate) // [ {Название сегмента + [{Название сегмента + цифра}]} ...]

    /**
     * Получение числа по предикату
     **/
    Count getSimpleCount(1: SimpleCountMode mode, 2: Predicate predicate) // num

    /**
     * Получение регионов (стран или городов) для ЛК.
     **/
    Regions getRegions(1: RegionsMode mode, 2: Predicate predicate)
}