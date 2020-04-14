namespace java com.rbkmoney.damsel.analytics
namespace erlang analytics

/**
 * Отметка во времени согласно RFC 3339.
 *
 * Строка должна содержать дату и время в UTC в следующем формате:
 * `2016-03-22T06:12:27Z`.
 */
typedef string Timestamp

/** Символьный код, уникально идентифицирующий валюту. */
typedef string CurrencySymbolicCode

typedef i64 Count

typedef i64 Amount

typedef double Percent