MilesAway, dziennik podróży
Projekt aplikacji turystycznej będącej osobistym dziennikiem podróży. Docelowo użytkownik będzie dokumentować odbyte podróże, oglądać je na interaktywnej mapie i przeglądać statystyki z całej historii lub wybranego roku.

Po kilku latach korzystania z aplikacji można otworzyć mapę i zobaczyć wszystkie podróże, odwiedzone kraje oraz statystyki pokazujące, jak podróżowaliśmy na przestrzeni lat.

Funkcjonalności
Konta użytkowników
Rejestracja, logowanie i wylogowywanie
Edycja podstawowych danych profilu
Przełączanie Profilu na publiczny lub prywatny
Przeglądanie podróży innych użytkowników (tylko profile publiczne)
Zarządzanie podróżami
Dodawanie, edycja i usuwanie podróży
Nazwa, data lub zakres dat, opis
Dowolna liczba punktów i odcinków w podróży
Ustalanie kolejności miejsc i środka transportu dla każdego odcinka
Przykład podróży:

Legnica → Berlin (samochód)
Berlin → Majorka (samolot)
Zwiedzanie Majorki, kilka punktów (samochód)
Majorka → Berlin (samolot)
Berlin → Legnica (samochód)
Środki transportu (planowane)
Transport	Prezentacja na mapie	Obliczanie dystansu
Samochód	Trasa po rzeczywistej sieci dróg	Z API wyznaczającego trasy
Samolot	Łuk między punktami	Odległość po kuli ziemskiej
Pociąg	Linia prosta	Odległość w linii prostej
Inne	Uproszczone połączenie	Odległość w linii prostej
Interaktywna mapa
Pojedyncza podróż z punktami i odcinkami
Rozróżnienie transportu kolorami, ikonami lub stylem linii
Wszystkie podróże użytkownika na jednej mapie
Automatyczne oznaczanie odwiedzonych państw na podstawie zapisanych podróży
Przybliżanie mapy i podgląd szczegółów tras
Statystyki
Dla całej historii oraz dla wybranego roku kalendarzowego:

liczba odbytych podróży
liczba i lista odwiedzonych państw (wyróżnione na mapie)
łączna liczba przebytych kilometrów
dystans według środka transportu
liczba odwiedzonych miejsc
Architektura
flowchart TD
    M["Flutter / Dart"] -->|"HTTPS / JSON / token Sanctum"| A["Laravel API"]
    W["Przeglądarka administratora"] -->|"Sesja webowa"| F["Panel Filament"]
    A --> S["Reguły domenowe i autoryzacja"]
    F --> S
    S --> D["PostgreSQL 16"]
    S --> E["Geokodowanie i routing"]
Aplikacja składa się z backendu Laravel oraz mobilnej aplikacji Flutter. Docelowo aplikacja mobilna będzie korzystać ze wspólnego REST API (/api/v1).

backend/    # Laravel: REST API
mobile/     # Aplikacja mobilna Flutter
docker/     # Konfiguracja środowiska kontenerowego (Nginx, PHP, Node)
docs/       # Dokumentacja projektu

Stack technologiczny
| Warstwa | Technologia |
| --- | --- |
| Backend / API | PHP 8.3+, Laravel 12 |
| Uwierzytelnianie API | Laravel Sanctum |
| Panel administracyjny | Laravel Filament; wersja do przypięcia po sprawdzeniu zgodności |
| Aplikacja mobilna | Flutter + Dart, środowisko Android Studio |
| Baza danych | PostgreSQL 16 |
| Kontenery | Docker, Docker Compose |
| Mapa webowa, jeśli potrzebna w panelu | Leaflet lub MapLibre GL JS — do ustalenia |
| Mapa mobilna | Pakiet Flutter do ustalenia, np. integracja MapLibre; decyzja oddzielna od biblioteki JavaScript |
| Routing samochodowy | OpenRouteService lub OSRM — do ustalenia |
| Geokodowanie | Nominatim, Photon lub inny dostawca — do ustalenia |
| Granice państw | GeoJSON, np. Natural Earth; zbiór i wersja do ustalenia |
| Testy backendu | PHPUnit |
| Testy mobilne | Propozycja: flutter_test oraz integration_test; decyzja zespołu |
| Jakość kodu | Laravel Pint; propozycja dla Fluttera: dart format i flutter analyze |
| Automatyzacja | GitHub Actions; CI do przygotowania, wdrożenie CD po wyborze hostingu |

Wymagania
Docker Desktop (z obsługą Docker Compose v2)
Git
(Opcjonalnie do pracy bez kontenerów: PHP >= 8.3 i Composer, Node.js 22.18+ (lub 24.12+) i npm, PostgreSQL 16).

Uruchomienie lokalne (Docker)
Sklonuj repozytorium:

git clone <url-repo>
cd dziennik
Skonfiguruj zmienne środowiskowe:

cp .env.example .env
cp .env backend/.env
cp frontend/.env.example frontend/.env
Główny .env dostarcza zmienne dla Docker Compose, a backend/.env jest używany przez Laravel. Oba pliki muszą mieć zgodne wartości DB_*. Ustaw niepuste lokalne DB_PASSWORD w głównym .env przed uruchomieniem bazy.

Zbuduj i uruchom kontenery w tle:

docker compose up -d --build
Zainstaluj zależności backendu:

docker compose exec backend composer install
Zainicjalizuj backend wewnątrz kontenera:

# Sprawdź, czy backend/.env zawiera klucz; wygeneruj go tylko, jeśli jest pusty
docker compose exec backend sh -c 'if grep -q "^APP_KEY=." .env; then echo "APP_KEY jest ustawiony"; else echo "APP_KEY jest pusty — generuję klucz"; php artisan key:generate; fi'

# Odtwórz backend, aby kontener wczytał APP_KEY z pliku backend/.env
docker compose up -d --force-recreate backend

# Sprawdź, czy klucz jest dostępny w środowisku kontenera (bez wypisywania wartości)
docker compose exec backend php -r "echo getenv('APP_KEY') ? 'APP_KEY jest ustawiony' : 'APP_KEY jest pusty';"

# Wykonanie migracji bazy i seedera
docker compose exec backend php artisan migrate --seed
Dostęp do aplikacji
Frontend (Vue/Vite): http://localhost:5173 (z hot-reloadem Vite)
Backend (API / Nginx): http://localhost:8000
Baza danych (PostgreSQL): localhost:5432 (baza, użytkownik i hasło zgodne z głównym .env)
Przydatne polecenia Docker
# Zatrzymanie kontenerów
docker compose down

# Podgląd logów wszystkich usług
docker compose logs -f

# Wejście do powłoki kontenera backendu
docker compose exec backend sh

# Uruchamianie komend Artisan
docker compose exec backend php artisan <komenda>
Konfiguracja
Zmienne środowiskowe ustawiasz w plikach .env (nie commituj ich do repozytorium). Wartości w głównym .env i backend/.env muszą być zgodne. Lokalnego hasła do bazy nie używaj na środowisku produkcyjnym.

W pliku backend/.env dla środowiska Docker hostem bazy danych jest nazwa kontenera postgres:

DB_CONNECTION=pgsql
DB_HOST=postgres
DB_PORT=5432
DB_DATABASE=dziennik
DB_USERNAME=dziennik_user
DB_PASSWORD=local_dev_password
Zmienna	Opis
DB_*	Dane połączenia z bazą (backend)
ROUTING_API_KEY	Klucz do API wyznaczania tras (do skonfigurowania, gdy funkcja zostanie wdrożona)
GEOCODING_API_KEY	Klucz do API geokodowania (do skonfigurowania, gdy funkcja zostanie wdrożona)
VITE_API_BASE_URL	Bazowy adres API frontendu (domyślnie http://localhost:8000/api/v1)
Testy i jakość kodu
Polecenia lokalne uruchamiamy w kontenerach:

# Backend
docker compose exec backend php artisan test
docker compose exec backend ./vendor/bin/pint --test

# Frontend
docker compose exec frontend npm run lint
docker compose exec frontend npm run test
docker compose exec frontend npm run build
GitHub Actions uruchamia testy backendu i build frontendu dla PR. Zmiany w frontend/ uruchamiają dodatkowo workflow lint/test/build frontendu; osobny workflow sprawdza formatowanie backendu. Mimo to przed wysłaniem PR uruchom lokalnie wszystkie kontrole z powyższej listy.

Współpraca
Zasady współpracy opisuje CONTRIBUTING.md, procedura realizacji zadań jest w TASK_ins.md, a backlog w TASK.md.

Licencja
Projekt udostępniany na licencji MIT. Szczegóły w pliku LICENSE.
