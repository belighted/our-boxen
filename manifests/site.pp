require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::home}/homebrew/bin",
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin'
  ],

  environment => [
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::boxen_user}"
  ]
}

File {
  group => 'staff',
  owner => $boxen_user
}

Package {
  provider => homebrew,
  require  => Class['homebrew']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => File["${boxen::config::bindir}/boxen-git-credential"],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node default {
  # core modules, needed for most things
  include homebrew
  include autoconf
  include automake
  include git
  include hub
  include dnsmasq

  include openssl
  class { 'ruby::global':
    version => '2.0.0-p353'
  }
  ruby::version { '2.1.0': }

  include nodejs::v0_10

  nodejs::module { ['yeoman', 'socket.io', 'express']:
    node_version => 'v0.10'
  }

#  include sublime_text_2
#  sublime_text_2::package { 'Emmet':
#    source => 'sergeche/emmet-sublime'
#  }
  include alfred
  include autojump
  include chrome
  include dropbox
  include firefox
  include skype
  include spotify
#  include steam
  include tower
  include transmission
  include vlc
  include wkhtmltopdf
  include wget
  include pgadmin3
  phantomjs::version { '1.9.2': }
  include postgresql
  include pow
  include heroku
  include hipchat
  include zsh
  include iterm2::stable
  include onepassword
  include mou
#  include sequel_pro
#  include redis
#  include istatmenus4
#  include mongodb

  package {
    [
      'ack',
      'findutils',
      'gnu-tar',
      'chromedriver',
      'imagemagick',
      'watch'
    ]:
  }

  include osx::global::expand_print_dialog
  include osx::global::expand_save_dialog
  include osx::finder::show_external_hard_drives_on_desktop
  include osx::finder::show_removable_media_on_desktop
  include osx::finder::empty_trash_securely
  include osx::universal_access::ctrl_mod_zoom
  include osx::no_network_dsstores
  include osx::software_update

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }
}
