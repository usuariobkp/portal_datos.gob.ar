FROM datosgobar/portal-base:release-0.8.19
MAINTAINER Leandro Gomez<lgomez@devartis.com>

ARG PORTAL_VERSION
ENV CKAN_HOME /usr/lib/ckan/default
ENV CKAN_DIST_MEDIA /usr/lib/ckan/default/src/ckanext-gobar-theme/ckanext/gobar_theme/public/user_images
ENV CKAN_DEFAULT /etc/ckan/default

WORKDIR /portal
RUN $CKAN_HOME/bin/pip install -e git+https://github.com/datosgobar/datos.gob.ar.git#egg=ckanext-gobar_theme
COPY ./conf/config/init_datosgobar.sh /etc/ckan_init.d/
COPY ./conf/config/remove_google_analytics_plugin.sh /etc/ckan_init.d/
RUN bash /etc/ckan_init.d/remove_google_analytics_plugin.sh
RUN mkdir -p $CKAN_DIST_MEDIA
RUN chown -R www-data:www-data $CKAN_DIST_MEDIA
RUN chmod u+rwx $CKAN_DIST_MEDIA
RUN echo "$PORTAL_VERSION" > /portal/version

VOLUME $CKAN_DIST_MEDIA $CKAN_DEFAULT
