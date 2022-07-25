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
    variable PKG
    array set PKG {
        "version_string"	"0.0.4"
        "version_number"	"0000400"
        "version_patch"		"alpha"
        "name"			    "package ZCT"
        "auteur"		    "ZarTeK-Creole"
    }
    if { [info commands ::putlog] == "" } {
        set PKG(eggdrop) 0
        set PPL "puts"
    } else {
        set PKG(eggdrop) 1
        set PPL "putlog"
    }
}

namespace eval ::ZCT::pkg {
}
# Charger une package
proc ::ZCT::pkg::load { PKG_NAME {PKG_VERSION ""} {SCRIPT_NAME ""} {MISSING_MODE "die"} } {
    if { ${SCRIPT_NAME} == "" }  {
        set ERR_PREFIX "\[Erreur\] Le script nécessite du package '${PKG_NAME}'"
        set OK_PREFIX "\[OK\] Le script à chargé le package '${PKG_NAME}'"
    } else {
        set ERR_PREFIX "\[Erreur\] Le script '${SCRIPT_NAME}' nécessite du package '${PKG_NAME}'"
        set OK_PREFIX "\[OK\] Le script '${SCRIPT_NAME}' à chargé le package '${PKG_NAME}'"
    }
    if { ${PKG_VERSION} == "" } {
        if { [catch { set PKG_VERSION [package require ${PKG_NAME}]}] } {
            ${MISSING_MODE} "${ERR_PREFIX} pour fonctionner. [::ZCT::pkg::How_Download ${PKG_NAME}]"
        }
    } else {
        if { [catch { set PKG_VERSION [package require ${PKG_NAME} ${PKG_VERSION}]}] } {
            ${MISSING_MODE} "${ERR_PREFIX} version ${PKG_VERSION} ou supérieur pour fonctionner. [::ZCT::pkg::How_Download ${PKG_NAME}]"
        }
    }
    ${::ZCT::PPL} "${OK_PREFIX} avec la version ${PKG_VERSION} avec succès"
}
# Si un package est absent lors du "pkg load" nous retournons une aide pour l'installer le package manquant
proc ::ZCT::pkg::How_Download { PKG_NAME } {
    switch -nocase ${PKG_NAME} {
        Logger      { return "Il fait partie de la game de tcllib.\n Téléchargement sur https://www.tcl.tk/software/tcllib/"}
        Tcl         { return "Télécharger la derniere version sur https://www.tcl.tk/software/tcltk/"}
        default     { return "Aucune information sur ${PKG_NAME}, vous devez chercher sur internet"  }
    }
}
# Verifications de presence de variables.
# Utile pour verifié que tout les variables ont bien été donné dans une fichier de configuration
# dans
# set VARS_LIST				[list "list1" "list2"];  #definitié les nom des arrayx
#  Le code verifie a partir de la les listes defini graces a
# set VARS_list1			[list "var1" "var2"]
# set VARS_list2			[list "var3" "var4"]
# Il verifiera la presence de ${list1(var1)}, ${list1(var2)}, ${list2(var3)} et ${list2(var4)}
proc ::ZCT::Is:ArrayList:Exists { NAMESPACE } {
    set ::TMP_NS_ArrayList ${NAMESPACE}
    namespace inscope ${NAMESPACE} {
        variable VARS_LIST
        if { ![info exists VARS_LIST] } {
            return -code error \
                [format "%s > La liste des ArrayLists a verifier '%s' est inexistant." ${::TMP_NS_ArrayList} "VARS_LIST"]
        }
        foreach LIST_NAME ${VARS_LIST} {
            puts [format "%s > Verification de la présence des variables : \$%s\(..)" ${::TMP_NS_ArrayList} ${LIST_NAME}]
            variable VARS_${LIST_NAME}
            if { ![info exists VARS_${LIST_NAME}] } {
                return -code error \
                    [format "%s > Liste de variables '%s' est inexistant." ${::TMP_NS_ArrayList} "VARS_${LIST_NAME}"]
            }
            variable ${LIST_NAME}
            if { ![array exists ${LIST_NAME}] } {
                return -code error \
                    [format "%s > '%s' n'est pas une liste Array." ${::TMP_NS_ArrayList} "${LIST_NAME}"]
            }
            foreach VAR_NAME [subst \$VARS_${LIST_NAME}] {
                if { ![info exists ${LIST_NAME}(${VAR_NAME})] } {
                    return -code error \
                        [format "%s > L'Array '%s' est inexistant." ${::TMP_NS_ArrayList} "${LIST_NAME}(${VAR_NAME})"]
                }
            }
        }
        unset  ::TMP_NS_ArrayList
    }

}
# Creer des couleurs pour le partyline
# par exemple pour du texte en rouge en partyline :
# putlog "[pcolor_red]mon text rouge[pcolors_end] et ici aucune couleur"
foreach {color_name value} { red 1 yellow 3 cyan 5 magenta 6 blue 4 green 2 } {
    proc ::ZCT::pcolor_${color_name} {} "return \033\\\[01\\;3${value}m"
}
proc ::ZCT::pcolors_end { } {
    return \033\[\;0m
}
# procedure qui retourne où il est appellé
proc ::ZCT::calledby {} {
    set level [expr [info leve] - 2]
    if { ${level} > 0 } {
        return [lindex [info level ${level} ] 0]
    } else {
        if { [string length [info script] ] > 0 } {
            return [info script]
        } else {
            return [info nameofexecutable]
        }
    }
}
# Putlog amelioreé, avec des niveau (couleurs differentes) et type de text
if { ${::ZCT::PKG(eggdrop)} } {
    proc ::ZCT::putlog { text {level_name ""} {text_name ""} } {
        variable ::ZCT::SCRIPT
        set UP_LEVEL_NAME [::ZCT::calledby]
        if { ${text_name} == "" } {
            if { ${level_name} != "" } {
                set text_name " - ${level_name}"
            } else {
                set text_name ""
            }
        } else {
            set text_name " - ${text_name}"
        }
        switch -nocase ${level_name} {
            "error"		{ puts "[pcolor_red]\[${UP_LEVEL_NAME}${text_name}\][pcolors_end] [pcolor_blue]${text}[pcolors_end]" }
            "warning"	{ puts "[pcolor_yellow]\[${UP_LEVEL_NAME}${text_name}\][pcolors_end] [pcolor_blue]${text}[pcolors_end]" }
            "notice"	{ puts "[pcolor_cyan]\[${UP_LEVEL_NAME}${text_name}\][pcolors_end] [pcolor_blue]${text}[pcolors_end]" }
            "debug"		{ puts "[pcolor_magenta]\[${UP_LEVEL_NAME}${text_name}\][pcolors_end] [pcolor_blue]${text}[pcolors_end]" }
            "info"		{ puts "[pcolor_blue]\[${UP_LEVEL_NAME}${text_name}\][pcolors_end] [pcolor_blue]${text}[pcolors_end]" }
            "success"	{ puts "[pcolor_green]\[${UP_LEVEL_NAME}${text_name}\][pcolors_end] [pcolor_blue]${text}[pcolors_end]" }
            default		{ puts "\[${UP_LEVEL_NAME}${text_name}\] [pcolor_blue]${text}[pcolors_end]" }
        }
    }
    if { [info commands ::putlog.old] == "" } {
        rename ::putlog ::putlog.old;
        interp alias {} putlog {} ::ZCT::putlog
    }
}
namespace eval ::ZCT::TXT {
    namespace export *
}
namespace eval ::ZCT::TXT::visuals {
    namespace export *
}
# permet de centrer du text sur une longueur donné
proc ::ZCT::TXT::visuals::espace { text length } {
    set text			[string trim ${text}]
    set text_length		[string length ${text}];
    set espace_length	[expr (${length} - ${text_length})/2.0]
    set ESPACE_TMP		[split ${espace_length} .]
    set ESPACE_ENTIER	[lindex ${ESPACE_TMP} 0]
    set ESPACE_DECIMAL	[lindex ${ESPACE_TMP} 1]
    if { ${ESPACE_DECIMAL} == 0 } {
        set espace_one			[string repeat " " ${ESPACE_ENTIER}];
        set espace_two			[string repeat " " ${ESPACE_ENTIER}];
        return "${espace_one}${text}${espace_two}"
    } else {
        set espace_one			[string repeat " " ${ESPACE_ENTIER}];
        set espace_two			[string repeat " " [expr (${ESPACE_ENTIER}+1)]];
        return "${espace_one}${text}${espace_two}"
    }

}
##############################################################################
### Substitution des symboles couleur/gras/soulignement/...
###############################################################################
# Modification de la fonction de MenzAgitat
# <cXX> : Ajouter un Couleur avec le code XX : <c01>; <c02,01>
# </c>  : Enlever la Couleur (refermer la deniere declaration <cXX>) : </c>
# <b>   : Ajouter le style Bold/gras
# </b>  : Enlever le style Bold/gras
# <u>   : Ajouter le style Underline/souligner
# </u>  : Enlever le style Underline/souligner
# <i>   : Ajouter le style Italic/Italique
# <s>   : Enlever les styles precedent
proc ::ZCT::TXT::visuals::apply { data } {
    regsub -all -nocase {<c([0-9]{0,2}(,[0-9]{0,2})?)?>|</c([0-9]{0,2}(,[0-9]{0,2})?)?>} ${data} "\003\\1" data
    regsub -all -nocase {<b>|</b>} ${data} "\002" data
    regsub -all -nocase {<u>|</u>} ${data} "\037" data
    regsub -all -nocase {<i>|</i>} ${data} "\026" data
    return [regsub -all -nocase {<s>} ${data} "\017"]
}
# Enleve les style visuals
proc ::ZCT::TXT::visuals::remove { data } {
    regsub -all -nocase {<c([0-9]{0,2}(,[0-9]{0,2})?)?>|</c([0-9]{0,2}(,[0-9]{0,2})?)?>} ${data} "" data
    regsub -all -nocase {<b>|</b>} ${data} "" data
    regsub -all -nocase {<u>|</u>} ${data} "" data
    regsub -all -nocase {<i>|</i>} ${data} "" data
    return [regsub -all -nocase {<s>} ${data} ""]
}
# Procedure interne qui permet de creer les procs et les subprocs automatiquement
# https://forum.eggdrop.fr/Une-proc-qui-gere-lexploration-des-sous-commandes-par-les-namespaces-t-1951.html
proc ::ZCT::create_sub_procs { namespace } {
    # Boucle sur les namespaces enfants de $namespace (::example) retourne -> ::example::text; ::example::text2
    foreach child_name [namespace children ${namespace}] {
        # Création de procédure portant le nom des namespaces enfants ::example::text, ::example::text2
        proc ${child_name} { {subcommand ""} args } {
            # tout ce qui fais partie ici, sera exécuté lors de l'exécution de la proc créer
            # les variables, commandes
            # le  proc_path contient chemin de la proc (lors de sont exécution et non maintenant donc)
            set proc_path [lindex [info level 0] 0]
            # Si la proc est appeler sans subcommand, nous signalons qu'elle nécessite une
            if { ${subcommand} == "" } {
                return  -code error \
                    "wrong # args: should be \"${proc_path} subcommand ?arg ...?\""
            }
            # Si la subcommand n'existe pas dans les procs enfants, ont prévois de retourner la liste des procs existante dans le namespace courant (celle de la proc appelé )
            if { [info commands ${proc_path}::${subcommand}] == "" } {
                set subcommands_list  [join [string map "${proc_path}:: \"\"" [info procs ${proc_path}::*]] ", "]
                return  -code error \
                    "wrong ${proc_path} unknown or ambiguous subcommand \"${subcommand}\": must be ${subcommands_list}"
            }
            # si la subcommand existe, on l'execute avec les valeurs fournis
            ${proc_path}::${subcommand} {*}${args}
        }
        # ici nous sommes sorties de la création de la proc, et de retour dans la boucle enfant, nous allons exporté les proc
        namespace export *
        # Nous allons répéter ces opérations dans le niveau inferieur/enfants (dans ::example::text et ::example::text2)
        create_sub_procs ${child_name}
    }
    # fin de la boucle
}
::ZCT::create_sub_procs ::ZCT

package provide ZCT ${::ZCT::PKG(version)}
${::ZCT::PPL} "Package ZCT version ${::ZCT::PKG(version)} par ${::ZCT::PKG(auteur)} chargé."