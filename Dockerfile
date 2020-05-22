FROM mjclottery/php-azure-webapp

# switch working directory
WORKDIR /var/www/html

# download mediawiki with azure fixes and with included release extensions
RUN set -eux; \
	git clone --single-branch --branch "azure-friendly-1-34-1" --depth=1 https://github.com/callahm3/mediawiki.git; \
	cd mediawiki; \
	git submodule update --init; \
	cd /var/www/html; \
	/bin/cp -rf mediawiki/. . ;\
	rm -rf .git ;\
	rm -rf mediawiki; \
	rm -rf vendor \
	;

# copy composer.local.json config (not to be confused with docker-compose) file
COPY config/composer.local.json /var/www/html/composer.local.json

# download extra extensions (commonly used extensions for wikipedia modules)
RUN set -eux; \
	cd extensions; \
	git clone --single-branch --branch "REL1_34" --depth=1 https://github.com/wikimedia/mediawiki-extensions-Wikibase.git; \
	cd mediawiki-extensions-Wikibase; \
	git submodule update --init --recursive; \
	cd ..; \
	mv mediawiki-extensions-Wikibase Wikibase; \
	#
	#
	# git clone --single-branch --branch "REL1_34" --depth=1 https://github.com/wikimedia/mediawiki-extensions-InputBox.git; \
	# cd mediawiki-extensions-InputBox; \
	# git submodule update --init --recursive; \
	# cd ..; \
	git clone --single-branch --branch "REL1_34" --depth=1 https://github.com/wikimedia/mediawiki-extensions-TemplateData.git; \
	cd mediawiki-extensions-TemplateData; \
	git submodule update --init --recursive; \
	cd ..; \
	mv mediawiki-extensions-TemplateData TemplateData; \
	#
	#
	git clone --single-branch --branch "REL1_34" --depth=1 https://github.com/wikimedia/mediawiki-extensions-CirrusSearch.git; \
	cd mediawiki-extensions-CirrusSearch; \
	git submodule update --init --recursive; \
	cd ..; \
	mv mediawiki-extensions-CirrusSearch CirrusSearch; \
	#
	#
	# git clone --single-branch --branch "REL1_34" --depth=1 https://github.com/wikimedia/mediawiki-extensions-Cite.git; \
	# cd mediawiki-extensions-Cite; \
	# git submodule update --init --recursive; \
	# cd ..; \
	git clone --single-branch --branch "REL1_34" --depth=1 https://github.com/wikimedia/mediawiki-extensions-TemplateStyles.git; \
	cd mediawiki-extensions-TemplateStyles; \
	git submodule update --init --recursive; \
	cd ..; \
	mv mediawiki-extensions-TemplateStyles TemplateStyles; \
	#
	#
	git clone --single-branch --branch "REL1_34" --depth=1 https://github.com/wikimedia/mediawiki-extensions-TemplateWizard.git; \
	cd mediawiki-extensions-TemplateWizard; \
	git submodule update --init --recursive; \
	cd ..; \
	mv mediawiki-extensions-TemplateWizard TemplateWizard; \
	#
	#
	git clone --single-branch --branch "REL1_34" --depth=1 https://github.com/wikimedia/mediawiki-extensions-WikibaseCirrusSearch.git; \
	cd mediawiki-extensions-WikibaseCirrusSearch; \
	git submodule update --init --recursive; \
	cd ..; \
	mv mediawiki-extensions-WikibaseCirrusSearch WikibaseCirrusSearch; \
	#
	#
	git clone --single-branch --branch "REL1_34" --depth=1 https://github.com/wikimedia/mediawiki-extensions-Elastica.git; \
	cd mediawiki-extensions-Elastica; \
	git submodule update --init --recursive; \
	cd ..; \
	mv mediawiki-extensions-Elastica Elastica \
	;

# have composer associate extensions and install dependencies
RUN php /usr/local/bin/composer.phar install --no-dev

# change ownership to nginx
RUN chown -R nginx:nginx /var/www/ && \
	chown -R nginx:nginx /run && \
	chown -R nginx:nginx /var/lib/nginx && \
	chown -R nginx:nginx /var/log/nginx && \
	chown -R nginx:nginx /etc/nginx-cache

# COPY src/cache_test.php /var/www/html/cache_test.php

# COPY src/info.php /var/www/html/info.php
# Copy entrypoint and config files
COPY docker-entrypoint.sh /dockerfiles/docker-entrypoint.sh
# COPY config/nginx.conf /etc/nginx/nginx.conf
# COPY config/fpm-pool.conf /etc/php7/php-fpm.d/www.conf
# COPY config/php.ini /etc/php7/conf.d/custom.ini
# COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# COPY config/userlist.txt /etc/pgbouncer/userlist.txt
# COPY config/custom_pgbouncer.ini /etc/pgbouncer/custom_pgbouncer.ini

RUN set -eux; \
	mv /var/www/html/images /var/www/html/azure_install_images\
	;

# expose web port and ssh port
EXPOSE 8080 2222

ENTRYPOINT [ "/dockerfiles/docker-entrypoint.sh" ]