# Premium Hesap Makinesi (Dual-Engine Calculator)

Modern, şık tasarımlı ve çift motorlu (Esnaf ve Bilimsel Mod) gelişmiş bir Flutter hesap makinesi uygulaması. Uygulama, hem günlük esnaf hesaplamalarını (KDV, yüzde kâr/zarar işlemleri) hem de karmaşık bilimsel matematiksel formülleri destekler.

---

## 🌟 Öne Çıkan Özellikler

### 1. Çift Motorlu Hesaplama Düzeni (Esnaf & Bilimsel Mod)
*   **Esnaf Modu (Esnaf/Accounting Mode)**: Standart masaüstü hesap makinesi mantığıyla çalışır. Eşittir (`=`) tuşuna basmaya gerek kalmadan ardışık yüzde işlemleri (örn. `1500 * 20 % +` yazıldığında anında `1800` sonucunu üretir) ve kâr-zarar ekleme/çıkarma işlemleri kolayca yapılabilir.
*   **Bilimsel Mod (Scientific Mode)**: Gelişmiş matematiksel ifadeleri (trigonometrik `sin`, `cos`, `tan`, logaritmik `log`, `ln`, karekök `sqrt`, üs alma `x²`, `xy`, parantez öncelikleri, `π` ve `e` sabitleri) parantez hiyerarşisiyle çözümler.
*   **DEG / RAD Geçişi**: Trigonometrik hesaplamalar için derece ve radyan modları arasında tek tıkla geçiş yapma imkanı.

### 2. KDV Hesaplama Ekranı (KDV Dahil / Hariç)
*   Tek ekranda **KDV Dahil** ve **KDV Hariç** hesaplamalarını aynı anda anlık olarak yapar.
*   Hızlı aksiyon butonları (`%1`, `%10`, `%20`) ile KDV oranını tek dokunuşla belirleme veya özel KDV oranı girebilme seçeneği sunar.
*   Yatay ve dikey taşmaları önleyen, dar ekranlarda metinlerin otomatik küçülmesini sağlayan esnek arayüz tasarımı.

### 3. Hesaplama Geçmişi (Calculation Tape)
*   Yapılan tüm işlemler tarih ve saat bilgisiyle kalıcı bir hafızada tutulur.
*   Sol üst köşedeki **Saat/Geçmiş** simgesine tıklandığında açılan şık alt çekmece (Bottom Sheet) üzerinden eski hesaplamalar incelenebilir veya tek tıkla temizlenebilir.

### 4. Gelişmiş Ayarlar Çekmecesi (Settings Drawer)
*   **5 Farklı Premium Tema Seçeneği**:
    *   🔵 **Normal (Açık Tema)**
    *   ⚫ **Dark (Koyu Tema)**
    *   🟢 **Green (Nane Yeşili)**
    *   🔴 **Red (Yakut Kırmızısı)**
    *   🟡 **Retro Gold**: Siyah arka plan, nostaljik zeytin yeşili gösterge ekranı ve özel buton renkleri ile retro hesap makinesi esintisi.
*   **Dokunsal Titreşim (Haptic Feedback) Ayarı**: Sürgü (Slider) üzerinden 0-255 arası titreşim şiddetini ve süresini fiziksel olarak özelleştirme.
*   **Tuş Klik Sesleri**: Bağımsız olarak tuş klik seslerini açıp kapatabilme.

---

## 🎨 Retro Gold Tema Renk Paleti
*   **Uygulama Arka Planı**: `#000000` (Saf Siyah)
*   **Gösterge Ekranı Arka Planı**: `#444229` (Koyu Zeytin Yeşili)
*   **Gösterge Sayı Rengi**: `#DBDBDB` (Gözü yormayan açık gri dijital sayılar)
*   **Rakam Tuşları**: `#1F1F1F` (Koyu gri tuşlar ve `#DBDBDB` yazı rengi)
*   **Operatör Tuşları**: `#0F0F0F` (Siyah tuşlar ve `#B5B5B5` yazı rengi)
*   **Temizleme (AC) Tuşu**: `#0F0F0F` (Siyah tuş ve `#B5AC75` muted altın yazı rengi)

---

## 🚀 Kurulum ve Çalıştırma

Projeyi yerel bilgisayarınızda çalıştırmak veya derlemek için aşağıdaki adımları uygulayabilirsiniz.

### Gereksinimler
*   Flutter SDK (v3.10 veya üzeri)
*   Dart SDK
*   Android Studio / Xcode (Simülatör veya fiziksel cihaz bağlantısı için)
*   CocoaPods (iOS derlemeleri için)

### Adımlar

1.  Projeyi klonlayın:
    ```bash
    git clone https://github.com/ArdaBolukbasi/hesapmakinesi.git
    cd hesapmakinesi
    ```

2.  Bağımlılıkları yükleyin:
    ```bash
    flutter pub get
    ```

3.  Uygulamayı bir test cihazında veya simülatörde başlatın:
    ```bash
    flutter run
    ```

---

## 📦 Dağıtım ve APK/IPA Derleme

### Android için Release APK Üretme:
Aşağıdaki komutu çalıştırarak optimize edilmiş ve boyut olarak küçültülmüş kurulum dosyasını oluşturabilirsiniz:
```bash
flutter build apk --release
```
*Oluşan APK Dosyası:* `build/app/outputs/flutter-apk/app-release.apk`

### iOS (iPhone) için Yükleme:
iOS güvenlik sınırları nedeniyle, fiziksel cihazlarda hata ayıklama (JIT) korumasını aşmak için uygulamayı **Release modunda** derlemeniz gerekir:
```bash
flutter run --release
```
*Not: Telefonunuza ilk yüklemeden önce Xcode (`open ios/Runner.xcworkspace`) açıp, Runner hedefini seçerek **Signing & Capabilities** sekmesinden kendi Apple ID hesabınızı ("Personal Team") seçtiğinizden emin olun.*

---

## 🛠️ Kullanılan Teknolojiler ve Kütüphaneler
*   **Flutter & Dart** - Çapraz platform mobil geliştirme çatısı.
*   **Flutter Riverpod** - State Management (Durum Yönetimi).
*   **Shared Preferences** - Ayarların ve tema tercihlerinin cihaz hafızasında kalıcı olarak saklanması.
*   **Vibration** - Cihazın titreşim motorunu milisaniye ve genlik bazında kontrol etme.
*   **Math Expressions** - Bilimsel formüllerin parantez hiyerarşisine göre analiz edilip çözümlenmesi.

---

**Made by Arda Bölükbaşı**  
*Bu proje bir pair-programming kodlama çalışması olup en yüksek performans ve kullanıcı deneyimi hedeflenerek geliştirilmiştir.*
