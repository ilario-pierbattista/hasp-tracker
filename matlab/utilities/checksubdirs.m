function presence = checksubdirs(baseDir, dirs);
    % checksubdirs controlla l'esistenza delle sottodirectory specificate da dirs nella directory baseDir.
    % Example:
    %   presence = checksubdirs('/home/johndoe', {'foo', 'bar'}) Verifica che, nella directory /home/johndoe siano presenti le sottodirectory foo e bar

    presence = true;
    for subdir = dirs
        [fullpath, isdirectory] = checkpath(fullfile(baseDir, char(subdir)));
        if isempty(fullpath) || ~isdirectory
            presence = false;
            break;
        end
    end
end
