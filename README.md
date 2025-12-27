# ShieldPay

ShieldPay, 4’lü proje kapsamında geliştirilen; web uygulaması, servis odaklı mimari (SOA) bileşenleri, veritabanı ve makine öğrenmesi modüllerini tek bir yapıda birleştiren örnek bir projedir.

## Repository Yapısı
- **web/Payment.Web**: ASP.NET MVC web uygulaması (UI + iş akışları)
- **soa/**: SOAP (Spyne), gRPC (Python) ve Node.js Express API servisleri
- **ml/**: Model eğitimi / değerlendirme çıktıları ve entegrasyon dosyaları
- **veritabani/**: SQL script/backup ve veritabanı materyalleri

## Teknoloji Yığını
- **Web:** ASP.NET MVC (C#), Razor Views
- **SOA:** SOAP (Spyne/Python), gRPC (Python), Node.js (Express)
- **Veritabanı:** MySQL
- **ML:** Python, scikit-learn / ilgili notebook ve modeller

## Kurulum ve Çalıştırma (Özet)
> Gizli bilgiler repoya eklenmez. Ortam değişkenlerini yerelde tanımlayınız.

### Web (ASP.NET MVC)
- Visual Studio ile çalıştırılabilir veya:
  - `dotnet run`

### Node.js API
- `npm install`
- `npm start`

### SOAP / gRPC
- İlgili servis klasöründe server başlatılır, client ile test edilir.

## Notlar
- Repo, proje bileşenlerini modüler klasör yapısı ile sunar.
- Servis testleri için Postman/terminal çıktıları kullanılabilir.

