# $Id: gn.sed,v 1.1 2004/01/09 20:38:01 dvd Exp $
# convert head of arx to arguments of rvp
/grammars/,/}/ {
  s/[ 	]+/ /g
  s/#.*$|(^| )grammars( |{|$)|{|}/ /g
  s/ *([^ ]+)="([^ ]+)" */\1=\2 /gp
}
