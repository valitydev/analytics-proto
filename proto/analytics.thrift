include "base.thrift"

namespace java com.rbkmoney.damsel.analytics

/**
 * В каком разбиении сервис отдаёт данные.
 **/
enum SplitUnit {
    MINUTE
    HOUR
    DAY
    WEEK
    MONTH
    YEAR
}

/**
 * Статусы платежей.
 **/
enum Status {
    PENDING
    PROCESSED
    CAPTURED
    CANCELLED
    REFUNDED
    FAILED
}

/**
 * Параметры фильтрации мерчанта
 **/
struct MerchantFilter {
    1: required string party_id
    2: optional list<string> shop_ids
}

/**
 * Параметры фильтрации по времени
 **/
struct TimeFilter {
    1: required base.Timestamp from_time
    2: required base.Timestamp to_time
}

/**
 * Запрос с разбивкой по периодам
 **/
struct FilterRequest {
    1: required MerchantFilter merchant_filter
    2: required TimeFilter time_filter
}

/**
 * Запрос с разбивкой по периодам сгруппированый по отрезкам
 **/
struct SplitFilterRequest {
    1: required FilterRequest filter_request
    2: required SplitUnit split_unit
}

/**
 * Распределение в процентах для чего-либо
 **/
struct NamingDistribution {
    1: required string name
    2: required base.Percent percents
}

/**
 * Список оборотов с группировкой по  валютам
 **/
struct AmountResponse {
    1: required list<CurrencyGroupedAmount> groups_amount
}

/**
 * Результат запроса распределения ошибок
 **/
struct ErrorDistributionsResponse {
    1: required list<NamingDistribution> error_distributions
}

/**
 * Сгруппированное по валюте значение оборота
 **/
struct CurrencyGroupedAmount {
    1: required base.Amount amount
    2: required base.CurrencySymbolicCode currency
}

/**
 * Результат запроса колличества сгруппированных по валютам
 **/
struct CountResponse {
    1: required list<CurrecyGroupCount> groups_count
}

/**
 * Сгруппированное по валюте колличество
 **/
struct CurrecyGroupCount {
    1: required base.Count count
    2: required base.CurrencySymbolicCode currency
}

/**
 * Результат запроса распределения платежных средств
 **/
struct PaymentToolDistributionResponse {
    1: required List<NamingDistribution> payment_tools_distributions
}

/**
 * Результат запроса оборотов разделенного на временные участки и сгруппированного по валюте
 **/
struct SplitAmountResponse {
    1: required List<GroupedCurrencyOffsetAmount> grouped_currency_amounts
    2: optional SplitUnit recommended_unit
}

/**
 * Результат оборотов сгруппированных по валюте
 **/
struct GroupedCurrencyOffsetAmount {
    1: required base.CurrencySymbolicCode currency
    2: required List<OffsetAmount> offset_amounts
}

/**
 * Оборот со смещением в временном интервале
 **/
struct OffsetAmount {
    1: required base.Amount amount
    2: required base.Count offset
}

/**
 * Результат запроса колличества платежей разделенного на временные участки и сгруппированного по валюте и статусам
 **/
struct SplitCountResponse {
    1: required List<GroupedCurrencyOffsetCount> payment_tools_destrobutions
    2: optional SplitUnit recommended_unit
}

/**
 * Колличества платежей сгруппированые по валюте
 **/
struct GroupedCurrencyOffsetCount {
    1: required base.CurrencySymbolicCode currency
    2: required List<GroupedStatusOffsetCount> offset_amounts
}

/**
 * Колличества платежей сгруппированые по статусам
 **/
struct GroupedStatusOffsetCount {
    1: required Status status
    2: required list<OffsetCount> offsetCounts
}

/**
 * Колличество платежей со смещением в временном интервале
 **/
struct OffsetCount {
    1: required base.Count count
    2: required base.Count offset
}

/**
 * Сервис для работы с аналитикой
 **/
service AnalyticsService {

    /**
     * Получение распределения использования платежных инструментов для ЛК.
     **/
    PaymentToolDistributionResponse GetPaymentsToolDistribution(1: FilterRequest request)

    /**
     * Получение списка оборотов с группировкой по валютам для ЛК.
     **/
    AmountResponse GetPaymentsAmount(1: FilterRequest request)

    /**
     * Получение среднего размера платежа с группировкой по валютам для ЛК.
     **/
    AmountResponse GetAveragePayment(1: FilterRequest request)

    /**
     * Получение колличества платежей с группировкой по валютам для ЛК.
     **/
    CountResponse GetPaymentsCount(1: FilterRequest request)

    /**
     * Получение распределения ошибок для ЛК.
     **/
    ErrorDistributionsResponse GetPaymentsErrorDistribution(1: FilterRequest request)

    /**
     * Получение списка оборотов с группировкой по валютам и разделенные по временным интервалам для ЛК.
     **/
    SplitAmountResponse GetPaymentsSplitAmount(1: SplitFilterRequest request)

    /**
     * Получение колличества платежей с группировкой по валютам и статусам, разделенные по временным интервалам для ЛК.
     **/
    SplitCountResponse GetPaymentsSplitCount(1: SplitFilterRequest request)

    /**
     * Получение списка возвратов с группировкой по валютам для ЛК.
     **/
    AmountResponse GetRefundsAmount(1: FilterRequest request)

}