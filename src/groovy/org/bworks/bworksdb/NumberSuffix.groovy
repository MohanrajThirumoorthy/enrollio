package org.bworks.bworksdb
class NumberSuffix { 
    String render(number) {

        if ( number.toString()[-1] == '1' ) {
            return number+"st"
        }
        else if (number.toString()[-1] == "3") {
            return number + "rd"
        }
        else if (number.toString()[-1] == "2") {
            return number + "nd"
        }
        else{
            return number + "th"
        }
    }
}
