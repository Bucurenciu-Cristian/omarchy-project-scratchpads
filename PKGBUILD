# Maintainer: Bogdan Cristian Bucurenciu <bucurenciu.cristian@gmail.com>
pkgname=omarchy-project-scratchpads
pkgver=1.0.0
pkgrel=1
pkgdesc="Project-specific special workspaces for Hyprland with tmux session sync (omarchy extension)"
arch=('any')
url="https://github.com/Bucurenciu-Cristian/${pkgname}"
license=('MIT')
depends=('omarchy' 'tmux' 'jq')
optdepends=(
  'fd: faster directory browsing in project picker'
  'walker: GUI picker interface (omarchy default launcher)'
)
install="${pkgname}.install"
source=("${pkgname}-${pkgver}.tar.gz::${url}/archive/v${pkgver}.tar.gz")
sha256sums=('SKIP')

package() {
  cd "${pkgname}-${pkgver}"

  # Install scripts to /usr/bin
  install -d "${pkgdir}/usr/bin"
  for script in bin/*; do
    install -Dm755 "${script}" "${pkgdir}/usr/bin/$(basename "${script}")"
  done

  # Install example config
  install -Dm644 projects.conf.example \
    "${pkgdir}/usr/share/${pkgname}/projects.conf.example"

  # Install license
  install -Dm644 LICENSE "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
}
