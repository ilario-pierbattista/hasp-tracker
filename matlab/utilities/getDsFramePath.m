function path = getDsFramePath(context, number, camera, stream, varargin)
% Argomenti opzionali: numero del frame da prelevare
if length(varargin) > 1
    error('myfuns:getDsFramePath:TooManyInputs',...
        'richiede al più un argomento opzionale')
end

base_dir = fullfile('/home/ilario/Documenti/Tirocinio/Dataset');
if exist(base_dir) ~= 7
    error('myfuns:getDatasetFilePath:fileNotFound',...
        strcat('La directory di base ', base_dir, ' non esiste'))
end
fold = fullfile(base_dir, context);
chechDirExists(fold);
if length(number) == 1
    number = strcat('0', number);
end
fold = fullfile(fold, number);
chechDirExists(fold);
folders = ['']

path = fold;


function result = chechDirExists(fold)
% Controlla l'esistenza di una cartella
result = false;
if exist(fold) ~= 7
    error('myfuns:getDatasetFilePath:fileNotFound',...
       strcat('La directory ', fold, ' non esiste'))
else
    result = true;
end


