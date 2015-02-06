name              'webapp'
maintainer        'Vu Chau'
maintainer_email  'vuctdn@gmail.com'
license           'Apache 2.0'
description       'Installs django webapplication'
version           '1.0.0'
recipe            'webapp::default', 'Installs django webapplication.'

depends "openssl"
depends "build-essential"
depends "git"
depends "python"
depends "apt"
depends "postgresql"
