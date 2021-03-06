# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

class roles_profiles::profiles::cltbld_user {

    case $::operatingsystem {
        'Darwin': {
            $password     = lookup('cltbld_user.password')
            $salt         = lookup('cltbld_user.salt')
            $iterations   = lookup('cltbld_user.iterations')
            $kcpassword   = lookup('cltbld_user.kcpassword')

            # Create the cltbld user
            users::single_user { 'cltbld':
                # Bug 1122875 - cltld needs to be in this group for debug tests
                groups     => [ '_developer' ],
                password   => $password,
                salt       => $salt,
                iterations => $iterations,
            }

            # Set user to autologin
            class { 'macos_utils::autologin_user':
                user       => 'cltbld',
                kcpassword => $kcpassword,
            }

            # Enable DevToolsSecurity
            include macos_utils::enable_dev_tools_security

            macos_utils::clean_appstate { 'cltbld':
                user  => 'cltbld',
                group => 'staff',
            }
        }
        default: {
            fail("${::operatingsystem} not supported")
        }
    }
}
