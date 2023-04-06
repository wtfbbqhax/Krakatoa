# APKBUILD for Rust project

The following template can be used to generate an Alpine APKs from your own Rust project hosted on [github.com](github.com). 

For a full example, see [packages/lightspd-manifest](../packages/lightspd-manifest/APKBUILD).

```sh
# Contributor: Your Name <youremail@domain.com>
# Maintainer: Your Name <youremail@domain.com>
pkgname=myrustproject
pkgver=0.1.0
pkgrel=0
pkgdesc="My Rust project"
url="https://github.com/yourusername/myrustproject"
arch="all"
license="MIT"
options="!check"
giturl="https://github.com/yourusername/myrustproject.git"
makedepends="cargo git"
builddir="$srcdir/$pkgname"

prepare() {
    mkdir -p "$builddir"
    git clone --depth 1 --branch main "$giturl" "$builddir"
}

build() {
    cd "$builddir"
    cargo build --release
}

package() {
    mkdir -p "$pkgdir"
    cd "$pkgdir"
    cargo install --path "$builddir" --root "$PWD/usr/"
}
```
