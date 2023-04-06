# APKBUILD for Golang project's

The following template can be used to generate an Alpine APKs from your own Golang project hosted on [github.com](github.com). 

Note, there are currently no example packages in this repository.

```sh
# Contributor: Your Name <youremail@domain.com>
# Maintainer: Your Name <youremail@domain.com>
pkgname=mygoproject
pkgver=1.0.0
pkgrel=0
pkgdesc="My Golang project"
url="https://github.com/yourusername/mygoproject"
arch="all"
license="MIT"
depends=""
makedepends="go"
source="https://github.com/yourusername/mygoproject/archive/v$pkgver.tar.gz"
builddir="$srcdir/mygoproject-$pkgver"

build() {
	cd "$builddir"
	export GOPATH="$builddir/build"
	go build -o mygoproject
}

package() {
	cd "$builddir"
	install -Dm755 mygoproject "$pkgdir/usr/bin/mygoproject"
}

sha512sum="
1234567890abcdef1234567890abcdef  v1.0.0.tar.gz
"
```
