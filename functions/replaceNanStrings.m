function replacedNanData = replaceNanStrings( data )

replacedNanData = data;
replacedNanData( any(isnan(replacedNanData),2), :) = [];

end

