source /opt/utils/script-utils.sh

setup_clash() {
  #  Install the latest release: https://github.com/MetaCubeX/mihomo/tree/Alpha
     VER_CLASH=$(curl -sL https://github.com/MetaCubeX/mihomo/releases.atom | grep 'releases/tag/v' | head -1 | grep -Po '\d[\d.]+' ) \
  && URL_CLASH="https://github.com/MetaCubeX/mihomo/archive/refs/tags/v$VER_CLASH.tar.gz" \
  && echo "Downloading clash version ${VER_CLASH} from: ${URL_CLASH}" \
  && install_tar_gz $URL_CLASH \
  && mv /opt/mihomo-* /tmp/clash && cd /tmp/clash \
  && export BUILDTIME=$(date -u) \
  && export GOARCH=amd64 && export GOOS=linux && export GOAMD64=v3 && export CGO_ENABLED=0 \
  && opt='-X \"github.com/metacubex/mihomo/constant.Version=${VER_CLASH}\" -X \"github.com/metacubex/mihomo/constant.BuildTime=${BUILDTIME}\" -w -s -buildid=1' \
  && opt=$(eval echo $opt) \
  && cmd="go build -tags with_gvisor -trimpath -o /opt/clash/clash -ldflags '${opt}'" \
  && eval $cmd && /opt/clash/clash -v \
  && echo "@ Version of Clash $(clash -v)"

     mkdir -pv /opt/clash/config \
  && wget -O /opt/clash/config/geoip.metadb https://fastly.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geoip.metadb \
  && wget -O /opt/clash/config/geosite.dat  https://fastly.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geosite.dat \
  && wget -O /opt/clash/config/geoip.dat    https://fastly.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geoip.dat
}

setup_verge() {
    #  Install the latest release: https://clash-verge-rev.github.io/index.html
     VER_VERGE=$(curl -sL https://github.com/clash-verge-rev/clash-verge-rev/releases.atom | grep 'releases/tag/v' | head -1 | grep -Po '\d[\d.]+' ) \
  && URL_VERGE="https://github.com/clash-verge-rev/clash-verge-rev/archive/refs/tags/v$VER_VERGE.tar.gz" \
  && echo "Downloading clash-verge version ${VER_VERGE} from: ${URL_VERGE}" \
  && install_tar_gz $URL_VERGE \
  && mv /opt/clash-verge-* /tmp/verge && cd /tmp/verge \
  && npm i && npm run web:build && ls -alh \
  && mv /tmp/verge/dist /opt/clash/ui
}