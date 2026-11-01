# Współpraca przy MilesAway

Ten dokument opisuje zasady pracy nad aplikacją mobilną MilesAway, API oraz webowym panelem administracyjnym.

Instrukcja uruchomienia znajduje się w [README.md](README.md). Zadania, kryteria akceptacji i zależności śledzimy w GitHub Issues.

## Zespół i odpowiedzialność

| Osoba | GitHub | Główne obszary |
| --- | --- | --- |
| Amadeusz Żyła | [@Amadeuszzyla](https://github.com/Amadeuszzyla) | Aplikacja mobilna, dokumentacja, konfiguracja i utrzymanie serwera VPS |
| Adrian Jurak | [@AdrianJurak](https://github.com/AdrianJurak) | Backend i API |
| Kyril Ryab | [@KirilRyab](https://github.com/KirilRyab) | Aplikacja mobilna |

Osobę odpowiedzialną za konkretne zadanie przypisujemy w polu **Assignees** w GitHub Issues. Zadania panelu Filament również wymagają jawnego przypisania.

Podział obszarów nie wyklucza wspólnej pracy ani przeglądania zmian innych członków zespołu.

## Struktura repozytorium

Przyjęty układ projektu:

```text
backend/    # Laravel: REST API, Sanctum i panel Filament
mobile/     # Aplikacja mobilna Flutter / Dart
docker/     # Pliki konfiguracji środowiska kontenerowego
docs/       # Dokumentacja projektu i API
.github/    # Szablony Issues, Pull Requestów i workflow GitHub Actions
```

Lokalizację pliku `compose.yaml` oraz nazwy usług określa konfiguracja repozytorium.

Aplikacja Flutter komunikuje się z API Laravel. Przyjęty prefiks endpointów to `/api/v1`.

Panel Filament działa w aplikacji Laravel i korzysta ze wspólnych reguł domenowych. Nie wymaga osobnego frontendu Vue.

## Pierwsze kroki

### 1. Sklonuj repozytorium

Zastąp `URL_REPOZYTORIUM` właściwym adresem:

```bash
git clone URL_REPOZYTORIUM MilesAway
cd MilesAway
```

### 2. Przygotuj konfigurację

Jeśli repozytorium zawiera poniższe pliki przykładowe:

```bash
cp .env.example .env
cp backend/.env.example backend/.env
```

Nie nadpisuj istniejących plików z własną konfiguracją.

- Główny `.env` zawiera wartości wykorzystywane przez Docker Compose.
- `backend/.env` zawiera konfigurację Laravel.
- Dane połączenia Laravel muszą odpowiadać konfiguracji usługi PostgreSQL.
- Ustaw własne, niepuste lokalne hasło do bazy.
- Nie kopiuj automatycznie całego głównego `.env` do `backend/.env`.
- Nigdy nie commituj plików `.env` zawierających dane dostępowe.

### 3. Uruchom backend i bazę danych

Polecenia zakładają usługę o nazwie `backend` i są wykonywane z katalogu zawierającego `compose.yaml`:

```bash
docker compose up -d --build
docker compose ps
```

Jeżeli obraz nie instaluje zależności podczas budowania:

```bash
docker compose exec backend composer install
```

Przy pierwszym uruchomieniu wygeneruj klucz aplikacji, **tylko jeśli `APP_KEY` jest pusty**:

```bash
docker compose exec backend php artisan key:generate
```

Następnie:

```bash
docker compose exec backend php artisan config:clear
docker compose exec backend php artisan migrate
```

Jeżeli projekt zawiera seedery z lokalnymi danymi demonstracyjnymi:

```bash
docker compose exec backend php artisan db:seed
```

Nie uruchamiaj seederów na środowisku produkcyjnym bez sprawdzenia ich działania.

Jeśli Compose przekazuje `APP_KEY` jako zmienną środowiskową, zastosuj dodatkowe kroki opisane w README. Wygenerowanie klucza w pliku nie zastępuje wartości przekazanej bezpośrednio do kontenera.

### 4. Uruchom aplikację mobilną

W osobnym terminalu:

```bash
cd mobile
flutter doctor
flutter pub get
flutter devices
```

Uruchom emulator Android lub podłącz urządzenie.

Jeśli klient API obsługuje konfigurację `API_BASE_URL` przez `--dart-define`:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000/api/v1
```

Adres jest przykładem dla standardowego emulatora Android Studio. Na telefonie należy użyć dostępnego adresu komputera w sieci lokalnej albo adresu serwera.

Szczegóły konfiguracji portów, panelu Filament i połączenia z API znajdują się w [README.md](README.md).

## Praca z Gitem — krok po kroku

1. Wybierz Issue, sprawdź zależności i przypisz zadanie do siebie.
2. Upewnij się, że bieżące zmiany są zapisane lub zabezpieczone.
3. Zaktualizuj `main` i utwórz gałąź:

   ```bash
   git switch main
   git pull --ff-only
   git switch -c feature/123-trip-editor
   ```

   `123` zastąp rzeczywistym numerem Issue.

4. Pracuj w małych, spójnych krokach.
5. Sprawdzaj zmiany przed commitem:

   ```bash
   git status
   git diff
   ```

6. Uruchom kontrole odpowiednie dla zmienianej części projektu.
7. Wypchnij gałąź:

   ```bash
   git push -u origin feature/123-trip-editor
   ```

8. Otwórz Pull Request do `main`, korzystając z szablonu `.github/PULL_REQUEST_TEMPLATE.md`, jeśli jest dostępny.
9. Powiąż PR z zadaniem i poproś członka zespołu o review.
10. Nanieś poprawki.
11. Po akceptacji i przejściu wymaganych kontroli scal PR metodą squash, jeśli jest dostępna, i usuń zakończoną gałąź.

**Nie pushujemy zmian bezpośrednio do `main`.**

Nie nadpisujemy cudzej historii gałęzi. Zmiany wymagające współpracy kilku osób uzgadniamy w Issue lub PR.

## Nazwy gałęzi

Format:

```text
typ/numer-issue-krotki-opis
```

Stosujemy małe litery, myślniki i nazwy bez polskich znaków.

| Typ | Przeznaczenie | Przykład |
| --- | --- | --- |
| `feature` | Nowa funkcja | `feature/123-trip-editor` |
| `fix` | Poprawka błędu | `fix/124-profile-privacy` |
| `refactor` | Zmiana struktury kodu | `refactor/125-routing-service` |
| `test` | Testy | `test/126-trip-statistics` |
| `chore` | Konfiguracja i utrzymanie | `chore/127-docker-setup` |
| `docs` | Dokumentacja | `docs/128-api-documentation` |

Kody backlogu, np. `PR-8` lub `BE-1`, nie są numerami GitHub Issues ani pull requestów. W nazwie gałęzi używamy numeru Issue nadanego przez GitHub.

## Commity

Format:

```text
typ: krótki opis w trybie rozkazującym
```

Opcjonalnie można wskazać obszar:

```text
typ(obszar): krótki opis
```

Przykłady:

```text
feat(auth): dodaj logowanie przez Sanctum
feat(mobile): dodaj formularz podróży
fix(map): popraw prezentację odcinka lotniczego
test(stats): dodaj przypadek podróży na przełomie roku
docs: uzupełnij instrukcję uruchomienia
chore: skonfiguruj środowisko Docker
```

Dozwolone typy:

- `feat`,
- `fix`,
- `refactor`,
- `test`,
- `docs`,
- `chore`.

Commit powinien obejmować spójną zmianę. Unikamy opisów takich jak `update`, `poprawki` lub `działa`.

## Zasady dla kodu

### Backend — Laravel i Sanctum

- Walidację żądań wydzielamy do Form Requests.
- Logikę domenową umieszczamy w serwisach lub klasach akcji; kontrolery pozostają niewielkie.
- Odpowiedzi API przygotowujemy przez API Resources, ze spójnym formatem JSON i właściwymi kodami HTTP.
- Endpointy udostępniamy pod prefiksem `/api/v1`.
- Uwierzytelnianie aplikacji mobilnej opieramy na tokenach Sanctum.
- Autoryzację realizujemy po stronie serwera, np. przez Policies i Gates.
- Nie ufamy przekazanemu przez klienta właścicielowi zasobu, roli administratora ani wyliczonemu dystansowi.
- Zmiany schematu bazy zapisujemy w migracjach.
- Powiązane zmiany punktów i odcinków zapisujemy atomowo.
- Integracje z routingiem i geokodowaniem wydzielamy od logiki kontrolerów.
- Obsługujemy błędy i limity dostawców zewnętrznych.

Formatowanie kodu:

```bash
docker compose exec backend ./vendor/bin/pint
```

### Panel administracyjny — Filament

- Panel znajduje się w projekcie Laravel.
- Dostęp wymaga jawnie przyznanych uprawnień administratora.
- Ukrycie przycisku lub menu nie zastępuje autoryzacji operacji.
- Zmiany wykonywane przez panel korzystają ze wspólnych reguł domenowych.
- Edycja podróży przez administratora musi poprawnie aktualizować geometrie, dystanse i statystyki.
- Zakres dostępu do prywatnych podróży musi być zgodny z zatwierdzonymi zasadami projektu.
- Hasła i tokeny nie mogą być ujawniane w widokach panelu.

### Aplikacja mobilna — Flutter i Dart

- Oddzielamy widoki od komunikacji z API i logiki stanu.
- Stosujemy konwencje Dart: klasy w `UpperCamelCase`, pliki w `lower_snake_case`.
- Wspólne komponenty, motyw i style przechowujemy w jednym miejscu.
- Formularze obsługują walidację oraz błędy zwracane przez API.
- Ekrany uwzględniają ładowanie, brak danych, błąd i możliwość ponowienia operacji.
- Adres API jest konfigurowalny.
- Tokeny przechowujemy za pomocą uzgodnionego mechanizmu bezpiecznego przechowywania.
- Nie zapisujemy tokenów ani danych prywatnych w logach.
- Obsługujemy utratę ważności tokenu i wylogowanie.
- Środki transportu rozróżniamy nie tylko kolorem, ale także ikoną lub stylem linii.
- Zachowujemy spójny styl MilesAway: beż, brąz, złoto, leśna zieleń i elementy paper cut-out.

Formatowanie i analiza, z katalogu `mobile/`:

```bash
dart format .
flutter analyze
```

### Reguły domenowe MilesAway

- Transport przypisujemy do każdego odcinka osobno.
- Trasa samochodowa korzysta z rzeczywistej sieci dróg.
- Połączenie lotnicze przedstawiamy jako łuk.
- Pociąg i inne środki transportu mogą korzystać z uproszczonych połączeń.
- Brak wyniku routingu nie może być przedstawiony jako poprawna trasa o dystansie zero.
- Zmiana punktów, ich kolejności lub transportu wymaga aktualizacji powiązanych obliczeń.
- Edycja i usunięcie podróży muszą aktualizować statystyki oraz odwiedzone państwa.
- Zasady liczenia miejsc, państw i statystyk rocznych muszą być spójne z zatwierdzoną dokumentacją.
- Prywatność obejmuje wszystkie sposoby odczytu danych, również bezpośrednie zapytania po ID.

### Zasady wspólne

- Testy dobieramy do zachowania i ryzyka zmiany.
- Poprawka błędu powinna zawierać test regresyjny, jeśli można go sensownie przygotować.
- Nie commitujemy sekretów, plików `.env`, prywatnych kluczy ani rzeczywistych danych użytkowników.
- Nie dodajemy plików generowanych i katalogów zależności, które powinny być ignorowane przez Git.
- Wersjonujemy właściwe pliki blokady zależności aplikacji, np. `composer.lock` i `pubspec.lock`.
- Nie wprowadzamy niepowiązanych zmian formatowania w PR dotyczącym konkretnej funkcji.
- Nową zależność uzasadniamy w opisie PR.

## Testy i jakość kodu

### Backend

Z katalogu głównego repozytorium:

```bash
docker compose exec backend php artisan test
docker compose exec backend ./vendor/bin/pint --test
```

Testy bazodanowe muszą używać oddzielnej bazy testowej.

Nie uruchamiamy testów czyszczących dane na bazie produkcyjnej ani na bazie z ważnymi danymi deweloperskimi.

### Aplikacja mobilna

Z katalogu `mobile/`:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter build apk --debug
```

Jeśli skonfigurowano testy integracyjne:

```bash
flutter test integration_test
```

Testy integracyjne wymagają działającego emulatora lub urządzenia oraz odpowiednio przygotowanego środowiska testowego.

### Kluczowe przypadki testowe

- Poprawna i niepoprawna rejestracja oraz logowanie.
- Odrzucenie tokenu po wylogowaniu.
- Próba odczytu prywatnych danych innego użytkownika.
- Próba edycji cudzej podróży, również publicznej.
- Zmiana profilu z publicznego na prywatny.
- Dodanie, usunięcie i przestawienie punktów podróży.
- Podróż wykorzystująca kilka środków transportu.
- Awaria geokodera lub silnika routingu.
- Pusta historia podróży.
- Powtarzające się miejsca i państwa.
- Podróż na przełomie roku.
- Aktualizacja statystyk po edycji lub usunięciu podróży.

Testy automatyczne usług zewnętrznych powinny korzystać z kontrolowanych odpowiedzi. Sprawdzenie rzeczywistej integracji wykonujemy osobno, zgodnie z limitami dostawcy.

## Pull Request

Opis PR powinien zawierać:

- problem lub realizowaną potrzebę,
- zakres zmiany i wynikowe zachowanie,
- powiązane Issue,
- sposób oraz wynik weryfikacji,
- zmiany konfiguracji lub bazy danych,
- istotne ograniczenia.

Dla zmian interfejsu warto dołączyć zrzut ekranu lub krótkie nagranie bez prywatnych danych.

Jeżeli PR realizuje całe zadanie:

```text
Closes #123
```

Jeżeli realizuje tylko część:

```text
Refs #123
```

Nie zamykamy zadania automatycznie, jeżeli pozostały niespełnione kryteria akceptacji.

## Przed otwarciem Pull Requesta

Uruchom kontrole właściwe dla zmienianej części projektu.

- [ ] Zmiana działa lokalnie i spełnia kryteria akceptacji.
- [ ] Testy backendu przechodzą, jeśli zmiana dotyczy backendu.
- [ ] Kontrola Laravel Pint przechodzi, jeśli zmieniono PHP.
- [ ] Formatowanie Dart i `flutter analyze` przechodzą, jeśli zmieniono aplikację mobilną.
- [ ] Testy Flutter przechodzą, jeśli zmiana dotyczy aplikacji mobilnej.
- [ ] Build Android został sprawdzony, jeśli zmiana wpływa na budowanie aplikacji.
- [ ] Sprawdzono autoryzację i prywatność, jeśli zmiana dotyczy dostępu do danych.
- [ ] Opis PR wyjaśnia cel, zakres i sposób weryfikacji.
- [ ] PR jest powiązany z właściwym Issue.
- [ ] Dokumentacja API jest aktualna, jeśli zmienił się kontrakt.
- [ ] README i przykładowa konfiguracja są aktualne, jeśli zmiana ich dotyczy.
- [ ] Migracje i ich wpływ na dane zostały opisane.
- [ ] W commitach nie ma sekretów ani rzeczywistych danych użytkowników.

Dla zmian wyłącznie dokumentacyjnych sprawdzamy poprawność treści, linków i przykładów. Kontrole niezwiązane ze zmianą można oznaczyć jako „nie dotyczy”.

## Aktualizacja dokumentacji API

Dokumentację aktualizujemy w tym samym PR co zmianę implementacji.

Dotyczy to w szczególności:

- dodania lub usunięcia endpointu,
- zmiany pól wejścia i odpowiedzi,
- zmiany walidacji,
- zmiany kodów HTTP,
- zmiany uwierzytelniania lub uprawnień,
- zmiany paginacji i filtrów,
- zmiany zasad obliczania statystyk.

Kontrakt opisujemy w uzgodnionym pliku OpenAPI lub dokumentacji Markdown w `docs/`.

Przykłady nie mogą zawierać prawdziwych tokenów ani danych użytkowników. Planowanych endpointów nie przedstawiamy jako wdrożonych.

## GitHub Actions

Docelowe kontrole CI obejmują:

- testy backendu,
- kontrolę formatowania PHP,
- kontrolę formatowania Dart,
- analizę statyczną Flutter,
- testy aplikacji mobilnej,
- build Android.

Rzeczywisty zakres kontroli określają pliki w `.github/workflows/`. Nie zakładamy, że workflow działa, dopóki nie zostanie dodany i zweryfikowany.

Przed scaleniem muszą przejść wszystkie kontrole wymagane dla danego PR.

## Ukończenie zadania

Zadanie uznajemy za ukończone, gdy:

- spełniono kryteria akceptacji,
- przeprowadzono odpowiednie testy lub udokumentowaną weryfikację,
- zaktualizowano dokumentację,
- co najmniej jedna osoba z zespołu zaakceptowała PR,
- zmiany zostały scalone do `main`,
- zaktualizowano stan Issue.

## Zgłaszanie błędów

Zgłoszenie powinno zawierać:

- krótki opis problemu,
- kroki odtworzenia,
- wynik oczekiwany i rzeczywisty,
- wersję lub commit,
- środowisko, urządzenie albo przeglądarkę,
- zanonimizowane logi lub zrzuty, jeśli pomagają odtworzyć błąd.

Nie publikujemy haseł, tokenów ani prywatnych tras użytkowników.

Problem umożliwiający dostęp do cudzych danych zgłaszamy prywatnie właścicielowi repozytorium lub zespołowi przed umieszczeniem szczegółów w publicznym Issue.
