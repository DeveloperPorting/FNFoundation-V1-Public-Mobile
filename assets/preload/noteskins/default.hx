// this gets the BF noteskin
function bfSkin() { return "NOTE_assets"; }

// this gets the DAD noteskin
function dadSkin() { return "NOTE_assets"; }

// this gets the notesplash skin and offset
function noteSplash(offsets){
    for (i in 0...PlayState.SONG.keys) {
        offsets[i].x += 30;
    }
    return "Foundationsplash"; 
}

// does ur noteskin have quants ? 
function quants() { return false; }

// offset notes, receptors and sustains
function offset(noteOff, strumOff, susOff){}

