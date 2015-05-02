function path = getDatasetPath(set_number)
% controllo esistenza variabile d'ambiente
if isempty(getenv('DATASET_ROOT'))
    run('initEnvironment')
end

% Casting del numero
if isnumeric(set_number)
    set_number = int2str(set_number);
end

path = fullfile(getenv('DATASET_ROOT'), set_number);

% Controllo esistenza cartella
if exist(path) ~= 7
    path = '';
    error('myfuns:getDatasetPath:fileNotFound',...
       strcat('La directory ', path, ' non esiste'))
end
