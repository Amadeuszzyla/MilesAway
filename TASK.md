# TASK.md — lista zadań projektu MilesAway

Lista zadań rozwojowych. Każde zadanie to **jeden branch = jeden Pull Request**. Numer `PR-X` jest identyfikatorem zadania; używaj go w nazwie brancha, tytule Issue i opisie PR.

Powiązane dokumenty:

- [TASK_ins.md](TASK_ins.md) — instrukcja wykonywania zadań.
- [CONTRIBUTING.md](CONTRIBUTING.md) — zasady Git, review i jakości kodu.
- [README.md](README.md) — opis projektu i uruchomienie.

## Stan projektu

Lista przedstawia plan realizacji, a nie potwierdzony stan implementacji.

Przed utworzeniem nowych Issues należy porównać ją z kodem i istniejącymi zadaniami.

## Zespół i proponowane przypisania

| Skrót | Osoba | Konto GitHub | Główna odpowiedzialność |
| --- | --- | --- | --- |
| AZ | Amadeusz Żyła | [@Amadeuszzyla](https://github.com/Amadeuszzyla) | Aplikacja mobilna, dokumentacja, VPS |
| AJ | Adrian Jurak | [@AdrianJurak](https://github.com/AdrianJurak) | Backend i API |
| KR | Kyril Ryab | [@KirilRyab](https://github.com/KirilRyab) | Aplikacja mobilna |

## Definition of Ready (Kiedy można zacząć zadanie)

Zadanie można rozpocząć, gdy:

- [ ] Issue ma kod PR-X oraz jasno opisany cel i zakres.
- [ ] Określono mierzalne kryteria akceptacji.
- [ ] Opisano sposób weryfikacji.
- [ ] Zadania z kolumny **Zależy od** są już zmergowane do `main`.
- [ ] Ustalono niezbędne reguły biznesowe i kontrakt API.
- [ ] Zależności są dostępne albo uzgodniono zakres pracy równoległej.

## Definition of Done (Kiedy zadanie jest zakończone)

Zadanie jest zakończone, gdy:

- [ ] Spełniono kryteria Issue oraz warunek odbioru z tabeli.
- [ ] Zmiana działa w odpowiednim środowisku.
- [ ] Przechodzą właściwe testy i kontrole jakości.
- [ ] Sprawdzono autoryzację, prywatność i obsługę błędów, jeśli dotyczą zmiany.
- [ ] Dokumentacja API, konfiguracji i migracji jest aktualna.
- [ ] PR zaakceptowały co najmniej dwie osoby z zespołu.
- [ ] Wymagane kontrole CI przeszły.
- [ ] Kod scalono do `main`, a gałąź została zamknięta.
- [ ] Zamknięto Issue i zaktualizowano status.

Przyjęty cykl pracy:

```text
Backlog → Do zrobienia → W trakcie → Review → Gotowe
```

Blokadę opisujemy w komentarzu i oznaczamy statusem lub etykietą `blocked`.

GitHub Projects jest opcjonalny. Zadania można prowadzić przez Issues, przypisania, etykiety i milestones.

### Rozmiary zadań

| Rozmiar | Znaczenie |
| --- | --- |
| S | Małe zadanie obejmujące lokalną zmianę |
| M | Kilka powiązanych zmian |
| L | Większa funkcja lub integracja wymagająca rozważenia podziału |

Rozmiary są wstępnymi oszacowaniami, nie gwarantowanymi terminami. Zadania przewidywane na więcej niż dwa dni pracy dzielimy przed realizacją.

Zależności opisują warunki pełnego odbioru. Nie wszystkie zadania poprzedniej fazy muszą być zakończone przed rozpoczęciem kolejnej.

## Faza 0: Fundament projektu

| ID | Zadanie | Obszar | Zależy od | Osoba | Rozmiar |
| --- | --- | --- | --- | --- | --- |
| **PR-1** | Pliki repozytorium i środowisko Docker: `.gitignore`, konteneryzacja (`compose.yaml`, Dockerfile PHP 8.3-FPM, Nginx, PostgreSQL 16), `.env.example`, wybór licencji, szablony Issue i PR w `.github/` | devops / docs | — | AZ | M |
| **PR-2** | Inicjalizacja backendu w Dockerze: Laravel 12, Sanctum, Pint, PHPUnit, konfiguracja połączenia z PostgreSQL | backend | PR-1 | AJ | M |
| **PR-3** | Inicjalizacja aplikacji mobilnej: Flutter, Dart, konfiguracja Android Studio, struktura katalogu `mobile/`, przypięcie wersji SDK | mobile | — | KR | M |
| PR-4 | Prefiks `/api/v1`, endpoint zdrowia `GET /api/v1/health`, jednolity format odpowiedzi błędów JSON | backend | PR-2 | AJ | S |
| PR-5 | CI backendu w GitHub Actions: instalacja zależności Composer, kontrola formatowania Pint, testy PHPUnit z PostgreSQL | backend / CI | PR-2 | AJ | M |
| PR-6 | CI aplikacji mobilnej w GitHub Actions: instalacja Flutter, kontrola formatowania Dart, analiza statyczna, testy i build Android | mobile / CI | PR-3 | KR | M |
| PR-7 | Dokumentacja decyzji w `docs/`: wybór pakietu map Flutter, dostawcy kafelków, routingu, geokodowania i granic państw oraz ustalenie zasad statystyk i prywatności | docs / analiza | — | AZ | M |
| PR-8 | Szkielet dokumentacji API w `docs/` (OpenAPI lub Markdown) wraz z regułami aktualizacji dokumentacji | docs | PR-4, PR-7 | AZ | M |

---

## Faza 1: Konta użytkowników

| ID | Zadanie | Obszar | Zależy od | Osoba | Rozmiar |
| --- | --- | --- | --- | --- | --- |
| **PR-9** | Migracja i model użytkownika: dane profilu, pole widoczności publiczny/prywatny, fabryka i seeder | backend | PR-2, PR-7 | AJ | S |
| PR-10 | Rejestracja: `POST /api/v1/auth/register`, Form Request, haszowanie hasła, API Resource i testy | backend | PR-9, PR-8 | AJ | M |
| PR-11 | Logowanie i wylogowanie: `POST /api/v1/auth/login`, `POST /api/v1/auth/logout`, tokeny Sanctum, ograniczenie prób logowania i testy | backend | PR-10 | AJ | M |
| PR-12 | Profil użytkownika: `GET` i `PATCH /api/v1/me`, edycja danych, zmiana widoczności, autoryzacja i testy | backend | PR-11 | AJ | M |
| **PR-13** | Klient API we Flutterze: konfiguracja adresu API, wspólna obsługa żądań HTTP, nagłówków, tokenu, błędów 401/422 i problemów z siecią | mobile | PR-3, PR-8 | KR | M |
| PR-14 | Zarządzanie sesją we Flutterze: stan użytkownika, logowanie, wylogowanie, bezpieczne przechowywanie tokenu i odtwarzanie sesji po restarcie | mobile | PR-13, PR-11 | KR | M |
| PR-15 | Motyw MilesAway i nawigacja: kolory, typografia, komponenty paper cut-out, ekran główny oraz dostęp do ekranów dla gościa i zalogowanego użytkownika | mobile / UI | PR-3 | AZ | M |
| PR-16 | Ekrany rejestracji i logowania: formularze, walidacja, komunikaty błędów i integracja ze stanem sesji | mobile | PR-14, PR-15, PR-10, PR-11 | KR | M |
| PR-17 | Ekran edycji profilu: dane użytkownika, przełącznik publiczny/prywatny i zapis zmian przez API | mobile | PR-15, PR-14, PR-12 | AZ | M |

---

## Faza 2: Podróże, punkty i odcinki

| ID | Zadanie | Obszar | Zależy od | Osoba | Rozmiar |
| --- | --- | --- | --- | --- | --- |
| **PR-18** | Model `Trip`: nazwa, data lub zakres dat, opis, właściciel, migracja i polityka dostępu uwzględniająca własność oraz widoczność profilu | backend | PR-9 | AJ | M |
| PR-19 | CRUD podróży: `/api/v1/trips`, paginowana lista, szczegóły, tworzenie, edycja, usuwanie, walidacja i testy autoryzacji | backend | PR-18, PR-11, PR-8 | AJ | L |
| **PR-20** | Modele `Place`, `TripPoint` i `Leg`: miejsca, punkty podróży z kolejnością, odcinki, transport, dystans, geometria i stan obliczeń; migracje i relacje | backend | PR-18, PR-7 | AJ | M |
| PR-21 | API punktów podróży: dodawanie, edycja, usuwanie, zmiana kolejności, transakcje i testy | backend | PR-20, PR-19 | AJ | L |
| PR-22 | API odcinków: powiązanie sąsiednich punktów, aktualizacja odcinków po zmianie trasy, wybór transportu i testy | backend | PR-21 | AJ | L |
| PR-23 | Flutter: lista podróży użytkownika, paginacja, odświeżanie, stan ładowania i pusty stan | mobile | PR-15, PR-14, PR-19 | KR | M |
| PR-24 | Flutter: formularz tworzenia i edycji podróży (nazwa, daty, opis), usuwanie z potwierdzeniem | mobile | PR-23 | KR | M |
| PR-25 | Flutter: ekran szczegółów podróży z danymi, uporządkowaną listą punktów i odcinków, bez mapy | mobile | PR-23, PR-21, PR-22 | KR | M |
| PR-26 | Flutter: edytor trasy, dodawanie i usuwanie punktów, zmiana kolejności oraz wybór transportu dla każdego odcinka | mobile | PR-24, PR-25 | KR | L |

---

## Faza 3: Geokodowanie i dystanse

| ID | Zadanie | Obszar | Zależy od | Osoba | Rozmiar |
| --- | --- | --- | --- | --- | --- |
| PR-27 | Serwis geokodowania i endpoint `GET /api/v1/geocode?q=`: wyszukiwanie miejsc, cache, limit zapytań i obsługa błędów dostawcy | backend | PR-4, PR-7, PR-8 | AJ | M |
| PR-28 | Serwis obliczania odległości geodezyjnej między punktami, np. haversine, jednostki w metrach i testy jednostkowe | backend | PR-2, PR-7 | AJ | S |
| PR-29 | Serwis wyznaczania tras samochodowych OpenRouteService/OSRM: geometria drogowa, dystans, timeout i obsługa błędów API | backend | PR-2, PR-7 | AJ | L |
| PR-30 | Automatyczne wyliczanie i zapis geometrii oraz dystansu odcinka według transportu, przeliczanie po zmianach i obsługa brakujących wyników | backend | PR-22, PR-28, PR-29 | AJ | L |
| PR-31 | Rozpoznawanie kraju miejsca na podstawie współrzędnych lub geokodera, normalizacja kodów państw i zapis w bazie | backend | PR-20, PR-27 | AJ | M |
| PR-32 | Flutter: wyszukiwanie i wybór miejsca podczas dodawania punktu, prezentacja wyników oraz podpowiedzi zgodnie z możliwościami dostawcy | mobile | PR-26, PR-27 | KR | M |

---

## Faza 4: Interaktywna mapa

| ID | Zadanie | Obszar | Zależy od | Osoba | Rozmiar |
| --- | --- | --- | --- | --- | --- |
| **PR-33** | Bazowy widget mapy Flutter: wybrany pakiet mapowy, kafelki lub styl mapy, zoom, konfiguracja i atrybucje | mobile | PR-3, PR-7 | AZ | M |
| PR-34 | Mapa pojedynczej podróży: markery punktów, geometrie odcinków i dopasowanie widoku do trasy | mobile | PR-33, PR-25, PR-30 | AZ | L |
| PR-35 | Rozróżnienie transportu na mapie: kolory, ikony, style linii i legenda | mobile | PR-34 | AZ | M |
| PR-36 | Prezentacja lotu jako łuku, samochodu po drogach, pociągu i innych środków transportu jako uproszczonych połączeń | mobile | PR-35, PR-30 | AZ | L |
| PR-37 | Mapa wszystkich podróży użytkownika: endpoint zbiorczy `GET /api/v1/map`, pobieranie historii i widok Flutter | backend + mobile | PR-34, PR-30 | AZ + AJ | L |
| PR-38 | Odwiedzone państwa: agregacja kodów krajów, dane granic GeoJSON, obsługa wysp i wyróżnianie państw na mapie | backend + mobile | PR-37, PR-31 | AZ + AJ | L |
| PR-39 | Szczegóły trasy: panel punktu lub odcinka, dystans, środek transportu i przybliżanie do wybranej trasy | mobile | PR-36, PR-37 | AZ | M |

---

## Faza 5: Statystyki

| ID | Zadanie | Obszar | Zależy od | Osoba | Rozmiar |
| --- | --- | --- | --- | --- | --- |
| PR-40 | Serwis i endpoint `GET /api/v1/stats?year=`: liczba podróży, lista i liczba państw, liczba miejsc, dystans całkowity i według transportu, przeliczanie po zmianach i testy | backend | PR-30, PR-31, PR-7 | AJ | L |
| PR-41 | Flutter: ekran statystyk, karty z liczbami, lista odwiedzonych państw i zestawienie dystansów | mobile | PR-40, PR-15, PR-14 | KR | M |
| PR-42 | Flutter: filtr „Cała historia” / wybrany rok oraz prezentacja dystansu według transportu w tabeli lub na wykresie | mobile | PR-41 | KR | M |

---

## Faza 6: Profile publiczne

| ID | Zadanie | Obszar | Zależy od | Osoba | Rozmiar |
| --- | --- | --- | --- | --- | --- |
| PR-43 | API publicznych profili: lista użytkowników, ich podróże, mapa i statystyki, filtrowanie prywatnych danych, kontrola dostępu i testy | backend | PR-12, PR-19, PR-37, PR-40 | AJ | L |
| PR-44 | Flutter: przeglądanie publicznych użytkowników, profil innego użytkownika oraz jego podróże, mapa i statystyki w trybie tylko do odczytu | mobile | PR-43, PR-39, PR-42 | KR | L |

---

## Faza 7: Jakość i wykończenie

| ID | Zadanie | Obszar | Zależy od | Osoba | Rozmiar |
| --- | --- | --- | --- | --- | --- |
| PR-45 | Seedery danych demonstracyjnych: profile publiczny i prywatny, podróż Legnica–Berlin–Majorka z powrotem, różne lata i powtarzające się miejsca | backend | PR-22, PR-30, PR-31 | AJ | M |
| PR-46 | Przegląd i ujednolicenie stanów Flutter: komunikaty błędów, brak dostępu, brak sieci, ładowanie, puste dane i ponawianie operacji | mobile | PR-17, PR-26, PR-39, PR-42, PR-44 | KR | M |
| PR-47 | Dostosowanie układu i dostępności: małe ekrany, większy tekst, kontrast, semantyka, cele dotykowe oraz obsługa panelu klawiaturą | mobile / admin | PR-46, PR-53 | AZ | L |
| PR-48 | Optymalizacja backendu: indeksy, paginacja, eliminacja N+1, cache tras i geokodowania oraz unieważnianie cache po zmianach | backend | PR-30, PR-40, PR-43 | AJ | M |
| PR-49 | Testy integracyjne i end-to-end: rejestracja, logowanie, podróż wieloodcinkowa, mapy, statystyki, prywatność, publiczne profile i panel administratora | QA / integracja | PR-16, PR-17, PR-32, PR-38, PR-39, PR-42, PR-44, PR-45, PR-47, PR-48, PR-53 | KR | L |
| PR-50 | Dokumentacja końcowa: aktualizacja README, CONTRIBUTING i API, instrukcja uruchomienia i wdrożenia, raport testów i opis ograniczeń | docs | PR-5, PR-6, PR-8, PR-49, PR-54, PR-55 | AZ | M |

---

## Panel administracyjny Filament

Zadania panelu można realizować równolegle z aplikacją mobilną po zakończeniu wskazanych zależności.

| ID | Zadanie | Obszar | Zależy od | Osoba | Rozmiar |
| --- | --- | --- | --- | --- | --- |
| PR-51 | Instalacja i konfiguracja Filament: zgodna wersja, panel administratora, logowanie sesyjne, uprawnienia i tworzenie konta administratora | admin | PR-2, PR-9 | AJ | M |
| PR-52 | Zarządzanie użytkownikami w Filament: lista, wyszukiwanie, szczegóły, edycja dozwolonych danych i kontrola uprawnień | admin | PR-51, PR-12 | AJ | M |
| PR-53 | Zarządzanie podróżami w Filament: lista, filtrowanie, szczegóły, zatwierdzone operacje edycji/usuwania oraz aktualizacja tras i statystyk | admin | PR-52, PR-19, PR-30, PR-40 | AJ | L |

---

## Serwer VPS i utrzymanie

| ID | Zadanie | Obszar | Zależy od | Osoba | Rozmiar |
| --- | --- | --- | --- | --- | --- |
| PR-54 | Wdrożenie backendu i panelu na VPS: Docker Compose, konfiguracja domeny, HTTPS, zmienne środowiskowe, logi, healthcheck i instrukcja aktualizacji | devops | PR-5, PR-30, PR-51 | AZ | L |
| PR-55 | Kopie zapasowe PostgreSQL: harmonogram, miejsce przechowywania, retencja, kontrola błędów i test odtworzenia danych | devops | PR-54, PR-45 | AZ | M |

## Zadania dodatkowe — Filament, VPS i decyzje

| ID | Zadanie i minimalny warunek odbioru | Obszar | Zależy od | Osoba | Rozmiar |
| --- | --- | --- | --- | --- | --- |
| PR-51 | Instalacja zgodnej wersji Filament, panel, logowanie sesyjne, autoryzacja administratora i sposób utworzenia konta. Testy odrzucają zwykłego użytkownika również przy bezpośrednim wywołaniu akcji. | Admin | PR-2, PR-9, PR-56 | AJ | M |
| PR-52 | Zarządzanie użytkownikami: lista, wyszukiwanie, szczegóły i zatwierdzone operacje. Bez ujawniania haseł/tokenów; zmiana widoczności używa wspólnych reguł. | Admin | PR-51, PR-12 | AJ | M |
| PR-53 | Zarządzanie podróżami w Filament: lista, filtry, szczegóły i zatwierdzone edycje/usuwanie. Zmiany aktualizują trasy i statystyki; dostęp do danych prywatnych odpowiada PR-56. | Admin | PR-52, PR-19, PR-30, PR-40 | AJ | L |
| PR-54 | Wdrożenie API i panelu na VPS: Compose, HTTPS, sekrety, trwała baza, logi, wyłączony debug, healthcheck i instrukcja aktualizacji/wycofania. Flutter łączy się z API HTTPS; baza nie jest niepotrzebnie publiczna. | DevOps | PR-5, PR-30, PR-51 | AZ | L |
| PR-55 | Kopie PostgreSQL: harmonogram, miejsce, retencja, ochrona dostępu i kontrola błędów. Wykonano odtworzenie do oddzielnego środowiska i porównanie danych. | DevOps | PR-54, PR-45 | AZ | M |
| PR-56 | Reguły biznesowe i zakres: rok podróży, miejsca/kraje, przyszłe daty, minimum punktów, zmiana kolejności, braki dystansu, prywatność i uprawnienia admina. Decyzje zapisane z przykładami wyników. | Analiza / docs | — | AZ | M |
| PR-57 | Plan odbioru: narzędzia testowe Flutter, urządzenia, Android/iOS, dane referencyjne, macierz uprawnień i mierzalny budżet wydajności mapy wieloletniej. | QA | PR-3, PR-56 | KR | M |
| PR-58 | Wymagania zajęć i pokrycie backlogu: przypisania, terminy, linki repozytoriów i mapa wymaganie → Issue. Potwierdzono zgłoszenie grupy i kompletność zadań; braki opisano. | Organizacja | PR-1, PR-56 | AZ | S |

Zakres panelu administracyjnego wymaga zatwierdzenia.

Usuwanie kont, nadawanie ról, blokowanie kont i dostęp do prywatnych podróży nie są automatycznie zaakceptowane — rozstrzyga je PR-56.

## Reguły do ustalenia w PR-56

| Pytanie | Co trzeba ustalić |
| --- | --- |
| Podróż na przełomie roku | Przypisanie do roku rozpoczęcia czy podział według dat odcinków? |
| Odwiedzone miejsce | Unikalne miejsce czy liczba wizyt? Jak identyfikować powtórzenia i ręczne punkty? |
| Odwiedzony kraj | Kraje zapisanych punktów czy także tranzyt? Jak traktować wyspy i brak rozpoznania? |
| Data i zakres | Normalizacja pojedynczej daty i obsługa przyszłych podróży |
| Punkty i odcinki | Minimalna liczba punktów i transport po zmianie sąsiedztwa |
| Niepełny dystans | Prezentowanie braku trasy, sumy znanych odcinków i przybliżeń |
| Prywatność | Wartość domyślna, publiczne pola, dostęp gościa i zalogowanego oraz cache |
| Administrator | Dozwolone operacje i zakres dostępu do prywatnych danych |

## Pokrycie wymagań

| Wymaganie | Główne zadania |
| --- | --- |
| Rejestracja, logowanie i wylogowanie | PR-10, PR-11, PR-14, PR-16 |
| Edycja danych i widoczność profilu | PR-9, PR-12, PR-17 |
| Przeglądanie cudzych publicznych podróży | PR-43, PR-44 |
| CRUD podróży, nazwa, daty i opis | PR-18, PR-19, PR-23, PR-24 |
| Wiele punktów, kolejność i transport odcinka | PR-20, PR-21, PR-22, PR-25, PR-26 |
| Geokodowanie i rozpoznawanie kraju | PR-27, PR-31, PR-32 |
| Samochód po rzeczywistych drogach | PR-29, PR-30, PR-36 |
| Łuk lotniczy, pociąg i inne | PR-28, PR-30, PR-36 |
| Mapa jednej podróży, legenda, zoom i szczegóły | PR-33, PR-34, PR-35, PR-39 |
| Mapa wszystkich podróży i wyróżnione państwa | PR-37, PR-38 |
| Statystyki całej historii i wybranego roku | PR-40, PR-41, PR-42 |
| Webowy panel administracyjny | PR-51, PR-52, PR-53 |
| Serwer i trwałość danych | PR-54, PR-55 |
| Jakość, odbiór i dokumentacja | PR-5, PR-6, PR-8, PR-46–PR-50, PR-56–PR-58 |

## Zakres podstawowy i rozszerzenia

Zakres podstawowy obejmuje:

- konta użytkowników,
- prywatność profilu,
- przeglądanie publicznych podróży,
- zarządzanie podróżami,
- wiele punktów i różne środki transportu,
- mapy i odwiedzone państwa,
- statystyki,
- API i panel administracyjny.

Rozszerzenia wymagające osobnej decyzji:

- zdjęcia i osobne wspomnienia,
- obserwowanie użytkowników,
- polubienia,
- powiadomienia,
- eksport danych,
- planowanie przyszłych podróży.

Projekt nie obejmuje nawigacji GPS ani idealnego odtworzenia rzeczywiście przebytej drogi.

## Utrzymanie listy

- GitHub Issues jest źródłem aktualnego statusu.
- Nie skreślamy identyfikatorów w tabelach, aby zachować czytelność zależności.
- Po utworzeniu zadań dopisujemy linki do rzeczywistych Issues.
- Nie zmieniamy istniejących identyfikatorów.
- Nowe zadania zaczynają się od **PR-59**.
- Podział zadania zapisujemy przez nowe powiązane Issues i aktualizację zależności.
- Zmiana zakresu wymaga aktualizacji kryteriów i poinformowania zainteresowanych osób.
- Nie zamykamy zadania nadrzędnego, jeśli pozostał niezrealizowany wymagany zakres.
