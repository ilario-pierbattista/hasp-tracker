function result = checkisdir(fullpath)
    % checkisdir Controlla che fullpath esista e sia una cartella
    [fullpath, isdirectory] = checkpath(fullpath);
    if isempty(fullpath) || ~isdirectory
        result = false;
    else
        result = fullpath;
    end
end
