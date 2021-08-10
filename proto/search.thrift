include "base.thrift"

namespace java com.rbkmoney.damsel.analytics.search
namespace erlang analytics

typedef string PartyId
typedef string Timestamp

struct CategoryFilter {
    1: optional string name
}

struct ShopFilter {
    1: optional string location_url
    2: optional CategoryFilter category_filter
}

struct PartyFilter {
    1: optional string contact_info_email
}

struct ContractFilter {
    1: optional Timestamp legal_agreement_signed_at
}

struct PartyFilterRequest {
    1: optional ShopFilter shop_filter
    2: optional PartyFilter party_filter
    3: optional ContractFilter contract_filter
}

service SearchService {
    list<PartyId> findPartyIds(1: PartyFilterRequest request)
}
