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
  include ruby::2_0_0
  include ruby::2_1_0
  
  include nodejs::v0_10
  
  include alfred
  include autojump
  include chrome
  include cloudapp
  include dropbox
  include firefox
  include skype
  include spotify
  include tower
  include transmission
  include vlc
  include wkhtmltopdf
  include wget
  include pgadmin3
  include phantomjs::1_9_2
  include postgresql
  include pow
  include heroku
  include hipchat
  include zsh
  
  dockutil::item { 'Add chrome':
    item     => "/Applications/Google Chrome.app",
    label    => "Google Chrome",
    action   => "add",
    position => 1,
  }
  dockutil::item { 'Add airmail':
    item     => "/Applications/Airmail.app",
    label    => "Airmail",
    action   => "add",
    position => 2,
  }
  dockutil::item { 'Add osfoora':
    item     => "/Applications/Osfoora.app",
    label    => "Osfoora",
    action   => "add",
    position => 3,
  }
  dockutil::item { 'Add skype':
    item     => "/Applications/Skype.app",
    label    => "Skype",
    action   => "add",
    position => 4,
  }
  dockutil::item { 'Add hipchat':
    item     => "/Applications/HipChat.app",
    label    => "HipChat",
    action   => "add",
    position => 5,
  }
  dockutil::item { 'Add MacVim':
    item     => "/Applications/MacVim.app",
    label    => "MacVim",
    action   => "add",
    position => 6,
  }
  dockutil::item { 'Add iterm':
    item     => "/Applications/iTerm.app",
    label    => "iTerm",
    action   => "add",
    position => 7,
  }
  dockutil::item { 'Add calendar':
    item     => "/Applications/Calendar.app",
    label    => "Calendar",
    action   => "add",
    position => 8,
  }
  dockutil::item { 'Add spotify':
    item     => "/Applications/Spotify.app",
    label    => "Spotify",
    action   => "add",
    position => 9,
  }
  dockutil::item { 'Add transmission':
    item     => "/Applications/Transmission.app",
    label    => "Transmission",
    action   => "add",
    position => 10,
  }
  dockutil::item { 'Add 1password':
    item     => "/Applications/1Password.app",
    label    => "1Password",
    action   => "add",
    position => 11,
  }

  homebrew::tap { 'joelcogen/macvimsplitbrowser': }
  package {
    [
      'ack',
      'findutils',
      'gnu-tar',
      'macvim-split-browser',
      'chromedriver',
      'imagemagick',
      'watch'
    ]:
  }
  
  include osx::global::expand_print_dialog
  include osx::global::expand_save_dialog
  include osx::global::disable_remote_control_ir_receiver
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
