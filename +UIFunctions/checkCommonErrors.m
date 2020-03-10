function checkCommonErrors(x, msgid)
    if ~isfinite(x) || ~isscalar(x) || ~isreal(x)
        error([msgid, ':InvalidInput'], 'Could not parse data.  Only scalar, finite, real numbers are allowed.');
    end
end