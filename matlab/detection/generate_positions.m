function positions = generate_positions(frame_dim, window_dim, humans, granularity, first_iteration);
    % Considerando la posizione attuale delle persone rilevate, fornisce
    % un insieme di punti in cui posizionare le finestre di rilevamento
    % entro le quali è probabile trovare la persona all'istante successivo
    if nargin == 3
        first_iteration = false;
    end
    global FRAMEWORK_BORDER_WIDTH;
    global DETECTION_GRANULARITY;

    limits = frame_dim - window_dim;

    x = [1:granularity:limits(1)];
    y = transpose([1:granularity:limits(2)]);
    x = repmat(x, size(y, 1), 1);
    y = repmat(y, 1, size(x, 2));

    if first_iteration
        % Alla prima iterazione, tutte le aree del frame possono contenere la
        % figura di una persona
        positions = [x(:), y(:)];
    else
        % Alle iterazioni successive, solamente le bande laterali del frame e le
        % aree intorno alla posizione attuale della persona potranno contenere,
        % all'istante successivo la figura della

        % @TODO Questo è un porchetto, rimuovere questa struttura condizionale
        filtered_x = zeros(size(x)); filtered_y = zeros(size(y));
        if isempty(humans)
            filtered_x = get_matrix_border(x, FRAMEWORK_BORDER_WIDTH / DETECTION_GRANULARITY, filtered_x);
            filtered_y = get_matrix_border(y, FRAMEWORK_BORDER_WIDTH / DETECTION_GRANULARITY, filtered_y);
        else
            for i = [1:size(humans, 1)]
                [filtered_x, filtered_y] = get_human_neighbourhood(x, y, humans(i, :),...
                    filtered_x, filtered_y);
            end
        end
        positions = [];
        unfiltered_positions = [filtered_x(:), filtered_y(:)];
        for i = [1:size(unfiltered_positions, 1)]
            if prod(unfiltered_positions(i, :)) ~= 0
                positions = [positions; unfiltered_positions(i, :)];
            end
        end
    end
    positions = positions - 1;
end

function destination = get_matrix_border(matrix, border_width, destination);
    if nargin == 2
        destination = zeros(size(matrix));
    end
    [r,c] = size(matrix);
    destination(:, 1:border_width) = matrix(:, 1:border_width);
    destination(:, c - border_width + 1:c) = matrix(:, c - border_width + 1:c);
    destination(1:border_width, :) = matrix(1:border_width, :);
    destination(r - border_width + 1:r, :) = matrix(r - border_width + 1:r, :);
end

function [dest_x, dest_y] = get_human_neighbourhood(x, y, human_position, dest_x, dest_y);
    global HUMAN_NEIGHBORHOOR_RADIUS;
    global DETECTION_GRANULARITY;
    box_step = HUMAN_NEIGHBORHOOR_RADIUS/DETECTION_GRANULARITY;

    human_x = repmat(human_position(1), size(x));
    human_y = repmat(human_position(2), size(y));
    diff_x = abs(x - human_x);
    diff_y = abs(y - human_y);
    [m, x_position] = min(diff_x(:));
    [i, x_position] = ind2sub(size(diff_x), x_position);
    [m, y_position] = min(diff_y(:));
    [y_position, i] = ind2sub(size(diff_y), y_position);
    human_x_range = [(x_position - box_step):(x_position + box_step)];
    human_x_range = human_x_range(find(human_x_range >= 1));
    human_x_range = human_x_range(find(human_x_range <= size(x, 2)));
    human_y_range = [(y_position - box_step):(y_position + box_step)];
    human_y_range = human_y_range(find(human_y_range >= 1));
    human_y_range = human_y_range(find(human_y_range <= size(y, 1)));
    dest_x(:, human_x_range) = x(:, human_x_range);
    dest_y(human_y_range, :) = y(human_y_range, :);
end
