require 'package'

class Glib < Package
  description 'GLib provides the core application building blocks for libraries and applications written in C.'
  homepage 'https://developer.gnome.org/glib'
  version '2.76.3'
  license 'LGPL-2.1'
  compatibility 'all'
  source_url 'https://gitlab.gnome.org/GNOME/glib.git'
  git_hashtag version

  binary_url({
    aarch64: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/glib/2.76.3_armv7l/glib-2.76.3-chromeos-armv7l.tar.zst',
     armv7l: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/glib/2.76.3_armv7l/glib-2.76.3-chromeos-armv7l.tar.zst',
       i686: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/glib/2.76.3_i686/glib-2.76.3-chromeos-i686.tar.zst',
     x86_64: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/glib/2.76.3_x86_64/glib-2.76.3-chromeos-x86_64.tar.zst'
  })
  binary_sha256({
    aarch64: 'ea45ec63316031319b99b8e66228574c360a188a9b0a2e386d1be7083baced42',
     armv7l: 'ea45ec63316031319b99b8e66228574c360a188a9b0a2e386d1be7083baced42',
       i686: '924fed84893dcf1022a0d9e502f745bd342f8bfada90862363565cbff7b0741d',
     x86_64: '692f4b1cbc1571268f7b84f800de561f638419a387b8b159b8ad1c3aeec7f7aa'
  })

  depends_on 'elfutils' # R
  depends_on 'libffi' # R
  depends_on 'pcre' # R
  depends_on 'py3_pygments' => :build
  depends_on 'shared_mime_info' # L
  depends_on 'util_linux' # R
  depends_on 'zlibpkg' # R
  depends_on 'pcre2' # R
  depends_on 'gcc_lib' # R

  no_strip if %w[aarch64 armv7l].include? ARCH
  gnome

  def self.build
    system "mold -run meson setup #{CREW_MESON_OPTIONS.gsub('strip=true', 'strip=false')} \
    -Dselinux=disabled \
    -Dsysprof=disabled \
    -Dman=false \
    -Dtests=false \
    builddir"
    system 'meson configure builddir'
    system "mold -run #{CREW_NINJA} -C builddir"
  end

  def self.install
    system "DESTDIR=#{CREW_DEST_DIR} #{CREW_NINJA} -C builddir install"
    # Create libtool file. Needed by handbrake build.
    return if File.file?("#{CREW_DEST_LIB_PREFIX}/#{@libname}.la")

    @libname = name.to_s.start_with?('lib') ? name.downcase : "lib#{name.downcase}"
    @libnames = Dir["#{CREW_DEST_LIB_PREFIX}/#{@libname}.so*"]
    @libnames = Dir["#{CREW_DEST_LIB_PREFIX}/#{@libname}-*.so*"] if @libnames.empty?
    @libnames.each do |s|
      s.gsub!("#{CREW_DEST_LIB_PREFIX}/", '')
    end
    @dlname = @libnames.grep(/.so./).first
    @libname = @dlname.gsub(/.so.\d+/, '')
    @longest_libname = @libnames.max_by(&:length)
    @libvars = @longest_libname.rpartition('.so.')[2].split('.')

    @libtool_file = <<~LIBTOOLEOF
      # #{@libname}.la - a libtool library file
      # Generated by libtool (GNU libtool) (Created by Chromebrew)
      #
      # Please DO NOT delete this file!
      # It is necessary for linking the library.

      # The name that we can dlopen(3).
      dlname='#{@dlname}'

      # Names of this library.
      library_names='#{@libnames.reverse.join(' ')}'

      # The name of the static archive.
      old_library='#{@libname}.a'

      # Linker flags that cannot go in dependency_libs.
      inherited_linker_flags=''

      # Libraries that this one depends upon.
      dependency_libs=''

      # Names of additional weak libraries provided by this library
      weak_library_names=''

      # Version information for #{name}.
      current=#{@libvars[1]}
      age=#{@libvars[1]}
      revision=#{@libvars[2]}

      # Is this an already installed library?
      installed=yes

      # Should we warn about portability when linking against -modules?
      shouldnotlink=no

      # Files to dlopen/dlpreopen
      dlopen=''
      dlpreopen=''

      # Directory that this library needs to be installed in:
      libdir='#{CREW_LIB_PREFIX}'
    LIBTOOLEOF
    File.write("#{CREW_DEST_LIB_PREFIX}/#{@libname}.la", @libtool_file)
  end
end
