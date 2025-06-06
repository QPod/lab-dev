source /opt/utils/script-utils.sh


setup_R_rstudio() {
  #  https://posit.co/download/rstudio-server/
     RSTUDIO_VERSION=$(curl -sL https://download2.rstudio.org/current.ver | cut -d'.' -f'1-3' | sed 's/+/-/g' ) \
  && RSTUDIO_URL="https://download2.rstudio.org/server/jammy/amd64/rstudio-server-${RSTUDIO_VERSION}-amd64.deb" \
  && curl -sL -o /tmp/rstudio.deb ${RSTUDIO_URL} \
  && dpkg -x /tmp/rstudio.deb /tmp && mv /tmp/usr/lib/rstudio-server/ /opt/ \
  && ln -sf /opt/rstudio-server         /usr/lib/ \
  && ln -sf /opt/rstudio-server/bin/rs* /usr/bin/

  # Allow RStudio server run as root user
  # Configuration to make RStudio server disable authentication and do not run as daemon
     mkdir -pv /etc/rstudio \
  && echo "server-daemonize=0"     >> /etc/rstudio/rserver.conf \
  && echo "server-user=root"       >> /etc/rstudio/rserver.conf \
  && echo "auth-none=1"            >> /etc/rstudio/rserver.conf \
  && echo "auth-minimum-user-id=0" >> /etc/rstudio/rserver.conf \
  && echo "auth-validate-users=0"  >> /etc/rstudio/rserver.conf \
  && echo "www-allow-origin=*"     >> /etc/rstudio/rserver.conf \
  && echo "www-same-site=none"     >> /etc/rstudio/rserver.conf \
  && echo "www-frame-origin=same"  >> /etc/rstudio/rserver.conf \
  && echo "www-verify-user-agent=0">> /etc/rstudio/rserver.conf \
  && echo "database-config-file=/etc/rstudio/db.conf"  >> /etc/rstudio/rserver.conf \
  && echo "provider=sqlite"                            >> /etc/rstudio/db.conf \
  && echo "directory=/var/run/rstudio-server/"         >> /etc/rstudio/db.conf \
  && echo "[*]"                     > /etc/rstudio/logging.conf \
  && echo "log-dir=/var/log"       >> /etc/rstudio/logging.conf ;

  type rstudio-server && echo "@ Version of rstudio-server: $(rstudio-server version)" || return -1 ;
}


setup_R_rshiny() {
  #  https://posit.co/download/shiny-server/
     RSHINY_VERSION=$(curl -sL https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-18.04/x86_64/VERSION) \
  && RSHINY_URL="https://download3.rstudio.org/ubuntu-18.04/x86_64/shiny-server-${RSHINY_VERSION}-amd64.deb" \
  && curl -sL -o /tmp/rshiny.deb ${RSHINY_URL} \
  && dpkg -i /tmp/rshiny.deb \
  && sed  -i "s/run_as shiny;/run_as root;/g"  /etc/shiny-server/shiny-server.conf \
  && sed  -i "s/srv/root/g"                    /etc/shiny-server/shiny-server.conf \
  && printf '#!/bin/bash\n'                    > /usr/local/bin/start-shiny-server.sh \
  && printf 'USER=root exec shiny-server\n'   >> /usr/local/bin/start-shiny-server.sh \
  && chmod u+x /usr/local/bin/start-shiny-server.sh

  # Remove shiny's pandoc and pandoc-proc to reduce size if they are already installed in the jpy-latex step.
     ( which pandoc          && rm -rf /opt/shiny-server/ext/pandoc/pandoc          || true ) \
  && ( which pandoc-citeproc && rm -rf /opt/shiny-server/ext/pandoc/pandoc-citeproc || true ) \
  && rm -rf /opt/shiny-server/ext/node/bin/shiny-server \
  && ln -sf /opt/shiny-server/ext/node/bin/node /opt/shiny-server/ext/node/bin/shiny-server

  # hack shiny-server to allow run in root user: https://github.com/rstudio/shiny-server/pull/391
  sed  -i "s/throw new Error/logger.warn/g"  /opt/shiny-server/lib/worker/app-worker.js

  type shiny-server && echo "@ Version of shiny-server: $(shiny-server --version)" || return -1 ;
}
