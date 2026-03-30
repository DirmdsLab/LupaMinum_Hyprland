#!/usr/bin/env bash

SERVER="http://127.0.0.1:5000/translate_sub"

FILE="$1"

if [[ -z "$FILE" ]]; then
    echo "Usage:"
    echo "./translate_subtitle.sh subtitle.srt"
    exit 1
fi

EXT="${FILE##*.}"
BASENAME="${FILE%.*}"
OUTFILE="${BASENAME}-sub.vtt"

TMP_LINES=$(mktemp)

echo "Reading subtitle: $FILE"

# =========================
# SRT PARSER
# =========================

if [[ "$EXT" == "srt" ]]; then

awk '
BEGIN{RS="";FS="\n"}
{
    if(NF>=3){
        time=$2
        text=""
        for(i=3;i<=NF;i++){
            if($i!=""){
                text=text $i " "
            }
        }

        if(text!="")
            print time "|" text
    }
}
' "$FILE" > "$TMP_LINES"


# =========================
# VTT PARSER (FIX)
# =========================

elif [[ "$EXT" == "vtt" ]]; then

awk '
/-->/ {
    time=$0
    text=""

    while(getline line){
        if(line=="") break
        text=text line " "
    }

    if(text!="")
        print time "|" text
}
' "$FILE" > "$TMP_LINES"


# =========================
# ASS / SSA PARSER
# =========================

elif [[ "$EXT" == "ass" || "$EXT" == "ssa" ]]; then

grep "^Dialogue:" "$FILE" | awk -F',' '
{
    start=$2
    end=$3
    text=$10

    if(text!="" && text!="None"){
        time=start" --> "end
        print time "|" text
    }
}
' > "$TMP_LINES"

else
    echo "Unsupported subtitle format"
    exit 1
fi


echo "Building JSON..."

JSON=$(jq -Rn '
[ inputs | split("|") | {time: .[0], text: .[1]} ]
| {subs: .}
' < "$TMP_LINES")


echo "Sending subtitle to server..."

curl -s \
-X POST "$SERVER" \
-H "Content-Type: application/json" \
-d "$JSON" \
-o "$OUTFILE"

echo "Done."
echo "Saved: $OUTFILE"

rm "$TMP_LINES"