# Maintainer: peuborges <peuborges@proton.me>
pkgname=fnaf-cli
pkgver=1.0.0
pkgrel=1
pkgdesc="Five Nights at Freddy's - Terminal Edition for Linux (Bash port)"
arch=('any')
url="https://github.com/peuborges/fnaf-cli"
license=('Unlicense')
depends=('bash' 'mpg123' 'coreutils')
makedepends=('git')
source=("$pkgname::git+https://github.com/peuborges/fnaf-cli.git")
sha256sums=('SKIP')

package() {
    cd "$srcdir/$pkgname"

    install -Dm755 "fnaf-cli" "$pkgdir/usr/bin/fnaf-cli"
    install -Dm644 "LICENSE" "$pkgdir/usr/share/licenses/$pkgname/LICENSE"

    mkdir -p "$pkgdir/usr/share/$pkgname"
    cp -r assets "$pkgdir/usr/share/$pkgname/"
    cp -r audio "$pkgdir/usr/share/$pkgname/"
    cp -r lib "$pkgdir/usr/share/$pkgname/"
    cp README.md "$pkgdir/usr/share/$pkgname/"

    install -Dm644 "README.md" "$pkgdir/usr/share/doc/$pkgname/README.md"

    # Fix paths in scripts for system-wide install
    sed -i "s|\"\$(cd \"\$(dirname \"\$0\")\" && pwd)\"|\"/usr/share/$pkgname\"|g" \
        "$pkgdir/usr/bin/fnaf-cli"
    sed -i "s|\"\$(cd \"\$(dirname \"\$0\")/..\" && pwd)\"|\"/usr/share/$pkgname\"|g" \
        "$pkgdir/usr/share/$pkgname/lib/events.sh"
}
