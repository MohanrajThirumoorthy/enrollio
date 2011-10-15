package org.bworks.bworksdb
class NumberSuffix { 
    String render(number) {

        def numString = number.toString()

        if ( numString =~ /.*1$/ ) {
            return number+"st"
        }
        else if (numString =~ /13$/) {
            return number + "th"
        }
        else if (numString =~ /3$/) {
            return number + "rd"
        }
        else if (numString =~ /2$/) {
            return number + "nd"
        }
        else{
            return number + "th"
        }
    }
}
