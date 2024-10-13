# SPDX-FileCopyrightText:  2021 Richard Brežák and NixNG contributors
#
# SPDX-License-Identifier: MPL-2.0
#
#   This Source Code Form is subject to the terms of the Mozilla Public
#   License, v. 2.0. If a copy of the MPL was not distributed with this
#   file, You can obtain one at http://mozilla.org/MPL/2.0/.

{ lib
, writeShellScript
}:
{ n, s, cfgInit }:
with lib;
writeShellScript "${n}-finish" ''
  ${concatStringsSep "\n" (mapAttrsToList (cn: cv:
    with cv;
    optionalString (!cv.persistent) ''
      if [[ -e ${dst} ]] ; then
        echo '${n}: removing non-presistent `${dst}`'
        rm -v ${dst}
      fi
    ''
  ) s.ensureSomething.link)}

  ${concatStringsSep "\n" (mapAttrsToList (cn: cv:
    with cv;
    optionalString (!cv.persistent) ''
      if [[ -e ${dst} ]] ; then
        echo '${n}: removing non-presistent `${dst}`'
        rm -rv ${dst}
      fi
    ''
  ) s.ensureSomething.copy)}

  ${concatStringsSep "\n" (mapAttrsToList (cn: cv:
    abort "linkFarm is not implemented yet in runit!"
  ) s.ensureSomething.linkFarm)}

  ${concatStringsSep "\n" (mapAttrsToList (cn: cv:
    with cv;
    optionalString (!cv.persistent) ''
      if [[ -e ${dst} ]] ; then
        echo '${n}: removing non-persistent `${dst}`'
        rm -rv '${dst}'
      fi
    ''
  ) s.ensureSomething.exec)}

  ${concatStringsSep "\n" (mapAttrsToList (cn: cv:
    with cv;
    optionalString (!cv.persistent) ''
      if [[ -e ${dst} ]] ; then
        echo '${n}: removing non-persistent `${dst}`'

        ${if (type == "directory") then
          "rm -rv ${dst}"
          else if (type == "file") then
            ''
              rm -v ${dst}
            ''
          else
            abort "Unsupported init create type, module system should have caught this!"
         }
      fi
    ''
  ) s.ensureSomething.create)}

  (
    cd ${s.workingDirectory}
    ${optionalString (s.environment != {}) "export ${concatStringsSep " " (mapAttrsToList (n: v: "${n}=${v}") s.environment)}"}
    ${optionalString (s.execStop != null && !s.shutdownOnExit) "exec ${s.execStop}"}
    ${optionalString (s.execStop != null && s.shutdownOnExit) "${s.execStop}"}
  )

  ${optionalString (s.shutdownOnExit) ("exec ${cfgInit.shutdown}")}
''
