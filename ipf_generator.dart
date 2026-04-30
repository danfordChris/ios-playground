import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';

void main() {
  final generators = <BaseModelGenerator>[
    _User(),
    _Security(),
    _Notification(),
    _WatchlistItem(),
    _Order(),
    _Transaction(),
    _Portfolio(),
    _NewsItem(),
  ];
  CodeGenerator.of("ai_playground", generators).generate();
}

// ── DB-backed models ───────────────────────────────────────────────────────

class _User extends BaseModelGenerator {
  _User() : super.database("users", {
    "id": int,
    "firstName": String,
    "lastName": String,
    "phone": String,
    "email": String,
    "profilePhoto": String,
    "status": int,
    "createdAt": String,
  });
}

class _Security extends BaseModelGenerator {
  _Security() : super.database("securities", {
    "id": int,
    "name": String,
    "symbol": String,
    "sector": String,
    "type": String,
    "currentPrice": double,
    "changeAmount": double,
    "changePercent": double,
    "updatedAt": String,
  });
}

class _Notification extends BaseModelGenerator {
  _Notification() : super.database("notifications", {
    "id": int,
    "title": String,
    "body": String,
    "type": String,
    "payload": String,
    "isRead": bool,
    "createdAt": String,
  });
}

class _WatchlistItem extends BaseModelGenerator {
  _WatchlistItem() : super.database("watchlist_items", {
    "id": int,
    "securityId": int,
    "symbol": String,
    "addedAt": String,
  });
}

// ── API-only models (no local storage) ────────────────────────────────────

class _Order extends BaseModelGenerator {
  _Order() : super({
    "id": int,
    "securityId": int,
    "symbol": String,
    "orderType": String,
    "quantity": int,
    "price": double,
    "totalAmount": double,
    "status": String,
    "createdAt": String,
  });
}

class _Transaction extends BaseModelGenerator {
  _Transaction() : super({
    "id": int,
    "type": String,
    "amount": double,
    "reference": String,
    "description": String,
    "status": String,
    "createdAt": String,
  });
}

class _Portfolio extends BaseModelGenerator {
  _Portfolio() : super({
    "totalValue": double,
    "totalCost": double,
    "gainLoss": double,
    "gainLossPercent": double,
    "updatedAt": String,
  });
}

class _NewsItem extends BaseModelGenerator {
  _NewsItem() : super({
    "id": int,
    "title": String,
    "summary": String,
    "category": String,
    "source": String,
    "publishedAt": String,
    "imageUrl": String,
  });
}
