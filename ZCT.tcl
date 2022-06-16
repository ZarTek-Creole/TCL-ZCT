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
    }

}
proc ::ZCT::pkg:showdl { PKG_NAME } {
    switch ${PKG_NAME} {
        case {}
        default     {
            return
        }
    }
}
proc ::ZCT::pkg { PKG_NAME {PKG_VERSION ""} {SCRIPT_NAME ""} {MISSING_MODE "die"} } {
    if { ${SCRIPT_NAME} == "" }  {
        set ERR_PREFIX "\[Erreur\] Le script nécessite du package ${PKG_NAME}"
        set OK_PREFIX "\[OK\] Le script à chargé le package ${PKG_NAME} avec succès"
    } else {
        set ERR_PREFIX "\[Erreur\] Le script ${SCRIPT_NAME} nécessite du package ${PKG_NAME}"
        set OK_PREFIX "\[OK\] Le script ${SCRIPT_NAME} à chargé le package ${PKG_NAME} avec succès"
    }
    if { ${PKG_VERSION} == "" } {
        if { [catch { set PKG_VERSION [package require ${PKG_NAME}]}] } {
            ${MISSING_MODE} "${ERR_PREFIX} pour fonctionner. [::ZCT::pkg:showdl ${PKG_NAME}]"
        } else {
            putlog "${OK_PREFIX} version ${PKG_VERSION} avec succès"
        }
    } else {
        if { [catch { set PKG_VERSION [package require ${PKG_NAME} ${PKG_VERSION}]}] } {
            ${MISSING_MODE} "${ERR_PREFIX} version ${PKG_VERSION} ou supérieur pour fonctionner. [::ZCT::pkg:showdl ${PKG_NAME}]"
        } else {
            putlog "${OK_PREFIX} version ${PKG_VERSION} avec succès"
        }
    }
}
package provide ZCT ${::ZCT::pkg(version)}