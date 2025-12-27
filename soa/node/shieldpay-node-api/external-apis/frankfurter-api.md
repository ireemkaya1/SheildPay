# Frankfurter Currency API (Hazır API Kullanımı)

Bu servis, ShieldPay SOA mimarisi kapsamında kullanılan HARİCİ (hazır) bir API'dir.

## API Kaynağı
- Sağlayıcı: Frankfurter
- URL: https://api.frankfurter.app/latest
- Tür: REST / Public API
- Kimlik doğrulama: Gerekmez

## Kullanım Amacı
Fraud ve işlem analizlerinde, farklı para birimleri arasındaki tutarları normalize etmek
amacıyla döviz kuru bilgisini sağlamak.

## Projede Kullanıldığı Yer
- Katman: Service Layer (Node.js API)
- Dosya: index.js
- Endpoint: /api/rates

## Akış
1. İstemci (İleri Web / Test) → `/api/rates`
2. Node.js Servisi → Frankfurter API çağrısı
3. Gelen veri filtrelenir
4. İstemciye sade JSON olarak döndürülür

## Örnek Çağrı
GET /api/rates?from=USD&to=TRY

## Örnek Yanıt
```json
{
  "from": "USD",
  "to": "TRY",
  "rate": 32.45,
  "date": "2025-12-22"
}
