#############################################################################
#
#	Auteur	:
#		-> ZarTek (ZarTek.Creole@GMail.Com)
#
#	Website	:
#		-> github.com/ZarTek-Creole/TCL-ZCT
#
#	Support	:
#		-> github.com/ZarTek-Creole/TCL-ZCT/issues
#
#	Docs	:
#		-> github.com/ZarTek-Creole/TCL-ZCT/wiki
#
#   DONATE   :
#       -> https://github.com/ZarTek-Creole/DONATE
#
#	LICENSE :
#		-> Creative Commons Attribution 4.0 International
#		-> github.com/ZarTek-Creole/TCL-ZCT/blob/main/LICENSE.txt
#
#
#############################################################################
namespace eval ::ZCT {
    namespace export *
    variable pkg
    array set pkg {
        "version"		"0.0.1"
        "name"			"package ZCT"
        "auteur"		"ZarTeK-Creole"
    }
}

namespace eval ::ZCT::pkg {
    namespace export *
}
proc ::ZCT::pkg { cmd args } {
    ::ZCT::pkg::${cmd} {*}${args}
}
proc ::ZCT::pkg::load { PKG_NAME {PKG_VERSION ""} {SCRIPT_NAME ""} {MISSING_MODE "die"} } {
    if { ${SCRIPT_NAME} == "" }  {
        set ERR_PREFIX "\[Erreur\] Le script nécessite du package ${PKG_NAME}"
        set OK_PREFIX "\[OK\] Le script à chargé le package ${PKG_NAME}"
    } else {
        set ERR_PREFIX "\[Erreur\] Le script ${SCRIPT_NAME} nécessite du package ${PKG_NAME}"
        set OK_PREFIX "\[OK\] Le script ${SCRIPT_NAME} à chargé le package ${PKG_NAME}"
    }
    if { ${PKG_VERSION} == "" } {
        putlog "package require ${PKG_VERSION} 2"
        if { [catch { set PKG_VERSION [package require ${PKG_NAME}]}] } {
            ${MISSING_MODE} "${ERR_PREFIX} pour fonctionner. [::ZCT::pkg::How_Download ${PKG_NAME}]"
        }
    } else {
        if { [catch { set PKG_VERSION [package require ${PKG_NAME} ${PKG_VERSION}]}] } {
            ${MISSING_MODE} "${ERR_PREFIX} version ${PKG_VERSION} ou supérieur pour fonctionner. [::ZCT::pkg::How_Download ${PKG_NAME}]"
        }
    }
    putlog "${OK_PREFIX} avec la version ${PKG_VERSION} avec succès"
}
proc ::ZCT::pkg::How_Download { PKG_NAME } {
    switch -nocase ${PKG_NAME} {
        Logger { return "Il fait partie de la game de tcllib.\n Téléchargement sur https://www.tcl.tk/software/tcllib/"}
        Tcl { return "Télécharger la derniere version sur https://www.tcl.tk/software/tcltk/"}
        default     {
            return
        }
    }
}

package provide ZCT ${::ZCT::pkg(version)}
putlog "Package ZCT version ${::ZCT::pkg(version)} par ${::ZCT::pkg(auteur)} chargé."