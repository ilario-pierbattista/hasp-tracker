function save_reversed_sample(sample, frame_data, coordinates, destination_folder);
    parts = {'frame'};
    parts{2} = num2str(sample.id);
    parts{3} = num2str(sample.width);
    parts{4} = num2str(sample.height);
    parts{5} = num2str(coordinates(1));
    parts{6} = num2str(coordinates(2));
    if sample.positive
        parts{7} = 'true.bin';
    else
        parts{7} = 'false.bin';
    end
    filename = strjoin(parts, '_');
    fd = fopen(fullfile(destination_folder, filename), 'w');
    fwrite(fd, transpose(frame_data), 'uint16');
    fclose(fd);
end
