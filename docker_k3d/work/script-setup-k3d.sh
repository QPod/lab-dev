setup_k3d() {
  ARCH="amd64"
  #  Install the latest release: https://github.com/k3d-io/k3d
     VER_K3D=$(curl -sL https://github.com/k3d-io/k3d/releases.atom | grep 'releases/tag/v' | head -1 | grep -Po '\d[\d.]+' ) \
  && URL_K3D="https://github.com/k3d-io/k3d/releases/download/v$VER_K3D/k3d-linux-$ARCH" \
  && echo "Downloading k3d version ${VER_K3D} from: ${URL_K3D}" \
  && curl -L -o /opt/k3d/k3d $URL_K3D \
  && chmod +x /opt/k3d/k3d && ln -sf /opt/k3d/k3d /usr/local/bin/ \
  && k3d version
}

setup_kubectl() {
  ARCH="amd64"
  # https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-kubectl-binary-with-curl-on-linux
     VER_KUBECTL=$(curl -L -s https://dl.k8s.io/release/stable.txt) \
  && URL_KUBECTL="https://dl.k8s.io/release/$VER_KUBECTL/bin/linux/amd64/kubectl" \
  && echo "Downloading kubectl version ${VER_KUBECTL} from: ${URL_KUBECTL}" \
  && curl -L -o /opt/k3d/kubectl $URL_KUBECTL \
  && chmod +x /opt/k3d/kubectl && ln -sf /opt/k3d/kubectl /usr/local/bin/
}
