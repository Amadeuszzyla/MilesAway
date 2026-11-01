# TASK_ins.md — instrukcja wykonywania zadań

Ten dokument opisuje pracę nad zadaniem w projekcie **MilesAway**: od wyboru Issue, przez implementację i testy, do przeglądu kodu i zamknięcia zadania.

Powiązane dokumenty:

- [CONTRIBUTING.md](CONTRIBUTING.md) — zasady współpracy, Git i standardy kodu.
- [README.md](README.md) — opis projektu i konfiguracja środowiska.
- [Dokumentacja](docs/) — kontrakt API, decyzje i pozostałe materiały projektowe.

Aktualny zakres zadania, zależności i kryteria akceptacji znajdują się w **GitHub Issues**.

## Zespół

| Osoba | GitHub | Główne obszary |
| --- | --- | --- |
| Amadeusz Żyła | [@Amadeuszzyla](https://github.com/Amadeuszzyla) | Aplikacja mobilna, dokumentacja, konfiguracja i utrzymanie VPS |
| Adrian Jurak | [@AdrianJurak](https://github.com/AdrianJurak) | Backend i API |
| Kyril Ryab | [@KirilRyab](https://github.com/KirilRyab) | Aplikacja mobilna |

Każde Issue ma konkretną osobę przypisaną w **Assignees**. Zadania panelu Filament również wymagają przypisania wykonawcy.

Główne obszary odpowiedzialności nie wykluczają wspólnej pracy ani wykonywania review innych części systemu.

## Szybka ściągawka

### Rozpoczęcie pracy

Najpierw upewnij się, że nie masz niezapisanych zmian:

```bash
git status
git switch main
git pull --ff-only
git switch -c feature/123-trip-editor
```

`123` zastąp rzeczywistym numerem GitHub Issue.

### Zapis zmian

```bash
git status
git diff
git add -p
git diff --cached
git commit -m "feat(trips): dodaj edytor podróży"
```

Nowe pliki dodaj osobno przez `git add SCIEZKA_PLIKU`. Przed commitem sprawdź, co zostało przygotowane do zapisu.

### Kontrole backendu

Z katalogu głównego repozytorium, przy działającej usłudze `backend`:

```bash
docker compose exec backend php artisan test
docker compose exec backend ./vendor/bin/pint --test
```

### Kontrole aplikacji mobilnej

Z katalogu `mobile/`:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter build apk --debug
```

Uruchamiaj kontrole odpowiednie dla zmiany. Testy Flutter wykonujemy na komputerze deweloperskim, a backendu — w kontenerze.

### Wysłanie gałęzi

```bash
git push -u origin feature/123-trip-editor
```

Następnie otwórz Pull Request do `main` przez interfejs GitHub lub GitHub CLI.

## Zasady ogólne

1. **Jedno spójne zadanie realizujemy na osobnej gałęzi i w osobnym PR.** Większą funkcję dzielimy na powiązane Issues.
2. **Nie pushujemy bezpośrednio do `main`.**
3. Realizujemy ustalony zakres. Niezwiązane pomysły i błędy zapisujemy jako osobne Issues.
4. Niejasności wpływające na zachowanie aplikacji wyjaśniamy przed implementacją.
5. Aplikacja Flutter korzysta z API Laravel pod przyjętym prefiksem `/api/v1`.
6. Panel Filament działa w Laravel i korzysta ze wspólnych reguł domenowych. Nie musi wykonywać żądań HTTP do własnego API.
7. Nie commitujemy sekretów, plików `.env` ani rzeczywistych danych użytkowników.
8. Zmiana kontraktu API wymaga aktualizacji dokumentacji i poinformowania osób pracujących nad aplikacją mobilną.
9. Stan zadania aktualizujemy na bieżąco.

## Cykl życia zadania

| Status | Znaczenie |
| --- | --- |
| Backlog | Zadanie oczekuje na doprecyzowanie lub ustalenie kolejności. |
| Do zrobienia | Zakres jest jasny i spełnia Definition of Ready. |
| W trakcie | Przypisana osoba pracuje nad zadaniem. |
| Review | PR jest gotowy do przeglądu. |
| Gotowe | Spełniono Definition of Done, kod scalono, a Issue zamknięto. |

Blokadę oznaczamy osobnym statusem lub etykietą `blocked` i opisujemy w komentarzu.

Jeśli zespół nie korzysta z GitHub Projects, wystarczą Issues, przypisania, etykiety i milestones. Brak dostępu do Projects nie powinien zatrzymywać pracy.

### Definition of Ready

Zadanie jest gotowe do rozpoczęcia, gdy:

- ma jasno opisany cel i zakres,
- zawiera sprawdzalne kryteria akceptacji,
- wskazuje zależności,
- ma ustalone wymagane decyzje biznesowe i techniczne,
- ma przypisaną osobę odpowiedzialną,
- opisuje sposób weryfikacji,
- przy zmianach między backendem a aplikacją mobilną ma uzgodniony kontrakt API.

Zależność nie zawsze wyklucza pracę równoległą. Można rozpocząć niezależną część, jeśli kontrakt jest ustalony, a ograniczenia zapisane w Issue.

### Definition of Done

Zadanie jest ukończone, gdy:

- spełniono wszystkie kryteria akceptacji,
- odpowiednie testy i kontrole jakości przechodzą,
- sprawdzono działanie zmienionej funkcji,
- zaktualizowano dokumentację,
- rozwiązano uwagi z review,
- co najmniej jedna osoba z zespołu zaakceptowała PR,
- wymagane kontrole CI przeszły,
- zmiany zostały scalone do `main`,
- zamknięto Issue i zaktualizowano status.

Samo utworzenie PR lub ukończenie ekranu z danymi demonstracyjnymi nie oznacza zakończenia funkcji wymagającej integracji z API.

## Krok po kroku

### 1. Wybierz i zrozum zadanie

- Wybierz Issue ze statusu „Do zrobienia”.
- Przypisz je do siebie.
- Przeczytaj cel, zakres, kryteria akceptacji i zależności.
- Sprawdź, czy ktoś już nie pracuje nad tym samym fragmentem.
- Ustal, które części dotyczą backendu, aplikacji mobilnej, panelu lub infrastruktury.
- Jeśli zależność blokuje implementację, opisz blokadę albo uzgodnij niezależny zakres pracy.

Przykładowo: edytor podróży we Flutterze może powstawać przed zakończeniem API, jeśli zespół uzgodnił format punktów, odcinków, transportu i błędów walidacji.

### 2. Przygotuj środowisko

Sprawdź lokalne zmiany i pobierz aktualne `main`:

```bash
git status
git switch main
git pull --ff-only
```

Jeśli środowisko jest już skonfigurowane:

```bash
docker compose up -d
docker compose ps
```

Przy pierwszym uruchomieniu postępuj zgodnie z [README.md](README.md).

Dla aplikacji mobilnej, z katalogu `mobile/`:

```bash
flutter pub get
flutter devices
```

Sprawdź, czy aplikacja używa właściwego adresu API.

Nie generuj ponownie istniejącego `APP_KEY` ani nie resetuj bazy przy każdym rozpoczęciu pracy.

### 3. Utwórz gałąź

Format:

```text
typ/numer-issue-krotki-opis
```

Przykład:

```bash
git switch -c feature/123-trip-editor
```

| Prefiks | Zastosowanie |
| --- | --- |
| `feature/` | Nowa funkcja |
| `fix/` | Poprawka błędu |
| `refactor/` | Zmiana struktury kodu |
| `test/` | Testy |
| `chore/` | Konfiguracja i utrzymanie |
| `docs/` | Dokumentacja |

Używamy małych liter i myślników, bez spacji i polskich znaków.

Kody backlogu, np. `PR-8` lub `BE-1`, nie są numerami nadanymi przez GitHub. W nazwie gałęzi stosujemy rzeczywisty numer Issue.

### 4. Pracuj w małych krokach

Każdy commit powinien obejmować jedną logiczną zmianę.

Format:

```text
typ: krótki opis w trybie rozkazującym
```

Opcjonalnie wskaż obszar:

```text
typ(obszar): krótki opis
```

Przykłady:

```text
feat(trips): dodaj model podróży
feat(mobile): dodaj wybór transportu dla odcinka
fix(auth): unieważnij token przy wylogowaniu
test(stats): sprawdź podróż na przełomie roku
docs(api): opisz tworzenie podróży
chore(docker): skonfiguruj PostgreSQL
```

Dozwolone typy: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`.

Przed commitem sprawdź:

```bash
git diff
git diff --cached
```

Nie dodawaj przypadkowo plików środowiskowych, logów, zależności ani wyników budowania.

### 5. Implementuj zgodnie z zasadami projektu

#### Backend — Laravel i Sanctum

- Walidacja żądań w Form Requests.
- Logika domenowa w serwisach lub klasach akcji.
- Niewielkie kontrolery.
- Odpowiedzi przez API Resources.
- Spójny JSON i właściwe kody HTTP.
- Endpointy pod `/api/v1`.
- Autoryzacja po stronie serwera, np. przez Policies.
- Migracje dla zmian schematu bazy.
- Transakcje dla powiązanych zmian punktów i odcinków.
- Oddzielone integracje routingu i geokodowania.

Formatowanie:

```bash
docker compose exec backend ./vendor/bin/pint
```

#### Panel administracyjny — Filament

- Dostęp tylko dla uprawnionych administratorów.
- Autoryzacja każdej operacji, niezależnie od widoczności przycisków.
- Wspólne reguły domenowe z API.
- Poprawne przeliczanie tras i statystyk po zmianie danych.
- Dostęp do prywatnych podróży zgodny z zatwierdzonym zakresem uprawnień.
- Brak ujawniania haseł i tokenów w panelu.

#### Aplikacja mobilna — Flutter i Dart

- Oddzielone widoki, logika stanu i komunikacja z API.
- Wywołania HTTP przez wspólnego klienta lub warstwę repozytoriów.
- Współdzielone komponenty, motyw i style.
- Obsługa ładowania, pustych danych, błędów i ponowienia operacji.
- Walidacja formularzy i prezentowanie błędów API.
- Bezpieczne przechowywanie tokenów.
- Obsługa utraty ważności sesji.
- Konfigurowalny adres backendu.
- Spójny wygląd MilesAway zgodny z przyjętymi makietami.

Z katalogu `mobile/`:

```bash
dart format .
flutter analyze
```

#### Dla wszystkich obszarów

- Dobierz testy do zachowania i ryzyka zmiany.
- Przy poprawce błędu dodaj test regresyjny, jeśli jest to uzasadnione.
- Usuń tymczasowe `dd()`, `dump()`, `print()` i `debugPrint()` używane do diagnostyki.
- Nie usuwaj potrzebnego logowania operacyjnego; zadbaj, aby nie zawierało sekretów.
- Nie zostawiaj martwego kodu ani zakomentowanych starych implementacji.
- Nie rozszerzaj zakresu o niezwiązane funkcje.

### 6. Koordynuj backend i aplikację mobilną

Gdy funkcja wymaga obu części:

1. Uzgodnijcie kontrakt API przed implementacją.
2. Zapiszcie go w dokumentacji w `docs/`.
3. Podzielcie pracę na powiązane Issues i osobne gałęzie.
4. Przygotujcie wspólne przykłady danych i błędów.
5. Po wdrożeniu API sprawdźcie integrację na rzeczywistym środowisku testowym.

Kontrakt powinien określać:

- metodę i ścieżkę endpointu,
- wymagane uwierzytelnianie,
- parametry i pola wejściowe,
- schemat odpowiedzi,
- walidację i błędy,
- jednostki i format dat,
- paginację i filtrowanie, jeśli dotyczą operacji,
- zasady prywatności.

W MilesAway należy szczególnie uzgodnić:

- format i kolejność punktów,
- transport przypisany do odcinka,
- zapis współrzędnych,
- stan obliczania trasy,
- oznaczanie nieznanego lub przybliżonego dystansu,
- zasady liczenia statystyk rocznych.

Przy zmianie kontraktu oznacz zainteresowane osoby w komentarzu:

- `@AdrianJurak` — backend i API,
- `@Amadeuszzyla` oraz `@KirilRyab` — aplikacja mobilna.

Dane testowe umożliwiają pracę równoległą, ale nie zastępują końcowej weryfikacji integracji.

### 7. Sprawdź zmianę przed PR

#### Backend i panel

Z katalogu głównego repozytorium:

```bash
docker compose exec backend php artisan test
docker compose exec backend ./vendor/bin/pint --test
```

Testy bazodanowe muszą korzystać z oddzielnej bazy testowej.

#### Aplikacja mobilna

Z katalogu `mobile/`:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

Jeżeli zmiana wpływa na budowanie aplikacji:

```bash
flutter build apk --debug
```

Jeżeli skonfigurowano testy integracyjne i zmiana ich dotyczy:

```bash
flutter test integration_test
```

Testy integracyjne wymagają urządzenia lub emulatora.

#### Lista kontrolna

- [ ] Kryteria akceptacji zostały sprawdzone.
- [ ] Odpowiednie testy i kontrole jakości przechodzą.
- [ ] Funkcja działa z rzeczywistym API, jeśli obejmuje integrację.
- [ ] Obsłużono błędy, brak danych i ładowanie.
- [ ] Sprawdzono prywatność i uprawnienia, jeśli zmiana ich dotyczy.
- [ ] Dokumentacja API jest aktualna.
- [ ] Zmiany konfiguracji i migracje zostały opisane.
- [ ] Nie dodano sekretów ani prywatnych danych.
- [ ] Nie wprowadzono przypadkowych zmian poza zakresem.

Dla zadania dokumentacyjnego sprawdź treść, linki i przykłady. Kontrole niezwiązane ze zmianą oznacz jako „nie dotyczy”.

### 8. Wypchnij gałąź i otwórz Pull Request

```bash
git push -u origin feature/123-trip-editor
```

Otwórz PR do `main`. Skorzystaj z szablonu `.github/PULL_REQUEST_TEMPLATE.md`, jeśli jest dostępny.

Przykładowy opis:

```markdown
## Cel

Użytkownik może dodać wiele punktów podróży i wybrać transport dla każdego odcinka.

## Zmiany

- Dodano edytor punktów.
- Dodano wybór transportu.
- Połączono formularz z API.

## Powiązane zadanie

Closes #123

## Weryfikacja

- Testy formularza: wynik ...
- Testy klienta API: wynik ...
- Scenariusz podróży mieszanej: wynik ...
- Środowisko / urządzenie: ...

## Konfiguracja i ograniczenia

Opis zmian konfiguracji, migracji i pozostałych ograniczeń albo „Nie dotyczy”.
```

Stosuj:

- `Closes #123` — gdy PR w pełni realizuje zadanie.
- `Refs #123` — gdy realizuje tylko część lub odnosi się do zadania.

Automatyczne zamknięcie przez `Closes` następuje przy scaleniu do domyślnej gałęzi repozytorium. W naszym workflow zakładamy, że jest nią `main`.

### 9. Przeprowadź review

#### Jako autor

- Poproś co najmniej jedną osobę z zespołu o review.
- Odpowiadaj na komentarze i wyjaśniaj decyzje.
- Poprawki dodawaj do tej samej gałęzi.
- Po zmianach ponownie uruchom odpowiednie kontrole.
- Nie scalaj PR bez wymaganej akceptacji.

#### Jako recenzent

- Porównaj zmianę z kryteriami akceptacji.
- Sprawdź logikę, obsługę błędów i przypadki brzegowe.
- Zweryfikuj uprawnienia i prywatność danych.
- Sprawdź zgodność implementacji z kontraktem API.
- Oceń, czy testy sprawdzają zachowanie, a nie tylko strukturę kodu.
- Zwróć uwagę na wpływ migracji i konfiguracji.
- Komentuj konkretnie i uprzejmie.

Dążymy do pierwszej odpowiedzi w ciągu jednego dnia roboczego. Jeśli nie możesz wykonać review, poinformuj autora, aby mógł poprosić inną osobę.

### 10. Scal zmiany i uporządkuj gałąź

Po akceptacji i przejściu wymaganych kontroli:

1. Scal PR przez **Squash and merge**, jeśli repozytorium udostępnia tę metodę.
2. Ustaw tytuł commita w formacie `typ: opis`.
3. Usuń zdalną gałąź przyciskiem na GitHubie.
4. Zaktualizuj lokalne repozytorium:

   ```bash
   git switch main
   git pull --ff-only
   git branch -d feature/123-trip-editor
   ```

Po squash merge Git może odmówić usunięcia lokalnej gałęzi przez `-d`, ponieważ jej historia nie została scalona wprost. Najpierw potwierdź, że PR jest scalony i gałąź nie zawiera dodatkowych zmian. Dopiero wtedy można użyć:

```bash
git branch -D feature/123-trip-editor
```

5. Sprawdź, czy Issue jest zamknięte i ma status „Gotowe”.
6. Uzupełnij zadanie informacją o istotnych ograniczeniach lub dalszych krokach.

## Przypadki szczególnie ważne dla MilesAway

| Obszar | Co trzeba sprawdzić |
| --- | --- |
| Konta | Niepoprawne dane logowania, wylogowanie i ponowne użycie tokenu |
| Prywatność | Odczyt cudzych prywatnych danych po ID i zmiana profilu publicznego na prywatny |
| Podróże | Nazwa, data pojedyncza, zakres dat i opcjonalny opis |
| Punkty | Dodanie, usunięcie, przestawienie oraz powrót do tego samego miejsca |
| Transport | Osobny środek transportu dla każdego odcinka |
| Samochód | Rzeczywista geometria drogi i jawna obsługa braku trasy |
| Samolot | Łuk na mapie i poprawnie oznaczony przybliżony dystans |
| Państwa | Powtórzenia, wyspy, nierozpoznany kraj i zgodność listy z mapą |
| Statystyki | Pusta historia, różne lata, podróż na przełomie roku i przeliczenie po zmianach |
| Panel | Brak dostępu zwykłego użytkownika i zachowanie wspólnych reguł domenowych |
| Historia podróży | Paginacja i brak pomijania danych na mapie zbiorczej |

Oczekiwane wyniki muszą odpowiadać zatwierdzonym regułom biznesowym. Nie ustalamy ich niezależnie w backendzie i aplikacji mobilnej.

## Wątpliwości, blokady i zmiany zakresu

| Sytuacja | Działanie |
| --- | --- |
| Niejasne wymaganie | Zadaj pytanie w Issue i oznacz właściwą osobę. |
| Zadanie jest za duże | Zaproponuj podział na mniejsze, powiązane Issues. |
| Zależność blokuje pracę | Opisz blokadę, dodaj link i oznaczenie `blocked`. |
| Można pracować niezależnie | Uzgodnij zakres równoległy i kontrakt, zapisz ustalenia w Issue. |
| Błąd poza zakresem | Utwórz osobne Issue opisujące błąd. |
| Pomysł na rozszerzenie | Dodaj Issue do Backlogu, bez automatycznego rozszerzania bieżącej pracy. |
| Konieczna zmiana zakresu | Uzgodnij ją z osobami odpowiedzialnymi i zaktualizuj kryteria akceptacji. |
| Zmiana API wpływa na Flutter | Zaktualizuj kontrakt i oznacz osoby pracujące nad aplikacją. |
| Problem z VPS | Opisz objawy i środowisko, oznacz `@Amadeuszzyla`; nie publikuj danych dostępowych. |
| Nie wiadomo, czy zacząć | Sprawdź Definition of Ready i brakujące decyzje. |

Jeśli przez 1–2 godziny nie możesz ruszyć dalej, poproś zespół o pomoc. Podaj, co sprawdzono, jaki jest błąd i czego potrzebujesz.

### Konflikt z `main`

Przed aktualizacją gałęzi zapisz bieżącą pracę.

Dla opublikowanej gałęzi można pobrać zmiany i scalić `main`:

```bash
git fetch origin
git merge origin/main
```

Rozwiąż konflikty, sprawdź wynik i uruchom odpowiednie testy.

Nie wybieraj automatycznie jednej strony konfliktu bez zrozumienia zmian. Rebase opublikowanej lub współdzielonej gałęzi uzgodnij z osobami, które z niej korzystają.

## Kontrole automatyczne

Docelowo GitHub Actions powinno sprawdzać:

- testy backendu,
- formatowanie PHP przez Laravel Pint,
- formatowanie Dart,
- analizę statyczną Flutter,
- testy aplikacji mobilnej,
- build Android.

Aktualny zakres kontroli określają pliki w `.github/workflows/`.

Nie zakładamy istnienia konkretnych plików workflow, audytu zależności ani konfiguracji Dependabot, dopóki nie zostaną dodane i zweryfikowane.

Przed scaleniem muszą przejść wszystkie kontrole wymagane dla danego PR. Zasady opisane w dokumentacji nie zastępują ustawienia ochrony gałęzi przez właściciela repozytorium.

## Najczęstsze błędy

- Praca bezpośrednio na `main`.
- Duży PR zawierający wiele niezwiązanych zmian.
- Rozpoczęcie implementacji bez jasnych kryteriów akceptacji.
- Zmiana API bez aktualizacji dokumentacji i informacji dla osób od Fluttera.
- Uznanie ekranu z danymi testowymi za ukończoną integrację.
- Logika domenowa powielona w API i panelu Filament.
- Wywołania HTTP rozproszone po widgetach Flutter.
- Kontrola prywatności wyłącznie przez ukrycie elementów interfejsu.
- Brak przeliczenia tras i statystyk po zmianie podróży.
- Przedstawienie braku routingu jako dystansu zero.
- Commit pliku `.env`, kluczy API lub danych użytkowników.
- Uruchamianie testów na niewłaściwej bazie.
- Zamknięcie Issue mimo niespełnionych kryteriów.
- Usunięcie gałęzi bez sprawdzenia, czy wszystkie zmiany zostały zachowane.
