# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

class macos_utils::show_full_name (
    Boolean $enabled = false,
) {
    $val = $enabled ? { true => '1', false => '0' }

    if $::operatingsystem == 'Darwin' {
        macos_utils::defaults { 'show_full_name':
            domain => '/Library/Preferences/com.apple.loginwindow',
            key    => 'SHOWFULLNAME',
            value  => $val,
        }
    } else {
        fail("${module_name} does not support ${::operatingsystem}")
    }
}
