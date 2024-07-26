require 'buildsystems/pip'

class Py3_pillow < Pip
  description 'Pillow is a Python Imaging Library (PIL).'
  homepage 'https://python-pillow.org/'
  @_ver = '9.2.0'
  version "#{@_ver}-py3.12"
  license 'HPND'
  compatibility 'x86_64 aarch64 armv7l'
  source_url 'SKIP'

  depends_on 'freetype' # R
  depends_on 'glibc' # R
  depends_on 'lcms' # R
  depends_on 'libjpeg_turbo'
  depends_on 'libtiff' # R
  depends_on 'libwebp' # R
  depends_on 'libxcb'
  depends_on 'openjpeg' # R
  depends_on 'py3_lxml'
  depends_on 'py3_xlsxwriter'
  depends_on 'python3' => :build
  depends_on 'zlib' # R

  no_compile_needed
end
