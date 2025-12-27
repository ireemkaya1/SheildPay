# ShieldPay

ShieldPay, 4’lü proje kapsamında geliştirilen; İleri Web, SOA, Veritabanı ve Makine Öğrenmesi bileşenlerini tek bir projede birleştiren örnek bir uygulamadır.

## Klasör Yapısı
- **web/Payment.Web**: ASP.NET MVC (İleri Web) uygulaması
- **soa/**: SOAP (Spyne), gRPC (Python), Node.js Express API servisleri
- **ml/**: Model eğitimi, değerlendirme ve servis entegrasyonu
- **veritabani/**: SQL script/backup ve veritabanı dokümanları

## İleri Web İster Karşılığı (Özet)
- 5+ Controller ve 3+ Action
- Esnek View yapısı (rol bazlı içerik)
- PartialView / ViewComponent kullanımı
- Custom Layout (en az 3 view’de)
- DB bağlantısı + CRUD (Transactions)
- 2 kullanıcı rolü: Admin / User
- ViewBag / ViewData / TempData ile sayfalar arası veri aktarımı

## SOA (Özet)
- SOAP: WSDL üzerinden servis çağrısı
- gRPC: proto + server/client iletişimi
- Node.js API: health/predict/rates endpointleri
- Hazır API tüketimi: döviz/kurlar (ör. Frankfurter)

## Çalıştırma (Kısa)
> Gizli bilgiler (.env / appsettings.json) repoya eklenmez. Örnek dosyaları yerelde oluşturunuz.

### Web (ASP.NET MVC)
- Visual Studio ile çalıştırabilir veya:
  - `dotnet run`

### Node.js API
- `npm install`
- `npm start`

### SOAP / gRPC
- İlgili klasörde server’ı çalıştırıp client ile test ediniz.

## GitHub
Repo: https://github.com/ireemkaya1/SheildPay
