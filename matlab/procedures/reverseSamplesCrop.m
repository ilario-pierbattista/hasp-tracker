% A partire dagli esempi, ricostruisce il frame che li contiene
%
% Passi:
% 1) Associare a gruppi di samples i relativi gruppi di frames
% 2) Per ogni sample, ricercare nel relativo gruppo il frame corrispondente
% 3) Memorizzare classicazione e eventuale posizione della persona

initEnvironment;

% matrice di mappatura
mapping = [1 150 1 1;
151 300 2 1;
301 450 3 1;
451 600 4 1;
601 750 5 1;
751 900 6 1;
901 1050 7 1;
1051 1200 8 1;
1201 1350 9 1;
1351 1500 10 1;
1501 1700 1 0;
1701 1900 2 0;
1901 2100 3 0;
2101 2300 4 0;
2301 2500 5 0;
2501 2700 6 0;
2701 2900 7 0;
2901 3100 8 0];

% Input della path
datasetPath = inputdef('Path del dataset [%s] ', fullfile(getenv('TEST1'), '..'), 's');
datasetPath = checkisdir(datasetPath);
if isempty(datasetPath)
    error('Path non valida');
elseif ~checksubdirs(datasetPath, {'positives', 'negatives'})
    error('La path non contiene un dataset');
end
% Input delle dimensioni dei frame
frames_size = inputdef('Dimensioni dei frame [%d %d]: ', [512 424]);
frames_size = struct('width', frames_size(1), 'height', frames_size(2));

% Input dell'indice iniziale (utile per riprendere il processo in un secondo momento)
begin_index = inputdef('Indice iniziale da cui partire [%d]: ', 1);

% Creazione della directory di destinazione
destination_folder = strcat('reversed_samples_',datestr(now, 'DDmmmYYYYHHMMSS'));
destination_folder = fullfile(pwd, destination_folder);
if ~exist(destination_folder)
    mkdir(destination_folder);
end

% Apertura dei frammenti e ricerca
samples = getFrames(datasetPath);
[s ind] = sort([samples.id]);
samples = samples(ind);

listed_frame_paths = struct();

% Input dell'indice del frame da cui cominciare a cercare l'esempio
force_first_frame = false;
if begin_index ~= 1
    last_frame_analysed = inputdef('Indice del frame da cui partire a cercare [%d]: ', 1);
    force_first_frame = true;
else
    last_frame_analysed = 1;
end

last_group_analysed = [];
saved_frames = [];
number_of_found_frames = begin_index - 1;
number_of_non_founds_frames = 0;
% for each sample in dataset
for i = [1:size(samples,1)]
    for row = [1:size(mapping, 1)]
        if mapping(row, 1) <= samples(i).id
            group = mapping(row, :);
        end
    end
    classification = group(4);
    record_index = group(3);
    record_path = get_record_path(record_index, classification);
    field_name = regexprep(record_path,'[^a-zA-Z0-9]','');
    if ~isfield(listed_frame_paths, field_name)
        listed_frame_paths = setfield(listed_frame_paths,...
            field_name,...
            getFramesPath(record_path));
    end

    % Ricerca
    paths = getfield(listed_frame_paths, field_name);
    % Defining research order
    % If the previous sample was found at the frame i, then the next samples should be
    % located in the frames j > i
    if isequal(last_group_analysed, group(3:4)) || force_first_frame
        frame_indexes = [last_frame_analysed : size(paths, 1)];
        frame_indexes = [frame_indexes [1 : frame_indexes - 1]];
        force_first_frame = false;
    else
        frame_indexes = [1 : size(paths, 1)];
    end
    % for each frame in record group
    found = false;
    for j = frame_indexes
        % tupla identificativa del frame
        frame_identifier = [samples(i).positive group(3) j];
        image_data = readImageData(char(paths{j}), frames_size.width, frames_size.height, 16);
        sample_data = readImageData(samples(i).filepath, samples(i).width, samples(i).height, 16);
        fprintf('\rAnalysing frame #%3d/%3d (group %d, %d)', j, length(frame_indexes), frame_identifier(2), frame_identifier(1));
        coordinates = search_blob_pattern(image_data, sample_data);
        % if not empty, then the parent frame has been found
        if ~isempty(coordinates)
            % controllo sui frame già salvati per evitare i duplicati
            if isempty(saved_frames) || isempty(find(ismember(saved_frames, frame_identifier, 'rows')))
                save_reversed_sample(samples(i), image_data, coordinates, destination_folder);
                saved_frames = [saved_frames; frame_identifier];
            end
            found = true;
            number_of_found_frames = number_of_found_frames + 1;
            fprintf(' -> Sample %4d/%4d (%d not founds)\n', number_of_found_frames, size(samples, 1), number_of_non_founds_frames);
            last_frame_analysed = j;
            last_group_analysed = group(3:4);
            break;
        end
    end
    if ~found
        number_of_non_founds_frames = number_of_non_founds_frames + 1;
    end
end
fprintf('\n');
