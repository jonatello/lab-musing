VirtualHost *:443>
    ServerName example.com
	ServerAlias www.example.com
                DocumentRoot "/usr/local/www/apache24/data/"
	SSLEngine on

	SSLCertificateFile "/usr/local/etc/letsencrypt/live/www.example.com/cert.pem"
	SSLCertificateKeyFile "/usr/local/etc/letsencrypt/live/www.example.com/privkey.pem"
	SSLCertificateChainFile "/usr/local/etc/letsencrypt/live/www.example.com/fullchain.pem"

<FilesMatch "\.(cgi|shtml|phtml|php)$">
    SSLOptions +StdEnvVars
</FilesMatch>

<Directory "/usr/local/www/apache24/cgi-bin">
    SSLOptions +StdEnvVars
</Directory>

	BrowserMatch "MSIE [2-5]" \
        nokeepalive ssl-unclean-shutdown \
        downgrade-1.0 force-response-1.0

	CustomLog "/var/log/apache/httpd-ssl_request.log" \
          "%t %h %{SSL_PROTOCOL}x %{SSL_CIPHER}x \"%r\" %b"

	<Directory "/usr/local/www/apache24/data/">
            Options Indexes FollowSymLinks MultiViews
        #AllowOverride controls what directives may be placed in .htaccess files.       
                        AllowOverride All
        #Controls who can get stuff from this server file
                        Require all granted
        </Directory>
       
    ErrorLog "/var/log/apache/example.com.ssl-error.log"
    CustomLog "/var/log/apache/example.com.ssl-access_log" combined

</VirtualHost>
