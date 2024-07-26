require 'package'

class Libmetalink < Package
  description 'libmetalink is a Metalink library written in C language.'
  homepage 'https://launchpad.net/libmetalink/'
  version '0.1.3-4'
  license 'MIT'
  compatibility 'all'
  source_url 'https://launchpad.net/libmetalink/trunk/libmetalink-0.1.3/+download/libmetalink-0.1.3.tar.xz'
  source_sha256 '86312620c5b64c694b91f9cc355eabbd358fa92195b3e99517504076bf9fe33a'
  binary_compression 'tar.zst'

  binary_sha256({
    aarch64: '8bd31fde06e46219af5b677ba5c9b07a08791ac55e54210c5cffab26388765ae',
     armv7l: '8bd31fde06e46219af5b677ba5c9b07a08791ac55e54210c5cffab26388765ae',
       i686: 'bd310b53a21259a255b889a5bd45aa8be2e37fb27fa46e7335e5301e5527ded2',
     x86_64: '8310e4105b2420764bad16dc53886172f7fe1bd80a87c2b22df3c4781db76077'
  })

  depends_on 'glibc' # R
  depends_on 'icu4c' # R
  depends_on 'libxml2' # R
  depends_on 'zlib' # R

  def self.patch
    downloader 'https://launchpadlibrarian.net/380798344/0001-fix-covscan-issues.patch',
               'd236dfa0d4a1938a40ff2ce4dd348c42b74ad68807df0f1b6ea69c11725fd9cf'
    system 'patch -Np1 -i 0001-fix-covscan-issues.patch'
    system 'filefix'
  end

  def self.build
    system "./configure #{CREW_OPTIONS} \
      --with-libxml2 \
      --without-libexpat"
    system 'make'
  end

  def self.check
    system 'make', 'check'
  end

  def self.install
    system 'make', "DESTDIR=#{CREW_DEST_DIR}", 'install'
  end
end
