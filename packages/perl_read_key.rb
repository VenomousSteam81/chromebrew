require 'package'
Package.load_package("#{__dir__}/perl_term_readkey.rb")

class Perl_read_key < Package
  description 'Term::ReadKey - A perl module for simple terminal control'
  homepage 'https://metacpan.org/pod/Term::ReadKey'
  version Perl_term_readkey.version
  license 'GPL-1+ or Artistic'
  compatibility 'all'

  is_fake

  depends_on 'perl_term_readkey'
end
