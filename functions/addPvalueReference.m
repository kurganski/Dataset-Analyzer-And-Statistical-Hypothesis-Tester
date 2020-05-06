
function infoStr = addPvalueReference(infoStr, p)

if p < 0.05
    infoStr = [infoStr; ""; ""; "*при p < 0.05 исследование считается низкопробным"; ...
        "см. https://ru.wikipedia.org/wiki/P-%D0%B7%D0%BD%D0%B0%D1%87%D0%B5%D0%BD%D0%B8%D0%B5"];
end