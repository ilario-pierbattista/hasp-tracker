function [checkedPath, isdirectory] = checkpath(pathname)
% Se esiste una variabile globale con questo nome, valutarne il contenuto
globalstoredPath = getenv(pathname);
absolutePath = fullfile(pwd, pathname);

if exist(globalstoredPath)
    checkedPath = globalstoredPath;
elseif exist(absolutePath)
    checkedPath = absolutePath;
elseif exist(pathname)
    checkedPath = pathname;
else
    checkedPath = '';
end

if ~isempty(checkedPath)
    isdirectory = isdir(checkedPath);
else
    isdirectory = false;
end
