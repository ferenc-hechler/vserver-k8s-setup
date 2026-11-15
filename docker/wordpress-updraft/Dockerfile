FROM bitnami/wordpress:latest

# Als Root-Benutzer wechseln, um Schreibrechte zu haben (falls nötig)
USER root

# UpdraftPlus-Plugin herunterladen
RUN curl -o /tmp/updraftplus.zip https://downloads.wordpress.org/plugin/updraftplus.zip

# PHP nutzen, um das ZIP-Archiv ohne unzip-Befehl zu entpacken
RUN php -r '$zip = new ZipArchive; if ($zip->open("/tmp/updraftplus.zip") === TRUE) { $zip->extractTo("/opt/bitnami/wordpress/wp-content/plugins/"); $zip->close(); echo "Erfolgreich entpackt\n"; } else { echo "Fehler beim Entpacken\n"; exit(1); }'

# Heruntergeladene ZIP-Datei wieder löschen
RUN rm /tmp/updraftplus.zip

# Korrekte Dateiberechtigungen für den Bitnami-Benutzer wiederherstellen
RUN chown -R 1001:1001 /opt/bitnami/wordpress/wp-content/plugins/updraftplus

# Das Init-Skript in den von Bitnami vorgesehenen Ordner kopieren
COPY activate-plugin.sh /docker-entrypoint-initd/activate-plugin.sh
COPY activate-plugin.sh /docker-entrypoint-initdb.d/activate-plugin.sh

# Sicherstellen, dass das Skript ausführbar ist und dem richtigen Benutzer gehört
RUN chmod +x /docker-entrypoint-initd/activate-plugin.sh \
    && chown 1001:1001 /docker-entrypoint-initd/activate-plugin.sh
	RUN chmod +x /docker-entrypoint-initdb.d/activate-plugin.sh \
	    && chown 1001:1001 /docker-entrypoint-initdb.d/activate-plugin.sh
	
# Zurück zum Standard-Bitnami-Benutzer wechseln
USER 1001
