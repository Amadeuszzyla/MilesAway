# TASKS — backlog projektu MilesAway

Stan: plan realizacji. Kody **PR-1–PR-36** identyfikują zadania w tym pliku; nie są numerami GitHub Issues ani Pull Requests.
## Zakres i założenia

- Aplikacja: **Android / Flutter**. Backend: **Laravel, Sanctum, PostgreSQL**. Panel webowy: **Filament**. Infrastruktura: Docker Compose i VPS.
- Panel służy do zarządzania kontami i banami (PR-24) oraz do podglądu podróży i miejsc tylko do odczytu wraz z usuwaniem podróży naruszających zasady (PR-36). Panel nie tworzy ani nie edytuje treści podróży i miejsc.
- Weryfikacja e-maila, reset hasła i usuwanie własnego konta są obowiązkowymi rozszerzeniami przyjętymi przez zespół.
- Obowiązkowe są testy, lint i build. Wdrożenie VPS może być ręczne według sprawdzonego runbooka.
- Planowane po MVP: iOS, nawigacja GPS, idealne odtworzenie faktycznej drogi, planowanie przyszłych podróży, zdjęcia, avatar, biogram, komentarze, obserwowanie, wiadomości i pełny tryb offline.
## Zespół i repozytoria

| Właściciel | Odpowiedzialność |
| --- | --- |
| @AdrianJurak | Backend, API, baza danych i Filament |
| @KirilRyab | Flutter, integracja aplikacji, CI mobile i odbiór |
| @Amadeuszzyla | Flutter: UI/mapy/profil, dokumentacja i VPS |

Repozytoria wskazane w materiałach: API — `AdrianJurak/MilesAway_Travel_Journal_Api`; APP — `Amadeuszzyla/MilesAway`. Zadania backendu i Fluttera są oddzielne; odbiór systemu pozostaje przekrojowy.

## Reguły domeny

| Temat | Obowiązująca reguła |
| --- | --- |
| Podróż | Nazwa, data lub zakres dat, opcjonalny opis, co najmniej jeden punkt. Pojedyncza data oznacza start=end. Tylko odbyte podróże, bez przyszłego zakończenia. |
| Punkty i odcinki | n punktów tworzy n−1 odcinków. Nie wprowadzać małego biznesowego limitu liczby punktów; ograniczenia techniczne muszą być opisane i umożliwiać zapis dużych tras. |
| Typ punktu | `visit` zalicza odwiedziny; `transit` i `shaping` służą przejazdowi/kształtowaniu trasy i nie zaliczają miejsc ani państw. |
| Odwiedzone miejsce | Unikalne `place_id` występujące w punktach visit. Miejsce może być budynkiem, górą lub innym obiektem, także poza miastem. Miasto nie jest kluczem deduplikacji. |
| Tożsamość miejsca | Stabilny identyfikator obiektu dostawcy albo trwały lokalny identyfikator. Ponowny wybór zapisanego miejsca używa tego samego ID. Nazwa i bliskość współrzędnych wskazują kandydatów, lecz same nie scalają różnych obiektów. Nie gwarantujemy automatycznej identyfikacji semantycznej dowolnych ręcznych punktów. |
| Odwiedzony kraj | Kraj punktu visit, rozpoznany z miejsca/współrzędnych i zapisany jako znormalizowany kod. Sam przebieg drogi lub lotu przez kraj nie zalicza odwiedzin. Nierozpoznany kraj jest jawnie oznaczony. |
| Daty punktów | Nie maleją wraz z kolejnością i mieszczą się w zakresie podróży; kilka punktów może mieć tę samą datę. Daty mają semantykę kalendarzową, bez przesuwania między strefami. |
| Rok statystyk | Liczba podróży według roku rozpoczęcia; miejsca i kraje według dat wizyt; cały dystans odcinka według daty wyjazdu z punktu początkowego. Nie dzielimy dystansu na północy. |
| Mapa roku | Pokazuje podróże przecinające wybrany rok; wyróżnienie odwiedzonych krajów wynika z wizyt w tym roku. UI wyjaśnia różnicę wobec licznika podróży według daty startu. |
| Transport | Car: droga i dystans dostawcy routingu. Plane: dystans geodezyjny, wizualnie łuk. Train/other: dystans geodezyjny i uproszczone połączenie. To szacunki, nie zapis GPS. |
| Jednostki | Dystans przechowywany w metrach; kilometry i zaokrąglenia dopiero w prezentacji. |
| Brak obliczeń | `null` i stan pending/failed; suma znanych odcinków jest oznaczona jako niepełna. Podróż bez odcinków ma poprawne zero. |
| Edycja trasy | Atomowy zapis i kontrola revision. Niezmienione pary zachowują transport; nowe pary wymagają wyboru. Nieaktualne joby nie zapisują wyników. |
| Prywatność | Profil domyślnie prywatny. Odczyt cudzych publicznych danych tylko po zalogowaniu, bez e-maila i sekretów. Zmiana prywatności/ban obowiązuje przy kolejnym żądaniu, również przy cache. |
| Moderacja | Admin może przeglądać podróże i miejsca tylko do odczytu oraz usunąć podróż naruszającą zasady po podaniu powodu. Usunięcie jest trwałe, audytowane i nie zmienia innych danych użytkownika; admin nie edytuje treści. |
| Ban | Blokuje dostęp, unieważnia sesje/tokeny i ukrywa publiczne dane; nie usuwa podróży. Unban wymaga nowego logowania i zachowuje wcześniejszą widoczność. |
| Usunięcie konta | Potwierdzenie hasłem, usunięcie danych i sesji. Odtworzenie starej kopii wymaga zastosowania aktualnego rejestru usunięć przed udostępnieniem systemu. |
| Sieć | Formularze zachowują wpisane dane podczas bieżącej pracy po błędzie sieci. Nie jest to pełna synchronizacja offline. |

Przykłady odbioru: ponowne odwiedzenie tej samej góry daje jedno miejsce w całej historii; dwa różne obiekty w Berlinie dają dwa miejsca; punkt tranzytowy nie zwiększa liczby miejsc ani krajów. Podróż rozpoczęta 31 grudnia i zakończona 2 stycznia liczy się w roku rozpoczęcia, natomiast styczniowa wizyta liczy się w styczniu nowego roku.

## Definition of Ready (DoR)

Zadanie może przejść do „Do zrobienia”, gdy:

- [ ] Ma kod, jednoznaczny cel, zakres, właściciela i mierzalne kryteria akceptacji.
- [ ] Zespół zaakceptował rozmiar i oszacował czas implementacji, testów oraz poprawek.
- [ ] Uzgodniono istotne reguły domeny, kontrakt i sposób weryfikacji.
- [ ] Wyniki z kolumny „Zależy od” są dostępne w main; ewentualny wcześniejszy start na kontrakcie/atrapie opisano w Issue.
- [ ] Dostępne są środowisko, dane testowe, uprawnienia i konfiguracja dostawcy albo zaakceptowane atrapy.
- [ ] Dla zadania L uzgodniono kolejność checklist i oceniono czytelność planowanego PR-a. Podział na dodatkowe PR-y wynika z ryzyka lub potrzeby wcześniejszej integracji, nie z liczby checkboxów.

Kolumna „Zależy od” oznacza twarde zależności pełnego odbioru. Praca na kontrakcie pozwala zacząć wcześniej, ale nie zamknąć zadania bez integracji. Fazy są grupami tematycznymi, nie sztywnym harmonogramem.

## Definition of Done (DoD)

- [ ] Wszystkie kryteria Issue są spełnione, a dowody weryfikacji dołączone do PR lub Issue dla zadania bez zmian w repo.
- [ ] Testy powstały razem z implementacją; obejmują istotne błędy, walidację, uprawnienia i prywatność.
- [ ] Wymagane testy, lint i build są zielone. Backend: testy z PostgreSQL, Pint i build obrazu/zasobów; Flutter: format, analyze, test i build Android.
- [ ] Dla dokumentacji przechodzą właściwe walidacje/linki/kompilacja; nie tworzy się fikcyjnych testów funkcjonalnych tekstu.
- [ ] Kontrakt OpenAPI, instrukcje, konfiguracja i migracje są aktualne; nie ma sekretów w kodzie ani logach.
- [ ] Zmiana działa po integracji z wymaganymi zależnościami. Nie traktuje się atrapy jako dowodu działającej integracji produkcyjnej.
- [ ] Jeśli zadanie zmienia repozytorium, PR uzyskał akceptację dwóch pozostałych członków zespołu, wymagane kontrole CI i squash merge do main. Zadanie bez zmian w repo ma udokumentowany wynik odbioru w Issue.
- [ ] Issue zamknięto dopiero po scaleniu wszystkich niezbędnych części; uzupełniono pole „Czas rzeczywisty” i zaktualizowano status.

Bazowe workflow powstają ze szkieletami w PR-2/PR-3; PR-4 domyka kontrole backendu i kontraktu. Nie trzeba czekać na końcowy odbiór, aby testować poszczególne funkcje.

## Cykl pracy

1. **Backlog:** doprecyzowanie zakresu, zależności i przypisania; brak oznaczenia „gotowe” wyłącznie na podstawie tego pliku.
2. **Do zrobienia:** spełniona DoR, uzgodniony rozmiar i czas.
3. **W trakcie:** branch, np. `feat/PR-14-trips-api`, implementacja i testy. Blokadę opisuje komentarz i etykieta `blocked` z zależnością.
4. **Review:** PR z opisem zmiany, dowodami testów i powiązaniem z rzeczywistym Issue; dwie recenzje pozostałych członków.
5. **Gotowe:** spełniona DoD; dla zmian w repo także zielone CI, integracja i merge. Niespełnione kryteria cofają zadanie do pracy.

### Powiązanie Issues, PR-ów i akceptacji

- **Issue opisuje odbieralny rezultat.** Kroki implementacji to checkboxy w tym Issue, a nie obowiązkowe osobne Issues i PR-y.
- **PR obejmuje spójną zmianę w jednym repozytorium.** Preferuj jeden PR realizujący całe Issue, jeśli pozostaje czytelny do review. Kilka commitów i checklist nie wymaga kilku PR-ów.
- Możesz zamknąć kilka powiązanych Issues jednym PR-em, jeśli mają wspólny cel, zgodnego właściciela i komplet spełnionych kryteriów. Dwie akceptacje dotyczą PR-a, nie każdego powiązanego Issue osobno.
- Nie łącz backendu i Fluttera w jedno Issue wykonawcze ani nie przenoś zmian między repozytoriami tylko po to, aby zmniejszyć liczbę PR-ów.
- Jeśli zmiana jest zbyt duża lub wymaga wcześniejszego scalenia części odblokowującej inną osobę, podziel ją na mniejsze PR-y w ramach tego samego Issue. Wcześniejsze PR-y używają `Refs #numer`; dopiero końcowy używa `Closes #numer`.
- Pomiar, próba odtworzenia i demonstracja mogą zostać odebrane dowodami w Issue. Nie twórz pustego PR-a wyłącznie do zamknięcia zadania. Jeśli zmieniasz kod lub dokumentację, obowiązuje zwykły review PR-a.
- Pozostają **dwie akceptacje pozostałych członków zespołu dla każdego PR-a**, zielone CI i squash merge. Samo zmniejszenie liczby Issues nie zmniejsza akceptacji, jeśli liczba PR-ów się nie zmieni.
- Przy scenariuszu jednego PR-a na każde z 36 Issues potrzeba 72 akceptacji (po dwie na PR). To szacunek wariantu, nie narzucona liczba PR-ów.
- Kod `PR-X` nie jest numerem GitHub. Używaj `Closes #rzeczywisty_numer` lub pełnego odwołania między repo. GitHub Projects pozostaje opcjonalny.

### Styl tytułów i opisów

Tytuł Issue zapisuj jako **czasownik + rezultat + obszar**, np. `[PR-8] Zaimplementuj rejestrację, logowanie i wylogowanie w API`. Stosuj polecenia: „Dodaj”, „Skonfiguruj”, „Zaimplementuj”, „Wyświetl”, „Sprawdź”. Wymagania techniczne opisują działania, a kryteria akceptacji — obserwowalny wynik. Nie wymuszaj czasownika w kryterium kosztem jego mierzalności.

## Rozmiary

| Rozmiar | Znaczenie |
| --- | --- |
| S | Mała, lokalna zmiana o ograniczonym ryzyku |
| M | Spójna funkcja lub integracja z testami |
| L | Większa funkcja z kilkoma checklistami; przed startem sprawdź wykonalność i zakres review |

Rozmiar jest oceną względną. **Szacunek (h)** to wstępna ocena zespołu: implementacja, testy i własne poprawki, bez czasu review innych osób (ok. 1–2 h na PR). Orientacyjnie M ≈ 6–10 h, L ≈ 14–20 h. Szacunek zespół potwierdza przed przejściem do „Do zrobienia” (DoR). **Czas rzeczywisty (h)** uzupełnia właściciel przy zamknięciu Issue; oba pola trafiają do sprawozdania.

## Lista zadań

### Skonfiguruj fundament i środowisko

| ID | Zadanie | Obszar | Właściciel | Zależy od | Rozmiar | Szac. (h) | Rzecz. (h) |
| --- | --- | --- | --- | --- | --- | --- | --- |
| PR-1 | Ustal reguły domeny i skonfiguruj organizację pracy | dokumentacja / organizacja | @Amadeuszzyla | — | M | 8 | — |
| PR-2 | Uruchom backend Laravel i udostępnij wersjonowane API | backend / DevOps | @AdrianJurak | — | M | 8 | — |
| PR-3 | Uruchom aplikację Flutter i skonfiguruj CI Android | mobile / CI | @KirilRyab | — | M | 8 | — |
| PR-4 | Zdefiniuj kontrakt OpenAPI i skonfiguruj CI backendu | dokumentacja / API / CI / backend | @AdrianJurak | PR-1, PR-2 | M | 10 | — |
| PR-5 | Wybierz i zweryfikuj dostawców usług mapowych | analiza / integracje | @AdrianJurak | PR-1 | M | 8 | — |
| PR-6 | Dodaj motyw MilesAway i nawigację aplikacji | mobile / UI | @Amadeuszzyla | PR-3 | M | 8 | — |
| PR-7 | Opisz uruchomienie projektu i przygotuj szkielet raportu | dokumentacja | @Amadeuszzyla | PR-2, PR-3 | M | 6 | — |

### Udostępnij konta użytkowników

| ID | Zadanie | Obszar | Właściciel | Zależy od | Rozmiar | Szac. (h) | Rzecz. (h) |
| --- | --- | --- | --- | --- | --- | --- | --- |
| PR-8 | Zaimplementuj rejestrację, logowanie i wylogowanie w API | backend | @AdrianJurak | PR-1, PR-2, PR-4 | L | 16 | — |
| PR-9 | Zaimplementuj weryfikację e-maila i reset hasła w API | backend | @AdrianJurak | PR-8 | L | 14 | — |
| PR-10 | Udostępnij edycję profilu i ustawienia prywatności w API. Zaimplementuj usuwanie własnego konta i danych w API | backend | @AdrianJurak | PR-8, PR-9 | M | 12 | — |
| PR-11 | Zintegruj klienta HTTP z zarządzaniem sesją Flutter | mobile | @KirilRyab | PR-3, PR-4, PR-8 | M | 8 | — |
| PR-12 | Dodaj ekrany logowania, rejestracji i odzyskiwania dostępu | mobile | @KirilRyab | PR-6, PR-8, PR-9, PR-11 | L | 16 | — |
| PR-13 | Dodaj ustawienia profilu i usuwanie konta w aplikacji | mobile | @Amadeuszzyla | PR-6, PR-10, PR-11, PR-27 | M | 8 | — |

### Dodaj podróże, miejsca i trasy

| ID | Zadanie | Obszar | Właściciel | Zależy od | Rozmiar | Szac. (h) | Rzecz. (h) |
| --- | --- | --- | --- | --- | --- | --- | --- |
| PR-14 | Zamodeluj podróże i udostępnij ich CRUD w API | backend | @AdrianJurak | PR-1, PR-4, PR-5, PR-8 | L | 20 | — |
| PR-15 | Zaimplementuj atomową edycję punktów i transportu | backend | @AdrianJurak | PR-14 | L | 16 | — |
| PR-16 | Dodaj przeglądanie i zarządzanie podróżami we Flutterze | mobile | @KirilRyab | PR-6, PR-11, PR-14 | L | 18 | — |
| PR-17 | Dodaj edytor trasy z wyszukiwaniem i wyborem miejsc | mobile | @KirilRyab | PR-15, PR-16, PR-18, PR-20 | L | 20 | — |
| PR-18 | Zintegruj geokodowanie i rozpoznawanie miejsc oraz krajów | backend | @AdrianJurak | PR-4, PR-5, PR-8, PR-14 | L | 16 | — |
| PR-19 | Zaimplementuj obliczanie tras, dystansów i zapis wyników | backend | @AdrianJurak | PR-1, PR-2, PR-5, PR-14, PR-15 | L | 18 | — |
| PR-20 | Wyświetl podróż na mapie i rozróżnij środki transportu | mobile | @Amadeuszzyla | PR-5, PR-6, PR-16, PR-19 | L | 20 | — |

### Dodaj historię, statystyki i zarządzanie kontami

| ID | Zadanie | Obszar | Właściciel | Zależy od | Rozmiar | Szac. (h) | Rzecz. (h) |
| --- | --- | --- | --- | --- | --- | --- | --- |
| PR-21 | Udostępnij historię map i statystyki podróżnicze w API | backend | @AdrianJurak | PR-14, PR-18, PR-19 | L | 18 | — |
| PR-22 | Wyświetl historię podróży i odwiedzone kraje na mapie | mobile | @Amadeuszzyla | PR-20, PR-21 | L | 16 | — |
| PR-23 | Dodaj ekran statystyk z filtrem roku | mobile | @KirilRyab | PR-6, PR-11, PR-21 | M | 10 | — |
| PR-24 | Skonfiguruj Filament i dodaj zarządzanie kontami oraz banami | admin / backend | @AdrianJurak | PR-8, PR-10 | L | 18 | — |
| PR-25 | Udostępnij publiczne profile i podróże przez API | backend | @AdrianJurak | PR-10, PR-21, PR-24 | M | 8 | — |
| PR-26 | Dodaj przeglądanie publicznych profili w aplikacji | mobile | @KirilRyab | PR-16, PR-22, PR-23, PR-25 | M | 8 | — |
| PR-35 | Dodaj w panelu podgląd podróży i miejsc oraz usuwanie treści naruszających zasady | admin / backend | @AdrianJurak | PR-14, PR-18, PR-21, PR-24 | M | 10 | — |

### Wdróż, sprawdź i udokumentuj projekt

| ID | Zadanie | Obszar | Właściciel | Zależy od | Rozmiar | Szac. (h) | Rzecz. (h) |
| --- | --- | --- | --- | --- | --- | --- | --- |
| PR-27 | Wdróż API na VPS i sprawdź procedurę aktualizacji | DevOps | @Amadeuszzyla | PR-2, PR-4 | M | 10 | — |
| PR-28 | Skonfiguruj kopie zapasowe i sprawdź odtworzenie danych | DevOps | @Amadeuszzyla | PR-27, PR-28 | M | 8 | — |
| PR-29 | Przygotuj dane demonstracyjne i wyniki referencyjne | QA / backend | @AdrianJurak | PR-21, PR-25, PR-27 | M | 8 | — |
| PR-30 | Zmierz i popraw wydajność API | backend / wydajność | @AdrianJurak | PR-21, PR-25, PR-28, PR-30 | M | 8 | — |
| PR-31 | Sprawdź wydajność i dostępność aplikacji Android | mobile / jakość | @Amadeuszzyla | PR-13, PR-22, PR-23, PR-26, PR-30 | M | 8 | — |
| PR-32 | Przeprowadź odbiór integracyjny aplikacji, API i panelu | QA | @KirilRyab | PR-3, PR-12, PR-13, PR-17, PR-20, PR-22, PR-23, PR-24, PR-26, PR-28, PR-29, PR-30, PR-31, PR-32, PR-36 | L | 16 | — |
| PR-33 | Uzupełnij dokumentację i opracuj sprawozdanie | dokumentacja | @Amadeuszzyla | PR-7, PR-29, PR-31, PR-32, PR-33 | M | 12 | — |
| PR-34 | Udostępnij APK i przeprowadź demonstrację projektu | wydanie / odbiór | @KirilRyab | PR-33, PR-34 | M | 8 | — |

## Szczegółowe opisy Issues

Każda poniższa sekcja jest treścią jednego Issue. Podpunkty pozostają checklistą tego Issue — nie wymagają osobnych zadań. Zależności oznaczają pełny odbiór; można zacząć na uzgodnionym kontrakcie i udostępnić wcześniejszy PR, jeśli odblokowuje inne zadanie. Wspólna DoD dotyczy każdego Issue. Endpointy bez prefiksu są pod `/api/v1`; payloady określa kontrakt PR-4.

### PR-1 — Ustal reguły domeny i skonfiguruj organizację pracy

**Właściciel:** @Amadeuszzyla  
**Obszar:** dokumentacja / organizacja  
**Zależy od:** —  
**Rozmiar:** M  
**Szacunek:** 8 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Zapewnić jednakowe rozumienie podróży, miejsc i statystyk. Ułatwić prowadzenie spójnego backlogu w dwóch repozytoriach.

#### Wymagania techniczne

- Zapisz reguły z sekcji „Reguły domeny” w dokumentacji projektu wraz z przykładami.
- Rozróżnij wymagania PDF i uzgodnione rozszerzenia; opisać macierz uprawnień.
- Przygotuj szablony Issue/PR, etykiety obszaru i blokady oraz zasady review.
- Porównaj istniejące Issues i kod przed publikacją nowej listy; mapować zakresy, nie numery.

#### Kryteria akceptacji

- [ ] Przykłady obejmują podróż przez Nowy Rok, powrót do tego samego miejsca i górę poza miastem.
- [ ] Zdefiniowano visit, transit, shaping, rok agregacji oraz niepełny dystans.
- [ ] Backend i mobile uzgodniły słownik i oczekiwane wyniki przykładów.
- [ ] Każde publikowane Issue ma właściciela, kryteria, rozmiar i linki zależności.
- [ ] CONTRIBUTING opisuje dwie recenzje, CI i squash merge.
- [ ] Nie powstają duplikaty istniejącej inicjalizacji; zapisano mapowanie istniejących zadań.

### PR-2 — Uruchom backend Laravel i udostępnij wersjonowane API

**Właściciel:** @AdrianJurak  
**Obszar:** backend / DevOps  
**Zależy od:** —  
**Rozmiar:** M  
**Szacunek:** 8 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Uzyskać powtarzalne środowisko backendu. Zapewnić wspólny punkt wejścia i przewidywalne odpowiedzi HTTP.

#### Wymagania techniczne

- Dokończ istniejącą inicjalizację; przypiąć zgodne wersje PHP, Laravel, PostgreSQL i zależności w konfiguracji/lockfile.
- Przygotuj Dockerfile, Compose, migracje, .env.example, trwały wolumen i bazowy workflow test/lint/build.
- Udostępnij /api/v1 oraz GET /api/v1/health z polami status i timestamp w ISO 8601 UTC.
- Wprowadź jednolite błędy JSON dla API: message, opcjonalne errors; obsłużyć 401/403/404/409/422/429/503 bez stack trace.

#### Kryteria akceptacji

- [ ] Czysty checkout uruchamia aplikację i migracje według instrukcji.
- [ ] Restart kontenerów zachowuje dane; testy korzystają z oddzielnej bazy.
- [ ] Repo nie zawiera sekretów; bazowe testy, Pint i build obrazu przechodzą.
- [ ] Health zwraca 200, status=ok i poprawny timestamp; jest kontrolą żywotności, nie pełną gotowością bazy.
- [ ] Nieistniejąca ścieżka /api/v1 zwraca 404 i JSON z message.
- [ ] Testy HTTP/feature obejmują health, 404 i walidację; route:list pokazuje prawidłowy prefiks.

### PR-3 — Uruchom aplikację Flutter i skonfiguruj CI Android

**Właściciel:** @KirilRyab  
**Obszar:** mobile / CI  
**Zależy od:** —  
**Rozmiar:** M  
**Szacunek:** 8 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Przygotować aplikację do rozwijania ekranów. Weryfikować aplikację przed scaleniem.

#### Wymagania techniczne

- Przypnij SDK i zależności, ustalić strukturę modułów oraz konfigurację adresu API.
- Dodaj bazowe CI: format, analyze, test i build APK.
- Uruchamiaj format --set-exit-if-changed, flutter analyze, flutter test i build APK.
- Przechowuj artefakt testowy CI; oddzielić go od podpisanego wydania.

#### Kryteria akceptacji

- [ ] Aplikacja instaluje się i uruchamia na emulatorze Android.
- [ ] Adres API jest konfigurowalny bez edycji kodu źródłowego.
- [ ] Bazowy test widgetu oraz formatowanie, analiza i build przechodzą.
- [ ] Błąd testu, analizy lub budowania blokuje wymagane kontrole.
- [ ] Zielony workflow udostępnia APK powiązany z commitem.
- [ ] Klucze podpisu nie trafiają do repo ani logów.

### PR-4 — Zdefiniuj kontrakt OpenAPI i skonfiguruj CI backendu

**Właściciel:** @AdrianJurak  
**Obszar:** dokumentacja / API / CI / backend  
**Zależy od:** PR-1, PR-2  
**Rozmiar:** M  
**Szacunek:** 10 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Umożliwić równoległe tworzenie backendu i aplikacji. Blokować scalanie zmian psujących backend.

#### Wymagania techniczne

- Utwórz docs/openapi.yaml dla kont, podróży, trasy, miejsc, map, statystyk i profili publicznych.
- Opisz schematy, autoryzację, paginację, błędy, jednostki i przykłady; dodać walidator i Swagger UI.
- Rozszerz bazowe CI o testy z PostgreSQL, Pint, walidację OpenAPI i build produkcyjnego obrazu z zasobami panelu.
- Włącz wymagane kontrole przed merge; konfigurację kompilacji raportu dodać po utworzeniu jego szkieletu.

#### Kryteria akceptacji

- [ ] Walidator akceptuje dokument; przykłady są zgodne ze schematami.
- [ ] Każda funkcja backlogu wymagająca API ma zaplanowany endpoint i kontrakt.
- [ ] Zmiana endpointu wymaga aktualizacji OpenAPI w tym samym PR; mobile potwierdziło przykłady.
- [ ] Celowo błędny test, format lub OpenAPI powoduje czerwony workflow.
- [ ] Testy nie wymagają rzeczywistych dostawców map ani produkcyjnych sekretów.
- [ ] Poprawny PR przechodzi test/lint/build; automatyczny deployment nie jest wymagany.

### PR-5 — Wybierz i zweryfikuj dostawców usług mapowych

**Właściciel:** @AdrianJurak  
**Obszar:** analiza / integracje  
**Zależy od:** PR-1  
**Rozmiar:** M  
**Szacunek:** 8 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Wybrać wykonalne integracje przed implementacją map.

#### Wymagania techniczne

- Porównaj dostępnych dostawców kafelków, geokodowania/reverse, routingu i granic państw; wykonać próbę API i mapy.
- Zapisz aktualne warunki, limity, koszty, atrybucje, możliwość cache/trwałego zapisu i dopuszczalność podpowiedzi.

#### Kryteria akceptacji

- [ ] Dokument wskazuje po jednym wybranym rozwiązaniu dla każdej roli wraz z uzasadnieniem i datą sprawdzenia.
- [ ] Próba daje trasę drogową, miejsce, kraj i renderowalne granice obejmujące wyspy.
- [ ] Opisano zachowanie przy limitach/awarii; nie zakłada się, że publiczny geokoder pozwala na autocomplete.

### PR-6 — Dodaj motyw MilesAway i nawigację aplikacji

**Właściciel:** @Amadeuszzyla  
**Obszar:** mobile / UI  
**Zależy od:** PR-3  
**Rozmiar:** M  
**Szacunek:** 8 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Nadać ekranom spójny wygląd i przewidywalną nawigację.

#### Wymagania techniczne

- Wprowadź beż, brąz, złoto i zieleń, proste komponenty paper cut-out oraz wspólne stany ekranów.
- Przygotuj nawigację kont, podróży, map, statystyk i profilu.

#### Kryteria akceptacji

- [ ] Nawigacja działa na małym ekranie i po powrocie z podstrony.
- [ ] Wspólne komponenty obejmują loading, pusty stan, błąd i retry.
- [ ] Tekst i akcje pozostają czytelne; dekoracje nie utrudniają obsługi.

### PR-7 — Opisz uruchomienie projektu i przygotuj szkielet raportu

**Właściciel:** @Amadeuszzyla  
**Obszar:** dokumentacja  
**Zależy od:** PR-2, PR-3  
**Rozmiar:** M  
**Szacunek:** 6 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Umożliwić nowej osobie uruchomienie projektu.

#### Wymagania techniczne

- Opisz backend, Flutter, emulator, telefon, konfigurację API oraz polecenia kontroli jakości.
- Utwórz szkielet raportu LaTeX i kompilację w CI; zaznaczyć planowane rozdziały VPS/panelu.

#### Kryteria akceptacji

- [ ] Druga osoba uruchamia oba repo z czystego checkoutu.
- [ ] Instrukcja nie wymaga sekretów zapisanych w repo.
- [ ] LaTeX buduje PDF; dokumentacja odróżnia wykonane funkcje od planowanych.

### PR-8 — Zaimplementuj rejestrację, logowanie i wylogowanie w API

**Właściciel:** @AdrianJurak  
**Obszar:** backend  
**Zależy od:** PR-1, PR-2, PR-4  
**Rozmiar:** L  
**Szacunek:** 16 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Przygotować bezpieczny model użytkownika. Pozwolić utworzyć konto z walidacją danych. Obsłużyć tokeny aplikacji i egzekwować stan konta.

#### Wymagania techniczne

- Dodaj username, e-mail, hasło, weryfikację, widoczność, rolę i stan blokady z migracjami/fabrykami.
- Zdefiniuj unikalność oraz normalizację identyfikatorów; nie pozwalać klientowi ustawiać roli.
- Dodaj POST /api/v1/auth/register, walidację, haszowanie i limit żądań.
- Zwracaj bezpieczny zasób użytkownika i stan wymaganej weryfikacji.
- Dodaj Sanctum i endpointy login/logout oraz GET /me; rozdzielić tokeny mobile od sesji panelu.
- Dodaj limity prób i sprawdzanie aktywności/weryfikacji konta na chronionych trasach.

#### Kryteria akceptacji

- [ ] Nowe konto jest prywatne i ma rolę użytkownika.
- [ ] Ograniczenia bazy zapobiegają duplikatom zgodnie z normalizacją.
- [ ] Serializacja publiczna nie zawiera e-maila, hasha, tokenów ani danych administracyjnych.
- [ ] Poprawna rejestracja tworzy jedno prywatne konto z zahashowanym hasłem.
- [ ] Błędne dane i zajęte identyfikatory dają udokumentowaną odpowiedź.
- [ ] Testy HTTP sprawdzają sukces, duplikaty, walidację i brak możliwości nadania roli admina.
- [ ] Poprawne dane wydają token; błędne nie ujawniają szczegółów konta.
- [ ] Logout unieważnia używany token; po nim chroniona trasa daje 401.
- [ ] Konto zbanowane nie uzyskuje dostępu; niezweryfikowane ma dostęp wyłącznie do dozwolonych operacji aktywacji/logout.

### PR-9 — Zaimplementuj weryfikację e-maila i reset hasła w API

**Właściciel:** @AdrianJurak  
**Obszar:** backend  
**Zależy od:** PR-8  
**Rozmiar:** L  
**Szacunek:** 14 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Potwierdzać własność adresu przed dostępem do danych. Umożliwić odzyskanie dostępu bez ujawniania kont.

#### Wymagania techniczne

- Dodaj wysyłkę i ponowienie wiadomości oraz wygasający, odporny na modyfikację link.
- Ustal powrót do aplikacji; oddzielić testową skrzynkę od SMTP produkcyjnego.
- Dodaj żądanie resetu oraz ustawienie nowego hasła za jednorazowym tokenem z terminem ważności.
- Po resecie unieważniaj tokeny i sesje; ograniczyć próby i wysyłkę.

#### Kryteria akceptacji

- [ ] Ważny link aktywuje konto; zły i wygasły nie aktywują.
- [ ] Ponowne użycie linku nie zmienia danych ani nie wydaje sesji; ponowna wysyłka ma limit.
- [ ] Testy z atrapą poczty sprawdzają wysyłkę i odblokowanie chronionych operacji po weryfikacji.
- [ ] Żądanie resetu dla istniejącego i nieistniejącego konta ma tę samą odpowiedź użytkową.
- [ ] Ważny token zmienia hasło raz; wygasły/użyty jest odrzucany.
- [ ] Stare hasło, tokeny i sesje przestają działać; nowe hasło pozwala zalogować aktywne konto.

### PR-10 — Udostępnij edycję profilu i ustawienia prywatności w API

**Właściciel:** @AdrianJurak  
**Obszar:** backend  
**Zależy od:** PR-8, PR-9  
**Rozmiar:** L  
**Szacunek:** 12 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Pozwolić użytkownikowi aktualizować własne konto.
Usunąć konto wraz z danymi i zapobiec jego powrotowi po restore.

#### Wymagania techniczne

- Dodaj PATCH /me i kontrolowane operacje zmiany hasła/e-maila wymagające aktualnego hasła.
- Zmiana e-maila wymaga ponownej weryfikacji; zmiana widoczności unieważnia publiczny cache.
- Dodaj DELETE /me wymagające hasła i jawnego potwierdzenia; usunąć konto, punkty, odcinki, podróże i sesje.
- Przygotuj minimalny rejestr nieodwracalnych usunięć z trwałym ID konta oraz eksport poza odtwarzaną kopię; opisać bezpieczny retry.

#### Kryteria akceptacji

- [ ] Użytkownik zmienia dozwolone pola wyłącznie własnego konta.
- [ ] Prywatność obowiązuje przy następnym żądaniu; dane wrażliwe nie wyciekają.
- [ ] Zmiana hasła/e-maila bez poprawnego hasła jest odrzucana; nowy e-mail przechodzi weryfikację.
- [ ] Poprawna operacja usuwa konto i wszystkie prywatne dane zależne; inne konto nie jest naruszone.
- [ ] Błędne hasło odrzuca operację; ponowienie nie odtwarza danych.
- [ ] Testy sprawdzają kaskadę i ponowne zastosowanie rejestru; procedura przechowania/restore jest sprawdzana w PR-28.

### PR-11 — Zintegruj klienta HTTP z zarządzaniem sesją Flutter

**Właściciel:** @KirilRyab  
**Obszar:** mobile  
**Zależy od:** PR-3, PR-4, PR-8  
**Rozmiar:** M  
**Szacunek:** 8 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Ujednolicić komunikację aplikacji z API. Utrzymywać i kończyć sesję użytkownika.

#### Wymagania techniczne

- Dodaj konfigurację base URL, nagłówki, timeout i mapowanie błędów HTTP na stany UI.
- Zdefiniuj modele kontraktu i atrapy; nie logować tokenów ani haseł.
- Przechowuj token w bezpiecznym magazynie platformy; odtwarzać stan przez /me.
- Po 401/logout usuwaj token i dane poprzedniego użytkownika; brak sieci odróżnić od nieważnej sesji.

#### Kryteria akceptacji

- [ ] Testy klienta obejmują 401/403/404/409/422/429/503 i brak sieci.
- [ ] Błąd walidacji można przypisać do pola formularza.
- [ ] Żądanie health działa na emulatorze i telefonie z konfigurowanym API.
- [ ] Restart aplikacji odtwarza ważną sesję.
- [ ] Logout i nieważny token prowadzą do logowania bez ujawniania poprzednich danych.
- [ ] Testy obejmują zmianę konta, restart oraz brak sieci przy weryfikacji sesji.

### PR-12 — Dodaj ekrany logowania, rejestracji i odzyskiwania dostępu

**Właściciel:** @KirilRyab  
**Obszar:** mobile  
**Zależy od:** PR-6, PR-8, PR-9, PR-11  
**Rozmiar:** L  
**Szacunek:** 16 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Udostępnić obsługę kont w aplikacji. Zamknąć ścieżki e-mailowe w aplikacji.

#### Wymagania techniczne

- Połącz formularze z API i stanem sesji; dodać walidację i blokadę wielokrotnego wysłania.
- Prowadzić niezweryfikowanego użytkownika do aktywacji; obsłużyć ban i limity.
- Dodaj ekran oczekiwania na aktywację, ponowną wysyłkę, żądanie resetu i ustawienie hasła.
- Obsłużyć linki i powrót z poczty według kontraktu oraz odświeżenie stanu konta.

#### Kryteria akceptacji

- [ ] Rejestracja i logowanie działają z API.
- [ ] Walidacja, błędne hasło, limit prób i brak sieci mają czytelne komunikaty.
- [ ] Testy widgetów obejmują sukces, błąd i stan ładowania.
- [ ] Użytkownik przechodzi od rejestracji przez e-mail do aktywnego konta.
- [ ] Reset kończy się ponownym logowaniem; link wygasły/użyty ma jasny komunikat.
- [ ] Testy obejmują walidację formularzy, link i ograniczenie ponownej wysyłki.

### PR-13 — Dodaj ustawienia profilu i usuwanie konta w aplikacji

**Właściciel:** @Amadeuszzyla  
**Obszar:** mobile  
**Zależy od:** PR-6, PR-10, PR-11, PR-27  
**Rozmiar:** M  
**Szacunek:** 8 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Udostępnić dane konta i ustawienia prywatności. Udostępnić jednoznaczną, świadomą operację usunięcia.

#### Wymagania techniczne

- Połącz formularz profilu, zmianę hasła/e-maila i widoczności z API.
- Pokazać konieczność ponownej weryfikacji i wymagane potwierdzenie aktualnym hasłem.
- Dodaj opis skutków, potwierdzenie i formularz hasła.
- Po potwierdzonym sukcesie wyczyść sesję i dane lokalne; timeout traktować jako niepewny wynik, wymagający sprawdzenia.

#### Kryteria akceptacji

- [ ] Zmiany są widoczne po ponownym otwarciu ekranu.
- [ ] Nieudany zapis nie udaje sukcesu ani nie gubi wpisanych danych.
- [ ] Testy widgetów obejmują prywatność, walidację i zmianę e-maila.
- [ ] Anulowanie nie wysyła usunięcia; błędne hasło pokazuje błąd.
- [ ] Po sukcesie aplikacja wraca do logowania bez starych danych.
- [ ] Testy widgetów obejmują anulowanie, sukces, błąd i utratę połączenia.

### PR-14 — Zamodeluj podróże i udostępnij ich CRUD w API

**Właściciel:** @AdrianJurak  
**Obszar:** backend  
**Zależy od:** PR-1, PR-4, PR-5, PR-8  
**Rozmiar:** L  
**Szacunek:** 20 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Zapisać podstawowe dane podróży i kontrolować dostęp. Liczyć także góry i inne miejsca poza miastami bez powielania wizyt. Powiązać transport i wyniki obliczeń z sąsiednimi punktami. Udostępnić zapis i odczyt własnych podróży.

#### Wymagania techniczne

- Dodaj Trip: właściciel, nazwa, start_date, end_date, opcjonalny opis, revision.
- Normalizuj pojedynczą datę do równego start/end; implementować reguły zakończonych podróży.
- Dodaj kanoniczne Place i TripPoint z datą, kolejnością, współrzędnymi i typem visit/transit/shaping.
- Opisz identity: stabilny identyfikator obiektu dostawcy lub jawny wybór istniejącego miejsca; współrzędne/nazwa służą szukaniu kandydatów, nie automatycznemu scalaniu.
- Dodaj Leg z punktami końcowymi, transportem car/plane/train/other, metrami, geometrią i revision.
- Zdefiniuj pending/ready/failed, null dla braku dystansu, ograniczenia relacji i usuwanie zależnych danych.
- Dodaj paginowane GET/POST /trips i GET/PATCH/DELETE /trips/{id}.
- Utwórz podróż z pierwszym punktem atomowo; obsłużyć idempotency key dla tworzenia i konflikt wersji edycji.

#### Kryteria akceptacji

- [ ] Migracje i relacje działają na PostgreSQL.
- [ ] Niepoprawny zakres i przyszłe zakończenie są odrzucane.
- [ ] Polityki odróżniają właściciela od cudzych danych; admin nie dostaje automatycznie dostępu do podróży.
- [ ] Dwie wizyty odwołujące się do tego samego place_id liczą jedno miejsce, również w różnych podróżach.
- [ ] Góra poza miejscowością liczy miejsce; dwa różne obiekty w jednym mieście liczą dwa.
- [ ] Nieznany punkt dostaje trwały lokalny identyfikator; wybór ponownie zapisanego miejsca zachowuje ID; bliskich obiektów nie scala sam próg odległości.
- [ ] Jednopunktowa podróż ma zero odcinków; n punktów ma n−1 odcinków.
- [ ] Nie można połączyć punktów różnych podróży.
- [ ] Brak wyniku różni się od poprawnego zera; fabryki obejmują wszystkie stany.
- [ ] CRUD działa dla właściciela, a cudze ID nie pozwalają czytać ani modyfikować prywatnych danych.
- [ ] Powtórzenie tego samego utworzenia po timeout nie tworzy duplikatu.
- [ ] Testy obejmują daty, paginację, usunięcie zależności, brak punktu i konflikt revision.

### PR-15 — Zaimplementuj atomową edycję punktów i transportu

**Właściciel:** @AdrianJurak  
**Obszar:** backend  
**Zależy od:** PR-14  
**Rozmiar:** L  
**Szacunek:** 16 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Zachować spójną trasę podczas zmian punktów.

#### Wymagania techniczne

- Dodaj atomowy zapis listy punktów i odcinków z revision; walidować daty i typy.
- Niezmienione pary zachowują transport; nowe pary wymagają wyboru; zmienione odcinki tracą stare wyniki.

#### Kryteria akceptacji

- [ ] Dodanie, usunięcie i reorder zachowują n−1 poprawnych odcinków.
- [ ] Błąd dowolnego elementu cofa całą operację; stara revision daje 409.
- [ ] Nie można usunąć ostatniego punktu; testy obejmują te same współrzędne, wiele punktów jednego dnia i cudze ID.

### PR-16 — Dodaj przeglądanie i zarządzanie podróżami we Flutterze

**Właściciel:** @KirilRyab  
**Obszar:** mobile  
**Zależy od:** PR-6, PR-11, PR-14  
**Rozmiar:** L  
**Szacunek:** 18 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Udostępnić przegląd zapisanej historii. Pozwolić zapisać podróż z podstawowymi danymi. Pokazać dane podróży, punkty i odcinki przed integracją mapy.

#### Wymagania techniczne

- Dodaj paginację, odświeżanie i przejście do szczegółów.
- Obsłużyć loading, pustą listę, błędy i ponawianie bez dublowania elementów.
- Dodaj nazwę, daty, opis i pierwszy punkt przez współrzędne lub wybór zapisanego miejsca.
- Dodaj usuwanie z potwierdzeniem, idempotency key i zachowanie formularza przy błędzie sieci.
- Wyświetl uporządkowane punkty, daty, transporty i dystanse z odpowiedzi szczegółowej.
- Przygotuj tryb właściciela i tryb tylko odczytu.

#### Kryteria akceptacji

- [ ] Wszystkie strony są osiągalne i zachowują stabilną kolejność.
- [ ] Odświeżenie pokazuje zmiany z API.
- [ ] Testy widgetów obejmują pustą listę, kolejną stronę i błąd sieci.
- [ ] Jednopunktowa podróż może powstać bez geokodera.
- [ ] Błędne daty i brak wymaganych pól są wskazane; timeout nie tworzy drugiej podróży.
- [ ] Edycja i usunięcie odświeżają listę; testy obejmują anulowanie usunięcia.
- [ ] Kolejność i dane odpowiadają API.
- [ ] Pending/failed nie są wyświetlane jako zero kilometrów.
- [ ] Jednopunktowa podróż i puste opisy nie psują układu; testy obejmują oba tryby.

### PR-17 — Dodaj edytor trasy z wyszukiwaniem i wyborem miejsc

**Właściciel:** @KirilRyab  
**Obszar:** mobile  
**Zależy od:** PR-15, PR-16, PR-18, PR-20  
**Rozmiar:** L  
**Szacunek:** 20 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Umożliwić wygodną edycję wieloodcinkowej podróży. Dodawać miejsca przez wyszukiwanie, mapę lub istniejący zapis.

#### Wymagania techniczne

- Dodaj punkty, daty, typy, reorder i wybór transportu dla każdej nowej pary.
- Wysyłaj atomową zmianę z revision; po 409 pozwolić odświeżyć dane bez cichego nadpisania.
- Połącz wyszukiwanie i reverse z edytorem; podpowiedzi tylko jeśli dostawca na nie pozwala.
- Pokazuj kandydatów zapisanych miejsc; odrzucać spóźnione odpowiedzi dla wcześniejszego zapytania.

#### Kryteria akceptacji

- [ ] Można zbudować trasę z różnymi transportami i zmienić kolejność punktów.
- [ ] Zmiana sąsiedztwa wymaga potwierdzenia nowych transportów.
- [ ] Testy obejmują reorder, konflikt, błąd walidacji i zachowanie wpisanych danych po utracie sieci.
- [ ] Użytkownik wybiera wynik, punkt na mapie albo istniejące miejsce.
- [ ] Ponowny wybór zapisanej góry używa jej place_id; nowa etykieta nie tworzy duplikatu.
- [ ] Testy obejmują brak wyników, awarię, szybkie zmiany zapytania i zachowanie współrzędnych.

### PR-18 — Zintegruj geokodowanie i rozpoznawanie miejsc oraz krajów

**Właściciel:** @AdrianJurak  
**Obszar:** backend  
**Zależy od:** PR-4, PR-5, PR-8, PR-14  
**Rozmiar:** L  
**Szacunek:** 16 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Wyszukiwać miejsca i rozpoznawać wskazane współrzędne. Zapisywać trwałe miejsca oraz wiarygodne kraje odwiedzin.

#### Wymagania techniczne

- Dodaj GET /geocode?q= i endpoint reverse pod /api/v1, adapter dostawcy, cache, limity i timeout.
- Normalizuj wyniki do identyfikatora dostawcy, etykiety, współrzędnych i kraju; serwer chroni klucze.
- Powiąż wyniki dostawcy z Place, normalizować kody krajów i zapisywać źródło rozpoznania.
- Dodaj wyszukiwanie istniejących miejsc użytkownika; własna etykieta punktu nie zmienia tożsamości miejsca.

#### Kryteria akceptacji

- [ ] Atrapy sprawdzają wynik, pustą listę, timeout i limit dostawcy.
- [ ] Powtórne zapytanie używa dozwolonego cache.
- [ ] API nie ujawnia sekretów i odróżnia brak wyników od awarii.
- [ ] Ponowny wybór tego samego obiektu daje ten sam place_id zgodnie z regułami PR-14.
- [ ] Góra poza miastem może mieć kraj i liczy się jako miejsce.
- [ ] Awaria nie gubi współrzędnych; nierozpoznany kraj pozostaje jawny i można ponowić rozpoznanie.

### PR-19 — Zaimplementuj obliczanie tras, dystansów i zapis wyników

**Właściciel:** @AdrianJurak  
**Obszar:** backend  
**Zależy od:** PR-1, PR-2, PR-5, PR-14, PR-15  
**Rozmiar:** L  
**Szacunek:** 18 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Obliczać szacunkowy dystans bez routingu drogowego. Wyznaczać wiarygodną drogę samochodu. Przeliczać zmienione odcinki bez utraty spójności.

#### Wymagania techniczne

- Zaimplementuj haversine w metrach z opisanym promieniem Ziemi i tolerancją.
- Użyj dla plane/train/other; nie utożsamiać ekranowej prostej z osobnym algorytmem odległości.
- Zintegruj wybranego dostawcę dla pary punktów; zwracać geometrię oraz dystans w metrach.
- Dodaj timeout, obsługę braku drogi i limitów oraz cache zgodny z warunkami.
- Po zapisie trasy uruchamiaj joby po zatwierdzeniu transakcji; dobierać algorytm do transportu.
- Zapisuj wynik tylko dla aktualnej revision i istniejącego odcinka; ograniczyć retry i umożliwić kontrolowane ponowienie.

#### Kryteria akceptacji

- [ ] Testy obejmują identyczne punkty, znaną parę, okolice biegunów i antymeridian.
- [ ] Wynik jest skończony i nieujemny, a tolerancja testów jest określona.
- [ ] Niepoprawne współrzędne są odrzucane.
- [ ] Próba integracji zwraca geometrię po sieci dróg.
- [ ] Testy z atrapami obejmują sukces, brak trasy, timeout i 429.
- [ ] Awaria nie zastępuje drogi prostą opisaną jako poprawna trasa samochodowa.
- [ ] Car używa routingu, pozostałe transporty dystansu geodezyjnego.
- [ ] Spóźniony job po edycji/usunięciu nie przywraca starej geometrii.
- [ ] Testy obejmują sukces, failed/null, retry, podwójne wykonanie i zmianę revision.

### PR-20 — Wyświetl podróż na mapie i rozróżnij środki transportu

**Właściciel:** @Amadeuszzyla  
**Obszar:** mobile  
**Zależy od:** PR-5, PR-6, PR-16, PR-19  
**Rozmiar:** L  
**Szacunek:** 20 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Przygotować wspólną mapę dla ekranów. Pokazać trasę zgodnie z transportem i stanem obliczeń.

#### Wymagania techniczne

- Zintegruj wybrany pakiet i kafelki, zoom, przesuwanie i atrybucje.
- Dodaj stan braku sieci, ograniczenia kluczy klienckich i sprzątanie zasobów mapy.
- Wyświetl markery, legendę, szczegóły odcinka/punktu, dopasowanie widoku i zoom.
- Rysuj car z geometrii drogi, plane jako łuk, train/other jako uproszczone połączenia; obsłużyć antymeridian.

#### Kryteria akceptacji

- [ ] Mapa działa na Androidzie i pozwala wskazać współrzędne.
- [ ] Atrybucje są widoczne i zgodne z wybraną usługą.
- [ ] Błąd kafelków nie zamyka aplikacji; test widgetu sprawdza otoczenie mapy z atrapą.
- [ ] Przykład Legnica–Berlin–Majorka–Berlin–Legnica ma poprawne style i szczegóły.
- [ ] Transport da się rozpoznać także bez polegania wyłącznie na kolorze.
- [ ] Failed/pending są jawne; trasa przez antymeridian nie biegnie przez cały ekran świata.

### PR-21 — Udostępnij historię map i statystyki podróżnicze w API

**Właściciel:** @AdrianJurak  
**Obszar:** backend  
**Zależy od:** PR-14, PR-18, PR-19  
**Rozmiar:** L  
**Szacunek:** 18 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Udostępnić komplet historii i kraje z wizyt. Wyliczać komplet metryk PDF według jednoznacznych reguł.

#### Wymagania techniczne

- Dodaj GET /map z filtrem roku/całej historii i paginacją oraz agregację krajów z visit.
- Rok mapy wybiera podróże przecinające rok; kraje filtra wynikają z wizyt w tym roku.
- Dodaj GET /stats?year= z liczbą podróży, unikalnych miejsc/krajów, listą państw, dystansem łącznym i per transport.
- Agreguj zgodnie z regułami roku; pokazywać kompletność dystansów i nierozpoznane kraje.

#### Kryteria akceptacji

- [ ] Wszystkie strony razem zawierają całą wybraną historię bez duplikatów.
- [ ] Tranzyt przez kraj nie zalicza go jako odwiedzonego; nierozpoznane kraje są oznaczone.
- [ ] Testy obejmują pustą historię, wyspy, zmianę trasy, usunięcie i granicę roku.
- [ ] Dwie wizyty w tej samej górze liczą jedno miejsce; transit/shaping nie zwiększają licznika.
- [ ] Znane dystanse sumują się, a null daje informację o niepełności zamiast zera.
- [ ] Testy sprawdzają wszystkie metryki, pustą historię, granicę roku i aktualizację po edycji/usunięciu.

### PR-22 — Wyświetl historię podróży i odwiedzone kraje na mapie

**Właściciel:** @Amadeuszzyla  
**Obszar:** mobile  
**Zależy od:** PR-20, PR-21  
**Rozmiar:** L  
**Szacunek:** 16 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Pozwolić przeglądać wieloletnią historię.

#### Wymagania techniczne

- Dodaj widoki ostatniej podróży, roku i całej historii, pobieranie stron oraz grupowanie markerów.
- Wyróżniaj rzeczywiste poligony krajów wraz z wyspami; obsłużyć mapowanie kodów i atrybucje.

#### Kryteria akceptacji

- [ ] Historia większa niż strona API jest kompletna; można wybrać podróż i jej szczegóły.
- [ ] Ostatnia podróż wynika z daty zakończenia, potem dodania i stabilnego ID.
- [ ] Filtr roku aktualizuje mapę i kraje; państwa nie są zastąpione przybliżonymi plamami.

### PR-23 — Dodaj ekran statystyk z filtrem roku

**Właściciel:** @KirilRyab  
**Obszar:** mobile  
**Zależy od:** PR-6, PR-11, PR-21  
**Rozmiar:** M  
**Szacunek:** 10 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Czytelnie prezentować wszystkie metryki i filtry.

#### Wymagania techniczne

- Dodaj karty metryk, listę państw i dystanse per transport dla roku/całej historii.
- Przeliczaj metry na kilometry dopiero w prezentacji; oznaczać niepełne wyniki.

#### Kryteria akceptacji

- [ ] Widoczne są wszystkie sześć grup metryk wymaganych w PDF, w tym miejsca poza miastami.
- [ ] Filtr roku zmienia dane; pusty wynik daje poprawne zera.
- [ ] Testy widgetów obejmują kompletne/niepełne dane, błąd API i listę państw.

### PR-24 — Skonfiguruj Filament i dodaj zarządzanie kontami oraz banami

**Właściciel:** @AdrianJurak  
**Obszar:** admin / backend  
**Zależy od:** PR-8, PR-10  
**Rozmiar:** L  
**Szacunek:** 18 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Oddzielić administrację kontami od funkcji podróżniczych. Umożliwić administratorowi kontrolowaną obsługę kont. Egzekwować blokadę w całym systemie.

#### Wymagania techniczne

- Zainstaluj zgodną wersję Filament, sesyjne logowanie i politykę dostępu do panelu.
- Przygotuj bezpieczne utworzenie pierwszego administratora bez publicznej rejestracji roli.
- Dodaj paginowaną listę, wyszukiwanie, filtry i szczegóły kont oraz edycję username/e-maila z walidacją.
- Zmiana e-maila wymaga ponownej weryfikacji; audytować autora, czas i zakres zmian, bez sekretów.
- Dodaj ban/unban z powodem, administratorem i czasem; sprawdzać blokadę przy każdym chronionym żądaniu.
- Ban unieważnia tokeny/sesje i publiczny cache, zachowując dane oraz wcześniejszą widoczność; chronić ostatniego admina przed zablokowaniem.

#### Kryteria akceptacji

- [ ] Admin loguje się do panelu; zwykłe konto nie otwiera panelu ani bezpośrednich akcji.
- [ ] Publiczna rejestracja nie tworzy administratora.
- [ ] Zasoby podróży i miejsc dodaje PR-36; PR-24 dostarcza dostęp sesyjny i politykę dostępu z testami dostępu i odmowy.
- [ ] Admin wyszukuje konto i zmienia dozwolone dane; konflikt unikalności nie niszczy zapisu.
- [ ] Panel nie pokazuje hashów ani tokenów.
- [ ] Testy akcji potwierdzają uprawnienia i audyt; nadawanie ról, wymuszanie hasła i usuwanie cudzych kont nie są dostępne.
- [ ] Zbanowany użytkownik nie loguje się i nie używa wcześniej wydanych sesji.
- [ ] Unban pozwala zalogować się ponownie, lecz nie przywraca starych tokenów.
- [ ] Testy obejmują bezpośrednie akcje, audyt, brak uprawnień i ochronę ostatniego admina.

### PR-25 — Udostępnij publiczne profile i podróże przez API

**Właściciel:** @AdrianJurak  
**Obszar:** backend  
**Zależy od:** PR-10, PR-21, PR-24  
**Rozmiar:** M  
**Szacunek:** 8 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Pozwolić zalogowanym przeglądać publiczne dane innych osób.

#### Wymagania techniczne

- Dodaj wyszukiwanie profili oraz odczyt podróży, map i statystyk w osobnym kontekście użytkownika.
- Sprawdzać prywatność/ban przy każdym żądaniu i przed użyciem cache; zwracać ograniczone zasoby.

#### Kryteria akceptacji

- [ ] Publiczny aktywny profil jest dostępny tylko do odczytu po zalogowaniu.
- [ ] Prywatny lub zbanowany profil i jego zasoby dają 404; gość otrzymuje 401.
- [ ] Testy obejmują zmianę widoczności, ban, ID cudzej podróży, brak e-maila i brak prawa zapisu.

### PR-26 — Dodaj przeglądanie publicznych profili w aplikacji

**Właściciel:** @KirilRyab  
**Obszar:** mobile  
**Zależy od:** PR-16, PR-22, PR-23, PR-25  
**Rozmiar:** M  
**Szacunek:** 8 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Udostępnić społeczną część wymaganą w PDF.

#### Wymagania techniczne

- Dodaj wyszukiwarkę użytkowników, profil oraz jego podróże, mapę i statystyki.
- Użyj osobnego kontekstu danych i trybu tylko odczytu; obsłużyć utratę dostępu w trakcie oglądania.

#### Kryteria akceptacji

- [ ] Użytkownik znajduje publiczny profil i przegląda jego dane.
- [ ] Brak przycisków edycji cudzych podróży; nawigacja nie miesza danych właścicieli.
- [ ] Po odmowie API wcześniejsze dane są usuwane z widoku; testy obejmują prywatność i ban.

### PR-27 — Wdróż API na VPS i sprawdź procedurę aktualizacji

**Właściciel:** @Amadeuszzyla  
**Obszar:** DevOps  
**Zależy od:** PR-2, PR-4  
**Rozmiar:** M  
**Szacunek:** 10 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Sprawdzić środowisko produkcyjne przed zakończeniem funkcji.

#### Wymagania techniczne

- Przygotuj produkcyjny Compose, HTTPS, prywatną bazę, trwałe wolumeny, worker, SMTP, rotację logów i monitoring zasobów.
- Udostępnij Swagger UI z aktualnym docs/openapi.yaml razem z wdrożonym API i dodaj go do smoke testu.
- Opisz ręczne wdrożenie konkretnego obrazu/commita, migracje, smoke test i rollback wraz z ograniczeniami cofania migracji.

#### Kryteria akceptacji

- [ ] Health i dokumentacja API działają przez HTTPS; testowy e-mail dociera.
- [ ] Swagger UI jest dostępny pod publicznym adresem wdrożonego API, opisuje wdrożoną wersję i przechodzi smoke test po każdej aktualizacji.
- [ ] Debug jest wyłączony, sekrety poza repo, baza nie jest publiczna.
- [ ] Druga osoba wykonuje aktualizację i kontrolowane wycofanie; późniejsze funkcje wdrażane są przyrostowo.

### PR-28 — Skonfiguruj kopie zapasowe i sprawdź odtworzenie danych

**Właściciel:** @Amadeuszzyla  
**Obszar:** DevOps  
**Zależy od:** PR-27, PR-28  
**Rozmiar:** M  
**Szacunek:** 8 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Sprawdzić odzyskiwanie danych bez przywracania usuniętych kont.

#### Wymagania techniczne

- Zweryfikuj harmonogram, retencję, spójność PostgreSQL i kopię poza VPS; nie traktować samego snapshotu jako dowodu poprawnego restore.
- Odtwórz izolowanie z wyłączoną pocztą/jobami zewnętrznymi; przed uruchomieniem zastosować aktualny rejestr usunięć spoza starej kopii.

#### Kryteria akceptacji

- [ ] Udokumentowano zakres kopii, dostęp, harmonogram, retencję, RPO i zmierzony czas odtworzenia.
- [ ] Po restore relacje i reprezentatywne podróże są poprawne.
- [ ] Konto usunięte po wykonaniu kopii nie wraca; izolowane środowisko nie wysyła wiadomości.

### PR-29 — Przygotuj dane demonstracyjne i wyniki referencyjne

**Właściciel:** @AdrianJurak  
**Obszar:** QA / backend  
**Zależy od:** PR-21, PR-25, PR-27  
**Rozmiar:** M  
**Szacunek:** 8 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Zapewnić powtarzalną podstawę testów i demonstracji.

#### Wymagania techniczne

- Dodaj fikcyjne seedery Legnica–Berlin–Majorka z powrotem oraz deterministyczne atrapy integracji.
- Uwzględnić górę odwiedzoną dwukrotnie, dwa obiekty jednego miasta, tranzyt, shaping, lata graniczne i brak dystansu.

#### Kryteria akceptacji

- [ ] Seed daje powtarzalny zestaw bez danych prawdziwych osób.
- [ ] Zapisano dokładne oczekiwane liczby miejsc, krajów, podróży i dystansów dla lat i całości.
- [ ] Zestaw zawiera profile prywatne/publiczne/zbanowane i przypadek jednopunktowy.

### PR-30 — Zmierz i popraw wydajność API

**Właściciel:** @AdrianJurak  
**Obszar:** backend / wydajność  
**Zależy od:** PR-21, PR-25, PR-28, PR-30  
**Rozmiar:** M  
**Szacunek:** 8 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Zachować sprawność wieloletniej historii.

#### Wymagania techniczne

- Zmierz API na 100 podróżach i 2000 punktach; ustalić przed pomiarem środowisko, obciążenie i budżet czasu odpowiedzi.
- Sprawdź indeksy, N+1, paginację i unieważnianie cache; poprawić wykryte problemy.

#### Kryteria akceptacji

- [ ] Raport zawiera metodę, p95, liczbę żądań, zasoby i wynik względem uzgodnionego budżetu.
- [ ] Nie giną strony/rekordy i nie występuje OOM.
- [ ] Test regresji chroni usunięte wąskie gardło; cache nie ujawnia danych po zmianie prywatności.

### PR-31 — Sprawdź wydajność i dostępność aplikacji Android

**Właściciel:** @Amadeuszzyla  
**Obszar:** mobile / jakość  
**Zależy od:** PR-13, PR-22, PR-23, PR-26, PR-30  
**Rozmiar:** M  
**Szacunek:** 8 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Utrzymać czytelność i płynność na docelowym telefonie.

#### Wymagania techniczne

- Sprawdź 100 podróży/2000 punktów, grupowanie markerów, pamięć i czas otwarcia mapy według wcześniej ustalonego budżetu.
- Sprawdź duży tekst, małe ekrany, kontrast, semantykę, cele dotykowe i rozróżnienie transportu bez koloru.

#### Kryteria akceptacji

- [ ] Raport wskazuje urządzenie, wersję, wyniki i budżet; brak OOM i znikających tras.
- [ ] Najważniejsze ścieżki działają przy powiększonym tekście i czytniku ekranu.
- [ ] Wykryte blokujące problemy są poprawione i ponownie zweryfikowane.

### PR-32 — Przeprowadź odbiór integracyjny aplikacji, API i panelu

**Właściciel:** @KirilRyab  
**Obszar:** QA  
**Zależy od:** PR-3, PR-12, PR-13, PR-17, PR-20, PR-22, PR-23, PR-24, PR-26, PR-28, PR-29, PR-30, PR-31, PR-32, PR-36  
**Rozmiar:** L  
**Szacunek:** 16 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Potwierdzić działanie całego systemu i wymagania PDF.

#### Wymagania techniczne

- Wykonaj scenariusze przekrojowe z końcowej macierzy pokrycia na podpisanym kandydacie release APK.
- Sprawdź realne SMTP, HTTPS, mapy i panel; automatyczne testy CI korzystają z atrap, a smoke test dostawców jest osobny.

#### Kryteria akceptacji

- [ ] Przechodzą konta, e-maile, CRUD/reorder, transporty, mapy, wszystkie statystyki, publiczne profile, bany, podgląd i moderacja podróży w panelu oraz usunięcie konta.
- [ ] Raport podaje commit/artefakt, urządzenie, testera, kroki, oczekiwany/rzeczywisty wynik oraz linki usterek.
- [ ] Nie pozostają usterki blokujące; poprawki przechodzą ponownie testy/lint/build i właściwe scenariusze.

### PR-33 — Uzupełnij dokumentację i opracuj sprawozdanie

**Właściciel:** @Amadeuszzyla  
**Obszar:** dokumentacja  
**Zależy od:** PR-7, PR-29, PR-31, PR-32, PR-33  
**Rozmiar:** M  
**Szacunek:** 12 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Opisać rzeczywiście dostarczony system i sposób jego utrzymania.

#### Wymagania techniczne

- Uaktualnij README, OpenAPI, CONTRIBUTING, instrukcje uruchomienia/aktualizacji i ograniczenia.
- Domknij raport LaTeX/PDF: opis zamówienia, architektura, technologie, obowiązki, zadania, planowany/rzeczywisty czas i wyniki testów.

#### Kryteria akceptacji

- [ ] Każdy członek zespołu sprawdził opis swojego wkładu.
- [ ] Instrukcje odtwarza druga osoba; linki i kompilacja PDF są poprawne.
- [ ] Raport nie przedstawia planu jako wykonania i nie zawiera terminów zajęć ani zasad oceniania.

### PR-34 — Udostępnij APK i przeprowadź demonstrację projektu

**Właściciel:** @KirilRyab  
**Obszar:** wydanie / odbiór  
**Zależy od:** PR-33, PR-34  
**Rozmiar:** M  
**Szacunek:** 8 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Udostępnić sprawdzoną wersję i powtarzalny scenariusz prezentacji.

#### Wymagania techniczne

- Opublikuj podpisany APK odpowiadający odebranemu kandydatowi, identyfikację wersji i instrukcję instalacji.
- Przećwicz demonstrację Android/API/Filament/Swagger na danych fikcyjnych; przygotować plan awaryjny.

#### Kryteria akceptacji

- [ ] Udostępniony APK instaluje się i łączy z właściwym API HTTPS; zgodność artefaktu potwierdza suma kontrolna.
- [ ] Klucz podpisu pozostaje poza repo; wersja i commit są zapisane.
- [ ] Zespół przechodzi demo kont, podróży, map, statystyk, banów i moderacji w panelu; nagranie jest tylko wariantem awaryjnym.

### PR-35 — Dodaj w panelu podgląd podróży i miejsc oraz usuwanie treści naruszających zasady

**Właściciel:** @AdrianJurak  
**Obszar:** admin / backend  
**Zależy od:** PR-14, PR-18, PR-21, PR-24  
**Rozmiar:** M  
**Szacunek:** 10 h  
**Czas rzeczywisty:** — h

#### Kontekst i cel

Umożliwić administratorowi kontrolę danych używanych przez aplikację mobilną bez ingerowania w treść podróży użytkowników.

#### Wymagania techniczne

- Dodaj zasób Filament tylko do odczytu: paginowana lista podróży (nazwa, właściciel, daty, liczba punktów, dystans, status obliczeń), wyszukiwanie i filtry (właściciel, rok, status), widok szczegółów z punktami, odcinkami i transportem. Bez formularzy tworzenia i edycji.
- Dodaj zasób tylko do odczytu dla miejsc: nazwa, identyfikator, kraj, liczba podróży i użytkowników, odnośnik do podróży zawierających miejsce.
- Dodaj akcję „Usuń podróż naruszającą zasady” z obowiązkowym powodem i potwierdzeniem. Usuń podróż wraz z punktami, odcinkami i wynikami obliczeń.
- Audytuj autora, czas, powód, ID podróży i właściciela, bez danych wrażliwych.
- Po usunięciu unieważnij cache publicznych profili i statystyk właściciela; ogranicz zasoby do roli administratora.
- Użyj eager loading, aby listy nie generowały zapytań N+1.

#### Kryteria akceptacji

- [ ] Admin przegląda podróże i miejsca; panel nie oferuje tworzenia ani edycji; zwykłe konto nie ma dostępu, także bezpośrednio.
- [ ] Wyszukiwanie, filtry i paginacja działają; test liczby zapytań potwierdza brak N+1.
- [ ] Usunięcie bez powodu lub potwierdzenia jest niemożliwe.
- [ ] Po usunięciu podróż znika z API, mapy historii, profilu publicznego i statystyk przy następnym żądaniu; inne podróże i konto użytkownika pozostają bez zmian.
- [ ] Wpis audytu zawiera autora, czas, powód, ID podróży i właściciela.
- [ ] Testy obejmują uprawnienia, brak edycji, audyt i unieważnienie cache.

## Pokrycie wymagań i scenariusze odbioru

| Wymaganie | Zadania | Minimalny scenariusz odbioru |
| --- | --- | --- |
| Rejestracja, logowanie, wylogowanie | PR-8, PR-11, PR-12 | Rejestracja, logowanie, restart i logout; stary token jest nieważny. |
| Weryfikacja e-maila i reset hasła | PR-9, PR-12 | Aktywacja z poczty, wygasły link, reset i unieważnienie sesji. |
| Edycja profilu i widoczność | PR-10, PR-13 | Zmiana danych i przełączenie publiczny/prywatny; obcy użytkownik traci dostęp. |
| Podgląd cudzych publicznych podróży | PR-25, PR-26 | Wyszukanie użytkownika, podróże/mapa/statystyki tylko do odczytu. |
| CRUD, nazwa, daty, opis podróży | PR-14, PR-16 | Utworzenie, edycja i usunięcie; pojedyncza data i zakres; cudze ID odrzucone. |
| Dowolna liczba punktów, kolejność i transport | PR-14, PR-15, PR-17 | Reorder trasy mieszanej, zachowanie par i wybór transportu nowych odcinków. |
| Samochód po drogach | PR-19, PR-20 | Rzeczywista geometria drogi; awaria nie udaje poprawnej trasy. |
| Samolot, pociąg, inne | PR-19, PR-20 | Łuk lotniczy, uproszczone połączenia i poprawne jednostki. |
| Mapa podróży, zoom, szczegóły i legenda | PR-20 | Rozpoznanie transportu, otwarcie punktu/odcinka i zmiana przybliżenia. |
| Mapa wszystkich podróży | PR-21, PR-22 | Historia większa od strony API jest kompletna. |
| Rozpoznawanie i wyróżnianie krajów | PR-18, PR-21, PR-22 | Wizyta zalicza kraj, tranzyt nie; widoczne rzeczywiste granice i wyspy. |
| Liczba podróży | PR-21, PR-23 | Pusta historia i podróż przez Nowy Rok zgodnie z regułą startu. |
| Liczba i lista krajów | PR-21, PR-23 | Powtórzenia nie zwiększają wyniku; nierozpoznane kraje są jawne. |
| Kilometry łącznie i według transportu | PR-19, PR-21, PR-23 | Suma per transport odpowiada sumie znanych dystansów; null nie jest zerem. |
| Liczba odwiedzonych miejsc, także poza miastami | PR-14, PR-18, PR-21, PR-23 | Dwie wizyty w tej samej górze dają jedno miejsce, dwa obiekty w mieście dają dwa. |
| Statystyki całej historii i roku | PR-21, PR-23 | Filtry stosują daty podróży/wizyt/odcinków zgodnie z regułami. |
| Zarządzanie kontami i bany | PR-24 | Edycja dozwolonych danych, ban/unban i audyt. |
| Panel: podgląd danych i moderacja | PR-36 | Podgląd podróży i miejsc tylko do odczytu; usunięcie podróży z powodem i audytem; podróż znika z API, map i statystyk. |
| Usunięcie konta | PR-27, PR-13, PR-29 | Usunięcie kaskadowe i brak powrotu konta po odtworzeniu starej kopii. |
| Usługi zewnętrzne | PR-5, PR-18, PR-19, PR-20 | Smoke test wybranych usług i prawidłowe atrybucje. |
| Działający, czytelny system | PR-4, PR-3, PR-6, PR-28, PR-29, PR-30, PR-31, PR-32, PR-33, PR-34, PR-35 | CI, pomiary, odbiór release APK, instrukcje i demonstracja. |
