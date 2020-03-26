require 'package'

class Wayland_protocols < Package
  description 'Wayland is a protocol for a compositor to talk to its clients.'
  homepage 'https://wayland.freedesktop.org/'
  version '1.20'
  source_url 'https://wayland.freedesktop.org/releases/wayland-protocols-1.20.tar.xz'
  source_sha256 '9782b7a1a863d82d7c92478497d13c758f52e7da4f197aa16443f73de77e4de7'

  binary_url ({
  })
  binary_sha256 ({
  })

  depends_on 'wayland'

  def self.build
    system './configure',
           "--prefix=#{CREW_PREFIX}",
           "--libdir=#{CREW_LIB_PREFIX}"
    system 'make'
  end

  def self.install
    system 'make', "DESTDIR=#{CREW_DEST_DIR}", 'install'
  end
end
