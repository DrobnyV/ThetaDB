# ThetaDB
Instalace a Spuštění
Předpoklady
MySQL Workbench - pro správu databáze
Python 3.7+ - pro běh aplikace
Exportovaná databáze - z projektu (soubor SQL s exportem databáze)

Krok 1: Nastavení Databáze
Otevřete MySQL Workbench:
Připojte se k vaší lokální nebo vzdálené databázové instanci.
Vytvořte novou databázi:
V MySQL Workbench, vytvořte novou databázi s názvem hotel2 (nebo podle vaší preference).
Použijte příkaz:
sql
CREATE DATABASE hotel2;
Import databáze:
Použijte Server > Data Import z menu v Workbench.
Vyberte Import from Self-Contained File a vyberte váš SQL exportní soubor.
Zvolte hotel2 jako cílovou databázi a postupujte podle kroků importu.

Krok 2: Nastavení Python Prostředí
Klonujte nebo stáhněte projekt z GitHubu:
bash
git clone [URL vašeho repozitáře]
Přejděte do adresáře projektu:
bash
cd [název-adresáře-projektu]
Instalace závislostí:
Nainstalujte potřebné Python knihovny. Předpokládá se, že máte pip nainstalovaný:
bash
pip install Flask mysql-connector-python

Krok 3: Konfigurace Databázového Připojení
Upravte config.py nebo podobný konfigurační soubor:
Pokud projekt používá konfigurační soubor pro databázové připojení, upravte ho takto:
python
DB_CONFIG = {
    'user': 'vaše_databázové_jméno',
    'password': 'vaše_heslo',
    'host': 'localhost',  # nebo IP adresa vašeho serveru
    'database': 'hotel2',
    'raise_on_warnings': True
}

Krok 4: Spuštění Aplikace
Spusťte aplikaci:
V adresáři projektu spusťte hlavní skript aplikace, který by měl být app.py nebo podobně:
bash
python app.py
Přístup k aplikaci:
Flask server běží na localhost:5000 (nebo na jakémkoliv portu, který jste nastavili), takže aplikaci můžete otevřít v prohlížeči na adrese:
http://localhost:5000/

Krok 5: Použití Aplikace
Prohlížení, vytváření, úpravu a mazání záznamů můžete provádět pomocí webového rozhraní, které by mělo být k dispozici po spuštění aplikace.
URL struktura by mohla vypadat například takto:
Prohlížení seznamu zákazníků: /list/Zakaznik
Přidání nového pokoje: /add/Pokoj
Aktualizace záznamu: /update/Adresa/ID

Krok 6: Import Dat
Pokud chcete importovat další data, můžete použít endpointy jako /import/Zeme s nahráváním CSV, JSON nebo XML souborů.

Poznámky
Ujistěte se, že máte správná práva pro přístup k databázi.
Pokud narazíte na problémy s připojením k databázi, zkontrolujte config.py nebo místo, kde je definováno připojení k DB.
Pro vývoj je doporučeno používat python app.py s argumentem --debug, aby bylo možné sledovat vývojové chyby v reálném čase.

Pokud máte jakékoli další dotazy nebo problémy, neváhejte nás kontaktovat nebo vytvořte issue na GitHubu.
