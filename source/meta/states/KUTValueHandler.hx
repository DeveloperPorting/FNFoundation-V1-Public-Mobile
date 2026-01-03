package meta.states;

class KUTValueHandler extends MusicBeatState
{
    //the only reason I made this its own class is because hit single has like 4 different menu themes and calls "getMenuMusic" really often, so im just making this instead of replacing every time it calls that function

    // foundation doesnt have nearly as many menu themes but this shit is called 20 different times throughout the source code bruh -xeight
    inline public static function getMenuMusic():String
    {
        return '079';
    }
}